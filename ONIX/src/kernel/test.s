	.file	"test.c"
	.text
	.globl	magic
	.data
	.align 4
	.type	magic, @object
	.size	magic, 4
magic:
	.long	20240514

	.globl	message
	.align 4
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
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	movl	$753664, -8(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L2
.L3:
	leal	message@GOTOFF(%eax), %ecx
	movl	-4(%ebp), %edx
	addl	%ecx, %edx
	movzbl	(%edx), %ecx
	movl	-8(%ebp), %edx
	movb	%cl, (%edx)
	addl	$2, -8(%ebp)
	addl	$1, -4(%ebp)
.L2:
	movl	-4(%ebp), %edx
	cmpl	$13, %edx
	jbe	.L3
	nop
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	kernel_init, .-kernel_init
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB1:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE1:
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
