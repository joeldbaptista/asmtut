#include <stdio.h>
#include <stdint.h>

int64_t sumseq(int64_t n);

int main(void)
{
	printf("sumseq(-10) = %ld\n", sumseq(-10));
	printf("sumseq(0) = %ld\n", sumseq(0));
	printf("sumseq(10) = %ld\n", sumseq(10));
	printf("sumseq(100) = %ld\n", sumseq(100));
	printf("sumseq(1000) = %ld\n", sumseq(1000));
	printf("sumseq(10000) = %ld\n", sumseq(10000));
	printf("sumseq(100000) = %ld\n", sumseq(100000));
	return 0;
}
