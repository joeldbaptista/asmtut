.global sumsqr2
.type sumsqr2, @function
sumsqr2:
	push %rbx
	push %r12
	mov $0, %rbx
	mov %rdi, %r12
1:	cmp $0, %r12
	jle 1f
	mov %r12, %rdi
	call sqr
	add %rax, %rbx
	dec %r12
	jmp 1b
1:	mov %rbx, %rax
	pop %r12
	pop %rbx
	ret
