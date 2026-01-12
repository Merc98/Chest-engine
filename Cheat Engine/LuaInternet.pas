unit LuaInternet;

{$mode delphi}

interface




uses
  Classes, SysUtils
  {$ifdef windows}, wininet, Winsock2, windows
  {$else}
  , fphttpclient,opensslsockets,openssl, StringHashList

  {$endif}
  ;

{$ifndef standalone}
procedure initializeLuaInternet;
{$endif}

type
  TWinInternet=class
  private
    {$ifdef windows}
    internet: HINTERNET;
    fheader: string;
    
    function IPv6Broken(hostname: string): boolean;
    function GetIPv4Address(hostname: string): string;
    {$else}
    fname: string;
    internet: TFPHTTPClient;


    procedure setHeader(s: string);
    function getHeader: string;
    procedure recreateFPHTTPClient;
    procedure storeCookies(urlstring: string);
    procedure loadCookies(urlstring: string);
    {$endif}
  public
    function getURL(urlstring: string; results: tstream): boolean;
    function postURL(urlstring: string; urlencodedpostdata: string; results: tstream): boolean;
    constructor create(name: string);
    destructor destroy; override;
  published
    {$ifdef windows}
    property Header: string read fheader write fheader;
    {$else}
    property Header: string read getHeader write setHeader;
    {$endif}
  end;


implementation

uses {$ifdef darwin}macport, registry,{$endif}{$ifndef standalone}MainUnit2, lua, LuaClass, LuaObject, LuaHandler,{$endif} URIParser, dialogs;

{$ifndef windows}
var cookies: tstringhashlist;
{$endif}

{$ifdef windows}
// Helper to check if IPv6 is broken (Happy Eyeballs-ish)
function TWinInternet.IPv6Broken(hostname: string): boolean;
var
  hints: TAddrInfoW;
  addr: PAddrInfoW;
  ptr: PAddrInfoW;
  sock: TSocket;
  res: integer;
  mode: u_long;
  fd_set_write: TFDSet;
  tv: TIMEVAL;
  hasIPv6: boolean;
begin
  result := false;
  hasIPv6 := false;

  FillChar(hints, SizeOf(hints), 0);
  hints.ai_family := AF_INET6;
  hints.ai_socktype := SOCK_STREAM;
  hints.ai_protocol := IPPROTO_TCP;

  // Resolve hostname for IPv6
  if GetAddrInfoW(PWideChar(WideString(hostname)), nil, @hints, addr) = 0 then
  begin
    ptr := addr;
    while ptr <> nil do
    begin
      hasIPv6 := true;
      
      // Try to connect with a short timeout
      sock := socket(ptr^.ai_family, ptr^.ai_socktype, ptr^.ai_protocol);
      if sock <> INVALID_SOCKET then
      begin
        // Set non-blocking
        mode := 1;
        ioctlsocket(sock, FIONBIO, @mode);

        connect(sock, ptr^.ai_addr, ptr^.ai_addrlen);

        FD_ZERO(fd_set_write);
        FD_SET(sock, fd_set_write);

        tv.tv_sec := 0;
        tv.tv_usec := 500000; // 500ms timeout

        res := select(0, nil, @fd_set_write, nil, @tv);
        
        closesocket(sock);

        if res > 0 then
        begin
          // Connection succeeded (or at least writable), IPv6 is likely working
          FreeAddrInfoW(addr);
          exit(false); 
        end;
      end;
      
      ptr := ptr^.ai_next;
    end;
    FreeAddrInfoW(addr);
  end;

  // If we found IPv6 addresses but none connected, assumed broken
  if hasIPv6 then
    result := true;
end;

function TWinInternet.GetIPv4Address(hostname: string): string;
var
  hints: TAddrInfoW;
  addr: PAddrInfoW;
  sockAddrIn: PSockAddrIn;
