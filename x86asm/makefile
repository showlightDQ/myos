build/%.bin:src/%.asm
	nasm $< -o $@

build/master.img: build/boot.bin
ifeq ("$(wildcard build/master.img)","")
	bximage -q -hd=10 -func=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$<  of=$@  bs=512 count=9 conv=notrunc

.PHONY:bochs
bochs:build/master.img
	rm -rf build/bx_enh_dbg.ini
	cd build && bochs -q -unlock

.PHONY:clean
clean:
	rm -rf build/*.bin
	rm -rf build/*.img
	rm -rf build/bx_enh_dbg.ini
	