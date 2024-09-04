[org 0x1000]
db 0x55,0xaa
;  xchg bx,bx
call check_memory
jmp prepare_protect_mode

 check_memory:
    pusha
    mov ax,0
    mov es,ax
    ;设置参数
    xor ebx,ebx
    mov edx,0x534d4150  ;固定签名 SMAP
    mov di,ards_buffer   ;存储位置

    .next:
        mov eax,0xe820  ;子功能码
        mov ecx,20      ;返回结构体为20Byte
        int 0x15
        jc .error     ;溢出位F位为1时为出错。

        add di,cx     ;存储位置后移20Byte
        inc dword[ards_count]   ;计数加1
        cmp ebx,0              ;返回结束？
        jnz .next              ;继续
        .error:    
    popa
    ret
    show_memory_check:
        mov cx,[ards_count]
        mov si,0
        .check_loop:
            mov eax,[si + ards_buffer]
            mov ebx,[si + ards_buffer + 8]
            mov edx,[si + ards_buffer +16]
            add si,20    
            xchg bx,bx
            loop .check_loop
        ret


prepare_protect_mode:
     
 xchg bx,bx
    cli

    in al,0x92   ;0x92端口寄存器的第1位是A20线控制位，0：地址回绕，地址大于1M后，实际访问地址值与1M的余数。 1：地址不回绕
    or al,0b0000010
    out 0x92,al  ;打开A20线

    lgdt [gdt_ptr]; 加载GDT 
       
    mov eax,cr0
    or eax,1
    mov cr0,eax ;设置CR0的第0位为1，打开保护模式
  
      
    jmp word code_selector:protect_mode_entrance 
    ;长跳转，可更新缓冲区的旧命令
    ud2 ; 出错代码，如果跳转不成功，可以卡在这里。

 [bits 32]
 ;定义ＧＤＴ指针。　即　ＬＧＤＴ加载的内容
    gdt_ptr:  ;GDT指针定义  LGDT 指令加载的内容！  
                ;通过LGDT gdt_ptr 命令告诉CPU从这里读取前16位数据是GDT的长度，最多可表示到64KB的表长度，除以8字节，最多可以有8192个描述符。
                ;（其实是长度-1，limit，表示读取时的最末端字节的偏移量）
                ;然后再读32位数据，是GDT的起始地址
    dw  (gdt_end - gdt_base - 1) ; GDT的总长度 limit（其实是最后一个字节的偏移量，它等于GDT总字节数-1.
    dd gdt_base  ;GDT 起始地址  

 ;定义段选择子
    ;用于放在段寄存器里面，指明用哪个 GDT 描述
        ;其实是16位的数，
        ;0~1位 RPL 请求特权级，表示生成这个选择子的权限
        ;2位   TI  描述符类型，1表示LDT ，0表示GDT
        ;高13位表示选择8191个GDT中的哪个
    code_selector equ 1<<3  ;　代码段使用第1个描述符
    data_selector equ 2<<3  ;  数据段使用第2个描述符
    test_selector equ 3<<3  ;  测试数据段

        base equ 0   ;32位 Base 基地址 可达 4G
        limit equ 0xfffff  ;20位limit (段大小-1)  可达 1M （如果limit的1表示4K，那么最大应该是可以访问4G
                    ;最终，以下data描述符定义了从零开始的１Ｍ内存的属性
                    ;但，因为打开了保护模式，仍可访问别４Ｇ的空间地址。       

