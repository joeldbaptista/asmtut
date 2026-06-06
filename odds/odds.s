/*
	Implement the follow logic in assembly

	n = 100;
	for (k = 0; k < n; ++k)
		if (k & 1)
			printf("Hey %d! You're odd\n", k);

*/
	.section .rodata
fmt:	.asciz "Hey %d! You're odd\n"

	.section .text
	.global main
	.type	main, @function
main:
	push %rbx
	xor %ebx, %ebx /* k = 0 */
top_loop:
	cmp $100, %ebx
	jge break_loop
	test $1, %ebx        /* sets ZF from k & 1 */
	jz inc_iterator
	lea fmt(%rip), %rdi
	mov %ebx, %esi
	xor %eax, %eax       /* 0 vector regs for the varargs call */
	call printf
inc_iterator:
	inc %ebx
	jmp top_loop
break_loop:
	pop %rbx
	xor %eax, %eax
	ret
