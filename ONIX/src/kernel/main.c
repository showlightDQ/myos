#include "onix/onix.h"
#include "onix/io.h"
#include "onix/types.h"

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