#include <stdio.h>

int
sum(int *a, int n)
{
	int s, *e;

	s = 0;
	e = a + n;

	while (a < e)
		s += *a++;
	return s;
}

int main(void)
{
	int a[] = {1, 2, 3, 4, 5};
	int n = 5;

	printf("sum(1, 2, 3, 4, 5) = %d\n", sum(a, n));
	return 0;
}
