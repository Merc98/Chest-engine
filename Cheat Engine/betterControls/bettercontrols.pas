unit betterControls;

{$mode delphi}

interface

{$ifdef windows}

uses
  windows,Classes, SysUtils, newRadioButton, newCheckBox, newButton, newListView,
  newEdit, newMainMenu, newForm, newListBox, newProgressBar, newMemo, newComboBox,
  newGroupBox, newSpeedButton, newTreeView, newHeaderControl, newScrollBar,
  newScrollBox, {$ifndef bc_skipsynedit}newSynEdit,{$endif}
  newPageControl, newtabcontrol, newStatusBar,
  newCheckListBox, newCheckGroup, newColorBox, newDirectoryEdit, NewHintwindow,
  newToggleBox, {$ifndef bc_skipvirtualstringtree}newvirtualstringtree,{$endif}
  Graphics, Themes, UxTheme, bettercontrolColorSet;
{$else}
uses {macport,} graphics,math, bettercontrolColorSet;
{$endif}

{$ifdef windows}
type
  TButton=class(TNewButton);
  TCheckBox=class(TNewCheckBox);
  TRadioButton=class(TNewRadioButton);
  TListView=class(TNewListView);
  TEdit=class(TNewEdit);
  TMainMenu=class(TNewMainMenu);
  TMenuItem=class(TNewMenuItem);
  TForm=class(TNewForm);
  TListBox=class(TNewListBox);
  TProgressBar=class(TNewProgressbar);
  TMemo=class(TNewMemo);
  TComboBox=class(TNewComboBox);
  TGroupBox=class(TNewGroupBox);
  TSpeedButton=class(TNewSpeedButton);
  TTreeview=class(TNewTreeView);
  THeaderControl=class(TNewHeaderControl);
  TScrollBar=class(TNewScrollBar);
  TScrollBox=class(TNewScrollBox);
{$ifndef bc_skipsynedit}
  TSynEdit=class(TNewSynEdit);
{$endif}
  TPageControl=class(TNewPageControl);
  TTabControl=class(TNewTabControl);
  TStatusBar=class(TNewStatusBar);
  TCheckListbox=class(TNewCheckListBox);
  TCheckGroup=class(TNewCheckGroup);  //not fully yet (too limited)
  TColorBox=class(TNewColorBox);
  TDirectoryEdit=class(TNewDirectoryEdit);
  THintWindow=class(TNewHintwindow);
  THintWindowClass =class of TNewHintwindow;

  TToggleBox=class(TNewToggleBox);
  {$ifndef bc_skipvirtualstringtree}
  TLazVirtualStringTree=class(TNewLazVirtualStringTree);
  {$endif}

{$endif}
var
  globalCustomDraw: boolean;
  currentColorSet: TBetterControlColorSet;

  //color overrides
  clWindowtext: TColor=graphics.clWindowText;
  clWindow: TColor=graphics.clWindow;
  clHighlight: TColor=graphics.clHighlight;
  clBtnFace: TColor=graphics.clBtnFace;
  clBtnText: TColor=graphics.clBtnText;

  ColorSet: TBetterControlColorSet; //set based on querying the system
  clBtnBorder: TColor=graphics.clBtnText;

  darkmodestring: string=''; //contains ' dark' if darkmode is used (used for settings)

{$ifdef windows}

type
  TAllowDarkModeForWindow = function(hwnd: HWND; state: DWORD): BOOL; stdcall;
  TAllowDarkModeForApp = function(state: integer): BOOL; stdcall;
  TFlushMenuThemes = procedure; stdcall;
  TRefreshImmersiveColorPolicyState = procedure; stdcall;
  TShouldAppsUseDarkMode = function: BOOL; stdcall;


var
  RefreshImmersiveColorPolicyState: TRefreshImmersiveColorPolicyState;
  AllowDarkModeForWindow: TAllowDarkModeForWindow;
  AllowDarkModeForApp: TAllowDarkModeForApp;
  FlushMenuThemes: TFlushMenuThemes;
  _ShouldAppsUseDarkMode: TShouldAppsUseDarkMode;


  procedure registerDarkModeHintHandler;
  procedure registerDarkModeFormAddHandler;
  {$endif}

  {$ifdef darwin}
  type BOOL=boolean;
  {$endif}
  function ShouldAppsUseDarkMode:BOOL;
  function incColor(c: tcolor; amount: integer): tcolor;


implementation

{$ifdef windows}
uses forms, controls, Registry, Win32Proc{$ifndef skip_mainunit2}, mainunit2{$endif};

