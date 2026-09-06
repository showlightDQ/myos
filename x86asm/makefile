# .PHONY : clean

# boot.bin : ./src/boot.asm
# 	nasm ./src/boot.asm -o ./build/boot.bin
# hd16m.img : boot.bin
# 	dd if=./build/boot.bin of=./build/hd16m.img bs=512 count=1 conv=notrunc
# bochs : hd16m.img
# 	bochs -f  ./build/b 	-q


# clean :
# 	rm -rf boot.bin


SRC_DIR := ./src
BUILD_DIR := ./build
# SRC_FILES := $(wildcard $(SRC_DIR)/*.asm)
SRC_FILES := boot.asm loader.asm
$(info $(SRC_FILES))


# BOOT_SRC := $(SRC_DIR)/test.asm
BOOT_SRC := $(SRC_DIR)/boot.asm
BOOT_BIN := $(BUILD_DIR)/boot.bin
HD_IMG   := $(BUILD_DIR)/hd16m.img
BOCHSRC  := $(BUILD_DIR)/b
ASFLAGS := nasm
# 磁盘大小 16MB
HD_SIZE_M := 16

DEBUG := 1
ifeq ($(DEBUG),1)
ASFLAGS += -g
endif

ifeq ($(DEBUG),1)
$(info debug模式打开)
else
$(info debug模式关闭)
endif



.PHONY: all bochs clean kill-bochs
T :=
all: $(BOOT_BIN) $(HD_IMG)


# 汇编生成boot.bin
$(BOOT_BIN): $(BOOT_SRC)
	mkdir -p $(BUILD_DIR)
	nasm -f bin $< -o $@

# 创建16MB硬盘镜像，写入boot.bin到第一个扇区
$(HD_IMG): $(BOOT_BIN)
	mkdir -p $(BUILD_DIR)
ifeq ("$(wildcard $(HD_IMG))","")
	$(info 新建img文件)
	dd if=/dev/zero of=$@ bs=1M count=$(HD_SIZE_M) status=none
endif
	dd if=$(BOOT_BIN) of=$@ bs=512 count=1 conv=notrunc status=none

# 杀掉残留bochs，防止旧实例卡死
kill-bochs:
	-pkill bochs
	-pkill -9 bochs

# 启动bochs调试，不要加 -q
bochs: kill-bochs all
	bochs -f $(BOCHSRC) -q
	$(info "bochs 结束")

clean:
	rm -rf $(BUILD_DIR)
