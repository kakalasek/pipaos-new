C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

CC = /home/pipa/opt/cross/bin/i686-elf-gcc

CFLAGS=-ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib

all: boot.o kernel.o
	$(CC) -T linker.ld -o os-image $(LDFLAGS) boot.o kernel.o -lgcc

boot.o: boot/boot.asm
	nasm -felf32 boot/boot.asm -o boot.o

kernel.o: kernel/kernel.c
	$(CC) -c kernel/kernel.c -o kernel.o $(CFLAGS)

clean:
	rm -rf *.bin *.dis *.o os-image *.elf *.o
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o