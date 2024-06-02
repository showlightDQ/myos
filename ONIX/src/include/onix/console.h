#ifndef ONIX_CONSOLE_H
    #define ONIX_CONSOLE_H

    #include <onix/types.h>
    #include<onix/io.h>
    #include<onix/string.h>
    

    static void set_screen() ;
    static void get_screen();
    static void set_cursor();
    static void set_xy_cursor();
    static void get_cursor();
        
    static void scroll_up();
    static void command_lf()  ;
    static void command_cr()  ;
    static void command_bs()  ;
    static void command_del()  ;
    void console_write(char* buf     , u32 count);  
    void console_init();
    void console_clear();
    void console_put_chars(char* str);
#endif