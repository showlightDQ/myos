[bits 32]
;------------------------------------------------
; 32位C库调用方式实现
; extern printf
; extern exit

; section .text

; global main

; main:
;     push message
;     call printf
;     add esp,4

;     push 0
;     call exit

; section .data
;     message db "hello world!!!" , 10,13,0
;     message_end:






;-------------------------------------------------------
;Linux中断调用方式
section .text
global main
main:

    mov eax,4;write
    mov ebx,1 ;stdout
    mov ecx,message   ;buffer
    mov edx,message_end - message
    int 0x80

    mov eax,1  ;exit
    mov ebx,0  ;status
    int 0x80

    section .data
        message db "hello world!!!" , 10,13,0
        message_end:

; 编译命令 nasm -f elf32 test_linux_protect_mode.asm 
; 链接命令 gcc -m32 test_linux_protect_mode.o -static