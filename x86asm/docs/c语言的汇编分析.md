```s
<makefile>
hello.s : hello.c
 	gcc -m32 -S $< -o $@
.PHONY : hello.S

<note>
.cfi开头的指令： call frame information  调用栈侦信息
.cfi_  用于调试的，可以在调用失败后回溯调用栈。
编译时可以用 gcc -m32 -S $< -o $@ -fno-asynchronous-unwind-tables

## PIC  position independent code 位置无关代码，动态链接的内容:
    动态链接  mov eax,eip  该汇编语句是无效的    
    需要  call	__x86.get_pc_thunk.ax   来获得 eip 的值  获得全局依稀表_GLOBAL_OFFSET_TABLE_， 存在eax中
    addl	$_GLOBAL_OFFSET_TABLE_, %eax

    编译时使用 -fno-pic 可去掉位置无关代码
    
    andl	$-16, %esp      ; andl 0xffffffff0, %esp   栈对齐
    可以用 -mpreferred-stack-boundary=2 来去掉

    AT&T汇编语法改为Intel语法  -masm=intel

最终  	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2 -masm=intel

结果：

main:
	push	ebp
	mov	ebp, esp  ;保存栈顶指针
	push	OFFSET FLAT:.LC0
	call	puts
	add	esp, 4
	push	OFFSET FLAT:.LC1
	call	puts
	add	esp, 4
	mov	eax, 0
	leave   ;等于 mov esp,ebp   pop ebp
	ret
```


leal -1($eax),$edx  ;等效于edx = eax-1 ，不同于取地址的值，这里只是减1括号内的值
lea 是Load Effective Address 的缩写。加载有效地址


		# -fverbose-asm 生成的汇编码中加入C原命令注释
		#-O0 optimise 优化级别
		# -fno-stack-protector  取消栈保护
		# -fno-pic  不使用位置无关代码
		# -fno-asynchronous-unwind-tables  		   
		# -fno-builtin  不用内建函数优化
		# https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html
		# -c    编译为中间代码
		# -e main   以main函数为入口
		# -masm=intel   转换为intel的汇编码
		# -fvergbose-asm  对应汇编码显示C语言命令