# Architecture

Chest-engine is organized around a native Lazarus/Free Pascal desktop application with supporting modules for memory scanning, debugging, scripting, networking and optional native components.

## Main application

Primary files:

```text
Cheat Engine/cheatengine.lpi
Cheat Engine/cheatengine.lpr
```

`cheatengine.lpi` is the Lazarus project file. It defines build modes, target platforms, compiler options, search paths and project metadata.

`cheatengine.lpr` is the program entry point. It initializes the application, loads internal units, handles command-line parameters, loads `.CT` and `.CETRAINER` files, initializes translation support and starts the UI.

## Major subsystems

### Memory scanning

Main file:

```text
Cheat Engine/memscan.pas
```

This subsystem coordinates memory scans through classes such as `TMemScan`, `TScanController`, `TScanner` and `TGroupData`.

Observed capabilities include exact scans, range scans, changed/unchanged comparisons, increased/decreased comparisons, byte arrays, strings, custom types, grouped scans and multi-threaded scanning.

### Debugging

Relevant modules include:

```text
Cheat Engine/CEDebugger.pas
Cheat Engine/VEHDebugger.pas
Cheat Engine/WindowsDebugger.pas
Cheat Engine/KernelDebugger.pas
Cheat Engine/DebuggerInterface.pas
```

These modules handle debugger attachment, debug events, breakpoints, thread/process state and platform-specific debugger interfaces.

### Lua scripting

The application entry point references a large Lua subsystem through units such as `LuaHandler`, `frmLuaEngineUnit`, `LuaMemscan`, `LuaFoundlist`, `LuaMemoryRecord`, `LuaForm`, `LuaThread`, `LuaPipe`, `LuaRemoteExecutor` and `LuaNetworkInterface`.

Lua support is used for automation, table logic, trainers, UI scripting and internal extension points.

### Network interface / ceserver

Main file:

```text
Cheat Engine/networkInterface.pas
```

The `TCEConnection` class and related command constants implement communication with a `ceserver`-style endpoint. The observed interface includes process enumeration, module/thread snapshots, memory read/write, debug event handling, breakpoints, file operations, option exchange and server termination commands.

### Auxiliary projects

The original README references supporting projects including:

- `speedhack.lpr`
- `luaclient.lpr`
- `DirectXMess.sln`
- `DotNetcompiler.sln`
- `monodatacollector.sln`
- `dotnetdatacollector.sln`
- `dotnetinvasivedatacollector.sln`
- `cejvmti.sln`
- `tcclib.sln`
- `vehdebug.lpr`
- `dbkkernel.sln`

These components are compiled separately when their corresponding functionality is needed.

## Repository-level organization added in `main`

```text
docs/        Project documentation
examples/    Example tables, Lua snippets and plugin skeletons
plugins/     Plugin SDK notes and sample layout
reports/     Report templates
scripts/     Utility scripts for validation and documentation checks
.github/     GitHub Actions workflows
```

This structure is documentation and project organization. It does not replace the original source layout under `Cheat Engine/`.
