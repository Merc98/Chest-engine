# Linux Build Notes

This project is primarily organized around the Lazarus/Free Pascal project under:

```text
Cheat Engine/cheatengine.lpi
```

The repository also contains networking and server-oriented code paths referenced by the source tree.

## Recommended documentation approach

Use this file to document verified Linux build steps only after testing the exact toolchain and target.

## Items to verify

- Free Pascal version.
- Lazarus version.
- Required packages.
- Target CPU architecture.
- Required native libraries.
- ceserver build steps.
- Output paths.
- Runtime paths.

## Current verified repository facts

- The main Lazarus project exists under `Cheat Engine/cheatengine.lpi`.
- The source tree includes Unix/JNI/network conditional compilation paths in some units.
- The network interface includes ceserver-style command handling through `Cheat Engine/networkInterface.pas`.

## Build log template

```text
Date:
Branch:
Commit:
OS:
CPU:
FPC version:
Lazarus version:
Command:
Result:
Notes:
```
