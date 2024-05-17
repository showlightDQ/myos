.PHONY : clean  bochs test bochsg
BUILD := ../build
SRC   := .
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



DEBUG:= -g
INCLUDE:= -I $(SRC)/include 



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
%.o : $(SRC)/kernel/%.asm
	$(shell mkdir -p ${BUILD}/kernel/)
	nasm -f elf32 $< -o ${BUILD}/kernel/$@
%.bin : ${SRC}/boot/%.asm
	$(shell mkdir -p ${BUILD}/boot/)
	nasm -f bin ${DEBUG} $< -o ${BUILD}/boot/$@
%.bin: %.o main.o	
	 ld -m elf_i386 -static $(BUILD)/kernel/$(word 1,$^)  $(BUILD)/kernel/$(word 2,$^)  -o $(BUILD)/kernel/$@ -Ttext $(ENTRYPOINT)
system.bin : kernel.bin 
	objcopy -O binary $(BUILD)/kernel/$< $(BUILD)/$@  # 展开.bss等空间，去掉头信息等内容

system.map : kernel.bin
	nm $(BUILD)/kernel/$< | sort > $(BUILD)/$@ 


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
test :
	echo $(CFLAGS)

