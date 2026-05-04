# Source Map

This source map lists verified files and their observed role in the repository.

## Main application

| Path | Role |
|---|---|
| `Cheat Engine/cheatengine.lpi` | Lazarus project definition for the main application. |
| `Cheat Engine/cheatengine.lpr` | Main program entry point. |

## Memory scanning

| Path | Role |
|---|---|
| `Cheat Engine/memscan.pas` | Memory scanner classes and scan coordination. |

## Debugger

| Path | Role |
|---|---|
| `Cheat Engine/CEDebugger.pas` | Legacy/compatibility debugger references and process attach flow. |
| `Cheat Engine/VEHDebugger.pas` | VEH debugger module. |
| `Cheat Engine/WindowsDebugger.pas` | Windows debugger module. |
| `Cheat Engine/KernelDebugger.pas` | Kernel debugger module. |
| `Cheat Engine/DebuggerInterface.pas` | Debugger interface abstraction. |

## Network / ceserver

| Path | Role |
|---|---|
| `Cheat Engine/networkInterface.pas` | ceserver-style connection and command interface. |

## Lua subsystem

The entry point references many Lua-related units, including:

```text
LuaHandler
frmLuaEngineUnit
LuaMemscan
LuaFoundlist
LuaMemoryRecord
LuaForm
LuaThread
LuaPipe
LuaRemoteExecutor
LuaNetworkInterface
```

## Documentation added in main

| Path | Role |
|---|---|
| `docs/architecture.md` | Architecture overview. |
| `docs/build-windows.md` | Windows build guide. |
| `docs/build-linux.md` | Linux build notes. |
| `docs/build-macos.md` | macOS build notes. |
| `docs/lua-api.md` | Lua subsystem overview. |
| `docs/plugin-sdk.md` | Plugin SDK notes. |
| `docs/memory-scanner.md` | Memory scanner overview. |
| `docs/debugger.md` | Debugger overview. |
| `docs/ceserver.md` | ceserver/network interface overview. |

## Maintenance note

Keep this file updated when adding verified source references.
