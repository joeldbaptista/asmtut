.section .data
fibo_last_k: .quad 0
fibo_prev:   .quad 1   /* fib(-1) = 1 in the extended sequence, so the
                          first step yields fib(1) = fib(-1) + fib(0) = 1 */
fibo_curr:   .quad 0   /* fib(0) = 0 */

.section .text
.global fibo
.type fibo,@function
fibo:
        mov fibo_last_k(%rip),%rax
        cmp %rdi,%rax
        je .Lreturn_curr        /* k already computed, return cached value */

        /* advance one step: new_curr = prev + curr */
        mov fibo_prev(%rip),%rax
        mov fibo_curr(%rip),%rcx
        add %rcx,%rax           /* rax = prev + curr */
        mov %rcx,fibo_prev(%rip)
        mov %rax,fibo_curr(%rip)
        mov %rdi,fibo_last_k(%rip)
        ret

.Lreturn_curr:
        mov fibo_curr(%rip),%rax
        ret
