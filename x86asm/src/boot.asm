org 0x7c00
xchg bx,bx

mov ax,0x3
int 0x10

; xchg bx,bx
mov ax,0x7c00
;mov ss,ax
mov sp,0x7c00

    mov ax,2*80
; call setCursor
; xchg bx,bx

;     mov ax,11
; call getCursor

;     mov ax,81
; call setCursor

call open_Int8
  
    mov bl,10
    mov ecx,1
    mov edi,0x1000
call read_disk
xchg bx,bx

    mov bl,2
    mov ecx,4
    mov esi,0x7C00
call write_disk

jmp 0x1000


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
    pushad

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
       
    inc dx ;0x1f6
    shr ecx,8
    and cx,0xf    
    mov al,0b1110_0000 ;主盘，LBA模式
    or al,cl
    out dx,al

    inc dx; 0x1f7
    mov al,0x20 ;读盘命令
    out dx,al

    ;读完一个盲区要检查一次，否则可能读错
    mov ax,0; 
    mov es,ax

    xor ecx,ecx   ;ecx清零
    mov cl,bl     ;定义循环次数

    .read_many:
        push cx
        call .check_read_state
        call .read_512byte
        pop cx
        loop .read_many

    popad
    ret
    .check_read_state:
        nop
        nop
        nop
        mov dx,0x1f7
        in al,dx
        and al,0b1000_1001
        cmp al,0b0000_1000
        jnz .check_read_state
        ret
     

    .read_512byte:
        mov cx,256  ;读入256个字，
        mov dx,0x1f0
        .read_loop:
            nop
            nop
            nop
            in ax,dx
            mov [edi],ax
            add edi,2
            loop .read_loop
        ret


write_disk: ;把内存的esi位置开始的bl个扇区，写入硬盘的第ecx个扇区
    pusha

    mov dx,0x1f2
    mov al,bl
    out dx,al ;设置读扇区数 

    inc dx ;0x1f3  平坦模式下   数据的起始 扇区
    mov al,cl
    out dx,al
    
    inc dx ;0x1f4
    mov al,ch
    out dx,al

    inc dx ;0x1f5
    shr ecx,16
    mov al,cl
    out dx,al
     
    inc dx ;0x1f6
    shr ecx,8
    and cx,0xf    
    mov al,0b1110_0000 ;主盘，LBA模式
    or al,cl
    out dx,al

    inc dx; 0x1f7
    mov al,0x30 ;写盘命令
    out dx,al

    mov ax,0; 
    mov es,ax

    xor ecx,ecx   ;ecx清零
    mov cl,bl     ;定义循环次数

    .write_many:
        push cx
        call .check_write_state
        call .write_512byte
        pop cx
        loop .write_many

    popa
    ret

    .check_write_state:
        nop
        nop
        nop
        mov dx,0x1f7
        in al,dx
        and al,0b1000_0001
        ;cmp al,0b0000_0000
        jnz .check_write_state
        ret    
    
    .write_512byte:
        mov cx,256  ;读入256个字，
        mov dx,0x1f0    
        .write_loop:
            nop
            nop
            nop
            mov ax,[esi]
            out dx,ax
            add esi,2
            loop .write_loop
        ret 

open_Int8:
    ; 外中断 https://wiki.osdev.org/8259_PIC
    ; ;8259芯片端口号 
    ; 主芯片控制0x20 
    ; 主芯片数据0x21
    ; 从芯片控制0xA0 
    ; 从芯片数据0xA1
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
    ADDR equ 0x3d4
    DATA equ 0x3d5
    HIGH equ 0x0e
    LOW  equ 0x0f
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