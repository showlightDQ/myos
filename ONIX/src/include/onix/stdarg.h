#ifndef ONIX_STDARG_H
    #define ONIX_STDARG_H

    typedef char *va_list;

    #define va_start(ap,v) (ap = (va_list) & v + sizeof(char*))  //让ap获得参数的地址，
    #define va_arg(ap,t)   (*(t *)((ap += sizeof(char*)) - sizeof(char*)))   //取ap的值，ap地址加4字节
    #define va_end(ap)     (ap = (va_list)0)
#endif