
[bits 32]

magic equ 0xe85250d6
i386 equ 0
length  equ header_end - header_start

section .multiboot2
header_start:
    dd magic
    dd i386
    dd length;
    dd -(magic + i386 + length)  ; 校验和，其值与所校验的以上三个字段加起来为零

    dw 0 ;type
    dw 0  ; flage
    dd 8  ; size

header_end:
times(0x40 -($-$$)) db 0xff

extern kernel_init
extern memory_init
extern gdt_init
extern console_init

section .text
global _start
_start:
    ;两个参数


    push ebx  ;ards 
    push eax  ;magic 0x20220205
    call memory_init
    call kernel_init
     

    jmp $