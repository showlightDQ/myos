	.file	"iner_assambly.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=3 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# iner_assambly.c:4:     asm("\n\t movl $1,%eax\n\t movl $2,%ebx\n\t int $0x80\n\t");
#APP
# 4 "iner_assambly.c" 1
	
	 movl $1,%eax
	 movl $2,%ebx
	 int $0x80
	
# 0 "" 2
#NO_APP
	movl	$0, %eax	#, _3
# iner_assambly.c:7: }
	popl	%ebp	#
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
