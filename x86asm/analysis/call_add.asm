[bits 32]

global add
extern printf


add:
    push ebp
    mov ebp, esp

    push message
    call printf
    add esp,4
    

        ; 栈结构
        ; 调用前 push j; push i ; push eip 
        ; push ebp
        ; 现在 
            ; ebp+12 = j
            ; ebp+8 = i
            ; ebp+4 = (eip) 
            ; ebp = (ebp)
    mov eax,[ebp+8]
    add eax,[ebp+12]

    leave
    ret

section .data
    message db "add called",10,13,0 