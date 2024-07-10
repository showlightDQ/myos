	.file	"hello.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -fno-pic -fno-asynchronous-unwind-tables -fno-ident
	.text
	.globl	message
	.data
	.align 4
	.type	message, @object
	.size	message, 13
message:
	.string	"hello world\n"
	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 1024
buf:
	.zero	1024
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# ./test_make/hello.c:8:     printf(message);
	pushl	$message	#
	call	printf	#
	addl	$4, %esp	#,
# ./test_make/hello.c:9:     return 0;
	movl	$0, %eax	#, _3
# ./test_make/hello.c:10: }
	leave	
	ret	
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
