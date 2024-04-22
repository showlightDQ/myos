[bits 32]
;------------------------------------------------
; 32位C库调用方式实现
extern printf
extern exit

section .text

global main

main:
    
    add esp,4
    mov dx,0x92
    in ax,dx
    mov eax,cr0

    push 0
    call exit

; 编译命令 nasm -f elf32 test_linux_protect_mode.asm 
; 链接命令 gcc -m32 test_linux_protect_mode.o -static