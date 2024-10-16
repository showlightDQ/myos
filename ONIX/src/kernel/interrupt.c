#include <onix/interrupt.h>
#include <onix/global.h>
#include <onix/debug.h>
#include <onix/printk.h>
#include <onix/stdlib.h>
#include <onix/io.h>
#include <onix/assert.h>

#define LOGK(fmt, args...) DEBUGK(fmt, ##args)
// // #define LOGK(fmt, args...)

#define ENTRY_SIZE 0x30

#define PIC_M_CTRL 0x20 // 主片的控制端口 用于写入(Initialization Command Words）ICW1
#define PIC_M_DATA 0x21 // 主片的数据端口 用于写入ICW2、3、4  
#define PIC_S_CTRL 0xa0 // 从片的控制端口 
#define PIC_S_DATA 0xa1 // 从片的数据端口
#define PIC_EOI 0x20    // 通知中断控制器中断结束

gate_t idt[IDT_SIZE];
pointer_t idt_ptr;

handler_t handler_table[IDT_SIZE];   //handler_table只不过是个void指针 数组，保存着函数的地址
extern handler_t handler_entry_table[ENTRY_SIZE];
extern void syscall_handler();
extern void page_fault();
extern void schedule();

static char *messages[] = {
    "#DE Divide Error\0",
    "#DB RESERVED\0",
    "--  NMI Interrupt\0",
    "#BP Breakpoint\0",
    "#OF Overflow\0",
    "#BR BOUND Range Exceeded\0",
    "#UD Invalid Opcode (Undefined Opcode)\0",
    "#NM Device Not Available (No Math Coprocessor)\0",
    "#DF Double Fault\0",
    "    Coprocessor Segment Overrun (reserved)\0",
    "#TS Invalid TSS\0",
    "#NP Segment Not Present\0",
    "#SS Stack-Segment Fault\0",
    "#GP General Protection\0",
    "#PF Page Fault\0",
    "--  (Intel reserved. Do not use.)\0",
    "#MF x87 FPU Floating-Point Error (Math Fault)\0",
    "#AC Alignment Check\0",
    "#MC Machine Check\0",
    "#XF SIMD Floating-Point Exception\0",
    "#VE Virtualization Exception\0",
    "#CP Control Protection Exception\0",
};

// // 通知中断控制器，中断处理结束
void send_eoi(int vector)
{
    if (vector >= 0x20 && vector < 0x28)
    {
        outb(PIC_M_CTRL, PIC_EOI);
    }
    if (vector >= 0x28 && vector < 0x30)
    {
        outb(PIC_M_CTRL, PIC_EOI);
        outb(PIC_S_CTRL, PIC_EOI);
    }
}

void set_interrupt_handler(u32 irq, handler_t handler)
{
    assert(irq >= 0 && irq < 16);
    handler_table[IRQ_MASTER_NR + irq] = handler;
}

void set_interrupt_mask(u32 irq, bool enable)
{
    assert(irq >= 0 && irq < 16);
    u16 port;
    if (irq < 8)
    {
        port = PIC_M_DATA;
    }
    else
    {
        port = PIC_S_DATA;
        irq -= 8;
    }
    if (enable)
    {
        outb(port, inb(port) & ~(1 << irq));
    }
    else
    {
        outb(port, inb(port) | (1 << irq));
    }
}

// 清除 IF 位，返回设置之前的值
bool interrupt_disable()
{
    asm volatile(
        "pushfl\n"        // 将当前 eflags 压入栈中
        "cli\n"           // 清除 IF 位，此时外中断已被屏蔽
        "popl %eax\n"     // 将刚才压入的 eflags 弹出到 eax
        "shrl $9, %eax\n" // 将 eax 右移 9 位，得到 IF 位
        "andl $1, %eax\n" // 只需要 IF 位
    );
}

// 获得 IF 位
bool get_interrupt_state()
{
    asm volatile(
        "pushfl\n"        // 将当前 eflags 压入栈中
        "popl %eax\n"     // 将压入的 eflags 弹出到 eax
        "shrl $9, %eax\n" // 将 eax 右移 9 位，得到 IF 位
        "andl $1, %eax\n" // 只需要 IF 位
    );
}

// 设置 IF 位
void set_interrupt_state(bool state)
{
    if (state)
        asm volatile("sti\n");
    else
        asm volatile("cli\n");
}

            int count;
void default_handler(int vector)
{
    send_eoi(vector);  
    DEBUGK("[%x] default interrupt called...%04d\n", vector,count++);
    // schedule(); 
      
}
                
