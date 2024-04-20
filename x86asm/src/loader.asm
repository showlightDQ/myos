[org 0x1000]
extern blink
xchg bx,bx
mov ax,0xb800
mov es,ax
mov byte [es:0],"L"

call check_memory
; call show_memory_check
       


prepare_protect_mode:
    xchg bx,bx 
    cli
    in al,0x92  
    or al,0b10
    out 0x92,al  ;打开A20线
    lgdt [gdt_ptr]; 加载GDT    
    mov eax,cr0
    or eax,1
    mov cr0,eax ;设置CR0的第0位为1，打开保护模式
   
      
    jmp word code_selector:protect_enable 
    ;长跳转，可更新缓冲区的旧命令
    ud2 ; 出错代码，如果跳转不成功，可以卡在这里。

    protect_enable:     
    xchg bx,bx 
        mov ax, data_selector
        mov ds, ax
        mov es, ax
        mov ss, ax
        mov fs, ax
        mov gs, ax
        mov esp, 0x10000    ;设置栈    
        mov byte [0xb8000], 'P'  ;测试保护模式寻址方式，
        xchg bx, bx 
        mov byte [0x200000], 'P'  ;测试访问1M以外的空间。
        xchg bx,bx
jmp $ 




    [bits 32]
;定义ＧＤＴ指针。　即　ＬＧＤＴ加载的内容
    gdt_ptr:  ;GDT指针定义  LGDT 指令加载的内容！！！！
    dw  (gdt_end - gdt_base - 1) ; GDT的总长度 limit（其实是最后一个字节的偏移量，它等于GDT总字节数-1.
    dd gdt_base  ;GDT 起始地址  

;定义段选择子
    code_selector equ 1<<3  ;　用于放在段寄存器里面，指明用哪个 GDT 描述
    data_selector equ 2<<3  ;  其实是16位的数，0~1 位表示权限  2位表示  ，高13位表示选择8191个GDT中的哪个

        base equ 0   ;32位 Base 基地址 可达 4G
        limit equ 0xfffff  ;20位limit (段大小-1)  可达 1M        

;定义ＧＤＴ　全局描述符表　第描述符８字节。
    gdt_base:   ;GDT 首地址
        dd 0,0  ;define double word 每个0是4字节，首GDT共8字节
    gdt_code:  ;GDT代码段定义
        dw limit &  0xffff   ;  取GDT的低16位limit
        dw base & 0xffff   ;取base的低16位（0~15）
        db (base >> 16) & 0xff  ;取base的16~23位
        db 0b1110 | 0b1001_0000  ;0x9e
            ;1110： 低4位是段类型，| E | C/D | R/W | A | 表示：代码段，依从，可读，没有访问过
            ;E:1代码段 E:0数据段 Executable
            ;E=1时 C：是否是依从代码段；R：是否可读
            ;E=0时 D：0向上扩展，1向下扩展； W：是否可写
            ;A: Accessed 是否被访问过
        ;1001  高4位：| Segment |  DPL | DPL | Present | 
        ;segment:1代码段，0数据段
        ;DPS：Descriptor Privilege Level 描述符特权等级 0最高，3最低
        ;present：存在位，1存内存，0存磁盘
        
        db 0b1100_0000 | (limit >> 16)
        ;前4位是 limit 的高4位值，后4位是 | granularity | big | long_mode | available |
        ;available 留用  ； long_mode：64位扩展标志 ； big:1:32位，0:16位；
        ;granularity:粒度 ：1:4K 0:1B 
        db (base >> 24 ) & 0xff  ;base的高8位

    gdt_data:  ;ＧＤＴ数据段定义
        dw limit &  0xffff   ;  取GDT的低16位limit
        dw base & 0xffff   ;取base的低16位（0~15）
        db (base >> 16) & 0xff  ;取base的16~23位
        db 0b0010 | 0b0001_0000  ;0x12    数据段，0等级，内存；
        db 0b1100_0000 | (limit >> 16)
        db (base >> 24 ) & 0xff  ;base的高8位
    gdt_end: 



; 内存检测
check_memory:
    pusha
    mov ax,0
    mov es,ax
    ;设置参数
    xor ebx,ebx
    mov edx,0x534d4150  ;固定签名 SMAP
    mov di,ards_buffer   ;存储位置

    .next:
        mov eax,0xE820  ;子功能码
        mov ecx,20      ;返回结构体为20Byte
        int 0x15
        jc .error     ;溢出位F位为1时为出错。

        add di,cx     ;存储位置后移20Byte
        inc word[ards_count]   ;计数加1
        cmp ebx,0              ;返回结束？
        jnz .next              ;继续
        .error:    
    popa
    ret
    show_memory_check:
        mov cx,[ards_count]
        mov si,0
        .check_loop        
            mov eax,[si + ards_buffer]
            mov ebx,[si + ards_buffer + 8]
            mov edx,[si + ards_buffer +16]
            add si,20    
            xchg bx,bx
            loop .check_loop
        ret
    ;=====检测信息存储区=============================
        ards_count:
        dw 0
        db "buffer",0xff,0xff
        ards_buffer:
        times 512 db 0xff,0xff,

    ;===================================================



times 1024 db 0x22
