	.file	"localvar.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mpreferred-stack-boundary=2 -m32 -mtune=generic -march=x86-64 -O0 -fno-asynchronous-unwind-tables -fno-pic -fno-builtin
	.text
	.section	.rodata
.LC0:
	.string	"\345\233\272\345\256\232\345\257\204\345\255\230\345\231\250%d+%d=%d \n"
	.align 4
.LC1:
	.string	"\345\220\214\345\257\204\345\255\230\345\231\250\345\215\240\344\275\215 a1%d+result%d=result%d\n"
.LC2:
	.string	"\344\273\273\346\204\217\345\257\204\345\255\230\345\231\250%d+%d=%d\n"
.LC3:
	.string	"\345\217\230\351\207\217\345\206\215\350\265\267\345\220\215%d+%d=%d\n"
.LC4:
	.string	"\347\254\254\344\270\211\345\255\227\346\256\265\344\275\277\347\224\250%d+%d=%d\n"
.LC5:
	.string	"\344\275\277\347\224\250\345\206\205\345\255\230\345\206\205\347\275\256%d+%d=%d\n"
	.align 4
.LC6:
	.string	"\344\270\215\347\224\250&\344\274\232\345\207\272\351\224\231\347\232\204\346\203\205\345\206\265a1=%d, b1=%d \n"
.LC7:
	.string	"\347\224\250&\347\232\204\346\203\205\345\206\265a1=%d, b1=%d \n"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	pushl	%esi	#
	pushl	%ebx	#
	subl	$20, %esp	#,
	movl	12(%ebp), %eax	# argv, tmp118
	movl	%eax, -28(%ebp)	# tmp118, argv
# localvar.c:4: {
	movl	%gs:20, %eax	# MEM[(<address-space-2> unsigned int *)20B], tmp127
	movl	%eax, -12(%ebp)	# tmp127, D.2201
	xorl	%eax, %eax	# tmp127
# localvar.c:5:      int a1 = 10;
	movl	$10, -24(%ebp)	#, a1
# localvar.c:6:     int b1 = 20;
	movl	$20, -20(%ebp)	#, b1
# localvar.c:7:     int result = 21;
	movl	$21, -16(%ebp)	#, result
# localvar.c:10:     asm volatile(
	movl	-24(%ebp), %eax	# a1, a1.0_1
	movl	-20(%ebp), %edx	# b1, b1.1_2
#APP
# 10 "localvar.c" 1
	addl %edx, %eax

# 0 "" 2
#NO_APP
	movl	%eax, -16(%ebp)	# tmp119, result
