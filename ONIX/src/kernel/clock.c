#include <onix/io.h>
#include <onix/interrupt.h>
#include <onix/assert.h>
#include <onix/debug.h>
#include <onix/task.h>
#include <onix/timer.h>

#define PIT_CHAN0_REG 0X40
#define PIT_CHAN2_REG 0X42
#define PIT_CTRL_REG 0X43  // 时间芯片的端口号

#define HZ 1
#define OSCILLATOR 1193182
#define CLOCK_COUNTER (OSCILLATOR / HZ)
#define JIFFY (1000 / HZ)

#define SPEAKER_REG 0x61
#define BEEP_HZ 4400
#define BEEP_COUNTER (OSCILLATOR / BEEP_HZ)
#define BEEP_MS 100

u32 volatile jiffies = 0;   //全局时间片
u32 jiffy = JIFFY;

int beeping = 0;
// bool volatile beeping = 0;

void start_beep()
{
    if (!beeping)
    {
        outb(SPEAKER_REG, inb(SPEAKER_REG) | 0b11);
        // beeping = true;
        // beeping = jiffies + 50 ;

    
        // task_sleep(BEEP_MS);

        // outb(SPEAKER_REG, inb(SPEAKER_REG) & 0xfc);
        // beeping = false;
    }
}
void stop_beep()
{
    if (beeping  && beeping < jiffies)
    {
        outb(SPEAKER_REG, inb(SPEAKER_REG) & 0xfc);
        beeping = 0;
    }
}

void clock_handler(int vector)
{
    static int  i = 1,j,k;
    assert(vector == 0x20); 
    send_eoi(vector); // 发送中断处理结束  
                     
    jiffies++;
    // if(jiffies%50 == 0)
    // {
    //     start_beep();
    // j = OSCILLATOR/i ;
    // i = i + i/100 +1;
    // if(i>23000) i = 20;    
    // outb(PIT_CTRL_REG, 0b10110110);
    // outb(PIT_CHAN2_REG, (u8)j);
    // outb(PIT_CHAN2_REG, (u8)(j >> 8));
    //     DEBUGK("beep %d\n",i);
    // }   
    //     DEBUGK("clock jiffies vector=%p,%d\n",vector, jiffies);
    stop_beep();
    

    // timer_wakeup();

    task_t *task = running_task();  // task指针指向 栈底，栈的前N个字节保存的栈信息结构体
    assert(task->magic == ONIX_MAGIC);  //结构体的最后一个数据是 魔数，检测魔数防止栈push越界

    task->jiffies = jiffies;  //更新全局时间片
    task->ticks--;  // 进程时间片减一
    if (!task->ticks)   // 如果任务时间片用完了，切换任务
    {
        schedule();
    }
}

// extern time_t startup_time;
// 
// time_t sys_time()
// {
//     return startup_time + (jiffies * JIFFY) / 1000;
// }

void pit_init()
{
    // 配置计数器 0 时钟
    outb(PIT_CTRL_REG, 0b00110100);
    outb(PIT_CHAN0_REG, CLOCK_COUNTER & 0xff);
    outb(PIT_CHAN0_REG, (CLOCK_COUNTER >> 8) & 0xff);

    // 配置计数器 2 蜂鸣器
    outb(PIT_CTRL_REG, 0b10110110);
    outb(PIT_CHAN2_REG, (u8)BEEP_COUNTER);
    outb(PIT_CHAN2_REG, (u8)(BEEP_COUNTER >> 8));
}

void clock_init()
{
    pit_init();  // 设置时钟寄存器
    set_interrupt_handler(IRQ_CLOCK, clock_handler);  // 注册 时钟中断（把handler的地址作为IRQ_CLOCK号中断的跳转目标），handler的任务是进程切换
    set_interrupt_mask(IRQ_CLOCK, true); //向中断芯片发送掩码，打开IRQ_CLOCK号中断的许可
}
