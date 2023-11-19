MBALIGN equ 1 << 0
MEMINFO equ 1 << 1
MBFLAGS equ MBALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + MBFLAGS)

section .multiboot
align 4
    dd MAGIC
    dd MBFLAGS
    dd CHECKSUM

section .bss
align 16
stack_bottom:
resb 16384
stack_top:

section .text
global _start:function (_start.end - _start)
_start:
    mov esp, stack_top

        extern kernel_main
        call kernel_main

        cli
.hang:  hlt
        jmp .hang
.end:

        extern gp
        global gdt_flush

        gdt_flush:
            lgdt[gp]
            mov ax, 0x10
            mov ds, ax
            mov es, ax
            mov fs, ax
            mov gs, ax
            mov ss, ax
            jmp 0x08:flush2
        flush2:
            ret