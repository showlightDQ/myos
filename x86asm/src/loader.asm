[org 0x1000]
extern blink
xchg bx,bx
mov ax,0xb800
mov es,ax
mov byte [es:0],"L"


; loopb:
; mov al,'X'
; mov bx,0
; call blink
; mov [ax:di],bx

jmp $

times 1024 db 0x22
