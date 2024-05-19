	.file	"parameter.c"
	.text
	.globl	add
	.type	add, @function
add:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	popl	%ebp
	ret
	.size	add, .-add
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	movl	$2, -24(%ebp)
	movl	$3, -20(%ebp)
	movl	$4, -16(%ebp)
	pushl	-20(%ebp)
	pushl	-24(%ebp)
	call	add
	addl	$8, %esp
	movl	%eax, -12(%ebp)
	movl	$4, %eax
	subl	$1, %eax
	addl	$22, %eax
	movl	$4, %ecx
	movl	$0, %edx
	divl	%ecx
	sall	$2, %eax
	subl	%eax, %esp
	movl	%esp, %eax
	addl	$15, %eax
	shrl	$4, %eax
	sall	$4, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	addl	$5, %eax
	movb	$-86, (%eax)
	movl	$0, %eax
	movl	-4(%ebp), %edx
	subl	%gs:20, %edx
	je	.L5
	call	__stack_chk_fail
.L5:
	leave
	ret
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
