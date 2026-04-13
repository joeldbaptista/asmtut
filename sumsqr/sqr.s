.global sqr
.type sqr, @function
sqr:
	mov %rdi, %rax
	mul %rax
	ret
