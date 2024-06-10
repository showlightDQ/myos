.PHONY : clean  bochs test bochsg
BUILD :=../build
SRC   :=.
KERNEL :=./kernel
ENTRYPOINT := 0x10000

CFLAGS:= -m32 
CFLAGS+= -fno-builtin
CFLAGS+= -nostdinc 
CFLAGS+= -fno-pic
CFLAGS+= -fno-pie
CFLAGS+= -nostdlib
CFLAGS+= -fno-stack-protector
CFLAGS:=$(strip $(CFLAGS))

	# -fno-pie  不生成位置无关的可执行文件
		# --verbose  显示编译命令细节
		# -nostdlib   不使用标准库
		# -nodefaultlibs   不使用默认库
		# -nostdinc   不使用标准include
		# -nostartfiles  不使用startfiles
		# -fomit-frame-pointer  忽略栈指针
		# -fno-stack-protector   不使用栈保护
		# -fverbose-asm 生成的汇编码中加入C原命令注释
		# -O0 optimise 优化级别
		# -fno-stack-protector  取消栈保护
		# -fno-pic  不使用位置无关代码
		# -fno-asynchronous-unwind-tables  		   
		# -fno-builtin  不用内建函数优化
		# https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html
		# -c  编译为中间代码 生成.o文件 gcc -c 其实是调用了 as -32 (as -32 $< -o $@)
		# -S  编译为汇编代码  生成.s文件
		# -g  编译为可debug 的代码  
		# -e main   以main函数为入口
		# -E 预处理
		# -masm=intel   转换为intel的汇编码
		# -fomit-frame-pointer （忽略栈指针）编译时忽略函数内的栈顶转移和恢复操作
		#                    即：push ebp ; mov ebp,esp......leave 
		# 链接 ld -m elf_i386 -static XXX.o -o XXX.out -e main
		#  --verbose   ：gcc XX.c -o XX.out --verbose 显示完整编译过程	

DEBUG:= -g
INCLUDE:= -I$(SRC)/include


qemug2 : $(BUILD)/master.img
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $< \
	-s -S     # 暂停，等待1234端口信号


master.img : boot.bin \
		loader.bin \
		system.bin \
		system.map \

	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $(BUILD)/$@
	dd if=$(BUILD)/boot/boot.bin   of=$(BUILD)/$@ bs=512 count=1   conv=notrunc seek=0
	dd if=$(BUILD)/boot/loader.bin of=$(BUILD)/$@ bs=512 count=3   conv=notrunc seek=1
	dd if=$(BUILD)/system.bin of=$(BUILD)/$@ bs=512 count=200 conv=notrunc seek=4
  
%.o : $(SRC)/kernel/%.c 
	$(shell mkdir -p ${BUILD}/kernel/)
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o ${BUILD}/kernel/$@

%.o : $(SRC)/lib/%.c 
	$(shell mkdir -p ${BUILD}/lib/)
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o ${BUILD}/lib/$@

%.o : $(SRC)/kernel/%.asm
	$(shell mkdir -p ${BUILD}/kernel/) 
	nasm -f elf32 $(DEBUG) $< -o ${BUILD}/kernel/$@    

%.bin : ${SRC}/boot/%.asm
	$(shell mkdir -p ${BUILD}/boot/)
	nasm -f bin ${DEBUG} $< -o ${BUILD}/boot/$@ 
kernel.bin:  kernel.o  \
		main.o \
		io.o \
		string.o \
		console.o \
		printk.o \
		vsprintf.o \
		

		    # 此处 文件先后 可能影响 dbg 的效果。
	ld -m elf_i386 -static \
	$(BUILD)/$(word 1,$^) \
	$(BUILD)/$(word 2,$^)  \
	$(BUILD)/$(word 3,$^)  \
	$(BUILD)/$(word 4,$^)  \
	$(BUILD)/$(word 5,$^)  \
	$(BUILD)/$(word 6,$^)  \
	$(BUILD)/$(word 7,$^)  \
	-o $(BUILD)/$@ -Ttext $(ENTRYPOINT)
system.bin : kernel.bin 
	objcopy -O binary $(BUILD)/$< $(BUILD)/$@  # 展开.bss等空间，去掉头信息等内容

system.map : kernel.bin
	nm $(BUILD)/$< | sort > $(BUILD)/$@ 


clean:
	# rm -rf $(BUILD)/boot/*.bin
	rm -rf $(BUILD)/*.img
	rm -rf $(BUILD)/*.img.lock
	# rm -rf ../*.o
	# rm -rf ../*.bin
	rm -rf bx_enh_dbg.ini
	find .. -type f -name "*.bin" 	-exec rm -f {} \;
	find .. -type f -name "*.o" 	-exec rm -f {} \;

bochs : master.img
	bochs -f ../bochs/bochsConfiguration -q  

bochsg : master.img
	bochs-gdb -f ../bochs/bochsrc_gdb -q  

qemu : master.img 
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $(BUILD)/$<  
	
qemug : master.img 
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $(BUILD)/$< \
	-s -S     # 暂停，等待1234端口信号

vmdk : master.img
	qemu-img convert -pO  vmdk $(BUILD)/$< $(BUILD)/master.$@
	 
test :
	@echo CFLAGS = $(CFLAGS)



































# ...........................chou chu moon...................................
$(BUILD)/boot/%.bin: $(SRC)/boot/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f bin $< -o $@

$(BUILD)/%.o: $(SRC)/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f elf32 $(DEBUG) $< -o $@

$(BUILD)/%.o: $(SRC)/%.c
	$(shell mkdir -p $(dir $@))
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o $@

$(BUILD)/kernel.bin: \
	$(BUILD)/kernel/kernel.o \
	$(BUILD)/kernel/main.o \
	$(BUILD)/kernel/io.o \


	$(shell mkdir -p $(dir $@))
	ld -m elf_i386 -static $^ -o $@ -Ttext $(ENTRYPOINT)

$(BUILD)/system.bin: $(BUILD)/kernel.bin
	objcopy -O binary $< $@

$(BUILD)/system.map: $(BUILD)/kernel.bin
	nm $< | sort > $@

$(BUILD)/master.img: $(BUILD)/boot/boot.bin \
	$(BUILD)/boot/loader.bin \
	$(BUILD)/system.bin \
	$(BUILD)/system.map  

	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $@
	dd if=$(BUILD)/boot/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot/loader.bin of=$@ bs=512 count=3 seek=1 conv=notrunc
	dd if=$(BUILD)/system.bin of=$@ bs=512 count=200 seek=4 conv=notrunc
# .....................................................................