{$ifdef skip_mainunit2}
const strCheatEngine='VoiceService';
{$endif}


var
  FHandle: THandle;
  FLoaded: Boolean;
  darkmodebuggy: boolean;
{$endif}
function inccolor(c: Tcolor; amount: integer): tcolor;
var  R, G, B : Byte;
begin
  RedGreenBlue(ColorToRGB(c), R, G, B);
  R := min(255, Integer(R) + amount);
  G := min(255, Integer(G) + amount);
  B := min(255, Integer(B) + amount);
  Result := RGBToColor(R, G, B);
end;
{$ifdef windows}
procedure RefreshImmersiveColorPolicyState_stub; stdcall;
begin
end;

function AllowDarkModeForWindow_stub(hwnd: HWND; state: DWORD): BOOL; stdcall;
begin
  exit(false);
end;

function AllowDarkModeForApp_stub(state: integer): BOOL; stdcall;
begin
  exit(false);
end;

var UsesDarkMode: (dmUnknown, dmYes, dmNo)=dmUnknown;

{$endif}
function ShouldAppsUseDarkMode:BOOL; stdcall;
{$ifdef windows}
var reg: tregistry;
{$endif}
begin
  {$IFDEF FORCEDDARKMODE}
  UsesDarkMode:=dmYes;
  exit(true);
  {$ENDIF}
  {$ifdef windows}
  if darkmodebuggy then exit(false);

  if UsesDarkMode=dmUnknown then
  begin

    reg:=TRegistry.Create;
    reg.RootKey:=HKEY_CURRENT_USER;
    if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize',false) then
    begin
      if reg.ValueExists('AppsUseLightTheme') then
      begin
        if reg.ReadInteger('AppsUseLightTheme')=0 then
          UsesDarkMode:=dmYes
        else
          UsesDarkMode:=dmNo;
      end;


      if UsesDarkMode=dmUnknown then
      begin
        if reg.ValueExists('SystemUsesLightTheme') then
        begin
          if reg.ReadInteger('SystemUsesLightTheme')=0 then
            UsesDarkMode:=dmYes
          else
            UsesDarkMode:=dmNo;
        end;
      end;
    end;

    reg.free;

    if UsesDarkMode=dmUnknown then
    begin
      UsesDarkMode:=dmNo;
      if assigned(_ShouldAppsUseDarkMode) then
      begin
        if _ShouldAppsUseDarkMode() then
          UsesDarkMode:=dmYes;
      end;
    end;
  end;

  exit(UsesDarkMode=dmyes);
  {$else}
  exit(false);
  {$endif}
end;

{$ifdef windows}


