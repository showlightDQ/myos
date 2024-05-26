#include "onix/onix.h"
#include "onix/io.h"
#include "onix/types.h"
#include "onix/string.h"
// #include <string.h>
#include "onix/console.h"



#define CRT_ADDR_REG 0x3d4 
#define CRT_DATA_REG 0x3d5

#define CRT_CURSOR_H 0xe
#define CRT_CURSOR_L 0xf


int magic = ONIX_MAGIC;
char message[] = "hello onix!!!";  //.data
char buf[1024];   //.bss



void kernel_init()
{
     // char* show = (char*)0xb8000;
     // for (int i = 0; i<sizeof(message); i++)
     // {
     //    show[i*2] = message[i];
     //      data = inb(CRT_DATA_REG);
        
     //  //   *show = message[i];
     //  //   show += 2;
     // }
   
 
     u8 data = inb(CRT_DATA_REG);
     size_t count = strlen(message);
     u8* strcpyOC ;
     char* pri = (char*) 0xb8000;
     strcpyOC = strcpy(pri,"haha");
     strcpyOC = strncpy(pri, message,20);
     int cmp1 = strcmp("abc","abcd");
     int cmp2 = strcmp("abc","abc");
     int cmp3 = strcmp("","");
     int cmp4 = strcmp("12","1");
     strncpy (buf,"abc",10);
     strncpy (buf,"abc",0);
     strncpy (buf,"abcdefg",4);
     strncpy (buf,"",4);
     int so = sizeof(message);
     console_init();
     console_write(message,so);

     return;

     
}