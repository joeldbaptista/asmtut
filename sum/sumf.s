.global sumf
.type sumf, @function
sumf:
	xorpd %xmm0, %xmm0
    cmpq $0, %rsi # if the length of the array is zero
    je 2f
1:	addsd (%rdi), %xmm0
	add $8, %rdi
	dec %rsi
	jnz 1b
2:	ret
#
#    double s = 0;
#    if (n == 0)  goto done
#loop:
#    s += *a;
#    a += sizeof(*a);
#    --n;
#    goto loop;
#done:
#    return s;
#
