.PHONY : pass_variable.s hello.s   no_cfi    variable.s  overflow.s
CFLAGS:= -fno-asynchronous-unwind-tables \
		-fno-pic \
		-mpreferred-stack-boundary=2 	\
		-O0 \
		-fno-builtin \
		# -fno-stack-protector \
		# -c \
		# -e main \


		
		
		
		#汇编代码不检查栈溢出

		#-O0 optimise 优化级别
		# -fno-stack-protector  取消栈保护
		# -fno-pic  不使用位置无关代码
		# -fno-asynchronous-unwind-tables  		   
		# -fno-builtin  不用内建函数优化
		# https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html
		# -c    编译为中间代码
		# -e main   以main函数为入口
		# -masm=intel   转换为intel的汇编码
%.s : %.c  
	gcc -m32 $< -S -o  $@ ${CFLAGS}

variable.s : variable.c 
	gcc -m32 -S $< -o $@   ${CFLAGS}

pass_variable.s : pass_variable.c 
	gcc -m32 -S $< -o $@   ${CFLAGS}

overflow.s : overflow.c 
	gcc -m32 -S $< -o $@   ${CFLAGS}
	




hello.s : hello.c
	gcc -m32 -S $< -o $@  

no_cfi : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables

no_pic : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic

no_stack : hello.c
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2

intel : hello.c
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2 -masm=intel

%.o : %.c  
	gcc -m32 $< -o $@ ${CFLAGS} -c

%.out : %.c  
	gcc -m32 $< -o $@ ${CFLAGS}