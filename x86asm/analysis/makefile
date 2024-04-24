.PHONY : hello.s  no_cfi
hello.s : hello.c
	gcc -m32 -S $< -o $@  

no_cfi : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables

no_pic : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic

no_stack : hello.c
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2