	.file	"pass_variable.c"
	.text
	.globl	fun1
	.type	fun1, @function
fun1:
	pushl	%ebp
	movl	%esp, %ebp
	nop
	popl	%ebp
	ret
	.size	fun1, .-fun1
	.globl	fun2
	.type	fun2, @function
fun2:
	pushl	%ebp
	movl	%esp, %ebp
	nop
	popl	%ebp
	ret
	.size	fun2, .-fun2
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$5, -4(%ebp)
	call	fun2
	call	fun2
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.data
	.align 4
	.type	a.2, @object
	.size	a.2, 4
a.2:
	.long	1
	.align 4
	.type	a.1, @object
	.size	a.1, 4
a.1:
	.long	2
	
	.align 4
	.type	a.0, @object
	.size	a.0, 4
a.0:
	.long	3
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
