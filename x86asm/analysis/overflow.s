	.file	"overflow.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	leal	3(%esp), %eax
	movdqa	.LC0, %xmm0
	movups	%xmm0, (%eax)
	movl	$663841, 16(%eax)
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 16
.LC0:
	.long	1819043176
	.long	1986994287
	.long	1818653285
	.long	555841391
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
