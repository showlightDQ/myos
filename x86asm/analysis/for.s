	.file	"for.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$2, -8(%ebp)
	movl	$1, -4(%ebp)
	jmp	.L2
.L3:
	addl	$3, -8(%ebp)
	addl	$1, -4(%ebp)
.L2:
	cmpl	$9, -4(%ebp)
	jle	.L3
	addl	$1, -8(%ebp)
	movl	-8(%ebp), %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
