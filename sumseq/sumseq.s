.global sumseq
.type sumseq, @function
sumseq:
	mov $0, %rax
1:	cmp $0, %rdi
	jle 1f
	add %rdi, %rax
	dec %rdi
	jmp 1b
1:	ret	