;定义ＧＤＴ　全局描述符表　每描述符８字节。
    gdt_base:   ;GDT 首地址
        dd 0,0  ;define double word 每个0是4字节，首GDT共8字节
    gdt_code:  ;GDT代码段定义
        dw limit &  0xffff   ;  取GDT的低16位limit
        dw base & 0xffff   ;取base的低16位（0~15）
        db (base >> 16) & 0xff  ;取base的16~23位
        db 0b1010 | 0b1001_0000  ;0x9e
            ;1110： 低4位是段类型，| E | C/D | R/W | A | 表示：代码段，依从，可读，没有访问过
            ;segment =1 的情况
            ;Executable E:1代码段 E:0数据段 
                 ;E=1时 C：1是0否是依从代码段；R：1是0否可读
            ;E=0时 D：0向上扩展，1向下扩展； W：1是0否可写
            ;A: Accessed 是否被访问过
        ;1001  高4位：| Segment |  DPL | DPL | Present | 
            ;segment:1代码段，0系统段
            ;DPL：Descriptor Privilege Level 描述符特权等级 0最高，3最低  只能由不低于等级的进程来访问
            ;present：存在位，1存内存，0存磁盘
            
        db 0b1100_0000 | (limit >> 16)
        ;前4位是 limit 的高4位值，后4位是 | granularity | big | long_mode | available |
        ;available 留用  ； long_mode：64位扩展标志 ； big:1:32位，0:16位；
        ;granularity:limit表示的粒度 ：1:4K 0:1B  
        db (base >> 24 ) & 0xff  ;base的高8位

    gdt_data:  ;ＧＤＴ数据段定义
        dw limit &  0xffff   ;  取GDT的低16位limit
        dw base & 0xffff   ;取base的低16位（0~15）
        db (base >> 16) & 0xff  ;取base的16~23位
        db 0b0000_0010 | 0b01001_0000  ;0x12    数据段，0等级，内存；
        db 0b1100_0000 | (limit >> 16)
        db (base >> 24 ) & 0xff  ;base的高8位
    gdt_test:  ;测试数据段
        dw 0xffff;  取GDT的低16位limit
        dw 0x8000   ;取base的低16位（0~15）
        db 0x000b  ;取base的16~23位
        db 0b0010 | 0b01001_0000  ;0x12    数据段，0等级，内存；
        db 0b0100_0000 
        db 0;base的高8位
    gdt_end: 



; 内存检测


