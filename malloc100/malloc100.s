        .section .rodata
fmt:    .asciz "%d\n"

        .section .text
        .global main
        .type   main, @function
main:
        push    %rbx                    /* callee-saved: array pointer */
        push    %r12                    /* callee-saved: print loop counter */
                                        /* (two pushes also re-align %rsp to 16) */

        mov     $400, %rdi              /* 100 * sizeof(int) */
        call    malloc
        mov     %rax, %rbx              /* %rbx = arr */

        /* arr[i] = i + 1  for i in 0..99 */
        xor     %ecx, %ecx              /* i = 0 */
1:      mov     %ecx, %eax
        inc     %eax                    /* value = i + 1 */
        mov     %eax, (%rbx,%rcx,4)     /* arr[i] = value */
        inc     %ecx
        cmp     $100, %ecx
        jl      1b

        /* printf("%d\n", arr[i])  for i in 0..99 */
        xor     %r12d, %r12d            /* i = 0; %r12 survives printf */
2:      lea     fmt(%rip), %rdi
        mov     (%rbx,%r12,4), %esi
        xor     %eax, %eax              /* variadic: 0 vector regs used */
        call    printf
        inc     %r12d
        cmp     $100, %r12d
        jl      2b

        mov     %rbx, %rdi
        call    free

        xor     %eax, %eax              /* return 0 */
        pop     %r12
        pop     %rbx
        ret
