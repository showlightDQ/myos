.PHONY : clean  bochs test bochsg  test
BUILD:=../build
SRC:=.

TEST   :=./test
KERNEL :=../build/kernel
LIB    :=../build/lib




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


CFLAGS:= -m32 					# 32 位的程序
CFLAGS+= -fno-builtin			# 不需要 gcc 内置函数
CFLAGS+= -nostdinc				# 不需要标准头文件
CFLAGS+= -fno-pic				# 不需要位置无关的代码  position independent code
CFLAGS+= -fno-pie				# 不需要位置无关的可执行程序 position independent executable
CFLAGS+= -nostdlib				# 不需要标准库
CFLAGS+= -fno-stack-protector	# 不需要栈保护
# CFLAGS+= -DONIX					# 定义 ONIX
# CFLAGS+= -DONIX_DEBUG			# 定义 ONIX_DEBUG
CFLAGS:=$(strip ${CFLAGS})

DEBUG:= -g
INCLUDE:=-I$(SRC)/include


 #设置make默认查找路径
vpath = %.asm .kernel:.boot
VPATH = ./src:../include
override INCLUDE += $(patsubst %,-I%,$(subst :, ,$(VPATH)))

$(BUILD)/boot/%.bin: $(SRC)/boot/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f bin $< -o $@

$(BUILD)/%.o: $(SRC)/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f elf32 $(DEBUG) $< -o $@

$(BUILD)/%.o: $(SRC)/%.c
	$(shell mkdir -p $(dir $@))
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o $@

# $(BUILD)/lib/libc.o: $(BUILD)/lib/crt.o \
# 	$(BUILD)/lib/crt1.o \
# 	$(BUILD)/lib/string.o \
# 	$(BUILD)/lib/vsprintf.o \
# 	$(BUILD)/lib/stdlib.o \
# 	$(BUILD)/lib/syscall.o \
# 	$(BUILD)/lib/printf.o \
# 	$(BUILD)/lib/assert.o \
# 	$(BUILD)/lib/time.o \
# 	$(BUILD)/lib/restorer.o \

# 	ld -m elf_i386 -r $^ -o $@

# BUILTIN_APPS := \
# 	$(BUILD)/builtin/init.out \
# 	$(BUILD)/builtin/osh.out \
# 	$(BUILD)/builtin/env.out \
# 	$(BUILD)/builtin/echo.out \
# 	$(BUILD)/builtin/cat.out \
# 	$(BUILD)/builtin/ls.out \
# 	$(BUILD)/builtin/kill.out \
# 	$(BUILD)/builtin/dup.out \
# 	$(BUILD)/builtin/err.out \
# 	$(BUILD)/builtin/count.out \

# $(BUILD)/builtin/%.out: $(BUILD)/builtin/%.o \
# 	$(BUILD)/lib/libc.o \
	
# 	ld -m elf_i386 -static $^ -o $@ -Ttext 0x1001000
MULTIBOOT2:=0x10000
# ENTRYPOINT:=$(shell python -c "print(f'0x{$(MULTIBOOT2) + 64:x}')")
ENTRYPOINT := 0x10040

LDFLAGS:= -m elf_i386 \
		-static \
		-Ttext $(ENTRYPOINT)\
		--section-start=.multiboot2=$(MULTIBOOT2)
LDFLAGS:=$(strip ${LDFLAGS})

$(BUILD)/kernel.bin: \
	$(BUILD)/kernel/start.o \
	$(BUILD)/kernel/main.o \
	$(BUILD)/kernel/io.o \
	$(BUILD)/kernel/console.o \
	$(BUILD)/kernel/printk.o \
	$(BUILD)/kernel/assert.o \
	$(BUILD)/kernel/debug.o \
	$(BUILD)/kernel/global.o \
	$(BUILD)/kernel/task.o \
	$(BUILD)/kernel/thread.o \
	$(BUILD)/kernel/mutex.o \
	$(BUILD)/kernel/gate.o \
	$(BUILD)/kernel/schedule.o \
	$(BUILD)/kernel/interrupt.o \
	$(BUILD)/kernel/handler.o \
	$(BUILD)/kernel/clock.o \
	$(BUILD)/kernel/time.o \
	$(BUILD)/kernel/rtc.o \
	$(BUILD)/kernel/memory.o \
	$(BUILD)/lib/bitmap.o \
	$(BUILD)/lib/list.o \
	$(BUILD)/lib/string.o \
	$(BUILD)/lib/vsprintf.o \
	$(BUILD)/lib/syscall.o \
	$(BUILD)/lib/stdlib.o \
	$(BUILD)/kernel/keyboard.o \

	$(shell mkdir -p $(dir $@))
	ld ${LDFLAGS} $^ -o $@

