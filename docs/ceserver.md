# ceserver / Network Interface Overview

Main file observed:

```text
Cheat Engine/networkInterface.pas
```

## Main class

```text
TCEConnection
```

`TCEConnection` wraps communication with a ceserver-style endpoint.

## Observed command areas

The network interface includes command constants and methods for:

- version queries;
- closing connections;
- terminating the server;
- opening processes;
- creating process/module/thread snapshots;
- closing handles;
- virtual memory queries;
- memory read/write;
- debug start/stop;
- waiting for debug events;
- continuing debug events;
- breakpoints;
- thread suspension/resume;
- thread context get/set;
- architecture and ABI queries;
- module loading;
- extension loading;
- speedhack speed setting;
- option get/set;
- named pipe operations;
- remote file operations;
- directory operations.

## Documentation tasks

To complete this document, review `networkInterface.pas` and document:

1. connection creation;
2. packet formats;
3. command IDs;
4. handle model;
5. error behavior;
6. memory read/write flow;
7. debug event flow;
8. file operation flow;
9. compatibility expectations for ceserver versions.
