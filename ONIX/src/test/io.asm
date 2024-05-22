[bits 32]

section .text 

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
