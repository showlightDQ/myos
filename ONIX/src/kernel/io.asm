[bits 32]

section .text 

global magic_breakpoint
magic_breakpoint:
    xchg bx,bx
    xchg ebx,ebx
    ; xchgw ebx,ebx
    ret

global inb 
inb:
    push ebp
    mov ebp,esp

    xor eax,eax ;
     mov edx,[ebp + 8] 
    in al,dx

    jmp $+2
    jmp $+2
    jmp $+2

    leave
    ret

global inw 
inw:
    push ebp
    mov ebp,esp
    
    xor eax,eax ;
    mov edx,[ebp + 8] 
    in ax,dx

    leave
    ret

global outb 
outb:
    push ebp
    mov ebp,esp
    
    xor eax,eax ;
    mov edx,[ebp + 8]  ; port add
    mov eax,[ebp + 12]; value

    out dx, al

    jmp $+2
    jmp $+2
    jmp $+2


    leave
    ret


global outw
outw:
    push ebp
    mov ebp,esp
    
    xor eax,eax ;
    mov edx,[ebp + 8]  ; port add
    mov eax,[ebp + 12]; value

    out dx, ax

    jmp $+2
    jmp $+2
    jmp $+2


    leave
    ret

