.global fibo
.type fibo,@function
fibo:
        /* returns fib(k) for k passed in %rdi
           uses iterative approach: a=fib(i-2), b=fib(i-1)
           registers: %rax=a, %rcx=b, %rdx=loop counter */
        xor %rax,%rax           /* a = fib(0) = 0 */
        test %rdi,%rdi
        jz .Ldone               /* k == 0: return 0 */

        mov $1,%rcx             /* b = fib(1) = 1 */
        mov $1,%rdx             /* i = 1 */
.Lloop:
        cmp %rdi,%rdx
        jge .Lreturn_b          /* i >= k: result is b */
        add %rcx,%rax           /* rax = a + b */
        xchg %rax,%rcx          /* rax = old b, rcx = a+b */
        inc %rdx
        jmp .Lloop
.Lreturn_b:
        mov %rcx,%rax
.Ldone:
        ret
