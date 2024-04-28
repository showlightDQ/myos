	.file	"if.c"
	.text
	.globl	compare
	.type	compare, @function
compare:
	pushl	%ebp
	movl	%esp, %ebp
	cmpl	$0, 8(%ebp)
	je	.L2
	movl	12(%ebp), %eax
	jmp	.L3
.L2:
	movl	16(%ebp), %eax
.L3:
	popl	%ebp
	ret
	.size	compare, .-compare
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	$3
	pushl	$2
	pushl	$1
	call	compare
	addl	$12, %esp
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
