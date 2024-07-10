[bits 32]
extern kernel_init
global _start
_start:
    
    mov byte [0xb8000],'K'
    ; xchg bx,bx
    call kernel_init
    
    xchg bx,bx
    int 0x00
    mov ebx ,0
    xchg bx,bx
    div ebx



    xchg bx,bx


    jmp $