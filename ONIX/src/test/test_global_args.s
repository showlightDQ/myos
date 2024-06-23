	.file	"test_global_args.c"
# GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
#	compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -m32 -mpreferred-stack-boundary=2 -mtune=generic -march=x86-64 -fno-pic -fno-asynchronous-unwind-tables -fno-ident
	.text
	.globl	a
	.data
	.align 4
	.type	a, @object
	.size	a, 4
a:
	.long	4096
	.globl	b
	.align 4
	.type	b, @object
	.size	b, 4
b:
	.long	8192
	.globl	test1
	.align 4
	.type	test1, @object
	.size	test1, 4
test1:
	.long	123
	.text
	.globl	running_task
	.type	running_task, @function
running_task:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# test_global_args.c:24:     asm volatile(
#APP
# 24 "test_global_args.c" 1
	movl %esp, %eax
 	andl $0xfffff000, %eax

# 0 "" 2
# test_global_args.c:27: }
#NO_APP
	nop	
	popl	%ebp	#
	ret	
	.size	running_task, .-running_task
	.globl	schedule
	.type	schedule, @function
schedule:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$8, %esp	#,
# test_global_args.c:33:     task_t *current = running_task();
	call	running_task	#
	movl	%eax, -8(%ebp)	# tmp84, current
# test_global_args.c:34:     task_t *next = current == a ? b :a;
	movl	a, %eax	# a, a.1_1
# test_global_args.c:34:     task_t *next = current == a ? b :a;
	cmpl	%eax, -8(%ebp)	# a.1_1, current
	jne	.L3	#,
# test_global_args.c:34:     task_t *next = current == a ? b :a;
	movl	b, %eax	# b, iftmp.0_2
	jmp	.L4	#
.L3:
# test_global_args.c:34:     task_t *next = current == a ? b :a;
	movl	a, %eax	# a, iftmp.0_2
.L4:
# test_global_args.c:34:     task_t *next = current == a ? b :a;
	movl	%eax, -4(%ebp)	# iftmp.0_2, next
# test_global_args.c:36:     task_switch(next);
	pushl	-4(%ebp)	# next
	call	task_switch	#
	addl	$4, %esp	#,
# test_global_args.c:37: }
	nop	
	leave	
	ret	
	.size	schedule, .-schedule
	.globl	thread_a
	.type	thread_a, @function
thread_a:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$4, %esp	#,
.L6:
# test_global_args.c:43:         int c = 200;
	movl	$200, -4(%ebp)	#, c
# test_global_args.c:44:         schedule();
	call	schedule	#
# test_global_args.c:42:     {
	jmp	.L6	#
	.size	thread_a, .-thread_a
	.globl	thread_b
	.type	thread_b, @function
thread_b:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$4, %esp	#,
.L8:
# test_global_args.c:51:         int c2 = 200;
	movl	$200, -4(%ebp)	#, c2
# test_global_args.c:53:         schedule();
	call	schedule	#
# test_global_args.c:50:     {
	jmp	.L8	#
	.size	thread_b, .-thread_b
	.type	task_create, @function
task_create:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$8, %esp	#,
# test_global_args.c:59:     u32 stack = (u32)task + PAGE_SIZE;
	movl	8(%ebp), %eax	# task, task.2_1
# test_global_args.c:59:     u32 stack = (u32)task + PAGE_SIZE;
	addl	$4096, %eax	#, tmp84
	movl	%eax, -8(%ebp)	# tmp84, stack
# test_global_args.c:61:     stack -= sizeof(task_frame_t);
	subl	$20, -8(%ebp)	#, stack
# test_global_args.c:62:     task_frame_t *frame = (task_frame_t *)stack;
	movl	-8(%ebp), %eax	# stack, tmp85
	movl	%eax, -4(%ebp)	# tmp85, frame
# test_global_args.c:63:     frame->edi = 0x33333333;
	movl	-4(%ebp), %eax	# frame, tmp86
	movl	$858993459, (%eax)	#, frame_6->edi
# test_global_args.c:64:     frame->esi = 0x22222222;
	movl	-4(%ebp), %eax	# frame, tmp87
	movl	$572662306, 4(%eax)	#, frame_6->esi
# test_global_args.c:65:     frame->ebx = 0x11111111;
	movl	-4(%ebp), %eax	# frame, tmp88
	movl	$286331153, 8(%eax)	#, frame_6->ebx
# test_global_args.c:66:     frame->ebp = 0x44444444;
	movl	-4(%ebp), %eax	# frame, tmp89
	movl	$1145324612, 12(%eax)	#, frame_6->ebp
# test_global_args.c:67:     frame->eip = (void*)target;
	movl	-4(%ebp), %eax	# frame, tmp90
	movl	12(%ebp), %edx	# target, tmp91
	movl	%edx, 16(%eax)	# tmp91, frame_6->eip
# test_global_args.c:69:     task->stack = (u32 *)stack;
	movl	-8(%ebp), %edx	# stack, stack.3_2
# test_global_args.c:69:     task->stack = (u32 *)stack;
	movl	8(%ebp), %eax	# task, tmp92
	movl	%edx, (%eax)	# stack.3_2, task_3(D)->stack
# test_global_args.c:70: }
	nop	
	leave	
	ret	
	.size	task_create, .-task_create
	.globl	task_init
	.type	task_init, @function
task_init:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$12, %esp	#,
# test_global_args.c:73:     task_t *a1 = a;
	movl	a, %eax	# a, tmp84
	movl	%eax, -12(%ebp)	# tmp84, a1
# test_global_args.c:74:     task_t *b1 = b;
	movl	b, %eax	# b, tmp85
	movl	%eax, -8(%ebp)	# tmp85, b1
# test_global_args.c:75:     int test2 = test1;
	movl	test1, %eax	# test1, tmp86
	movl	%eax, -4(%ebp)	# tmp86, test2
# test_global_args.c:77:     task_create(a, thread_a);
	movl	a, %eax	# a, a.4_1
	pushl	$thread_a	#
	pushl	%eax	# a.4_1
	call	task_create	#
	addl	$8, %esp	#,
# test_global_args.c:78:     task_create(b, thread_b);
	movl	b, %eax	# b, b.5_2
	pushl	$thread_b	#
	pushl	%eax	# b.5_2
	call	task_create	#
	addl	$8, %esp	#,
# test_global_args.c:79:     schedule();
	call	schedule	#
# test_global_args.c:81: }
	nop	
	leave	
	ret	
	.size	task_init, .-task_init
	.globl	main
	.type	main, @function
main:
	pushl	%ebp	#
	movl	%esp, %ebp	#,
# test_global_args.c:84:     task_init();
	call	task_init	#
# test_global_args.c:85:     return 0;
	movl	$0, %eax	#, _3
# test_global_args.c:87: }
	popl	%ebp	#
	ret	
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
