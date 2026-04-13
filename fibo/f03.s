.global factorial
.type factorial, @function
.text
factorial:
    cmp $1, %rdi
    jnbe 1f
    mov $1, %rax
    ret
1:  push %rdi
    dec %rdi
    call factorial
    pop %rdi
    imul %rdi, %rax
    ret
