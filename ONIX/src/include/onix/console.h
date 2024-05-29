#ifndef ONIX_CONSOLE_H
    #define ONIX_CONSOLE_H

    #include <onix/types.h>
    #include<onix/io.h>
    #include<onix/string.h>
    
    void console_init();
    void console_clear();
    void put_chars(char* str);
    static void set_screen();
    static void get_screen();
    static void set_cursor();
    static void get_cursor();    
    void console_write(char* buf , u32 count);     
#endif