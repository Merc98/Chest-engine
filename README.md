# Chest-engine

Repositorio consolidado en `main` a partir de la rama con contenido real (`master`). El proyecto corresponde a una copia/fork de **Cheat Engine 7.5**, una aplicación nativa de escritorio para investigación, depuración, análisis de memoria y modificación local de aplicaciones para uso personal y autorizado.

> Nota de seguridad y alcance: este repositorio no debe presentarse como un backend, API web, SaaS o servicio remoto completo. Es principalmente una aplicación nativa construida con Lazarus/Free Pascal, con componentes auxiliares en Pascal, C/C++ y proyectos Visual Studio. Úsalo únicamente en software propio, entornos de laboratorio o escenarios donde tengas permiso explícito.

## Estado del repositorio

- Rama consolidada: `main`
- Base usada para `main`: último commit válido de `master`
- Rama original por defecto detectada: `Cheat_Engine_Old`
- Ramas revisadas/detectadas: `master`, `Cheat_Engine_Old`, `revert-184-master`, `revert-2228-CE_spanish`, `wiki`
- `master` contiene el código principal real del proyecto.
- `revert-2228-CE_spanish` contiene un cambio de reversión relacionado con `READMEes.md`.
- `revert-184-master` está un commit por delante de `master`, sin cambios de archivos detectados en la comparación disponible.
- `Cheat_Engine_Old` y `wiki` no compartieron ancestro común con `master` en las comparaciones disponibles, por lo que no se fusionaron automáticamente para evitar mezclar historiales desconectados.

## Qué es

Chest-engine / Cheat Engine es un entorno de desarrollo y análisis enfocado en:

- inspección de procesos locales;
- escaneo de memoria;
- depuración;
- análisis de regiones de memoria;
- scripting con Lua;
- generación de trainers locales;
- análisis de estructuras, punteros, símbolos y módulos;
- soporte para componentes auxiliares como speedhack, Mono, .NET, Java, DirectX, TCC y depuradores específicos.

## Arquitectura general verificada

### 1. Aplicación principal Lazarus/Free Pascal

El proyecto principal está en:

```text
Cheat Engine/cheatengine.lpi
Cheat Engine/cheatengine.lpr
```

El archivo `.lpi` define el proyecto Lazarus, título `Cheat Engine 7.5`, modos de compilación de 32 y 64 bits, compilación Windows/macOS, opciones de optimización, rutas de unidades y opciones de internacionalización.

El archivo `.lpr` es el punto de entrada del programa. Carga una gran cantidad de unidades internas, inicializa la aplicación, procesa parámetros, carga tablas `.CT` / `.CETRAINER`, inicializa traducciones, preferencias, formularios, Lua y módulos principales.

### 2. Escaneo de memoria

Archivo principal observado:

```text
Cheat Engine/memscan.pas
```

Este módulo contiene clases como `TMemScan`, `TScanController`, `TScanner` y `TGroupData`. Su función es coordinar búsquedas de memoria y guardar resultados.

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

### 3. Debugger y control de procesos

Archivos/módulos relevantes:

```text
Cheat Engine/CEDebugger.pas
Cheat Engine/VEHDebugger.pas
Cheat Engine/WindowsDebugger.pas
Cheat Engine/KernelDebugger.pas
Cheat Engine/DebuggerInterface.pas
```

`CEDebugger.pas` se marca como depurador antiguo/obsoleto, pero aún mantiene referencias. Incluye lógica para adjuntar el depurador a un proceso seleccionado, detener depuración, consultar información de proceso/hilos y enlazar funciones de Windows como `DebugBreakProcess`, `DebugActiveProcessStop`, `NtQueryInformationProcess`, `NtQueryInformationThread` y `NtQuerySystemInformation`.

### 4. Interfaz de red / ceserver

Archivo observado:

```text
Cheat Engine/networkInterface.pas
```

Este módulo define `TCEConnection` y comandos para interactuar con un servidor remoto tipo `ceserver`. No es un backend web. Es una interfaz de comunicación nativa para operaciones remotas controladas por el cliente.

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

### 5. Lua y automatización interna

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

Esto indica que el proyecto tiene un subsistema de scripting amplio para automatizar acciones internas, formularios, memoria, listas, componentes visuales y comunicación.

### 6. Componentes auxiliares mencionados por el README original

El README original menciona proyectos secundarios que deben compilarse aparte si se quieren esas funciones:

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

## Qué NO es

Este repo no debe describirse como:

- un backend web;
- una API REST;
- una app cloud;
- una plataforma SaaS;
- un panel conectado a una base de datos;
- un proyecto listo para producción web;
- una herramienta con servicios externos garantizados.

No encontré evidencia de frontend web moderno, backend Node/Python, rutas API, controladores web, base de datos, autenticación web o despliegue cloud como parte central del proyecto.

## Build básico

Requisitos principales:

- Windows recomendado para la compilación principal.
- Lazarus 2.2.2 / Free Pascal 3.2.2 según README original.
- Visual Studio para varios `.sln` auxiliares.
- Permisos elevados si se va a ejecutar o depurar desde el IDE en Windows.

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

## Auditoría de consistencia

Revisión hecha para evitar documentación falsa:

- Sí hay proyecto Lazarus principal.
- Sí hay punto de entrada `cheatengine.lpr`.
- Sí hay módulo de escaneo de memoria.
- Sí hay módulos de depuración.
- Sí hay integración Lua amplia.
- Sí hay interfaz de red tipo `ceserver`.
- Sí hay README en español (`READMEes.md`) en `master`.
- No hay evidencia de backend web conectado.
- No hay evidencia de base de datos central.
- No hay evidencia de API HTTP propia.
- No se fusionaron ramas sin ancestro común para evitar romper historial.

## Uso responsable

Este software toca áreas sensibles del sistema operativo: memoria de procesos, depuración, módulos remotos y componentes kernel opcionales. Debe usarse únicamente con autorización y en entornos controlados.

## Enlaces originales del proyecto Cheat Engine

- Website: https://www.cheatengine.org
- Forum: https://forum.cheatengine.org
- Forum alternativo: https://opencheattables.com/
- Forum alternativo: https://fearlessrevolution.com/index.php
- Wiki: https://wiki.cheatengine.org/index.php?title=Main_Page
- Releases: https://github.com/cheat-engine/cheat-engine/releases
