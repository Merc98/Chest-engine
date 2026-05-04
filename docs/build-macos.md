# macOS Build Notes

The Lazarus project contains macOS-related build configuration and conditional source references.

Main project:

```text
Cheat Engine/cheatengine.lpi
```

The entry point references macOS-specific units under conditional compilation, including names such as:

```text
macport
macportdefines
coresymbolication
macexceptiondebuggerinterface
macCreateRemoteThread
macumm
machotkeys
macPipe
```

## Items to verify

- macOS version.
- CPU architecture.
- Lazarus version.
- FPC version.
- Required frameworks.
- Code signing expectations.
- Output executable path.
- Runtime permissions.

## Build log template

```text
Date:
Branch:
Commit:
macOS version:
CPU:
FPC version:
Lazarus version:
Command:
Result:
Notes:
```
