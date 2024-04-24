[bits 32]



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

    section .bss
        resb 0x100ff






; 编译命令 nasm -f elf32 elf.asm 
; 链接命令 gcc -m32 elf.o -static
;  readelf -e elf.o
;   objdump -d a.out
;   objdump -d a.out -nostartfile
;   objdump -d elf.o
;   objdump --help
;   objdump -d a.out -M intel    
;   gcc -m32 elf.o -static -nostartfiles    cannot find entry symbol _start; defaulting to 08049000
;   gcc -m32 elf.o -static -nostartfiles -e main
;   gcc -m32 elf.o -static -nostartfiles -e main -no-pie
;   

