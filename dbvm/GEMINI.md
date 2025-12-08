# Project Overview: DBVM (Debug Virtual Machine)

The `dbvm` project is a low-level bare-metal hypervisor/Virtual Machine Monitor (VMM) developed in C and Assembly. Its core functionality revolves around virtualizing a host system to enable advanced debugging, memory manipulation ("cloaking"), and fine-grained execution control. It supports both Intel (VT-x) and AMD (AMD-V) virtualization technologies.

This project appears to be designed for deep system introspection, modification, and potentially for security research, anti-cheat development, or custom system analysis tools. It features components for boot loading, dynamic memory management, interrupt handling, multi-core CPU initialization, and I/O management. The integration of `distorm64` suggests disassembler capabilities, and `lua` support (when serial port debugging is enabled) points to extensible scripting for control and analysis within the VMM.

## Technologies Used

*   **Languages:** C, Assembly (YASM)
*   **Virtualization Extensions:** Intel VT-x, AMD-V
*   **Build System:** Makefiles
*   **Disassembly:** distorm64
*   **Scripting (Conditional):** Lua
*   **Emulation/Testing:** QEMU

## Building and Running

The project's `Makefile` orchestrates the build process for various components, including the VMM, bootloader, and utility tools. It also provides convenient targets for running the VMM in QEMU.

### Building

To compile all project components:

```bash
make all
```

This command will build the `vmm.elf`, `vmm.bin`, `vmloader.elf`, `vmloader.bin`, `bootloader.bin`, and other executables and images.

### Running in QEMU

The `Makefile` includes targets for running `dbvm` within the QEMU emulator:

*   **Boot from `vmdisk.img` (Floppy Disk Image):**
    ```bash
    make qemu
    ```
    This command executes: `qemu-system-x86_64 -machine q35 -m 512 -fda vmdisk.img -serial stdio`

*   **Boot from `vmcd.iso` (CD-ROM Image):**
    ```bash
    make qemu-cdimage
    ```
    This command first creates the CD image and then executes: `qemu-system-x86_64 -machine q35 -m 5120 -cdrom vmcd.iso -boot d -serial stdio`

*   **QEMU with Serial Debugging:**
    ```bash
    make qemu-debug
    ```
    This target builds the project with `SERIALPORT=0x3f8` and `DISPLAYDEBUG=0` (enabling serial output), then launches QEMU with serial console redirection.

### Cleaning the Project

To remove all generated build artifacts:

```bash
make clean
```

## Development Conventions

*   **Low-Level Programming:** The codebase is predominantly in C and assembly, indicative of its bare-metal nature.
*   **Debugging & Logging:** Extensive use of custom `sendstringf` and `displayline` functions for output, redirected either to a serial port or directly to the emulated screen, controlled by `SERIALPORT` and `DISPLAYDEBUG` build flags. The `bochsbp()` function is also present for Bochs debugger integration.
*   **Memory Management:** Custom memory allocation routines (`malloc2`, `free`) and physical/virtual memory mapping functions are implemented.
*   **Exception Handling:** Custom `try`/`except`/`tryend` blocks are used for managing exceptions.
*   **Concurrency:** Critical sections, implemented with `criticalSection` structures and `csEnter`/`csLeave` functions, manage access to shared resources across multiple CPU cores.
*   **Project Structure:** The project is modular, with separate directories for different functionalities (e.g., `vmm` for the core VMM, `bootsector` for the bootloader, `common` for shared utilities, `distorm64` for disassembly, `lua` for scripting).
