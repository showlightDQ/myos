#include <onix/task.h>
#include <onix/printk.h>
#include <onix/debug.h>
// #include <onix/memory.h>
#include <onix/assert.h>
// #include <onix/interrupt.h>
#include <onix/string.h>




extern void task_switch(task_t *next);


#define PAGE_SIZE 0x1000

task_t *a = (task_t*) 0x1000;
task_t *b = (task_t*) 0x2000;
int test1 = 123;


task_t *running_task()
{
    asm volatile(
        "movl %esp, %eax\n \t"
        "andl $0xfffff000, %eax\n");
}

void schedule()
{
//     assert(!get_interrupt_state()); // 不可中断

    task_t *current = running_task();
    task_t *next = current == a ? b :a;

    task_switch(next);
}

u32 thread_a()
{
    while (true)
    {
        int c = 200;
        schedule();
    }
}
u32 thread_b()
{
    while (true)
    {
        int c2 = 200;
         
        schedule();
    }
}

static void task_create(task_t *task, target_t target)
{
    u32 stack = (u32)task + PAGE_SIZE;

    stack -= sizeof(task_frame_t);
    task_frame_t *frame = (task_frame_t *)stack;
    frame->edi = 0x33333333;
    frame->esi = 0x22222222;
    frame->ebx = 0x11111111;
    frame->ebp = 0x44444444;
    frame->eip = (void*)target;

    task->stack = (u32 *)stack;
}
void task_init()
{
    task_t *a1 = a;
    task_t *b1 = b;
    int test2 = test1;
    
    task_create(a, thread_a);
    task_create(b, thread_b);
    schedule();

}
int main(int argc, char const *argv[])
{
    task_init();
    return 0;
    
}

