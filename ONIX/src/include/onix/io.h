#ifndef ONIX_IO_H
    #define ONIX_IO_H
    #include<onix/types.h>

    #define CRT_ADDR_REG 0x3d4 
    #define CRT_DATA_REG 0x3d5

    #define CRT_CURSOR_H 0xe
    #define CRT_CURSOR_L 0xf


    extern u8 inb(u16 port);
    extern u16 inw(u16 port);

    extern void outb(u16 port, u8  value);
    extern void outw(u16 port, u16 value);
    

#endif