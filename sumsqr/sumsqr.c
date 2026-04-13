#include <stdio.h>
#include <stdint.h>

int64_t sumsqr(int64_t n);

int main(void)
{
	printf("sumsqr(-10) = %ld\n", sumsqr(-10));
	printf("sumsqr(0) = %ld\n", sumsqr(0));
	printf("sumsqr(10) = %ld\n", sumsqr(10));
	printf("sumsqr(100) = %ld\n", sumsqr(100));
	printf("sumsqr(1000) = %ld\n", sumsqr(1000));
	printf("sumsqr(10000) = %ld\n", sumsqr(10000));
	printf("sumsqr(100000) = %ld\n", sumsqr(100000));
	return 0;
}
