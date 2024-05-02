	.file	"iner_assambly.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=2 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	a
	.data
	.align 4
	.type	a, @object
	.size	a, 4
a:
	.long	1
	.globl	b
	.align 4
	.type	b, @object
	.size	b, 4
b:
	.long	2
	.globl	result
	.bss
	.align 4
	.type	result, @object
	.size	result, 4
result:
	.zero	4
	.section	.rodata
.LC0:
	.string	"aaaaa:"
	.align 4
.LC1:
	.string	"a = %d  ,b = %d  ,result=%d  ,c="
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# iner_assambly.c:13:     printf("aaaaa:");
	pushl	$.LC0	#
	call	printf	#
	addl	$4, %esp	#,
# iner_assambly.c:14:     asm volatile(
#APP
# 14 "iner_assambly.c" 1
	
	movl a, %eax 
	movl b, %ebx
	addl %ebx, %eax
	movl %eax, result
# 0 "" 2
# iner_assambly.c:21:     printf("a = %d  ,b = %d  ,result=%d  ,c=",a,b,result);
#NO_APP
	movl	result, %ecx	# result, result.0_1
	movl	b, %edx	# b, b.1_2
	movl	a, %eax	# a, a.2_3
	pushl	%ecx	# result.0_1
	pushl	%edx	# b.1_2
	pushl	%eax	# a.2_3
	pushl	$.LC1	#
	call	printf	#
	addl	$16, %esp	#,
	movl	$0, %eax	#, _8
# iner_assambly.c:26: }
	leave	
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
