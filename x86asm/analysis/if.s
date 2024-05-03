	.file	"if.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=2 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	compare
	.type	compare, @function
compare:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# if.c:4:     if (condition)
	cmpl	$0, 8(%ebp)	#, condition
	je	.L2	#,
# if.c:5:         return a;
	movl	12(%ebp), %eax	# a, _1
	jmp	.L3	#
.L2:
# if.c:7:         return b;    
	movl	16(%ebp), %eax	# b, _1
.L3:
# if.c:8: }
	popl	%ebp	#
	ret	
	.size	compare, .-compare
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# if.c:13:     compare(1,2,3);
	pushl	$3	#
	pushl	$2	#
	pushl	$1	#
	call	compare	#
	addl	$12, %esp	#,
# if.c:14:     return 0;
	movl	$0, %eax	#, _3
# if.c:15: }
	leave	
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
