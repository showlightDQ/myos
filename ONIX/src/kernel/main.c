#include "onix/onix.h"

int magic = ONIX_MAGIC;
char message[] = "hello onix!!!";  //.data
char buf[1024];   //.bss



void kernel_init()
{
     char* show = (char*)0xb8000;
     for (int i = 0; i<sizeof(message); i++)
     {
        show[i*2] = message[i];
      //   *show = message[i];
      //   show += 2;
     }
     
}