#include "onix/onix.h"
#include "onix/io.h"
#include "onix/types.h"



#define CRT_ADDR_REG 0x3d4 
#define CRT_DATA_REG 0x3d5

#define CRT_CURSOR_H 0xe
#define CRT_CURSOR_L 0xf


int magic = ONIX_MAGIC;
char message[] = "hello onix!!!";  //.data
char buf[1024];   //.bss



void kernel_init()
{
     char* show = (char*)0xb8000;
     for (int i = 0; i<sizeof(message); i++)
     {
        show[i*2] = message[i];
        u8 data = 22; 
      //   *show = message[i];
      //   show += 2;
     }

     u8 data = inb(CRT_DATA_REG);
     
}