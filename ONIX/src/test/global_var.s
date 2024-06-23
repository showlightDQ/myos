	.file	"global_var.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -fno-pic -fno-asynchronous-unwind-tables -fno-ident
	.text
	.globl	test1
	.data
	.align 4
	.type	test1, @object
	.size	test1, 4
test1:
	.long	100
	.align 4
	.type	test2, @object
	.size	test2, 4
test2:
	.long	200
	.section	.rodata
.LC0:
	.string	"test1=%zd\n"
.LC1:
	.string	"test2=%zd\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# global_var.c:9:     printf("test1=%zd\n",test1);/* code */
	movl	test1, %eax	# test1, test1.0_1
	pushl	%eax	# test1.0_1
	pushl	$.LC0	#
	call	printf	#
	addl	$8, %esp	#,
# global_var.c:10:     printf("test2=%zd\n",test2);/* code */
	movl	test2, %eax	# test2, test2.1_2
	pushl	%eax	# test2.1_2
	pushl	$.LC1	#
	call	printf	#
	addl	$8, %esp	#,
# global_var.c:11:     return 0;
	movl	$0, %eax	#, _6
# global_var.c:12: }
	leave	
	ret	
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
