// #include "../include/onix/types.h"
#include "onix/types.h"
#include <stdio.h>

typedef struct descriptor //8字节
{
    u16 limit_low;
    u32 base_low : 24;
    u8 type : 4;
    u8 segment : 1 ;
    u8 DPL : 2 ; 
    u8 present : 1 ;
    u8 limit_high :4 ;
    u8 available : 1 ;
    u8 long_mode : 1 ; 
    u8 big : 1 ;
    u8 granularity : 1; 
    u8 base_high ;
}  descriptor ;

int main(int argc, char const *argv[])
{
    printf("size of u8  %d \n" , sizeof(u8) );
    printf("size of u16 %d \n" , sizeof(u16) );
    printf("size of u32 %d \n" , sizeof(u32) );
    printf("size of u64 %d \n" , sizeof(u64) );
    printf("size of descriptor %d \n" , sizeof(descriptor) );

    descriptor des ;

    return 0;
}
