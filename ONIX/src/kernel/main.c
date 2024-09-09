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
#include <onix/rtc.h>
#include <onix/memory.h>
// #include <onix/time.h>

extern void time_init();
extern void rtc_init();

extern void clock_init();
extern void bitmaptest();

// #define CRT_ADDR_REG 0x3d4
// #define CRT_DATA_REG 0x3d5

// #define CRT_CURSOR_H 0xe
// #define CRT_CURSOR_L 0xf


void kernel_init()
{
     
     asm volatile("xchgw %bx, %bx");
     memory_map_init();
     mapping_init();
     interrupt_init();
     clock_init();
     task_init();

     // set_alarm(2);
     // time_init();
     // rtc_init();
     set_interrupt_state(true);

     hang();

     return;
}