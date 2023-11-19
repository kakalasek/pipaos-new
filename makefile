C_SOURCES = $(wildcard kernel/*.c drivers/*.c system/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h system/*.h)

OBJ = ${C_SOURCES:.c=.o}

CC = /home/pipa/opt/cross/bin/i686-elf-gcc
LINKER = linker/linker.ld

CFLAGS=-ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

os-image: boot/boot.o kernel/kernel.o ${OBJ}
	$(CC) -T $(LINKER) -o os-image $(LDFLAGS) $^ -lgcc

run: os-image
	qemu-system-i386 -kernel os-image

run-iso: iso
	qemu-system-i386 -cdrom os-image.iso

iso: os-image
	cp os-image isofiles/boot
	grub-mkrescue -o os-image.iso isofiles

boot/boot.o: boot/boot.asm
	nasm -felf32 $< -o $@

%.o: %.c ${HEADERS}
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -rf os-image isofiles/boot/os-image os-image.iso
	rm -rf boot/*.o
	rm -rf drivers/*.o
	rm -rf kernel/*.o
	rm -rf system/*.o

.PHONY: clean kernel run iso run-iso os-image