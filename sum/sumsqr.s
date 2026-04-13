/*
*   int sumsqr(int *a, int n);
*
*   It returns the sum of squares in `a`.
*/
.global sumsqr
.type sumsqr,@function
sumsqr:
    xor %eax, %eax
1:  mov (%rdi), %ecx
    imull %ecx, %ecx
    add %ecx, %eax
    add $4, %rdi
    dec %esi
    cmp $0, %esi
    jnz 1b
    ret
