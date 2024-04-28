	.file	"control.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.globl	compare
	.type	compare, @function
compare:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$4, %esp	#,
# control.c:4:     for (int  i = 0; i < 10; i++)
	movl	$0, -4(%ebp)	#, i
# control.c:4:     for (int  i = 0; i < 10; i++)
	jmp	.L2	#
.L6:
# control.c:6:         if(condition)
	cmpl	$0, 8(%ebp)	#, condition
	je	.L7	#,
# control.c:7:             continue;
	nop	
# control.c:4:     for (int  i = 0; i < 10; i++)
	addl	$1, -4(%ebp)	#, i
.L2:
# control.c:4:     for (int  i = 0; i < 10; i++)
	cmpl	$9, -4(%ebp)	#, i
	jle	.L6	#,
	jmp	.L5	#
.L7:
# control.c:9:             break;  
	nop	
.L5:
# control.c:11: } 
	nop	
	leave	
	ret	
	.size	compare, .-compare
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# control.c:15:     compare(1,2,3);
	pushl	$3	#
	pushl	$2	#
	pushl	$1	#
	call	compare	#
	addl	$12, %esp	#,
# control.c:16:     return 0;
	movl	$0, %eax	#, _3
# control.c:17: }
	leave	
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
