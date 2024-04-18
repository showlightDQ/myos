org 0x7c00
mov ax,0x3
int 0x10

ADDR equ 0x3d4
DATA equ 0x3d5
HIGH equ 0x0e
LOW  equ 0x0f

; xchg bx,bx
mov ax,0x7c00
;mov ss,ax
mov sp,0x7c00

mov ax,2*80
call setCursor
; xchg bx,bx
mov ax,11
call getCursor
mov ax,81
call setCursor
call open_Int8


loopb:
mov al,'X'
mov bx,0
call blink
jmp loopb

; https://wiki.osdev.org/8259_PIC

; ;8259芯片端口号 
; 主芯片控制0x20 
; 主芯片数据0x21
; 从芯片控制0xA0 
; 从芯片数据0xA1
open_Int8:

    PIC_M_CMD equ 0x20
    PIC_M_DATA equ 0x21

    ;设置8号中断向量：
    mov word [8*4], IR
    mov word [8*4 +2],0
    ;向OCW1写入屏蔽字，允许8号中断，时钟中断
    mov al , 0b1111_1110
    out PIC_M_DATA, al
    sti
    ret
;中断例程
    IR:
    ; xchg bx,bx 
    push ax
    push bx

    mov al,'I'
    mov bx,80
    call blink
    ;向OCW2发送中断执行结束标志0X20，允许下一中断
    MOV AL,0X20
    OUT PIC_M_CMD,AL    
    pop bx
    pop ax
    iret



blink:
    push es
    push dx
    push bx

    mov dx,0xb800
    mov es,dx

    shl bx,1
    mov dl,[es:bx]
    mov dh,0x41
    mov [es:bx+1],dh
    
    cmp dl,' '
    jnz .set_space
    .set_char:
        mov [es:bx],al
        jmp .done
       
    .set_space:
        mov byte [es:bx],' '
    .done:
        
        pop bx
        pop dx
        pop es
    ret




setCursor:
    push bx
    push dx

    mov bx,ax

    mov dx,ADDR
    mov al,LOW
    out dx,al
    
    mov dx,DATA
    mov al,bl
    out dx,al

    mov dx,ADDR 
    mov al,HIGH
    out dx,al
    
    mov dx,DATA
    mov al,bh
    out dx,al

    pop dx
    pop bx
    ret

getCursor:
    push dx
    push bx

    mov dx,ADDR
    mov al,LOW
    out dx,al
    
    mov dx,DATA
    in al,dx
    mov bl,al

    mov dx,ADDR 
    mov al,HIGH
    out dx,al
    
    mov dx,DATA
    in al,dx
    mov bh,al

    mov ax,bx
    pop bx
    pop dx
    ret









times 510 - ($ -$$) db 0
db 0x55 , 0xaa


