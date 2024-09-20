; 要支持 multiboot2，内核必须添加一个 multiboot 头，而且必须再内核开始的 32768(0x8000) 字节，而且必须 64 字节对齐；

; | 偏移  | 类型 | 名称                | 备注 |
; | ----- | ---- | ------------------- | ---- |
; | 0     | u32  | 魔数 (magic)        | 必须 |
; | 4     | u32  | 架构 (architecture) | 必须 |
; | 8     | u32  | 头部长度 (header_length)   | 必须 |
; | 12    | u32  | 校验和 (checksum)   | 必须 |
; | 16-XX |      | 标记 (tags)         | 必须 |

; - `magic` = 0xE85250D6
; - `architecture`:
;     - 0：32 位i386保护模式  4:32位MIPS
; - `checksum`：与 `magic`, `architecture`, `header_length` 相加必须为 `0`

; ## 参考文献

; - <https://www.gnu.org/software/grub/manual/grub/grub.html>
; - <https://www.gnu.org/software/grub/manual/multiboot2/multiboot.pdf>
; - <https://intermezzos.github.io/book/first-edition/multiboot-headers.html>
; - <https://os.phil-opp.com/multiboot-kernel/>
; - <https://bochs.sourceforge.io/doc/docbook/user/bios-tips.html>
; - <https://forum.osdev.org/viewtopic.php?f=1&t=18171>
; - <https://wiki.gentoo.org/wiki/QEMU/Options>
; - <https://hugh712.gitbooks.io/grub/content/>



; 按照makefile的配置，ld命令的参数：-Ttext $(ENTRYPOINT) --section-start=.multiboot2=$(MULTIBOOT2) 
; .text的起始地址是0x10040，.multiboot2段的起始地址是0x10000
; 按照以上参数和grub—rescue的配置，生成用kernel.bin文件生成kernel.iso。
; 使用grub生成的启动文件启动后，boot.asm和load.asm的内容都绕过了，直接由grub完成。 
; load以后.multiboot2段地址是0x10000 ，按grub规范，需要有以下段信息。
;  .text的起始地址是0x10040，boot、loader 可跳到这里开始执行 。 
; grub也设置成从这里执行（可改改试试）但loader设置的栈环境、内存检测数据这里都没有，要重新设置。（A20线、保护模式等已由grub设置好）还有一些其他数据，按规范存在别的地方或寄存器中。


[bits 32]
magic   equ 0xe85250d6
i386    equ 0
length  equ header_end - header_start

section .multiboot2
header_start:
    dd magic
    dd i386
    dd length;
    dd -(magic + i386 + length)  ; 校验和，其值与所校验的以上三个字段加起来为零
   
    ; 结束标记
    dw 0  ; type   
    dw 0  ; flage
    dd 8  ; size
header_end:



; grub启动后的状态：
; - EAX：魔数 `0x36d76289`
; - EBX：包含 bootloader 存储 multiboot2 信息结构体的，32 位 物理地址
; - CS：32 位 可读可执行的代码段，尺寸 4G
; - DS/ES/FS/GS/SS：32 位可读写的数据段，尺寸 4G
; - A20 线：启用
; - CR0：PG = 0, PE = 1，其他未定义
; - EFLAGS：VM = 0（Virtual 8086 Mode）, IF = 0, 其他未定义
; - ESP：内核必须尽早切换栈顶地址
; - GDTR：内核必须尽早使用自己的全局描述符表
; - IDTR：内核必须在设置好自己的中断描述符表之前关闭中断
; ## 参考文献; - <https://www.gnu.org/software/grub/manual/multiboot2/multiboot.pdf>

; times(0x40 -($-$$)) db 0xcc   ; 如果不是grub启动，可能需要这一句

extern device_init
extern console_init
extern gdt_init
extern memory_init
extern kernel_init
extern gdt_ptr
 

code_selector equ (0001 << 3)
data_selector equ (0002 << 3)
section .text
global _start
_start:
    
 
    push ebx  ;ards 
    push eax  ;magic 0x20220205
    mov eax , $
    mov eax, $-$$
    mov eax,ebx
    call console_init; 

xchg bx, bx
    call gdt_init
xchg bx, bx
    lgdt [gdt_ptr]

    ; mov eax , code_selector
    ;mov cs, ax     这两句为什么行不通

    jmp dword code_selector:_next   ;这里应该可以改
_next:

    mov ax,data_selector
    mov ds,ax
    mov es,ax
    mov fs,ax
    mov gs,ax
    mov ss,ax

; xchg bx, bx

    call memory_init

    mov esp,0x10000 

    call kernel_init
     

    jmp $
