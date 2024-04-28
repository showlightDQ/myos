	.file	"structure.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	data1
	.bss
	.align 4
	.type	data1, @object
	.size	data1, 9
data1:`
	.zero	9
	.globl	data2
	.align 4c
	.type	data2, @object
	.size	data2, 9
data2:
	.zero	9
	.globl	u2
	.type	u2, @object
	.size	u2, 2
u2:
	.zero	2
	.globl	en
	.data
	.align 4
	.type	en, @object
	.size	en, 4


en:
	.long	3

	.text
	
	
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$4, %esp	#,
# structure.c:36:     u1.u1=1;
	movzbl	-2(%ebp), %eax	# u1.u1, tmp86
	orl	$1, %eax	#, tmp87
	movb	%al, -2(%ebp)	# tmp87, u1.u1
# structure.c:37:     u1.u2=7;
	movzbl	-2(%ebp), %eax	# u1.u2, tmp90
	orl	$14, %eax	#, tmp91
	movb	%al, -2(%ebp)	# tmp91, u1.u2
# structure.c:38:     u1.u3=1;
	movzbl	-2(%ebp), %eax	# u1.u3, tmp94
	andl	$-49, %eax	#, tmp95
	orl	$16, %eax	#, tmp96
	movb	%al, -2(%ebp)	# tmp96, u1.u3
# structure.c:39:     u1.u4=1;
	movzbl	-2(%ebp), %eax	# u1.u4, tmp99
	andl	$63, %eax	#, tmp100
	orl	$64, %eax	#, tmp101
	movb	%al, -2(%ebp)	# tmp101, u1.u4
# structure.c:40:     u1.u5=7;
	movzbl	-1(%ebp), %eax	# u1.u5, tmp104
	andl	$-16, %eax	#, tmp105
	orl	$7, %eax	#, tmp106
	movb	%al, -1(%ebp)	# tmp106, u1.u5
# structure.c:41:     u1.u6=0xf;
	movzbl	-1(%ebp), %eax	# u1.u6, tmp109
	orl	$-16, %eax	#, tmp110
	movb	%al, -1(%ebp)	# tmp110, u1.u6
# structure.c:42:     return 0;
	movl	$0, %eax	#, _8
# structure.c:43: }
	leave	
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