# localvar.c:14:         printf("固定寄存器%d+%d=%d \n",a1,result,result);
	movl	-16(%ebp), %ecx	# result, result.2_3
	movl	-16(%ebp), %edx	# result, result.3_4
	movl	-24(%ebp), %eax	# a1, a1.4_5
	pushl	%ecx	# result.2_3
	pushl	%edx	# result.3_4
	pushl	%eax	# a1.4_5
	pushl	$.LC0	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:17:     asm volatile(
	movl	-24(%ebp), %edx	# a1, a1.5_6
	movl	-16(%ebp), %eax	# result, result.6_7
#APP
# 17 "localvar.c" 1
	addl %edx, %eax	# a1.5_6, tmp120
movl %eax, %eax	# tmp120, tmp120

# 0 "" 2
#NO_APP
	movl	%eax, -16(%ebp)	# tmp120, result
# localvar.c:23:         printf("同寄存器占位 a1%d+result%d=result%d\n",a1,result,result);
	movl	-16(%ebp), %ecx	# result, result.7_8
	movl	-16(%ebp), %edx	# result, result.8_9
	movl	-24(%ebp), %eax	# a1, a1.9_10
	pushl	%ecx	# result.7_8
	pushl	%edx	# result.8_9
	pushl	%eax	# a1.9_10
	pushl	$.LC1	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:25:     asm volatile(
	movl	-24(%ebp), %edx	# a1, a1.10_11
	movl	-20(%ebp), %ecx	# b1, b1.11_12
#APP
# 25 "localvar.c" 1
	addl %edx, %ecx	# a1.10_11, b1.11_12
movl %ecx, %eax	# b1.11_12, tmp121

# 0 "" 2
#NO_APP
	movl	%eax, -16(%ebp)	# tmp121, result
# localvar.c:30:         printf("任意寄存器%d+%d=%d\n",a1,b1,result);
	movl	-16(%ebp), %ecx	# result, result.12_13
	movl	-20(%ebp), %edx	# b1, b1.13_14
	movl	-24(%ebp), %eax	# a1, a1.14_15
	pushl	%ecx	# result.12_13
	pushl	%edx	# b1.13_14
	pushl	%eax	# a1.14_15
	pushl	$.LC2	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:34:     asm volatile(
	movl	-24(%ebp), %edx	# a1, a1.15_16
	movl	-20(%ebp), %ecx	# b1, b1.16_17
#APP
# 34 "localvar.c" 1
	addl %edx, %ecx	# a1.15_16, b1.16_17
movl %ecx, %eax	# b1.16_17, tmp122

# 0 "" 2
#NO_APP
	movl	%eax, -16(%ebp)	# tmp122, result
# localvar.c:39:         printf("变量再起名%d+%d=%d\n",a1,b1,result);
	movl	-16(%ebp), %ecx	# result, result.17_18
	movl	-20(%ebp), %edx	# b1, b1.18_19
	movl	-24(%ebp), %eax	# a1, a1.19_20
	pushl	%ecx	# result.17_18
	pushl	%edx	# b1.18_19
	pushl	%eax	# a1.19_20
	pushl	$.LC3	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:42:     asm volatile(
	movl	-24(%ebp), %ebx	# a1, a1.20_21
	movl	-20(%ebp), %esi	# b1, b1.21_22
#APP
# 42 "localvar.c" 1
	movl %ebx,%eax	# a1.20_21
movl %esi,%edx	# b1.21_22
addl %edx, %eax
movl %eax, %ecx	# tmp123

# 0 "" 2
#NO_APP
	movl	%ecx, -16(%ebp)	# tmp123, result
# localvar.c:51:         printf("第三字段使用%d+%d=%d\n",a1,b1,result);
	movl	-16(%ebp), %ecx	# result, result.22_23
	movl	-20(%ebp), %edx	# b1, b1.23_24
	movl	-24(%ebp), %eax	# a1, a1.24_25
	pushl	%ecx	# result.22_23
	pushl	%edx	# b1.23_24
	pushl	%eax	# a1.24_25
	pushl	$.LC4	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:54:     asm volatile(
#APP
# 54 "localvar.c" 1
	movl -24(%ebp),%eax	# a1
movl -20(%ebp),%edx	# b1
addl %edx, %eax
movl %eax, -16(%ebp)	# result

# 0 "" 2
# localvar.c:63:         printf("使用内存内置%d+%d=%d\n",a1,b1,result);
#NO_APP
	movl	-16(%ebp), %ecx	# result, result.25_26
	movl	-20(%ebp), %edx	# b1, b1.26_27
	movl	-24(%ebp), %eax	# a1, a1.27_28
	pushl	%ecx	# result.25_26
	pushl	%edx	# b1.26_27
	pushl	%eax	# a1.27_28
	pushl	$.LC5	#
	call	printf	#
	addl	$16, %esp	#,
# localvar.c:66:     asm volatile(
	movl	-20(%ebp), %eax	# b1, b1.28_29
#APP
# 66 "localvar.c" 1
	movl $11,%eax	# tmp124
movl $22,%eax	# b1.28_29

# 0 "" 2
#NO_APP
	movl	%eax, -24(%ebp)	# tmp124, a1
# localvar.c:75:         printf("不用&会出错的情况a1=%d, b1=%d \n",a1,b1);
	movl	-20(%ebp), %edx	# b1, b1.29_30
	movl	-24(%ebp), %eax	# a1, a1.30_31
	pushl	%edx	# b1.29_30
	pushl	%eax	# a1.30_31
	pushl	$.LC6	#
	call	printf	#
	addl	$12, %esp	#,
# localvar.c:76:     asm volatile(
	movl	-20(%ebp), %edx	# b1, b1.31_32
#APP
# 76 "localvar.c" 1
	movl $11,%eax	# tmp125
movl $22,%edx	# b1.31_32

# 0 "" 2
#NO_APP
	movl	%eax, -24(%ebp)	# tmp125, a1
# localvar.c:85:         printf("用&的情况a1=%d, b1=%d \n",a1,b1);
	movl	-20(%ebp), %edx	# b1, b1.32_33
	movl	-24(%ebp), %eax	# a1, a1.33_34
	pushl	%edx	# b1.32_33
	pushl	%eax	# a1.33_34
	pushl	$.LC7	#
	call	printf	#
	addl	$12, %esp	#,
	movl	$0, %eax	#, _58
# localvar.c:86: }
	movl	-12(%ebp), %edx	# D.2201, tmp128
	subl	%gs:20, %edx	# MEM[(<address-space-2> unsigned int *)20B], tmp128
	je	.L3	#,
	call	__stack_chk_fail	#
.L3:
	leal	-8(%ebp), %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%ebp	#
	ret	
	.size	main, .-main
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
