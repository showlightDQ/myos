	.file	"while.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$1, -8(%ebp)
	movl	$10, -4(%ebp)
	jmp	.L2
.L3:
	addl	$3, -8(%ebp)
.L2:
	cmpl	$1, -4(%ebp)
	jg	.L3
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