void exception_handler(
    int vector,
    u32 edi, u32 esi, u32 ebp, u32 esp,
    u32 ebx, u32 edx, u32 ecx, u32 eax,
    u32 gs, u32 fs, u32 es, u32 ds,
    u32 vector0, u32 error, u32 eip, u32 cs, u32 eflags          )   
{
    char *message = NULL;
    if (vector < 22)
    {
        message = messages[vector];
    }
    else
    {
        message = messages[15];
    }

    printk("\nEXCEPTION : %s \n", messages[vector]);
    printk("   VECTOR : 0x%02X\n", vector);
    printk("    ERROR : 0x%08X\n", error);
    printk("   EFLAGS : 0x%08X\n", eflags);
    printk("       CS : 0x%02X\n", cs);
    printk("      EIP : 0x%08X\n", eip);
    printk("      ESP : 0x%08X\n", esp);
    // 阻塞
    hang();
}

// // 初始化中断控制器
void pic_init()
{
    outb(PIC_M_CTRL, 0b00010001); // ICW1: 边沿触发, 级联 8259, 需要ICW4.
        /* 0	0	0	1	LTIM	ADI	SINGL	IC4
        ICW1 需要写入到主片的 0x20 端口和从片的 0xA0 端口；
        IC4 表示是否要写入 ICW4，这表示，并不是所有的 ICW 初始化控制字都需要用到；IC4 为 1 时表示需要在后面写入 ICW4 ，为 0 ICW1 则不需要。注意，x86 系统 IC4 必须为1
        SNGL 表示 single，若 SNGL 为 1 ，表示单片，若 SNGL 为 0，表示级联(Cascade)。若在级联模式下，这要涉及到主片和从片用哪个 sIRQ 接口互相连接的问题，所以当 SNGL 为 0 时，主片和从片也是需要 ICW3 的。
        ADI 表示 Call Address Interval，用来设置 8085 的调用时间间隔， x86 不需要设置。
        LTIM 表示 Level/Edge Triggered Mode，用来设置中断检测方式，LTIM 为 0 表示边沿触发，LTIM 为 1 表示电平触发；
        第 4 位的 1 是固定的，这是 ICW1 的标记；// 第 5 ~ 7 位专用于 8085 处理器，x86 不需要，直接置为 0 即可；*/
    outb(PIC_M_DATA, 0x20);       // ICW2: 起始中断向量号 0x20 0b0010_0000
        /*ICW2 需要写入到主片的 0x21 端口和从片的 0xA1；*/
    outb(PIC_M_DATA, 0b00000100); // ICW3: IR2接从片. 主片用置位1表示该口收取从片中断信息 
        //ICW3 仅在 级联的方式 下才需要 (如果 ICW1 中的 SNGL 为 0)，用来设置主片和从片用哪个 IRQ 接口互连。
    outb(PIC_M_DATA, 0b00000001); // ICW4: 8086模式, 正常EOI
    
    //.....................................................................
    outb(PIC_S_CTRL, 0b00010001); // ICW1: 边沿触发, 级联 8259, 需要ICW4.
    outb(PIC_S_DATA, 0x28);       // ICW2: 起始中断向量号 0x28
    outb(PIC_S_DATA, 2);          // ICW3: 设置从片连接到主片的 IR2 引脚，从片用编号标识连接到主片的第几口
    outb(PIC_S_DATA, 0b00000001); // ICW4: 8086模式, 正常EOI

    outb(PIC_M_DATA, 0b11111111); // 关闭所有中断
    outb(PIC_S_DATA, 0b11111111); // 关闭所有中断    
}

// 初始化中断描述符，和中断处理函数数组   
void idt_init()
{
    for (size_t i = 0; i < ENTRY_SIZE; i++)
    {
        gate_t *gate = &idt[i];
        handler_t handler = handler_entry_table[i];       
        gate->offset0 = (u32)handler & 0xffff;
        gate->offset1 = ((u32)handler >> 16) & 0xffff;
        gate->selector = 1 << 3; // 代码段
        gate->reserved = 0;      // 保留不用
        gate->type = 0b1110;     // 中断门
        gate->segment = 0;       // 系统段
        gate->DPL = 0;           // 内核态
        gate->present = 1;       // 有效
    }
    
    for (size_t i = 0; i < 0x20; i++)
    {
        handler_table[i] = exception_handler;
    }    
    // handler_table[0xe] = page_fault;  

    for (size_t i = 0x20; i < ENTRY_SIZE; i++)
    {
        handler_table[i] = default_handler;
    }
    for (size_t i = 0x21; i < ENTRY_SIZE; i++)
    {
        handler_table[i] = default_handler;
    }

    // 初始化系统调用
    gate_t *gate = &idt[0x80];
    gate->offset0 = (u32)syscall_handler & 0xffff;
    gate->offset1 = ((u32)syscall_handler >> 16) & 0xffff;
    gate->selector = 1 << 3; // 代码段
    gate->reserved = 0;      // 保留不用
    gate->type = 0b1110;     // 中断门
    gate->segment = 0;       // 系统段
    gate->DPL = 3;           // 用户态
    gate->present = 1;       // 有效

    idt_ptr.base = (u32)idt;
    idt_ptr.limit = sizeof(idt) - 1;

    asm volatile("lidt idt_ptr\n");
}

void interrupt_init()  //设置中断环境
{
    pic_init();
    idt_init();


}
