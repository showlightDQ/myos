global amemcpy
amemcpy:
    push ebp 
    mov ebp,esp
    ; 栈现状： 先 count(16),src(12),dst(8),eip(4),ebp(ebp)

    mov ecx,[ebp +16] ;count -> ecx
    mov esi,[ebp + 12]
    mov edi,[ebp + 8]

    cld   ; 设DF标志位为0.direction flag. 0:增，1:减
    
    rep  movsb ;move series bytes等于重复mov byte [es:edi],[ds:esi] 同时edi+1,esi+1   
    ; movsw ;move series words      
    ; rep movsd ;move series double words

    leave
    ret
    ; lodsb(ds:esi)-->al    
    ; lodsw(ds:esi)-->ax
    ; lodsd(ds:esi)-->eax
    ; stosb(es:edi)<--al
    ; stosw(es:edi)<--eax
    ; stosd(es:edi)<--eax

; section .text
; global main
; main:
;     push ebp
;     mov ebp,esp

;     push message.size
;     push message
;     push buffer
;     call amemcpy
;     add esp,12 
    
;     leave
;     ret

; section .data   ;VSCODE 调试时，在WATCH中用(char(*) [16])&message 显示内存数据
;     message db "hello ASM",10,13,0
;     ; message_end:  老方法
;     message.size equ ($-message)
; section .bss
;     ; buffer resb message_end-.data
;     buffer resb message.size