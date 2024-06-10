	.file	"pppointer.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -fno-pic -fno-asynchronous-unwind-tables -fno-ident
	.text
	.globl	test
	.type	test, @function
test:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$16, %esp	#,
	movl	8(%ebp), %eax	# p, tmp83
	movl	%eax, -16(%ebp)	# tmp83, p
# pppointer.c:2: {
	movl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp85
	movl	%eax, -4(%ebp)	# tmp85, D.2691
	xorl	%eax, %eax	# tmp85
# pppointer.c:3:     int b=100;
	movl	$100, -12(%ebp)	#, b
# pppointer.c:4:     int *a = &b;
	leal	-12(%ebp), %eax	#, tmp84
	movl	%eax, -8(%ebp)	# tmp84, a
# pppointer.c:19: }
	nop	
	movl	-4(%ebp), %edx	# D.2691, tmp86
	subl	%gs:20, %edx	# MEM[(<address-space-2> unsigned int *)20B], tmp86
	je	.L2	#,
	call	__stack_chk_fail	#
.L2:
	leave	
	ret	
	.size	test, .-test
	.globl	test2
	.type	test2, @function
test2:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$20, %esp	#,
# pppointer.c:22: {
	movl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp84
	movl	%eax, -4(%ebp)	# tmp84, D.2693
	xorl	%eax, %eax	# tmp84
# pppointer.c:24:     void *p = &ary;
	leal	-9(%ebp), %eax	#, tmp82
	movl	%eax, -20(%ebp)	# tmp82, p
# pppointer.c:25:     int a = test(p);
	pushl	-20(%ebp)	# p
	call	test	#
	addl	$4, %esp	#,
	movl	%eax, -16(%ebp)	# tmp83, a
# pppointer.c:26: }
	nop	
	movl	-4(%ebp), %eax	# D.2693, tmp85
	subl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp85
	je	.L4	#,
	call	__stack_chk_fail	#
.L4:
	leave	
	ret	
	.size	test2, .-test2
	.section	.note.GNU-stack,"",@progbits
