[bits 32]

section .text
global main
main:
    ; mov eax,0
    ; movzx ecx,bl  ;无符号扩展
    ; mov al,-1 ;0xff
    ; movsx ecx,al

    mov al,0xff
    add al,1
    ; WATCH 中 以$eflags 查看标志位变化
    ; 无符号数溢出，CF置1 半字节溢出AF置1
    
    ret