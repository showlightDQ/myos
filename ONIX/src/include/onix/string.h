#ifndef ONIX_STRING_H
    #define ONIX_STRING_H
    #include<onix/types.h>
    #define CHAR_0 0x30
    #define CHAR_a 0x40
    #define CHAR_DASH 0x2D


    char* strcpy(char* destnation, const char* src);  
    char* strcat(char* dest , const char* src);
    char *strncpy(char *dest, const char *src, size_t count); 
    size_t strlen(const char *str);
    int   strcmp(const char *lhs, const char *rhs);
    char *strchr(const char *str, int ch);
    char *strrchr(const char *str, int ch);
    int   memcmp(const void *lhs, const void *rhs, size_t count);
    void *memset(void *dest, int ch, size_t count);
    void *memcpy(void *dest, const void *src, size_t count);
    void *memchr(const void *str, int ch, size_t count);
    char *strsep(const char *str);
    char *strrsep(const char *str);
    char* int_to_string(int in_number , char* str);


#endif