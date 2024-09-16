#include <onix/interrupt.h>
#include <onix/syscall.h>
#include <onix/debug.h>
#include <onix/task.h>
#include <onix/stdio.h>
// #include <onix/arena.h>
// #include <onix/fs.h>

// #include <asm/unistd_32.h>

#include <onix/mutex.h>

lock_t lock;

#define LOGK(fmt, args...) DEBUGK(fmt, ##args)

void idle_thread()
{
    u32 counter = 0;
    set_interrupt_state(true);
    while (true)
    {
        lock_acquire(&lock);
        LOGK("idle task.... %d\n", counter++);
        lock_release(&lock);
        // BMB;
        // sleep(100000);
        asm volatile(
            "sti\n" // 开中断
            "hlt\n" // 关闭 CPU，进入暂停状态，等待外中断的到来
        );
        yield(); // 放弃执行权，调度执行其他任务
    }
}

extern int main();

int init_user_thread()
{
    while (true)
    {
        u32 status;
        pid_t pid = fork();
        if (pid)
        {
            pid_t child = waitpid(pid, &status);
            // printf("wait pid %d status %d %d\n", child, status, time());
        }
        else
        {
            // main();
        }
    }
    return 0;
}

extern void dev_init();

void init_thread()
{
    // char temp[100]; // 为栈顶有足够的空间
    // dev_init();
    // task_to_user_mode();
    lock_init(&lock);

    u32 counter = 0;
       set_interrupt_state(true);

    while (true)
    {
        lock_acquire(&lock);
        DEBUGK("init thread!!!  counter= %d --------------\n",counter++);
        lock_release(&lock);
        sleep(30);
        // test();
    }
}

void test_thread()
{
    u32 counter = 0;
    set_interrupt_state(true);

    while (true)
    {
        lock_acquire(&lock);
        DEBUGK("test thread!!!  counter= %d \n",counter++);
        lock_release(&lock);
        sleep(10);
        // test();
    }
    
}