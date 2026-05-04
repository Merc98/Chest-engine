# Memory Scanner Overview

Main file observed:

```text
Cheat Engine/memscan.pas
```

## Main classes

Observed class names include:

- `TMemScan`
- `TScanController`
- `TScanner`
- `TGroupData`
- `Tscanfilewriter`

## Observed scan categories

The memory scanner contains routines for multiple value types and comparison modes, including:

- byte;
- word;
- dword;
- qword;
- single;
- double;
- strings;
- widestrings;
- arrays of bytes;
- grouped data;
- custom types.

Observed comparison styles include:

- exact value;
- range/between;
- bigger than;
- smaller than;
- increased value;
- decreased value;
- changed value;
- unchanged value;
- Lua formula-based comparison.

## Result handling

The scanner includes a writer thread class used for result persistence. The code references address files, memory files, buffering, flushing and saved scan handlers.

## Documentation tasks

To complete this document, review `memscan.pas` section by section and document:

1. scan initialization;
2. region selection;
3. scanner thread lifecycle;
4. result file format;
5. rescan logic;
6. custom type handling;
7. Lua formula flow;
8. UI update hooks.