begin
  result := '';
  FillChar(hints, SizeOf(hints), 0);
  hints.ai_family := AF_INET;
  hints.ai_socktype := SOCK_STREAM;

  if GetAddrInfoW(PWideChar(WideString(hostname)), nil, @hints, addr) = 0 then
  begin
    if addr <> nil then
    begin
      sockAddrIn := PSockAddrIn(addr^.ai_addr);
      result := string(inet_ntoa(sockAddrIn^.sin_addr));
    end;
    FreeAddrInfoW(addr);
  end;
end;
{$endif}


{$ifndef windows}
procedure TWinInternet.setHeader(s: string);
begin
  internet.RequestHeaders.Text:=s;
end;

function TWinInternet.getHeader: string;
begin
  result:=internet.RequestHeaders.Text;
end;

procedure TWinInternet.storeCookies(urlstring: string);
var
  uri: TURI;
  c: tstringlist;
  i,j: integer;
  s: string;
  cname,cname2: string;
  cvalue,cvalue2: string;
  found: boolean;

  p: integer;
begin
  if internet.Cookies.Text='' then exit; //no new cookies

  uri:=ParseURI(urlstring);
  c:=cookies[uri.Host];
  if c=nil then
  begin
    c:=tstringlist.create;
    cookies[uri.Host]:=c;
  end;


  //update the cookies with the new values
  for i:=0 to internet.ResponseHeaders.count-1 do
  begin
    s:=internet.ResponseHeaders[i];
    if (LowerCase(Copy(S,1,10))='set-cookie') then
    begin
      Delete(s,1,Pos(':',S));

      cname:=trim(copy(s,1,pos('=',s)-1));


      cvalue:=trim(copy(s,pos('=',s)+1));
      cvalue:=copy(cvalue,1,pos(';',cvalue)-1);

      found:=false;
      for j:=0 to c.Count-1 do
      begin
        s:=c[j];
        cname2:=trim(copy(s,1,pos('=',s)-1));
        if cname=cname2 then
        begin
          c[j]:=cname+'='+cvalue; //update
          found:=true;
          break;
        end;
      end;

      if not found then
        c.add(cname+'='+cvalue);
    end;
  end;


end;

procedure TWinInternet.loadCookies(urlstring: string);
var
  uri: TURI;
  c: tstringlist;
begin
  uri:=ParseURI(urlstring);

  c:=cookies[uri.Host];
  if c<>nil then
  begin
    internet.Cookies.Text:=c.text;
  end;
end;

function TWinInternet.postURL(urlstring: string; urlencodedpostdata: string; results: tstream): boolean;
begin
  result:=false;
  try
    recreateFPHTTPClient;
    loadCookies(urlstring);

    internet.FormPost(urlstring,urlencodedpostdata,results);

    storeCookies(urlstring);

    result:=true;
  except
    result:=false;
  end;
end;

function TWinInternet.getURL(urlstring: string; results: tstream): boolean;
begin
  result:=false;
  try
    loadCookies(urlstring);
    internet.Get(urlstring, results);

    storeCookies(urlstring);
    result:=true;
  except

  end;

end;

procedure TWinInternet.recreateFPHTTPClient;
begin
  if internet<>nil then
    freeandnil(internet);

  internet:=TFPHTTPClient.Create(nil);
  internet.AddHeader('User-Agent',fname);
  internet.AllowRedirect:=true;
end;

{$else}

function TWinInternet.postURL(urlstring: string; urlencodedpostdata: string; results: tstream): boolean;
var
  url: HINTERNET;

  c,r: HInternet;
  available,actualread: dword;

  buf: PByteArray;

  u: TURI;

  port: dword;

  username, password: pchar;

  h: string;
  requestflags: dword;
  err: integer;
begin
  h:='Content-Type: application/x-www-form-urlencoded';

  result:=false;
  if internet<>nil then
  begin
    //InternetConnect(internet, );

    requestflags:=INTERNET_FLAG_PRAGMA_NOCACHE;

    u:=ParseURI(urlstring);

    port:=INTERNET_DEFAULT_HTTP_PORT;
    if lowercase(u.Protocol)='https' then
    begin
      port:=INTERNET_DEFAULT_HTTPS_PORT;
      requestflags:=requestflags or INTERNET_FLAG_SECURE;
    end
    else
    begin
