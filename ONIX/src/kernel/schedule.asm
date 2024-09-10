[bits 32]

section .text

global task_switch
task_switch:
    push ebp  ; ebp是主调函数的栈基址
    mov ebp, esp  ; 把上一函数的栈顶作为 栈基

    push ebx   ;  
    push esi
    push edi  ;约定 函数独享寄存器只有 ebx esi edi  ，存起来，下次用

    mov eax, esp;
    and eax, 0xfffff000; current  获得当前进程的栈底地址，也就是结构体地址

    mov [eax], esp  ;把当前进程的栈指针存入栈底

    mov eax, [ebp + 8]; 拿到传入的参数 next  跳过ebp前的4字节的ebp值，和4字节的eip值
    mov esp, [eax]   ; 切换栈环境， 进程从这里开始正式切换！！！！！！！
                    ; next开始的4K是另一个栈， 起始地址存着另一任务的esp值
    pop edi   ; 还原另一进程的寄存器环境
    pop esi
    pop ebx
    pop ebp

    ret
