/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif
 
/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif 

#include "../drivers/vga.h"
#include "../system/system.h"
#include "../gdt/gdt.h"
#include "../idt/idt.h"
#include "../idt/isr.h"
#include "../idt/irq.h"
 
void kernel_main(void) 
{
	gdt_install();
    idt_install();
    isrs_install();
    irq_install();

	clear_screen();
	print_string("Hello :)");
}