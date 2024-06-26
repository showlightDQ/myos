#include<stdio.h>

extern int add(int  ,int );
extern int __attribute__((fastcall)) sub(int ,int);
void fomit(void)
{
    printf("gcc -fomit-frame-pointer\n");
    //用-fomit-frame-pointer参数编译，可看到无栈移动编译的效果。
    //一些编译器不支持这个参数。dbg是无法跟踪、回溯栈
}
int main(int argc, char const *argv[])
{

    int i = 3; 
    int j = 4;
    int k = add(i,j);
    printf("%d+%d=%d\n",i,j,k);

     i = 7;
     j = 9;
     k = sub(i,j); //fastcall 属性的作用，调用前不用把参数入栈，而是把参数存入ecx,edx （从右向左）见汇编码
                    // movl	-8(%ebp), %edx	# j, tmp85
                    // movl	-12(%ebp), %eax	# i, tmp86
                    // movl	%eax, %ecx	# tmp86,
                    // call	sub	#
    printf("%d-%d=%d\n",i,j,k);

    fomit();

    return 0;
}

//CDECL =  C declaration C的函数调用约定
//ABI 约定 Application Binary Interface