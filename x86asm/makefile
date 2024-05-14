build/%.bin: src/%.asm
	nasm $< -o $@

build/%.o : src/%.asm
	nasm -f elf32 $< -o $@

ENTRY_POINT_ADDRESS:= 0x11000
build/kernel.bin : build/start.o build/main.o
	ld -m elf_i386 -static $^ -o $@ -Ttext ${ENTRY_POINT_ADDRESS} 
build/%.o : src/%.c
	gcc $(CFLAGS) -c $< -o $@

build/master.img: build/boot.bin build/loader.bin build/kernel.bin
ifeq ("$(wildcard build/master.img)","")
	bximage -q -hd=10 -func=create -sectsize=512 -imgmode=flat $@
endif
	dd if=build/boot.bin  of=$@  bs=512 count=1 seek=0 conv=notrunc
	dd if=build/loader.bin  of=$@  bs=512 count=4 seek=1 conv=notrunc 
	dd if=build/kernel.bin  of=$@  bs=512 count=100 seek=6 conv=notrunc 

.PHONY:bochs
bochs:build/master.img
	rm -rf build/bx_enh_dbg.ini
	cd build && bochs -q -unlock

.PHONY:clean
clean:
	rm -rf build/*.bin
	rm -rf build/*.o
	rm -rf build/*.img
	rm -rf build/bx_enh_dbg.ini

CFLAGS:=-m32 \
		-O0 \
		-static \
		-fno-asynchronous-unwind-tables \
		-fno-pic \
		-mpreferred-stack-boundary=2 	\
		-fno-builtin \
		-fverbose-asm  \
		-nostdlib \
		-nodefaultlibs \
		-nostdinc \
		-nostartfiles \
		-fno-pie \
 

		# -fno-pie  不生成位置无关的可执行文件
		# --verbose  显示编译命令细节
		# -nostdlib   不使用标准库
		# -nodefaultlibs   不使用默认库
		# -nostdinc   不使用标准include
		# -nostartfiles  不使用startfiles
		# -fomit-frame-pointer  忽略栈指针
		# -fno-stack-protector   不使用栈保护
	

		
		
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
		#  --verbose   ：gcc XX.c -o XX.out --verbose 显示完整编译过程		
