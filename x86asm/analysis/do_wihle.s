	.file	"do_wihle.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$1, -8(%ebp)
	movl	$10, -4(%ebp)
.L2:
	addl	$3, -8(%ebp)
	cmpl	$2, -4(%ebp)
	jg	.L2
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