//      requestflags:=requestflags or INTERNET_FLAG_NO_AUTO_REDIRECT;
    end;

    if u.Port<>0 then
      port:=u.port;

    if u.Username<>'' then
      username:=pchar(u.Username)
    else
      username:=nil;

    if u.Password<>'' then
      password:=pchar(u.Password)
    else
      password:=nil;

    if u.params<>'' then u.params:='?'+u.params;


    c:=InternetConnect(internet, pchar(u.Host), port, username, password, INTERNET_SERVICE_HTTP, 0,0);
    if c<>nil then
    begin
      r:=HttpOpenRequest(c, PChar('POST'), pchar(u.path+u.Document+u.Params), nil, nil, nil, requestflags, 0);
      if r<>nil then
      begin
        if HttpSendRequest(r,pchar(h),length(h),pchar(urlencodedpostdata), length(urlencodedpostdata)) then
        begin

          while InternetQueryDataAvailable(r, available, 0, 0) do
          begin
            if available=0 then break;

            getmem(buf, available+32);
            try
              if InternetReadFile(r, buf, available,actualread)=false then break;
              if actualread>0 then
              begin
                results.WriteBuffer(buf[0], actualread);
                result:=true; //something was read
              end;
            finally
              FreeMemAndNil(buf);
            end;
          end;
        end
        else
        begin
          err:=getLastOSError;

          if err=0 then beep;


        end;

        InternetCloseHandle(r);
      end;

      InternetCloseHandle(c);
    end;

  end;

end;

function TWinInternet.getURL(urlstring: string; results: tstream): boolean;
var url: HINTERNET;
  available,actualread: dword;

  buf: PByteArray;
  
  u: TURI;
  ipv4: string;
  useFallback: boolean;
  finalUrl: string;
  flags: dword;
  headersToSend: string;
begin
  result:=false;
  useFallback := false;
  finalUrl := urlstring;
  headersToSend := fheader;
  flags := INTERNET_FLAG_PRAGMA_NOCACHE or INTERNET_FLAG_RESYNCHRONIZE or INTERNET_FLAG_DONT_CACHE;

  if internet<>nil then
  begin
    u := ParseURI(urlstring);
    // Check if we need to fallback to IPv4
    if IPv6Broken(u.Host) then
    begin
      ipv4 := GetIPv4Address(u.Host);
      if ipv4 <> '' then
      begin
        useFallback := true;
        // Reconstruct URL with IPv4
        finalUrl := StringReplace(urlstring, u.Host, ipv4, [rfIgnoreCase]);
        
        // Add Host header if not already present
        if Pos('Host:', headersToSend) = 0 then
        begin
          if headersToSend <> '' then
            headersToSend := headersToSend + #13#10;
          headersToSend := headersToSend + 'Host: ' + u.Host;
        end;
        
        // Allow invalid CN because IP won't match cert
        flags := flags or INTERNET_FLAG_IGNORE_CERT_CN_INVALID or INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;
      end;
    end;
  
    if headersToSend='' then
      url:=InternetOpenUrl(internet, pchar(finalUrl),nil,0,flags, 0)
    else
      url:=InternetOpenUrl(internet, pchar(finalUrl), @headersToSend[1], length(headersToSend), flags,0);

    if url=nil then exit;

    while InternetQueryDataAvailable(url, available, 0, 0) do
    begin
      if available=0 then break;

      getmem(buf, available+32);
      try
        if InternetReadFile(url, buf, available+32,actualread)=false then break;
        if actualread>0 then
        begin
          results.WriteBuffer(buf[0], actualread);
          result:=true; //something was read
        end;
      finally
        FreeMemAndNil(buf);
      end;
    end;

    InternetCloseHandle(url);
  end;
end;



{$endif}


constructor TWinInternet.create(name: string);
begin

  {$ifdef windows}
  internet:=InternetOpen(pchar(name),0, nil, nil,0);
  {$else}



  fname:=name;
  openssl.DLLVersions[1]:=openssl.DLLVersions[2];
  openssl.DLLVersions[1]:='.46';
  openssl.DLLVersions[2]:='.44';
  InitSSLInterface;
  openssl.ErrClearError;

  recreateFPHTTPClient;

  {$endif}
