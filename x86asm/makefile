build/%.bin: src/%.asm
	nasm $< -o $@

build/master.img: build/boot.bin build/loader.bin
ifeq ("$(wildcard build/master.img)","")
	bximage -q -hd=10 -func=create -sectsize=512 -imgmode=flat $@
endif
	dd if=build/boot.bin  of=$@  bs=512 count=1 seek=0 conv=notrunc
	dd if=build/loader.bin  of=$@  bs=512 count=10 seek=1 conv=notrunc 

.PHONY:bochs
bochs:build/master.img
	rm -rf build/bx_enh_dbg.ini
	cd build && bochs -q -unlock

.PHONY:clean
clean:
	rm -rf build/*.bin
	rm -rf build/*.img
	rm -rf build/bx_enh_dbg.ini
	