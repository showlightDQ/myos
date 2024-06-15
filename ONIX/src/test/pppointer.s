	.file	"pppointer.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -fno-pic -fno-asynchronous-unwind-tables -fno-ident
	.text
	.section	.rodata
.LC0:
	.string	"012345"
	.text
	.globl	test
	.type	test, @function
test:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$8, %esp	#,
# pppointer.c:3:      char *a = "012345";
	movl	$.LC0, -8(%ebp)	#, a
# pppointer.c:4:     *a =  'A';
	movl	-8(%ebp), %eax	# a, tmp83
	movb	$65, (%eax)	#, *a_1
# pppointer.c:5:      int b=100;
	movl	$100, -4(%ebp)	#, b
# pppointer.c:6:      x = 1000;
	movl	$1000, 8(%ebp)	#, x
# pppointer.c:24: }
	nop	
	leave	
	ret	
	.size	test, .-test
	.globl	test2
	.type	test2, @function
test2:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$16, %esp	#,
# pppointer.c:27: {
	movl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp83
	movl	%eax, -4(%ebp)	# tmp83, D.2690
	xorl	%eax, %eax	# tmp83
# pppointer.c:29:     void *p = &ary;
	leal	-9(%ebp), %eax	#, tmp82
	movl	%eax, -16(%ebp)	# tmp82, p
# pppointer.c:31: }
	nop	
	movl	-4(%ebp), %eax	# D.2690, tmp84
	subl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp84
	je	.L3	#,
	call	__stack_chk_fail	#
.L3:
	leave	
	ret	
	.size	test2, .-test2
	.section	.note.GNU-stack,"",@progbits
