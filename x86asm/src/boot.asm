
mov ax,0x3
int 0x10

ADDR equ 0x3d4
DATA equ 0x3d5
HIGH equ 0x0e
LOW  equ 0x0f

xchg bx,bx
mov ax,0x7c00
;mov ss,ax
mov sp,0x7c00

mov ax,18*80

call setCursor
xchg bx,bx
mov ax,111

call getCursor

add ax,10

call setCursor

call halt


mov ax,500

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




; xchg bx,bx
; mov ax, 0x00
; mov ds, ax

; mov word [0],haha
; mov word [2],0
; mov word [80*4],haha
; mov word [80*4 +2],0

; xchg bx,bx
; mov ax, 0xb800
; mov ds, ax
 
; int 80

; xchg bx,bx
; mov ax, 0xb801
; mov ds, ax

; div bx

; mov ax,$$
; mov ax,$



; xchg bx,bx
; mov ax, 0xb809
; mov ds, ax

; haha:

; xchg bx,bx
; mov ax,msg
; mov si,ax

; mov cx,msg_end - msg
; mov ax,0
; mov di,ax
; mov di,0
; mov ax,0x0
; mov es,ax
; print:
;     mov byte al,[es:si]
;     mov byte[ds:di],al
;     add di,2
;     inc si
;     loop print

; iret

halt:
    jmp halt
msg:
    
    dw "hello world!"
    db 0x55
msg_end:
times 510 - ($ -$$) db 0
db 0x55 , 0xaa


org 0x7c00