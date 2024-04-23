 #  AT&T 格式汇编，命令： as -32 att.s -o att.o
 #  gcc -m32 att.o -static
 
.section .text
.globl main
main:

   

    movl $4, %eax #  write
    movl $1, %ebx # stdout
    movl $message, %ecx # buffer
    movl $(message_end - message), %edx
    int $0x80 

    movl $4, %eax #  write
    movl $1, %ebx # stdout
    movl $message, %ecx # buffer
    movl $(message_end - message), %edx # length

    #  寻址方式示例
    movb $'A',message  # 用A替换第一个字节
    movb $'B', 1(%ecx)  # 代表 ecx+1 
    movb $'C', (%ecx,%ebx,2)  # ebx=1 所以 = （ecx + 1 + 2 ）
    movb $'D', message -1(,%ebx,4)
    movb $'E', message(,%ebx,4)  # message + ebx * 4


    int $0x80 



    movl $1, %eax 
    movl $0, %ebx 
    int $0x80 

.section .data
message:
    .asciz "hello world!!! AT&T \n"
message_end:

.section .bss
    .lcomm buffer 256

