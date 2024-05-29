#include<onix/console.h>

#define CRT_ADDR_REG 0x3d4   //CRT(6845)索引寄存器
#define CRT_DATA_REG 0x3d5   //CRT(6845)数据寄存器

#define CRT_START_ADD_H 0xC //显卡内存起始位置  相对于0xB8000的偏移字符数
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

static u32 screen = MEM_BASE;  //当前显示器的起始位置  （内存地址）
static u32 pos = MEM_BASE; //当前光标位置  （内存地址）
static int  x, y;   //光标在当前屏幕上的显示位置。与pos

static u8 attr = 7;
static u16 erase = 0x0720 ;  //空格

void put_chars(char* str)
{
    while(*str != EOS)  
    {
        *(char*)pos++ =  *str++;
        pos++;
    }
    set_cursor();
}




static void set_screen()
{
    outb (CRT_ADDR_REG , CRT_START_ADD_H);
    outb (CRT_DATA_REG ,((screen - MEM_BASE ) >> 9 ) & 0xff ) ;
    outb (CRT_ADDR_REG , CRT_START_ADD_L);
    outb (CRT_DATA_REG ,((screen - MEM_BASE ) >> 1 ) & 0xff ) ;
}
static void get_screen()
{
    outb (CRT_ADDR_REG , CRT_START_ADD_H);
    screen = inb(CRT_DATA_REG) << 8;
    outb (CRT_ADDR_REG , CRT_START_ADD_L);
    screen |= inb(CRT_DATA_REG) ;

    screen <<= 1;
    screen += MEM_BASE;
}

static void set_cursor()
{
    //  
    outb (CRT_ADDR_REG , CRT_CURSOR_H);
    outb (CRT_DATA_REG ,((pos - MEM_BASE) >> 9 ) & 0xff ) ;     //搞清楚：cursor 到底是相对 MEM_BASE的，还是相对于SCREEN的。
    outb (CRT_ADDR_REG , CRT_CURSOR_L);
    outb (CRT_DATA_REG ,((pos - MEM_BASE) >> 1 ) & 0xff ) ;
    
     u32 delta;
    pos > screen ? (delta = (pos - screen) >>1) : (delta = 0);
    x = delta % WIDTH;
    y = delta / WIDTH;
}
static void get_cursor()
{
    outb (CRT_ADDR_REG , CRT_CURSOR_H);
    pos = inb(CRT_DATA_REG) << 8;
    outb (CRT_ADDR_REG , CRT_CURSOR_L);
    pos |= inb(CRT_DATA_REG) ;    
    pos<<=1;
    pos += MEM_BASE;

    get_screen();
    u32 delta;
    pos > screen ? (delta = (pos - screen) >>1) : (delta = 0);
    x = delta % WIDTH;
    y = delta / WIDTH;
}

void console_clear()
{
    screen = MEM_BASE;
    pos = MEM_BASE;
    x = y = 0;
    set_screen();
    set_cursor();
    u16 *ptr = (u16*)MEM_BASE;
    while (ptr <  (u16*)MEM_END)
    {
        *ptr++ = erase;
    }
}


 // 字符命令
    static void scroll_up()
    {
        screen += ROW_SIZE;
        set_screen();
    }
    static void command_lf()  // 换行
    {
        if(pos> MEM_BASE + MEM_SIZE - ROW_SIZE)  //如果光标在显存范围的最后一行，把当前屏复制到MEM_BASE起始的地方，清空后面的内容。
        {
            
            memcpy((void*)MEM_BASE, (void*)(MEM_BASE + MEM_SIZE - SCR_SIZE,SCR_SIZE));
            memset((void*)(MEM_BASE + SCR_SIZE), (char)0, MEM_BASE+MEM_SIZE-SCR_SIZE);
            pos = pos - screen + MEM_BASE;
            screen = MEM_BASE;
            set_screen();
        }
        if  (y == HEIGHT )
        {
            screen += ROW_SIZE;
            y--;
            set_screen();
        }
        pos += ROW_SIZE;
        y++;
        set_cursor();
       
    }
    static void command_cr()  // 回车（不换行）
    {
        pos -= (x*2);
        x = 0;
        set_cursor();
    }
    static void command_bs()  //退格
    {
        pos -= 2;
        *(u16 *)pos = erase;
        set_cursor();
        if(x)
            {
                x--;
            }
            else
            {
                y -= 1;
                x = WIDTH;
            }
    }
    static void command_del()  // DEL 键
    {
        char ch;
        int row_char_count = WIDTH - x ;
        u16* ptr = (u16*)pos;
        while(row_char_count--)
        {
            *ptr = *++ptr;  // 待研究
            *ptr = *(ptr+1);
            ptr++;
        }
        *(u16 *)ptr = erase;
    }



void console_write(char* buf , u32 count)
{
    char ch;
    char* ptr = (char*)pos;
    while (count--)
    {
        ch = *buf++;
        switch (ch)
        {
            case ASCII_NULL:
                break;             
            case ASCII_ENQ  :   
                
                break;
            case ASCII_BEL  :   
                
                break;  // \a 
            case ASCII_BS   :   
                command_bs();
                command_cr();
                break;  //  \b 
            case ASCII_HT   :   
                
                break;  //  \t 
            case ASCII_LF   :   
                command_lf();
                command_cf();
                break;  //  \n 
            case ASCII_VT   :   
                
                break;  //  \v 
            case ASCII_FF   :   
                
                break;  //  \f 
            case ASCII_CR   :   
                command_cr();
                break;  //  \r 
            case ASCII_DEL  :   
                command_del();
                break;


            default:
                *(char*)pos++ = ch ;
                pos++;


        }
    command_lf();
    command_cr();
    set_cursor();
    }

    
}
  
void console_init()
{
    // console_clear();
    pos = 2*2+MEM_BASE;
    set_cursor();
    screen = 5*2 + MEM_BASE;
    set_screen();
    get_screen();
    get_cursor();
 
    screen =  4*2 + MEM_BASE;
    set_screen();
    x = 10;
    y = 4;
    pos = 5*80 + MEM_BASE;
    set_cursor();
    get_cursor();
    put_chars("congratulation!!!");
    console_clear();
    pos = 8*80 + MEM_BASE;
    put_chars("congratulation!!!");


 
}
