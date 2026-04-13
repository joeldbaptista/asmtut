#include <stdio.h>

extern long fibo(long k);

int main(void)
{
    long n, k;
    printf("Enter n: ");
    scanf("%ld", &n);

    for (k = 0; k <= n; k++) {
        printf("fib(%ld) = %ld\n", k, fibo(k));
    }

    return 0;
}
