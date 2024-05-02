#include<stdio.h>

int main(int argc, char const *argv[])
{
     int a1 = 10;
    int b1 = 20;
    int result = 21;

    // 固定寄存器方式
    asm volatile(
        "addl %%edx, %%eax\n"    //执行的汇编指令
        :"=a"(result)            //把ax以只读的方式作为输出，输出到result的栈内地址
        :"a"(a1),"d"(b1));       //输入为eax取a1的值，edx取b1的值,
        printf("固定寄存器%d+%d=%d \n",a1,result,result);

    //任意寄存器方式  
    asm volatile(
        "addl %1, %2\n"    //执行的汇编指令
        "movl %2, %0\n"
        :"=&r"(result)            //%0   
        :"r"(a1),"0"(result));       //  "0"作为点位符
    
        printf("同寄存器占位 a1%d+result%d=result%d\n",a1,result,result);

    asm volatile(
        "addl %1, %2\n"    //执行的汇编指令
        "movl %2, %0\n"
        :"=&r"(result)            //%0  把%2表示的寄存器，以只读的方式作为输出，输出到result的栈内地址
        :"r"(a1),"r"(b1));       //输入为eax取a1的值，edx取b1的值,
        printf("任意寄存器%d+%d=%d\n",a1,b1,result);
    
    //自定义点位符  给变量起名字

    asm volatile(
        "addl %[var1], %[var2]\n"    //执行的汇编指令
        "movl %[var2], %[var0]\n"
        :[var0]"=&r"(result)            //%0  把%2表示的寄存器，以只读的方式作为输出，输出到result的栈内地址
        :[var1]"r"(a1),[var2]"r"(b1));       //输入为eax取a1的值，edx取b1的值,
        printf("变量再起名%d+%d=%d\n",a1,b1,result);
    
    //第三字段的使用
    asm volatile(
        "movl %[var1],%%eax\n"
        "movl %[var2],%%edx\n"
        "addl %%edx, %%eax\n"    //执行的汇编指令
        "movl %%eax, %[var0]\n"
        :[var0]"=&r"(result)            //%0  把%2表示的寄存器，以只读的方式作为输出，输出到result的栈内地址
        :[var1]"r"(a1),[var2]"r"(b1)       //输入为eax取a1的值，edx取b1的值,
        :"%eax","%edx"
        );        
        printf("第三字段使用%d+%d=%d\n",a1,b1,result);
    
    //使用内存位置
    asm volatile(
        "movl %[var1],%%eax\n"
        "movl %[var2],%%edx\n"
        "addl %%edx, %%eax\n"    //执行的汇编指令
        "movl %%eax, %[var0]\n"
        :[var0]"=m"(result)            //%0  把%2表示的寄存器，以只读的方式作为输出，输出到result的栈内地址
        :[var1]"m"(a1),[var2]"m"(b1)       //输入为eax取a1的值，edx取b1的值,
        :"%eax","%edx"
        );        
        printf("使用内存内置%d+%d=%d\n",a1,b1,result);

    //不用&会出错的情况
    asm volatile(
        "movl $11,%0\n"
        "movl $22,%1\n"        
        :"=r"(a1)            // 
        :"r"(b1)       
                //  66 "localvar.c" 1
                // 	movl $11,%eax	# tmp121
                //  movl $22,%eax	# b1.28_29
         );        
        printf("不用&会出错的情况a1=%d, b1=%d \n",a1,b1);
    asm volatile(
        "movl $11,%0\n"
        "movl $22,%1\n"        
        :"=&r"(a1)            // 
        :"r"(b1)       
            // movl $11,%eax	# tmp125
            // movl $22,%edx	# b1.31_32
         );        
        printf("用&的情况a1=%d, b1=%d \n",a1,b1);
}
// asm ("assembly code": output : input : changed registers)
// "constraint"(variable)

// | 约束 | 描述                                 |
// | ---- | ------------------------------------ |
// | a    | 使用 eax 及相关寄存器                |
// | b    | 使用 ebx 及相关寄存器                |
// | c    | 使用 ecx 及相关寄存器                |
// | d    | 使用 edx 及相关寄存器                |
// | S    | 使用 esi 及相关寄存器                |
// | D    | 使用 edi 及相关寄存器                |
// | r    | 使用任何可用的通用寄存器             |
// | q    | 使用 eax,ebx,ecx,edx 之一            |
// | A    | 对于 64 位值使用 eax 和 edx 寄存器   |
// | f    | 使用浮点寄存器                       |
// | t    | 使用第一个（顶部的）浮点寄存器       |
// | u    | 使用第二个浮点寄存器                 |
// | m    | 使用变量的内存位置                   |
// | o    | 使用偏移的内存位置                   |
// | V    | 只使用直接内存位置                   |
// | i    | 使用立即数整型                       |
// | n    | 使用值已知的立即数整型               |
// | g    | 使用任何可用的寄存器或者任何内存位置 |

// | 输出修饰符 | 描述                                   |
// | ---------- | -------------------------------------- |
// | +          | 可以读取和写入操作数                   |
// | =          | 只能写入操作数                         |
// | %          | 如果必要，操作数可以和下一个操作数切换 |
// | &          | 相关的寄存器只能用于输出               |