end;

destructor TWinInternet.destroy;
begin
  if internet<>nil then
  {$ifdef windows}
    InternetCloseHandle(internet);
  {$else}
    freeandnil(internet);
  {$endif}


  inherited destroy;
end;

{$ifndef standalone}

function getInternet(L: Plua_State): integer; cdecl;
begin
  if lua_gettop(l)>0 then
    luaclass_newClass(L, TWinInternet.create({$ifdef altname}'Cheat Engine'{$else}cename{$endif}+' : luascript-'+Lua_ToString(L,1)))
  else
    luaclass_newClass(L, TWinInternet.create({$ifdef altname}'Cheat Engine'{$else}cename{$endif}+' : luascript'));

  result:=1;
end;

function wininternet_getURL(L: Plua_State): integer; cdecl;
var
  i: TWinInternet;
  s: TMemoryStream;
begin
  result:=0;
  i:=luaclass_getClassObject(L);
  if lua_gettop(L)>=1 then
  begin
    s:=TMemoryStream.create;
    try
      if i.getURL(Lua_ToString(L, -1), s) then
      begin
        lua_pushlstring(L, s.Memory, s.Size);
        result:=1;
      end;
    finally
      s.free;
    end;
  end;
end;

function wininternet_postURL(L: Plua_State): integer; cdecl;
var
  i: TWinInternet;
  s: TMemoryStream;
  param: string;
begin
  result:=0;
  i:=luaclass_getClassObject(L);
  if lua_gettop(L)>=1 then
  begin
    s:=TMemoryStream.create;
    try
      if lua_gettop(L)>=2 then
        param:=Lua_ToString(L, 2)
      else
        param:='';

      if i.postURL(Lua_ToString(L, 1), param, s) then
      begin
        lua_pushlstring(L, s.Memory, s.Size);
        result:=1;
      end;
    finally
      s.free;
    end;
  end;
end;

procedure wininternet_addMetaData(L: PLua_state; metatable: integer; userdata: integer );
begin
  object_addMetaData(L, metatable, userdata);
  luaclass_addClassFunctionToTable(L, metatable, userdata, 'getURL', wininternet_getURL);
  luaclass_addClassFunctionToTable(L, metatable, userdata, 'postURL', wininternet_postURL);

end;

procedure initializeLuaInternet;
begin
  lua_register(LuaVM, 'getInternet', getInternet);
end;

{$ifndef windows}
procedure loadCookiesFromRegistry;
var
  r: TRegistry;
  names: tstringlist;
  i: integer;
  c: tstringlist;
begin
  macPortFixRegPath;
  r:=tregistry.Create;
  r.RootKey:=HKEY_CURRENT_USER;
  try
    if r.OpenKey('Cookies',false) then
    begin
      names:=tstringlist.create;

      try
        r.GetValueNames(names);
        for i:=0 to names.count-1 do
        begin
          c:=tstringlist.create;
          r.ReadStringList(names[i],c);
          cookies[names[i]]:=c;
        end;
      finally
        names.free;
      end;
    end;

  except
  end;

  r.free;
end;

procedure saveCookiesToRegistry;
var
  r: TRegistry;
  i: integer;

  e: PStringHashItem;
  host: string;
begin
  r:=TRegistry.Create;
  r.RootKey:=HKEY_CURRENT_USER;

  if r.OpenKey('Cookies',true) then
  begin
    for i:=0 to cookies.count-1 do
    begin
      e:=cookies.List[i];
      if e<>nil then
      begin
        host:=e^.Key;
        r.WriteStringList(host,tstringlist(e^.Data));
      end;

    end;

  end;
  r.free;
end;
{$endif}

initialization
  {$ifndef windows}
  cookies:=TStringHashList.Create(false);
  loadCookiesFromRegistry;
  {$endif}

  luaclass_register(TWinInternet, wininternet_addMetaData);

  {$ifndef windows}
finalization

  saveCookiesToRegistry;
  {$endif}
{$endif}

end.

