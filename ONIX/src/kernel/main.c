#include "onix/onix.h"
#include "onix/io.h"
#include "onix/types.h"
#include "onix/string.h"
#include "onix/console.h"
#include <onix/stdarg.h>
#include <onix/printk.h>
#include <onix/assert.h>
#include <onix/debug.h>
#include <onix/global.h>
#include <onix/task.h>
#include <onix/interrupt.h>
#include <onix/stdlib.h>

extern void clock_init();
// #define CRT_ADDR_REG 0x3d4
// #define CRT_DATA_REG 0x3d5

// #define CRT_CURSOR_H 0xe
// #define CRT_CURSOR_L 0xf


void kernel_init()
{
     
     asm volatile("xchgw %bx, %bx");
          
     console_init();
     
     gdt_init();
     interrupt_init();
     // task_init();
     clock_init();
     asm volatile("sti\n");
     hang();
  

     return;
}