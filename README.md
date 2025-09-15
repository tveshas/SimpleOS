# SimpleOS

A custom operating system built from scratch for x86 architecture.

## Features

- **Custom Bootloader**: Loads kernel from disk and switches to 32-bit protected mode
- **VGA Graphics**: 320x200 resolution with 256-color support
- **GUI System**: Multi-window interface with overlapping windows
- **Text Rendering**: Rectangle-based text display system
- **Memory Management**: Direct VGA memory access at 0xA0000

## Build Requirements

- i686-elf-gcc cross-compiler
- i686-elf-ld linker
- QEMU emulator

## Building
```bash
# Compile kernel
i686-elf-gcc -c kernel/gui_kernel_backup.c -o kernel/gui_kernel_backup.o -ffreestanding -m32 -nostdlib

# Link system
i686-elf-ld -o kernel/complete_os.bin -Ttext 0x10000 kernel/high_entry.o kernel/gui_kernel_backup.o kernel/screen.o gui/window.o gui/font.o --oformat binary

# Create bootable image
dd if=kernel/complete_os.bin of=fresh_os.img bs=512 seek=2 conv=notrunc

# Run
qemu-system-i386 -drive format=raw,file=fresh_os.img
