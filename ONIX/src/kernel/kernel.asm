[bits 32]

extern kernel_init
extern memory_init
global _start
_start:
    ;两个参数
    push ebx  ;ards 
    push eax  ;magic 0x20220205
    call memory_init
    ; xchg bx,bx
    ; call kernel_init
    
    xchg bx,bx


    jmp $