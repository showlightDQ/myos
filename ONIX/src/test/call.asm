[bits 32]
extern exit
global main
main :
    push 7
    push eax
    pop ebx
    pop ecx
    pusha
    popa
    call func
    push $
    ret

    push 0
    call exit

func:
    pusha
    popa
    ret
