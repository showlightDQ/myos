#include<onix/console.h>
#include<onix/io.h>

#define CRT_ADDR_REG 0x3d4   //CRT(6845)索引寄存器
#define CRT_DATA_REG 0x3d5   //CRT(6845)数据寄存器

#define CRT_START_ADD_H 0xC //显卡内存起始位置
#define CRT_START_ADD_L 0xD 
#define CRT_CURSOR_H 0xE
#define CRT_CURSOR_L 0xF

#define MEM_BASE 0xb8000
#define MEM_SIZE 0x4000
#define MEM_END (MEM_BASE + MEM_SIZE)
#define WIDTH 80
#define HEIGHT 25
#define ROW_SIZE (WIDTH *2)
#define SCR_SIZE (ROW_SIZE * HEIGHT)

#define ASCII_NULL 0x00
#define ASCII_ENQ  0x05
#define ASCII_BEL  0x07  // \a 
#define ASCII_BS   0x08  //  \b 
#define ASCII_HT   0x09  //  \t 
#define ASCII_LF   0x0A  //  \n 
#define ASCII_VT   0x0B  //  \v 
#define ASCII_FF   0x0C  //  \f 
#define ASCII_CR   0x0D  //  \r 
#define ASCII_DEL  0x7F

static u32 screen;  //当前显示器的起始位置  （内存地址）
static u32 pos; //当前光标位置
static int  x, y;   //坐标

static u8 attr = 7;
static u16 erase = 0x0720 ;  //空格

static void get_screen()
{
    outb (CRT_ADDR_REG , CRT_START_ADD_H);
    screen = inb(CRT_DATA_REG) << 8;
    outb (CRT_ADDR_REG , CRT_START_ADD_L);
    screen |= inb(CRT_DATA_REG) ;

    screen <<= 1;
    screen += MEM_BASE;
}

static void set_screen()
{
    outb (CRT_ADDR_REG , CRT_START_ADD_H);
    outb (CRT_DATA_REG ,((screen - MEM_BASE ) >> 9 ) & 0xff ) ;
    outb (CRT_ADDR_REG , CRT_START_ADD_L);
    outb (CRT_DATA_REG ,((screen - MEM_BASE ) >> 1 ) & 0xff ) ;
}

void console_clear();

void console_write(char* buf , u32 count);
  
void console_init()
{
    // console_clear();
    screen = 80 + MEM_BASE;
    set_screen();
    get_screen();

    screen =  160 + MEM_BASE;
    set_screen();
}
