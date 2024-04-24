	.file	"hello.c"
	.text
	.section	.rodata
.LC0:
	.string	"hello world!!!"
.LC1:
	.string	"hello puts!!!"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	$.LC0
	call	puts
	addl	$4, %esp
	pushl	$.LC1
	call	puts
	addl	$4, %esp
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
