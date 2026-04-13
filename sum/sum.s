/*
*   int sum(int *a, int n);
*/
.global sum
.type sum,@function
sum:
    xor %eax, %eax
1:  add (%rdi), %eax
    add $4, %rdi
    dec %esi
    cmp $0, %esi
    jnz 1b
    ret
#
#    s = 0;
#L1:
#    s += *a;
#    a += sizeof(*a);
#    --n;
#    if (n != 0) goto L1;
#    return s;
#
