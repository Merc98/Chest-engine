# Windows Build Guide

This guide documents the build path described by the original project README and the observed Lazarus project file.

## Main tools

- Lazarus 2.2.2
- Free Pascal 3.2.2
- Lazarus cross compiler for the target architecture
- Visual Studio for `.sln` auxiliary projects

## Main project

Open this project in Lazarus:

```text
Cheat Engine/cheatengine.lpi
```

Basic steps:

1. Install Lazarus 2.2.2 with FPC 3.2.2.
2. Install the needed cross compiler package for 32-bit or 64-bit builds.
3. Open Lazarus.
4. Select `Project -> Open Project`.
5. Open `Cheat Engine/cheatengine.lpi`.
6. Build with `Run -> Build` or `Shift + F9`.
7. For multiple targets, use `Run -> Compile many Modes`.

## Build modes

The Lazarus project contains multiple build modes, including 32-bit and 64-bit release configurations and additional target configurations.

The final executable output is configured through the `.lpi` file and generally targets the `bin/` output path.

## Auxiliary components

Some features require separate builds:

| Component | Purpose |
|---|---|
| `speedhack.lpr` | Speedhack DLLs |
| `luaclient.lpr` | Lua code support |
| `DirectXMess.sln` | DirectX overlay and snapshots |
| `DotNetcompiler.sln` | C# compile support from Lua |
| `monodatacollector.sln` | Mono inspection |
| `dotnetdatacollector.sln` | .NET symbols |
| `dotnetinvasivedatacollector.sln` | .NET JIT runtime support |
| `cejvmti.sln` | Java inspection |
| `tcclib.sln` | TCC / inline C support |
| `vehdebug.lpr` | VEH debugger interface |
| `dbkkernel.sln` | Kernel-mode functions |

## Notes

This document records the observed project structure and build information already present in the repository. It does not replace upstream build documentation.
