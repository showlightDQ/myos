[org 0x7c00]

mov ax,3
int 0x10  ;初始化屏幕

mov ax , 0
mov ds,ax
mov ss,ax
mov es,ax
mov sp,0x7c00

mov ax,0xb800
mov ds,ax
mov byte [0],'H'




jmp $


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




 




times 510-($-$$) db 0

db 0x55,0xaa

