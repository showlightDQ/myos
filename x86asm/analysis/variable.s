	.file	"variable.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=2 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	a
	.bss
	.align 4
	.type	a, @object
	.size	a, 4
a:
	.zero	4
	.globl	b
	.data
	.align 4
	.type	b, @object
	.size	b, 4
b:
	.long	305419896
	.globl	c
	.align 4
	.type	c, @object
	.size	c, 4
c:
	.long	5
	.align 4
	.type	d, @object
	.size	d, 4
d:
	.long	8
	.section	.rodata
	.align 4
	.type	e, @object
	.size	e, 4
e:
	.long	10
	.globl	array
	.bss
	.align 4
	.type	array, @object
	.size	array, 20
array:
	.zero	20
	.globl	iarray
	.data
	.align 4
	.type	iarray, @object
	.size	iarray, 20
iarray:
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.globl	message
	.align 4
	.type	message, @object
	.size	message, 7
message:
	.string	"hello\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# variable.c:12:     a = c ;
	movl	c, %eax	# c, c.0_1
	movl	%eax, a	# c.0_1, a
# variable.c:13:     b = a ;
	movl	a, %eax	# a, a.1_2
	movl	%eax, b	# a.1_2, b
# variable.c:14:     return 0;
	movl	$0, %eax	#, _6
# variable.c:15: }
	popl	%ebp	#
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
