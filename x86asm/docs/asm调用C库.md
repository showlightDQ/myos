
## asm调用C库，编译、链接

### Archliux 要先安装gcc的32位库
```code
pacman -S  lib32-gcc -libs
pacman -Sy lib32-gcc -libs
```
### 编译命令
```code 
nasm -f elf32 hello.asm 
gcc -m32 hello.o -o hello -static
```
```code asm
;32位C库调用方式实现 hello world 
extern printf
extern exit

section .text

global main

main:
    push message
    call printf
    add esp,4

    push 0
    call exit

section .data
    message db "hello world!!!" , 10,13,0
    message_end:

```

## int 0x80 的方式实现 hello world
```code

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


```
