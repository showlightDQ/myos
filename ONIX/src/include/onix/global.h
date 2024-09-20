#ifndef ONIX_GLOBAL_H
#define ONIX_GLOBAL_H

#include <onix/types.h>

#define GDT_SIZE 128

#define KERNEL_CODE_IDX 1
#define KERNEL_DATA_IDX 2
#define KERNEL_TSS_IDX 3

#define USER_CODE_IDX 4
#define USER_DATA_IDX 5

#define KERNEL_CODE_SELECTOR (KERNEL_CODE_IDX << 3)
#define KERNEL_DATA_SELECTOR (KERNEL_DATA_IDX << 3)
#define KERNEL_TSS_SELECTOR (KERNEL_TSS_IDX << 3)

#define USER_CODE_SELECTOR (USER_CODE_IDX << 3 | 0b11)
#define USER_DATA_SELECTOR (USER_DATA_IDX << 3 | 0b11)

// 全局描述符
typedef struct descriptor_t /* 共 8 个字节 */
{
    unsigned short limit_low;      // 段界限 0 ~ 15 位
    unsigned int base_low : 24;    // 基地址 0 ~ 23 位 16M
    unsigned char type : 4;        // 段类型
    unsigned char segment : 1;     // 1 表示代码段或数据段，0 表示系统段
    unsigned char DPL : 2;         // Descriptor Privilege Level 描述符特权等级 0 ~ 3
    unsigned char present : 1;     // 存在位，1 在内存中，0 在磁盘上
    unsigned char limit_high : 4;  // 段界限 16 ~ 19;
    unsigned char available : 1;   // 该安排的都安排了，送给操作系统吧
    unsigned char long_mode : 1;   // 64 位扩展标志
    unsigned char big : 1;         // 32 位 还是 16 位;
    unsigned char granularity : 1; // 粒度 4KB 或 1B
    unsigned char base_high;       // 基地址 24 ~ 31 位
} _packed descriptor_t;
//    gdt_code:  ;GDT代码段定义
//         dw limit &  0xffff   ;  取GDT的低16位limit
//         dw base & 0xffff   ;取base的低16位（0~15）
//         db (base >> 16) & 0xff  ;取base的16~23位
//         ;    |7:present|6~5:DPL|4:segment|     type|3:Execut|2:C/D|1:R/W|0:Accessed|                      
//         db   0b1001_1010  ;0x9e
//             ;1110： 低4位是段类型，| E | C/D | R/W | A | 表示：代码段，依从，可读，没有访问过
//             ;segment =1 的情况
//             ;Executable E:1代码段 E:0数据段 
//                  ;E=1时 C：1是0否是依从代码段；R：1是0否可读
//             ;E=0时 D：0向上扩展，1向下扩展； W：1是0否可写
//             ;A: Accessed 是否被访问过
//         ;1001  高4位：| Segment |  DPL | DPL | Present | 
//             ;segment:1代码段，0系统段
//             ;DPL：Descriptor Privilege Level 描述符特权等级 0最高，3最低  只能由不低于等级的进程来访问
//             ;present：存在位，1存内存，0存磁盘
            
//         db 0b1100_0000 | (limit >> 16)
//         ;前4位是 limit 的高4位值，后4位是 | granularity | big | long_mode | available |
//         ;available 留用  ； long_mode：64位扩展标志 ； big:1:32位，0:16位；
//         ;granularity:limit表示的粒度 ：1:4K 0:1B  
//         db (base >> 24 ) & 0xff  ;base的高8位
// 段选择子
typedef struct selector_t
{
    u8 RPL : 2; // Request Privilege Level
    u8 TI : 1;  // Table Indicator
    u16 index : 13;
} selector_t;

// 全局描述符表指针
typedef struct pointer_t
{
    u16 limit;
    u32 base;
} _packed pointer_t;

typedef struct tss_t
{
    u32 backlink; // 前一个任务的链接，保存了前一个任状态段的段选择子
    u32 esp0;     // ring0 的栈顶地址
    u32 ss0;      // ring0 的栈段选择子

    u32 esp1;     // ring1 的栈顶地址
    u32 ss1;      // ring1 的栈段选择子
    u32 esp2;     // ring2 的栈顶地址
    u32 ss2;      // ring2 的栈段选择子
    u32 cr3;
    u32 eip;
    u32 flags;
    u32 eax;
    u32 ecx;
    u32 edx;
    u32 ebx;
    u32 esp;
    u32 ebp;
    u32 esi;
    u32 edi;
    u32 es;
    u32 cs;
    u32 ss;
    u32 ds;
    u32 fs;
    u32 gs;
    u32 ldtr;          // 局部描述符选择子
    u16 trace : 1;     // 如果置位，任务切换时将引发一个调试异常
    u16 reversed : 15; // 保留不用
    u16 iobase;        // I/O 位图基地址，16 位从 TSS 到 IO 权限位图的偏移
    u32 ssp;           // 任务影子栈指针
} _packed tss_t;

void gdt_init();

#endif