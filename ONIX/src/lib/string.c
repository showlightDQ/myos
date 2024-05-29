#include <onix/string.h>

char* strcpy(char* dest, const char* src)
{
    char* ptr = dest;
    while (*src != EOS)
    {
        *ptr++ = *src++;        
    }
    return dest;
}


char* strcat(char* dest , const char* src)
{
    char* ptr= dest;
    while (*dest != EOS) dest++;
    while(*src != EOS)
    {
        *dest++ = *src++;
    }
    return dest;
}
char *strncpy(char *dest, const char *src, size_t count)
{
    char* ptr = dest;
    if (count == 0)   return dest;
    while (count-- != 0  && *src != EOS)
    {
        *dest++ = *src++;        
    }
    *dest = EOS;
    return ptr;
}
 
size_t strlen(const char *str)
{
    int count=0;
    while(*str++ != EOS) count++;
    return count;
}

int strcmp(const char *lhs, const char *rhs)
{
    int loc = 1;
    while(*lhs != EOS | *rhs != EOS)
    {
        if(*lhs - *rhs > 0 )
        {
            return loc;
        }
        
        if(*lhs - *rhs < 0 )
        {
            return -(loc);
        }
        loc++;
        lhs++;
        rhs++;
    }
    return 0;
    
}




char *strchr(const char *str, int ch)
{
    char *ptr = (char *)str;
    while (true)
    {
        if (*ptr == ch)
        {
            return ptr;
        }
        if (*ptr++ == EOS)
        {
            return NULL;
        }
    }
}

char *strrchr(const char *str, int ch)
{
    char *last = NULL;
    char *ptr = (char *)str;
    while (true)
    {
        if (*ptr == ch)
        {
            last = ptr;
        }
        if (*ptr++ == EOS)
        {
            return last;
        }
    }
}

int memcmp(const void *lhs, const void *rhs, size_t count)
{
    char *lptr = (char *)lhs;
    char *rptr = (char *)rhs;
    while ((count > 0) && *lptr == *rptr)
    {
        lptr++;
        rptr++;
        count--;
    }
    if (count == 0)
        return 0;
    return *lptr < *rptr ? -1 : *lptr > *rptr;
}

void *memset(void *dest, int ch, size_t count)
{
    char *ptr = dest;
    while (count--)
    {
        *ptr++ = ch;
    }
    // return dest;
}

void *memcpy(void *dest, const void *src, size_t count)
{
    char *ptr = dest;
    while (count--)
    {
        *ptr++ = *((char *)(src++));
    }
    // return dest;
}

void *memchr(const void *str, int ch, size_t count)
{
    char *ptr = (char *)str;
    while (count--)
    {
        if (*ptr == ch)
        {
            return (void *)ptr;
        }
        ptr++;
    }
}

#define SEPARATOR1 '/'                                       // 目录分隔符 1
#define SEPARATOR2 '\\'                                      // 目录分隔符 2
#define IS_SEPARATOR(c) (c == SEPARATOR1 || c == SEPARATOR2) // 字符是否位目录分隔符

// 获取第一个分隔符
char *strsep(const char *str)
{
    char *ptr = (char *)str;
    while (true)
    {
        if (IS_SEPARATOR(*ptr))
        {
            return ptr;
        }
        if (*ptr++ == EOS)
        {
            return NULL;
        }
    }
}

// 获取最后一个分隔符
char *strrsep(const char *str)
{
    char *last = NULL;
    char *ptr = (char *)str;
    while (true)
    {
        if (IS_SEPARATOR(*ptr))
        {
            last = ptr;
        }
        if (*ptr++ == EOS)
        {
            return last;
        }
    }
}
