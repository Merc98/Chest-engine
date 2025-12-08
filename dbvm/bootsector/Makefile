ASM = nasm
AFLAGS = -f bin

# Pfad zur Kernel-/VM-Image-Datei, deren Größe wir als 'size' definieren
KERNEL_IMAGE = ../vmloader.bin

all:
	@echo "Building bootloader..."
	@${ASM} ${AFLAGS} bootloader.asm -o ../bootloader.bin -Dsize=`stat -c%s ${KERNEL_IMAGE}`
	@echo "bootloader created"

clean:
	@rm -f ../bootloader.bin
	@rm -f *.*~
	@echo "bootloader cleaned"
