	.file	"call.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=2 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.section	.rodata
.LC0:
	.string	"gcc -fomit-frame-pointer\n"
	.text
	.globl	fomit
	.type	fomit, @function
fomit:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# call.c:7:     printf("gcc -fomit-frame-pointer\n");
	pushl	$.LC0	#
	call	printf	#
	addl	$4, %esp	#,
# call.c:10: }
	nop	
	leave	
	ret	
	.size	fomit, .-fomit
	.section	.rodata
.LC1:
	.string	"%d+%d=%d\n"
.LC2:
	.string	"%d-%d=%d\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$12, %esp	#,
# call.c:14:     int i = 3; 
	movl	$3, -12(%ebp)	#, i
# call.c:15:     int j = 4;
	movl	$4, -8(%ebp)	#, j
# call.c:16:     int k = add(i,j);
	pushl	-8(%ebp)	# j
	pushl	-12(%ebp)	# i
	call	add	#
	addl	$8, %esp	#,
	movl	%eax, -4(%ebp)	# tmp84, k
# call.c:17:     printf("%d+%d=%d\n",i,j,k);
	pushl	-4(%ebp)	# k
	pushl	-8(%ebp)	# j
	pushl	-12(%ebp)	# i
	pushl	$.LC1	#
	call	printf	#
	addl	$16, %esp	#,
# call.c:19:      i = 7;
	movl	$7, -12(%ebp)	#, i
# call.c:20:      j = 9;
	movl	$9, -8(%ebp)	#, j
# call.c:21:      k = sub(i,j); //fastcall 属性的作用，调用前不用把参数入栈，而是把参数存入ecx,edx （从右向左）见汇编码
	movl	-8(%ebp), %edx	# j, tmp85
	movl	-12(%ebp), %eax	# i, tmp86
	movl	%eax, %ecx	# tmp86,
	call	sub	#
	movl	%eax, -4(%ebp)	# tmp87, k
# call.c:26:     printf("%d-%d=%d\n",i,j,k);
	pushl	-4(%ebp)	# k
	pushl	-8(%ebp)	# j
	pushl	-12(%ebp)	# i
	pushl	$.LC2	#
	call	printf	#
	addl	$16, %esp	#,
# call.c:28:     fomit();
	call	fomit	#
# call.c:30:     return 0;
	movl	$0, %eax	#, _13
# call.c:31: }
	leave	
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
