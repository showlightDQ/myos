.PHONY : clean  bochs 


%.bin : %.asm
	nasm -f bin $< -o $@

master.img : boot.bin
	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $@
	dd if=boot.bin of=$@ bs=512 count=1 conv=notrunc

clean:
	rm -rf *.bin
	rm -rf *img
	rm -rf bx_enh_dbg.ini

bochs:master.img
	bochs -f bochsConfiguration -q  