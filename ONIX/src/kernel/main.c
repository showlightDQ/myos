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

// #define CRT_ADDR_REG 0x3d4
// #define CRT_DATA_REG 0x3d5

// #define CRT_CURSOR_H 0xe
// #define CRT_CURSOR_L 0xf

void test_args(int cnt, ...)
{
     va_list args;
     va_start(args, cnt);

     int arg;
     while (cnt--)
     {
          arg = va_arg(args, int);
     }
     va_end(args);
}

void kernel_init()
{
     
     magic_breakpoint();
     console_init();
     asm volatile("xchgw %bx, %bx");
     int cnt = 30;
     while (cnt--)
     {
          printk("hello onix %#010x\n", cnt);
     }
     DEBUGK("debug here! \n ");
     gdt_init();

     BMB;
     task_init();

     return;
}