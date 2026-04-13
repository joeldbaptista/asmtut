#include <stdio.h>

int sumsqr(int *, int);

int main(void)
{
	int a[] = {1, 2, 3, 4, 5};
	int n = 5;

	printf("sum(1, 2, 3, 4, 5) = %d\n", sumsqr(a, n));
	return 0;
}
