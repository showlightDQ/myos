[bits 32]

extern kernel_init
extern memory_init
extern gdt_init
extern console_init
global _start
_start:
    ;两个参数
    push ebx  ;ards 
    push eax  ;magic 0x20220205
    call memory_init
    call kernel_init
     

    mov eax,0   ;系统调用号
    int 0x80  ; 系统调用
    jmp $