CFLAGS:= -m32 
# CFLAGS+= -fno-builtin
# CFLAGS+= -nostdinc 
# CFLAGS+= -fno-pie
# CFLAGS+= -nostdlib
# CFLAGS+= -fno-stack-protector
# CFLAGS+= -fomit-frame-pointer   # 去掉函数的push ebp 等栈操作
CFLAGS+= -fverbose-asm
CFLAGS+= -nostartfiles     #不需要入口函数
CFLAGS+= -mpreferred-stack-boundary=2  # 2：2的2次方个字节。去掉栈对齐指令 andl	$-16, %esp  
CFLAGS+= -Qn  # 去掉GNU 的版本信息
CFLAGS+= -fno-pic   # 去掉位置无关PIC 代码 ，查找全局偏移表的语句
CFLAGS+= -fno-asynchronous-unwind-tables 

CFLAGS:=$(strip $(CFLAGS)) 
SRC   :=../
LIB    :=../build/lib
INCLUDE:= -I$(SRC)/include


.PHONY : clean  bochs test bochsg
# BUILD :=../build
# KERNEL :=../build/kernel
# ENTRYPOINT := 0x10000


.PHONY : %.s 
%.s : %.c
	gcc $(CFLAGS) $(INCLUDE) -S $< -o $@

%.out : %.s
	gcc $(CFLAGS) $(INCLUDE)  $< -o $@


