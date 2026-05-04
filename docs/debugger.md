# Debugger Overview

Debugger-related units observed in the project include:

```text
Cheat Engine/CEDebugger.pas
Cheat Engine/VEHDebugger.pas
Cheat Engine/WindowsDebugger.pas
Cheat Engine/KernelDebugger.pas
Cheat Engine/DebuggerInterface.pas
```

## Observed responsibilities

The debugger subsystem covers:

- attaching to a selected process;
- checking whether a process is available;
- debugger thread creation;
- debug event handling;
- breakpoint support;
- Windows API linking;
- process and thread information queries;
- kernel debugger integration through separate modules.

## Windows functions observed in `CEDebugger.pas`

Examples include:

- `DebugBreakProcess`
- `DebugActiveProcessStop`
- `DebugSetProcessKillOnExit`
- `IsDebuggerPresent`
- `NtQuerySystemInformation`
- `NtQueryInformationProcess`
- `NtQueryInformationThread`
- `NtSuspendProcess`
- `NtResumeProcess`

## Documentation tasks

To complete this document, review the debugger units and document:

1. debugger selection flow;
2. process attach flow;
3. breakpoint types;
4. thread/context handling;
5. VEH debugger flow;
6. Windows debugger flow;
7. kernel debugger flow;
8. UI integration points.
