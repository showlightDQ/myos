	.file	"main.c"
	.text
	.globl	magic
	.data
	.align 4
	.type	magic, @object
	.size	magic, 4
magic:
	.long	20240514
	.globl	message
	.align 8
	.type	message, @object
	.size	message, 14
message:
	.string	"hello onix!!!"
	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 1024
buf:
	.zero	1024
	.text
	.globl	kernel_init
	.type	kernel_init, @function
kernel_init:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	$753664, -8(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L2
.L3:
	movl	-12(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	cltq
	leaq	message(%rip), %rcx
	movzbl	(%rax,%rcx), %eax
	movb	%al, (%rdx)
	movb	$22, -13(%rbp)
	addl	$1, -12(%rbp)
.L2:
	movl	-12(%rbp), %eax
	cmpl	$13, %eax
	jbe	.L3
	movl	$981, %edi
	call	inb@PLT
	movb	%al, -14(%rbp)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	kernel_init, .-kernel_init
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
