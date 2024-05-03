[bits 32]
extern main
section .text
global _start
_start:
    xchg bx,bx
    mov byte [0xb8000],"S"
    call main
    jmp $