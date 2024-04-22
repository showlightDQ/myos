#include <stdio.h>

//生成定义GDT的汇编代码

typedef struct descriptor  //8字节 
{
    unsigned short limit_low; // limit 的低16位  1,2 byte
    unsigned int base_low :24;  //base 的 低24位  3,4,5 byte
    unsigned char type : 4;        
    unsigned char segment : 1;
    unsigned char DPL : 2 ;
    unsigned char present : 1;            //6 byte
    unsigned char limit_high : 4;
    unsigned char available : 1 ;
    unsigned char long_mode : 1;
    unsigned char big :1;
    unsigned char granularity : 1;       // 7 byte 
    unsigned char base_high ;            // 8 byte 
} __attribute__((packed)) descriptor;

void make_descriptor(descriptor *dest, unsigned int base, unsigned int limit)
{
    dest->base_low = base & 0xffffff;
    dest->base_high = (base >> 24) & 0xff;

    dest -> limit_low = limit & 0xffff;
    dest->limit_high = (limit >> 16) & 0xf;
}

int main(int argc, char const *argv[])
{
    descriptor dest;
    make_descriptor(&dest, 0x10000, 0x1000 - 1);
    dest.granularity = 0;
    dest.big = 1;
    dest.long_mode = 0;
    dest.present = 1 ;
    dest.DPL = 0;
    dest.segment = 1;
    dest.type = 0b0010;   //数据段，向上扩展，可写
    
    char *ptr = (char*)&dest;
    unsigned short value16 = *(short *)ptr;
    unsigned int value32 ;
    unsigned char value8 ;

    printf("dw 0x%x\n", value16);   // 1, 2 byte

    ptr += 2;
    value16 = *(short*)ptr;
    printf("dw 0x%x\n", value16);   // 3,4 byte 
    
    ptr += 2;
    value8 = *(char*)ptr; 
    printf("db 0x%x\n", value8);   // 5 byte

    ptr ++;
    value8 = *(char*)ptr; 
    printf("db 0x%x\n", value8);   // 6 byte

    ptr ++;
    value8 = *(char*)ptr; 
    printf("db 0x%x\n", value8);    //7 byte 

    ptr ++;
    value8 = *(char*)ptr; 
    printf("db 0x%x\n", value8);    // 8 byte
  
    return 0 ;
}