# $(BUILD)/kernel/device.o \
	$(BUILD)/kernel/timer.o \
	$(BUILD)/kernel/ramdisk.o \
	$(BUILD)/kernel/ide.o \
	$(BUILD)/kernel/serial.o \
	$(BUILD)/kernel/arena.o \
	$(BUILD)/kernel/tty.o \
	$(BUILD)/kernel/buffer.o \
	$(BUILD)/kernel/system.o \
	$(BUILD)/kernel/execve.o \
	$(BUILD)/kernel/signal.o \
	$(BUILD)/fs/super.o \
	$(BUILD)/fs/bmap.o \
	$(BUILD)/fs/inode.o \
	$(BUILD)/fs/namei.o \
	$(BUILD)/fs/file.o \
	$(BUILD)/fs/stat.o \
	$(BUILD)/fs/dev.o \
	$(BUILD)/fs/pipe.o \
	$(BUILD)/fs/ioctl.o \
	$(BUILD)/lib/fifo.o \
	$(BUILD)/lib/printf.o \
	$(BUILD)/builtin/osh.o \
	$(BUILD)/lib/restorer.o \

$(BUILD)/system.bin: $(BUILD)/kernel.bin
	objcopy -O binary $< $@

$(BUILD)/system.map: $(BUILD)/kernel.bin
	nm $< | sort > $@

include utils/image.mk

include utils/cdrom.mk
include utils/cmd.mk

.PHONY: clean
clean:
	rm -rf $(BUILD)









# qemug2 : $(BUILD)/master.img
# 	qemu-system-i386 \
# 	-m 32M \
# 	-boot c \
# 	-hda $< \
# 	-s -S     # 暂停，等待1234端口信号


# master.img : boot.bin \
# 		loader.bin \
# 		system.bin \
# 		system.map \

# 	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $(BUILD)/$@
# 	dd if=$(BUILD)/boot/boot.bin   of=$(BUILD)/$@ bs=512 count=1   conv=notrunc seek=0
# 	dd if=$(BUILD)/boot/loader.bin of=$(BUILD)/$@ bs=512 count=3   conv=notrunc seek=1
# 	test -n "$$(find $(BUILD)/system.bin -size -100k)"     
# 	# ; 检查system.bin的大小，不能大于100k
# 	dd if=$(BUILD)/system.bin      of=$(BUILD)/$@ bs=512 count=2000 conv=notrunc seek=4

%.s : $(SRC)/kernel/%.c 
	gcc -m32 -fverbose-asm -nostartfiles -mpreferred-stack-boundary=2 -Qn -fno-pic -fno-asynchronous-unwind-tables $(CFLAGS) $(INCLUDE) -s $< -o ${TEST}/$@
  
# $(KERNEL)/%.o : $(SRC)/kernel/%.c 
# 	$(shell mkdir -p ${BUILD}/kernel/)
# 	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o ${BUILD}/kernel/$@

#  $(KERNEL)/%.o : $(SRC)/kernel/%.asm
# 	$(shell mkdir -p ${BUILD}/kernel/) 
# 	nasm -f elf32 $(DEBUG) $< -o $@    

# %.o : $(SRC)/lib/%.c 
# 	$(shell mkdir -p ${BUILD}/lib/)
# 	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o ${BUILD}/lib/$@

# %.bin : ${SRC}/boot/%.asm
# 	$(shell mkdir -p ${BUILD}/boot/)
# 	nasm -f bin ${DEBUG} $< -o ${BUILD}/boot/$@ 


# system.bin : kernel.bin 
# 	objcopy -O binary $(KERNEL)/$< $(BUILD)/$@  
# 	# 展开.bss等空间,去掉头信息等内容

# system.map : kernel.bin
# 	nm $(KERNEL)/$< | sort > $(BUILD)/$@ 

 

#.............................................测试用。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
#查找并返回ls文件在哪个PATH文件夹下，并返回完整路径
pathsearch = $(firstword $(wildcard $(addsuffix /$(1),$(subst :, ,$(PATH))))) 
LS := $(call pathsearch,ls)
# 查找PATH目录下的所有文件
pathsearch =  $(wildcard $(addsuffix /$(1),$(subst :, ,$(PATH))))
LS1 := $(call pathsearch,*)
test :
	@echo CFLAGS = $(CFLAGS)
	@echo INCLUDE=$(INCLUDE)
	@echo $(notdir $(wildcard *))
	@echo PATH=$(PATH)
	@echo LS1=$(LS1)
	@echo LS=$(LS)
	
