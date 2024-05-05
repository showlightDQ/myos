.PHONY :  %.s  #此句无用
.PHONY : clean pass_variable.s hello.s   no_cfi    variable.s  overflow.s %.s
CC:=gcc  #"make test"命令时会自动执行 “CC ${CFLAGs} test.c -o test"，这个变量设定可以把cc换成gcc
CFLAGS:= -fno-asynchronous-unwind-tables \
		-fno-pic \
		-mpreferred-stack-boundary=2 	\
		-O0 \
		-fno-builtin \
		-fverbose-asm  \
		-m32 \
		-static \


		# --verbose 
		# -fomit-frame-pointer\
		# -fno-stack-protector \
		# -c \
		# -e main \

		
		
		#汇编代码不检查栈溢出

		# -fverbose-asm 生成的汇编码中加入C原命令注释
		# -O0 optimise 优化级别
		# -fno-stack-protector  取消栈保护
		# -fno-pic  不使用位置无关代码
		# -fno-asynchronous-unwind-tables  		   
		# -fno-builtin  不用内建函数优化
		# https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html
		# -c    编译为中间代码 生成.o文件 gcc -c 其实是调用了 as -32 (as -32 $< -o $@)
		# -S  编译为汇编代码  生成.s文件
		# -g  编译为可debug 的代码  
		# -e main   以main函数为入口
		# -E 预处理
		# -masm=intel   转换为intel的汇编码
		# -fomit-frame-pointer （忽略栈指针）编译时忽略函数内的栈顶转移和恢复操作
		#                    即：push ebp ; mov ebp,esp......leave 
		# 链接 ld -m elf_i386 -static XXX.o -o XXX.out -e main
		# gcc XX.c -o XX.out --verbose 显示完整编译命令		
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

%.o : %.s 
	as -32 $< -o $@

%.out : %.c  
	gcc -m32 $< -o $@ ${CFLAGS}
%.out : %.o 
	gcc -m32 $< -o $@ ${CFLAGS}



DEBUG := -g
%.o : %.asm
	nasm -f elf32 ${DEBUG} $< -o $@ 
%.o : %.c 
	gcc ${CFLAGS} ${DEBUG} -c $< -o $@
%.bin : %.asm
	nasm $< -o  $@ ${DEBUG}
string_in_c_and_asm.out : string_in_c_and_asm.o  string_in_asm_amemcpy.o 
	gcc $(CFLAGS) $(DEBUG) $^ -o $@

call.out :  call_add.o  call.o
	ld -m elf_i386 -static $^ -o $@ -e main
	
test_link.out : test_link.o
	ld -m elf_i386 -static $< -o $@ -e main

clean :
	rm -rf *.o