	.file	"overflow.c"
	.text
	.section	.rodata
.LC0:
	.string	"hello overflow!!!!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	pushl	$.LC0
	leal	-9(%ebp), %eax
	pushl	%eax
	call	strcpy
	addl	$8, %esp
	movl	$0, %eax
	movl	-4(%ebp), %edx
	subl	%gs:20, %edx
	je	.L3
	call	__stack_chk_fail
.L3:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
