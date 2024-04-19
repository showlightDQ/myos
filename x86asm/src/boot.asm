org 0x7c00
xchg bx,bx





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

    xchg bx,bx
    mov bl,2
    mov ecx,0
    mov edi,0x1000
call read_disk
call write_disk

loopb:
mov al,'X'
mov bx,0
call blink
jmp loopb


read_disk:  ;从硬盘的第ecx扇区读取bl个扇区，读入内存地址edi位置
    ;端口定义
        ; Primary    Secondary   in操作         out操作
        ; 0x1f0        0x1f0      Date          Date       仅此寄存器为16位 
        ; 0x1f1        0x1f1      Error         Features   8位
        ; 0x1f2        0x1f2      Sector        count      8位
        ; 0x1f3        0x1f3      LBA low                  8位   读写扇区编号，28位*512字节= 37位 =128G ?
        ; 0x1f4        0x1f4      LBA mid                  8位
        ; 0x1f5        0x1f5      LBA high                 8位
        ; 0x1f6        0x1f6      Device        Device  (0~3：LBA 24~27;  4:0主盘 1从盘 ； 6:0 CHS模式  1 LBA模式； 5、7：固定为1 ）
        ; 0x1f7        0x1f7      Status        Command  
        ;  0x1f7的数据：（out:0xEC:识别硬盘； 0x20 读硬盘 ； 0x30 写硬盘)
        ;               (in: 0位 err;  3位 DRQ 数据准备完毕； 7位 Busy 硬盘繁忙）
    
    ;参数定义
    ;edi-读入的内存地址
    ;ecx-读取的硬盘起始扇区
    ;bl-读取的扇区数量
    pusha

    mov dx,0x1f2
    mov al,bl
    out dx,al ;设置读扇区数 

    inc dx ;0x1f3  平坦模式下读取数据的起始位置0
    mov al,cl
    out dx,al
    
    inc dx ;0x1f4
    mov al,ch
    out dx,al

    inc dx ;0x1f5
    shr ecx,16
    mov al,cl
    out dx,al

        xchg bx,bx
    inc dx ;0x1f6
    shr ecx,8
    and cx,0xf    
    mov al,0b1110_0000 ;主盘，LBA模式
    or al,cl
    out dx,al

    inc dx; 0x1f7
    mov al,0x20 ;读盘命令
    out dx,al

    .check_read_state:
        nop
        nop
        nop
        mov dx,0x1f7
        in al,dx
        and al,0b1000_1001
        cmp al,0b0000_1000
        jnz .check_read_state

    
    mov ax,0;数据读入的位置
    mov es,ax
     
    mov dx,0x1f0
    mov cx,256  ;读入256个字，


    .read_loop:
        
        mov al,bl
        cmp al,0
        jz .done
        .read_512byte:
            nop
            nop
            nop
            in ax,dx
            mov [es:edi],ax
            add edi,2
            loop .read_512byte
    xchg bx,bx
    dec bl
    jmp .read_loop
    .done:

    xchg bx,bx
    popa
    ret


write_disk:
    mov dx,0x1f2
    mov al,1
    out dx,al ;设置写扇区数 

    mov al,2  

    inc dx ;0x1f3  平坦模式下  数据的起始位置
    out dx,al
    
    mov al,0

    inc dx ;0x1f4
    out dx,al

    inc dx ;0x1f5
    out dx,al

    inc dx ;0x1f6
    mov al,0b1110_0000 ;主盘，LBA模式
    out dx,al

    inc dx; 0x1f7
    mov al,0x30 ;写盘命令
    out dx,al

    .check_write_state:
        nop
        nop
        nop
        mov dx,0x1f7
        in al,dx
        and al,0b1000_0001
        ; cmp al,0b0000_0000
        jnz .check_write_state

    
    mov ax,0x50 ;数据读取的位置是 内存0x500开始的位置
    mov es,ax
    mov di,0

    mov dx,0x1f0
    mov cx,256  ;读入256个字，

    .write_loop:
        nop
        nop
        nop
        mov ax,[es:di]
        out dx,ax
        
        add di,2
        loop .write_loop

    xchg bx,bx
    ret













; 外中断 https://wiki.osdev.org/8259_PIC

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


