

nocfi := -fno-asynchronous-unwind-tables 
nopic := -fno-pic
s2    := -mpreferred-stack-boundary=2

s2    += -masm=intel


hello.s : t.c
	gcc -m32 -S $< -o $@ $(nocfi) $(nopic) $(s2)

.PHONY: hello.s