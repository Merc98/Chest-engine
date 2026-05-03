# Chest-engine

Repositorio consolidado en `main` a partir de la rama con contenido real (`master`). El proyecto corresponde a una copia/fork de **Cheat Engine 7.5**, una aplicación nativa de escritorio construida principalmente con Lazarus/Free Pascal.

## Estado del repositorio

- Rama consolidada: `main`
- Base usada para `main`: último commit válido de `master`
- Rama original por defecto detectada: `Cheat_Engine_Old`
- Ramas revisadas/detectadas: `master`, `Cheat_Engine_Old`, `revert-184-master`, `revert-2228-CE_spanish`, `wiki`
- `master` contiene el código principal del proyecto.
- `revert-2228-CE_spanish` contiene un cambio de reversión relacionado con `READMEes.md`.
- `revert-184-master` está un commit por delante de `master`, sin cambios de archivos detectados en la comparación disponible.
- `Cheat_Engine_Old` y `wiki` no compartieron ancestro común con `master` en las comparaciones disponibles.

## Descripción

Chest-engine / Cheat Engine es un entorno de desarrollo y análisis enfocado en:

- inspección de procesos;
- escaneo de memoria;
- depuración;
- análisis de regiones de memoria;
- scripting con Lua;
- generación de trainers;
- análisis de estructuras, punteros, símbolos y módulos;
- soporte para componentes auxiliares como speedhack, Mono, .NET, Java, DirectX, TCC y depuradores específicos.

## Estructura principal verificada

### Aplicación principal Lazarus/Free Pascal

Archivos principales:

```text
Cheat Engine/cheatengine.lpi
Cheat Engine/cheatengine.lpr
```

`cheatengine.lpi` define el proyecto Lazarus, título `Cheat Engine 7.5`, modos de compilación de 32 y 64 bits, compilación Windows/macOS, opciones de optimización, rutas de unidades y opciones de internacionalización.

`cheatengine.lpr` es el punto de entrada del programa. Carga unidades internas, inicializa la aplicación, procesa parámetros, carga tablas `.CT` / `.CETRAINER`, inicializa traducciones, preferencias, formularios, Lua y módulos principales.

### Escaneo de memoria

Archivo principal observado:

```text
Cheat Engine/memscan.pas
```

Este módulo contiene clases como `TMemScan`, `TScanController`, `TScanner` y `TGroupData`.

Capacidades observadas por nombres de clases, tipos y rutinas:

- escaneo exacto;
- escaneo por rangos;
- valores cambiados/no cambiados;
- valores incrementados/decrementados;
- tipos byte, word, dword, qword, single, double;
- strings y widestrings;
- arrays de bytes;
- búsquedas agrupadas;
- custom types;
- uso de hilos para escanear regiones;
- escritura de resultados en archivos temporales;
- comparación contra escaneos anteriores.

### Debugger y control de procesos

Archivos/módulos relevantes:

```text
Cheat Engine/CEDebugger.pas
Cheat Engine/VEHDebugger.pas
Cheat Engine/WindowsDebugger.pas
Cheat Engine/KernelDebugger.pas
Cheat Engine/DebuggerInterface.pas
```

`CEDebugger.pas` mantiene referencias de depuración y lógica para adjuntar el depurador a un proceso seleccionado, detener depuración, consultar información de proceso/hilos y enlazar funciones de Windows como `DebugBreakProcess`, `DebugActiveProcessStop`, `NtQueryInformationProcess`, `NtQueryInformationThread` y `NtQuerySystemInformation`.

### Interfaz de red / ceserver

Archivo observado:

```text
Cheat Engine/networkInterface.pas
```

Este módulo define `TCEConnection` y comandos para interactuar con un servidor tipo `ceserver`.

Capacidades observadas por constantes y métodos:

- conexión por socket;
- consulta de versión;
- abrir proceso remoto;
- snapshots de procesos, módulos e hilos;
- lectura/escritura de memoria;
- consulta de regiones de memoria;
- depuración remota;
- breakpoints;
- obtención de arquitectura/ABI;
- carga de módulos/extensiones;
- operaciones de archivos remotos;
- opciones de servidor;
- terminación del servidor.

### Lua y automatización interna

El punto de entrada incluye múltiples unidades `Lua*`, por ejemplo:

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

Esto muestra un subsistema de scripting para automatizar acciones internas, formularios, memoria, listas, componentes visuales y comunicación.

### Componentes auxiliares mencionados por el README original

- `speedhack.lpr`: soporte de speedhack en 32/64 bits.
- `luaclient.lpr`: soporte para `{$luacode}`.
- `DirectXMess.sln`: overlay/snapshot DirectX.
- `DotNetcompiler.sln`: comando Lua `cscompile`.
- `monodatacollector.sln`: inspección de entorno Mono.
- `dotnetdatacollector.sln`: símbolos .NET.
- `dotnetinvasivedatacollector.sln`: soporte JIT runtime .NET.
- `cejvmti.sln`: inspección Java.
- `tcclib.sln`: soporte `{$C}` y `{$CCODE}`.
- `vehdebug.lpr`: interfaz VEH debugger.
- `dbkkernel.sln`: funciones kernel mode.

## Build básico

Requisitos principales:

- Lazarus 2.2.2 / Free Pascal 3.2.2 según README original.
- Visual Studio para varios `.sln` auxiliares.

Pasos básicos:

1. Instalar Lazarus 2.2.2 con FPC 3.2.2.
2. Instalar el cross compiler necesario para 32/64 bits.
3. Abrir Lazarus.
4. Ir a `Project -> Open Project`.
5. Seleccionar:

```text
Cheat Engine/cheatengine.lpi
```

6. Compilar con `Run -> Build` o `Shift + F9`.
7. Para compilar varios modos, usar `Run -> Compile many Modes`.

## Archivos verificados durante la consolidación

- `README.md`
- `READMEes.md`
- `Cheat Engine/cheatengine.lpi`
- `Cheat Engine/cheatengine.lpr`
- `Cheat Engine/memscan.pas`
- `Cheat Engine/CEDebugger.pas`
- `Cheat Engine/networkInterface.pas`

## Enlaces originales del proyecto Cheat Engine

- Website: https://www.cheatengine.org
- Forum: https://forum.cheatengine.org
- Forum alternativo: https://opencheattables.com/
- Forum alternativo: https://fearlessrevolution.com/index.php
- Wiki: https://wiki.cheatengine.org/index.php?title=Main_Page
- Releases: https://github.com/cheat-engine/cheat-engine/releases
