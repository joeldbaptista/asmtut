#include <stdio.h>
#include <stdint.h>

int64_t sumsqr2(int64_t n);

int main(void)
{
	printf("sumsqr2(-10) = %ld\n", sumsqr2(-10));
	printf("sumsqr2(0) = %ld\n", sumsqr2(0));
	printf("sumsqr2(10) = %ld\n", sumsqr2(10));
	printf("sumsqr2(100) = %ld\n", sumsqr2(100));
	printf("sumsqr2(1000) = %ld\n", sumsqr2(1000));
	printf("sumsqr2(10000) = %ld\n", sumsqr2(10000));
	printf("sumsqr2(100000) = %ld\n", sumsqr2(100000));
	return 0;
}
