#include<stdio.h>

int a=1;
int b = 2;
int result;


int main( )
{

    
   
    printf("aaaaa:");
    asm volatile(
        "\n\tmovl a, %eax "
        "\n\tmovl b, %ebx"
        "\n\taddl %ebx, %eax"
        "\n\tmovl %eax, result"
    );
    
    printf("a = %d  ,b = %d  ,result=%d  ,c=",a,b,result);

    // asm("\n\t movl $1,%eax\n\t movl $0,%ebx\n\t int $0x80\n\t");
      

}