setup_page:
        ;32位系统可寻址内存共4G，4K为一页，共有1M页，每页用int 4字节表示(32位中的12们用来寻表址就够了），共需要4M 的页表
        ;二级页表系统：
        ;第一级PDT存储1K个表信息（每个表信息4字节）的起始地址（表占4K空间），负责解释线性地址的高10位，选出一个表来，
            ;表信息的中间10位可指向一个1K个的PTE表的起始地址（高10位不用？），如：中间十位为0b00_0000_1111则它指向0xf000的物理地址，作为PTE的基址（自动补三个零）
            ;低12位表明属性。
        ;第二级页表PTE可存储1K个表，每个表对应线性地址的中间10位。表数据的后20位作为物理地址的高20位，指定一个4K的物理地址区域，
            ;与线性地址的低12们共同组成一个32位的地址。可访问4G的内存空间。PTE表的低12位说明该地址的属性。
        
        ;PTE :Page Table Entry
        ;PDE :Page Director Entry
    PDE equ 0x2000  ;定义 0x2000~0x2FFF  PDE里面有1024个页的索引，每个索引4字节，共4K字节=0x1000
        ;PDE :Page Directory Entry
    PTE equ 0x3000  ;定义 0x3000~0x3FFF  PTE里面有1024个页，每个页有4k空间，
    ATTR equ 0b11   ;定义页表属性：在内存中，可写
    ATTR2 equ 0b10011  ;0x0013禁止高速缓存

        ;4字节 0~11 属性，12~31索引
        ;present : 1    是否在内存中
        ;write : 1      0只读/1可写
        ;user : 1       1普通用户 /0超级用户，特权3不允许写入
        ;pwt : 1        1页通写，表示该页需要高速缓存
        ;pcd : 1        1禁止高速缓存
        ;accessed :1    1是否被CPU访问过
        ;dirty :1       1脏位，是否已使用
        ;pat : 1        1页属性  / 0
        ;global : 1     1全局位，应该放在快表中
        ;available :3   1留给系统用
        ;index : 20     页索引，1M



    mov eax, PDE    ;清空 PDE
    call .clear_page
    mov eax, PTE        ;清空 PTE
    call .clear_page

    ;前面的1M内存  映射在1M
    ;前面的1M内存  映射到0xC000_0000 - 0xC0100_0000 

    mov eax, PTE
    or eax, ATTR
    mov [PDE], eax   ;  0x0000_3003 ; PDE第0项页表指向0x3000,在内存中，可写
    mov [PDE+ 0x300 * 4], eax;0x300左移2位=0xC00
        ;设置PDE第0x300页也指向PTE的第0页。PDE、PTE页码范围0x000~0x3FF,共1024*4字节
        ;即线性地址0B1100_0000_00**_****_****_****_****_****，指向的物理地址由PTE的多页决定
        ;即线性地址0xC0000000~0xC03FFFFF,共4M的空间由PTE指定
        ;每页PTE指向4K空间，每页PDE指向1024个PTE，即4M空间，
                 
        mov eax, PDE 
        or eax ,ATTR  ;附上属性
        mov [PDE + 0x3ff *4], eax ;0x3FF左移2位=0xFFC
        ;最后一个页表指向页目录
       
    mov ebx, PTE
    ; mov ecx, (0x100000 / 0x1000); 1M/4K = 256 
     mov ecx, (0x300000 / 0x1000); 1M/4K = 256 
        ;只设置256个PTE表，设置1M的可访问空间。有768个表没有设置。
    mov esi,0
    
    .next_page:
        mov eax,esi
        shl eax, 12 ;设置PTE索引号。指向物理地址的高8位，与线性的低12位组合访问1M空间
        or eax, ATTR ;设置每个PTE面的属性为“在内存中，可写”
        mov [ebx +esi *4], eax
        ;设置0B****_****_**00_0000_0000_0000_0000_0000到0B****_****_**00_0000_1111_1111_1111_1111这1M空间的属性
        inc esi
        loop  .next_page
        
    ; mov eax,0x0000_3003
    ; mov [PDE + 0x3C0 * 4],eax 
    ; mov eax,0x000B8003
    ; mov [PTE + 0*4],eax 
    ; xchg bx,bx
    ;打开内存映射    
    mov eax , PDE 
    mov cr3, eax  ;装载映射表
    mov eax, cr0
    or eax , 0b1000_0000_0000_0000_0000_0000_0000_0000;
    mov cr0, eax   ;开启映射 
    ret 
        .clear_page:
        ; xchg bx,bx
            mov ecx,0x400
            .loop_clear_page:
                mov dword [eax+ecx*4],0x0
                loop .loop_clear_page
            ret


print_string:   ;print string witch addressed by SI register, Location defined by DI
    pushad
    shl edi,1
    mov eax,0
    ; mov ds,ax 
    mov eax,0xb8000
    add edi,0xb8000
    ; mov es,ax
    .print_loop:
        mov al,[esi]
        cmp al,0
        jz .quit 
        mov [edi],al
        inc esi ;
        add edi,2
        jmp .print_loop
    .quit:
    popad
    ret


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
    push es

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
    pop es
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


protect_mode_entrance:  
        ; xchg bx,bx
        mov ax, data_selector
        mov ds, ax
        mov ss, ax
        ; mov ax, test_selector
        mov es, ax  
        ; mov eax, code_selector
        ; mov es,ax
        mov esp, 0x10000    ;设置栈    
        mov esi,str_pt;
        mov edi,80
        call print_string
        xchg bx,bx

        mov ebx , 0x100001
        mov [ebx],eax        
         mov [0x100000],ebx
        
        ; call setup_page

        mov ecx,4
        mov bl,200
        mov edi,0x10000
        call read_disk
        xchg bx,bx

        ;    mov ebx , 0x100001
        ; mov [ebx],eax        
        ;  mov [0x100000],ebx
        
        mov eax,0x20220205  
        mov ebx,ards_count
        ;增加以上两行，以更好地兼容grub
        jmp code_selector:0x10000
jmp $  

str_pt:
    db "In protect mode!!!!!",0

    ;=====检测信息存储区=============================
        ards_count:
        dd 0
        ; db "buffer",0xff,0xff
        ards_buffer:
        times 512 db 0xff,0xff,

    ;===================================================