type
  TBCFormEventHandler=class
  private
    procedure ShowHintEvent(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure FormAddedEvent(Sender: TObject; Form: TCustomForm);
  end;

procedure TBCFormEventHandler.ShowHintEvent(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if ShouldAppsUseDarkMode then
    HintInfo.HintColor:=ColorSet.TextBackground;
end;

procedure TBCFormEventHandler.FormAddedEvent(Sender: TObject; Form: TCustomForm);
begin
  {if ShouldAppsUseDarkMode then
  begin
    form.color:=$242424;
    if form.font.color=clDefault then
      form.font.color:=colorset.FontColor;
  end;  }

  //todo
end;

procedure registerDarkModeHintHandler;
var hh: TBCFormEventHandler;
begin
  hh:=TBCFormEventHandler.Create;
  application.AddOnShowHintHandler(hh.ShowHintEvent);
end;

procedure registerDarkModeFormAddHandler;
var hh: TBCFormEventHandler;
begin
  hh:=TBCFormEventHandler.Create;
  screen.AddHandlerFormAdded(hh.FormAddedEvent);
end;

var
  c: TColorRef;
  theme: THandle;
  i: integer;
  reg: TRegistry;
  // Pink theme: system color overrides for SetSysColors
  pinkSysIndices: array[0..19] of Integer;
  pinkSysColors:  array[0..19] of COLORREF;

{$endif}
initialization

  //setup ColorSet

  ColorSet.FontColor:=clWindowtext;
  colorset.TextBackground:=clWindow;

  {$ifdef windows}
  darkmodebuggy:=true;
  try
    currentColorSet:=ColorSet;

    RefreshImmersiveColorPolicyState:=@RefreshImmersiveColorPolicyState_stub;
    AllowDarkModeForWindow:=@AllowDarkModeForWindow_stub;
    AllowDarkModeForApp:=@AllowDarkModeForApp_stub;
    FlushMenuThemes:=@RefreshImmersiveColorPolicyState_stub;

    for i:=1 to Paramcount do
      if uppercase(ParamStr(i))='NOTDARK' then exit;

    reg:=tregistry.create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\'+strCheatEngine,false) then
      begin
        if reg.ValueExists('Disable DarkMode Support') and
           reg.ReadBool('Disable DarkMode Support') then exit;
      end;
    finally
      reg.free;
    end;


    if WindowsVersion>=wv10 then
    begin
      FHandle := LoadLibrary('uxtheme.dll');
      if FHandle<>0 then
      begin
        @RefreshImmersiveColorPolicyState := GetProcAddress(FHandle, MakeIntResource(104));
        @AllowDarkModeForWindow := GetProcAddress(FHandle, MakeIntResource(133));
        @AllowDarkModeForApp := GetProcAddress(FHandle, MakeIntResource(135));
        @FlushMenuThemes := GetProcAddress(FHandle, MakeIntResource(136));
        @_ShouldAppsUseDarkMode := GetProcAddress(FHandle, MakeIntResource(132));
      end;


      if not assigned(RefreshImmersiveColorPolicyState) then RefreshImmersiveColorPolicyState:=@RefreshImmersiveColorPolicyState_stub;
      if not assigned(AllowDarkModeForWindow) then AllowDarkModeForWindow:=@AllowDarkModeForWindow_stub;
      if not assigned(AllowDarkModeForApp) then AllowDarkModeForApp:=@AllowDarkModeForApp_stub;
      if not assigned(FlushMenuThemes) then FlushMenuThemes:=@RefreshImmersiveColorPolicyState_stub;


      AllowDarkModeForApp({$IFDEF FORCEDDARKMODE}2{$ELSE}1{$ENDIF});  //3 is disable, 2=force on, 1=system default


      FlushMenuThemes;
      RefreshImmersiveColorPolicyState;

      darkmodebuggy:=false;

      theme:=OpenThemeData(0,'ItemsView');
      if theme<>0 then
      begin
        GetThemeColor(theme, 0,0,TMT_TEXTCOLOR,ColorSet.FontColor);
        GetThemeColor(theme, 0,0,TMT_FILLCOLOR,ColorSet.TextBackground);
        colorset.InactiveFontColor:=ColorSet.FontColor xor $aaaaaa;
        ColorSet.ButtonBorderColor:=deccolor(ColorSet.FontColor,10);

        clwindowText:=ColorSet.FontColor;

        CloseThemeData(theme);

        if ShouldAppsUseDarkMode() then
        begin
          ColorSet.CheckboxFillColor:=$e8e8e8;
          ColorSet.InactiveCheckboxFillColor:=$999999;
          clBtnFace:=inccolor(ColorSet.TextBackground,8);
          clBtnText:=ColorSet.FontColor;

          clBtnBorder:=$9b9b9b;

          clWindow:=colorset.TextBackground;

          ColorSet.CheckboxCheckMarkColor:=InvertColor(ColorSet.CheckboxFillColor);
          ColorSet.InactiveCheckboxCheckMarkColor:=InvertColor(ColorSet.CheckboxCheckMarkColor);

          darkmodestring:=' dark';
        end;
      end;
    end;


  except

  end;
  {$endif}

  // ── Pink Theme ──────────────────────────────────────────────────────────────
  // Override all system/dark-mode colors with a rose-pink palette.
  // TColor format: $00BBGGRR
  ColorSet.FontColor               := $0032145A;  // dark rose         RGB( 90, 20, 50)
  ColorSet.InactiveFontColor       := $00643C78;  // muted rose        RGB(120, 60,100)
  ColorSet.TextBackground          := $00F5F0FF;  // lavender blush    RGB(255,240,245)
  ColorSet.EditBackground          := $00E9E4FF;  // misty rose        RGB(255,228,233)
  ColorSet.ButtonFaceColorDefault  := $00C1B6FF;  // light pink        RGB(255,182,193)
  ColorSet.ButtonFaceColorHover    := $00A08AFF;  // rose              RGB(255,138,160)
  ColorSet.ButtonFaceColorDown     := $00B469FF;  // hot pink          RGB(255,105,180)
  ColorSet.ButtonFaceColorDisabled := $00DCD2FF;  // pale pink         RGB(255,210,220)
  ColorSet.ButtonBorderColor       := $008264B4;  // deep rose border  RGB(180,100,130)
  ColorSet.ButtonBorderColorHover  := $005A3C96;  // darker border     RGB(150, 60, 90)
  ColorSet.ButtonInactiveBorderColor:=$00AA96C8;  // inactive border   RGB(200,150,170)
  ColorSet.CheckboxFillColor       := $00AA82FF;  // pink checkbox     RGB(255,130,170)
  ColorSet.InactiveCheckboxFillColor:=$00C8B4DC;  // pale checkbox     RGB(220,180,200)
  ColorSet.CheckboxCheckMarkColor  := $00F5F0FF;  // light mark        RGB(255,240,245)
  ColorSet.InactiveCheckboxCheckMarkColor:=$00DCD2FF;

  clWindowText := ColorSet.FontColor;
  clWindow     := ColorSet.TextBackground;
  clBtnFace    := ColorSet.ButtonFaceColorDefault;
  clBtnText    := ColorSet.FontColor;
  clHighlight  := ColorSet.ButtonFaceColorDown;
  clBtnBorder  := ColorSet.ButtonBorderColor;

  darkmodestring := '';  // force light-mode registry key suffix

  {$ifdef windows}
  // Also override Windows system colors so native controls (scrollbars,
  // menus, title bars, combobox dropdowns) also use the pink palette.
  // SetSysColors affects only the current process.
  // Windows system color indices (winuser.h)
  pinkSysIndices[0]  := 0;   // COLOR_SCROLLBAR
  pinkSysIndices[1]  := 1;   // COLOR_BACKGROUND
  pinkSysIndices[2]  := 2;   // COLOR_ACTIVECAPTION
  pinkSysIndices[3]  := 3;   // COLOR_INACTIVECAPTION
  pinkSysIndices[4]  := 4;   // COLOR_MENU
  pinkSysIndices[5]  := 5;   // COLOR_WINDOW
  pinkSysIndices[6]  := 6;   // COLOR_WINDOWFRAME
  pinkSysIndices[7]  := 7;   // COLOR_MENUTEXT
  pinkSysIndices[8]  := 8;   // COLOR_WINDOWTEXT
  pinkSysIndices[9]  := 9;   // COLOR_CAPTIONTEXT
  pinkSysIndices[10] := 13;  // COLOR_HIGHLIGHT
  pinkSysIndices[11] := 14;  // COLOR_HIGHLIGHTTEXT
  pinkSysIndices[12] := 15;  // COLOR_BTNFACE
  pinkSysIndices[13] := 16;  // COLOR_BTNSHADOW
  pinkSysIndices[14] := 17;  // COLOR_GRAYTEXT
  pinkSysIndices[15] := 18;  // COLOR_BTNTEXT
  pinkSysIndices[16] := 19;  // COLOR_INACTIVECAPTIONTEXT
  pinkSysIndices[17] := 20;  // COLOR_BTNHIGHLIGHT
  pinkSysIndices[18] := 24;  // COLOR_INFOBK
  pinkSysIndices[19] := 23;  // COLOR_INFOTEXT

  // COLORREF = $00BBGGRR (same byte order as TColor)
  pinkSysColors[0]  := $00DCD2FF;  // scrollbar        pale pink
  pinkSysColors[1]  := $00F5F0FF;  // desktop bg       lavender blush
  pinkSysColors[2]  := $00B469FF;  // active caption   hot pink
  pinkSysColors[3]  := $008264B4;  // inactive caption deep rose
  pinkSysColors[4]  := $00C1B6FF;  // menu bg          light pink
  pinkSysColors[5]  := $00F5F0FF;  // window bg        lavender blush
  pinkSysColors[6]  := $008264B4;  // window frame     deep rose
  pinkSysColors[7]  := $0032145A;  // menu text        dark rose
  pinkSysColors[8]  := $0032145A;  // window text      dark rose
  pinkSysColors[9]  := $00F5F0FF;  // caption text     light (on hot pink)
  pinkSysColors[10] := $00B469FF;  // highlight        hot pink
  pinkSysColors[11] := $00F5F0FF;  // highlight text   lavender blush
  pinkSysColors[12] := $00C1B6FF;  // btn face         light pink
  pinkSysColors[13] := $008264B4;  // btn shadow       deep rose
  pinkSysColors[14] := $008264B4;  // gray text        deep rose
  pinkSysColors[15] := $0032145A;  // btn text         dark rose
  pinkSysColors[16] := $00E9E4FF;  // inactive caption text
  pinkSysColors[17] := $00DCD2FF;  // btn highlight    pale pink
  pinkSysColors[18] := $00E9E4FF;  // tooltip bg       misty rose
  pinkSysColors[19] := $0032145A;  // tooltip text     dark rose

  SetSysColors(20, pinkSysIndices[0], pinkSysColors[0]);
  {$endif}
  // ────────────────────────────────────────────────────────────────────────────
end.

