/*
 * takes a null terminated string, and returns
 * the number of lower case letters.
 */
.global lccounter
.type lccounter, @function
lccounter:
	xor %eax, %eax
	mov %rdi, %rsi
1:	movb (%rsi), %dl
	testb %dl, %dl
	je 1f
	cmpb $'a', %dl
	jb 2f
	cmpb $'z', %dl
	ja 2f
	inc %eax
2:	inc %rsi
	jmp 1b
1:	ret
