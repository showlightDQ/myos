.PHONY : pass_variable.s hello.s   no_cfi    variable.s 
CFLAGS:= -fno-asynchronous-unwind-tables \
		-fno-pic \
		-mpreferred-stack-boundary=2 	\
		-O0\
		# -c
		# -e main\
		# -masm=intel

variable.s : variable.c 
	gcc -m32 -S $< -o $@   ${CFLAGS}

pass_variable.s : pass_variable.c 
	gcc -m32 -S $< -o $@   ${CFLAGS}





hello.s : hello.c
	gcc -m32 -S $< -o $@  

no_cfi : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables

no_pic : hello.c 
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic

no_stack : hello.c
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2

intel : hello.c
	gcc -m32 -S $< -o hello.s -fno-asynchronous-unwind-tables -fno-pic -mpreferred-stack-boundary=2 -masm=intel

%.o : %.c  
	gcc -m32 $< -o $@ ${CFLAGS} -c

%.out : %.c  
	gcc -m32 $< -o $@ ${CFLAGS}