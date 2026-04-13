#include <stdio.h>
#include "lowercase.h"

int main(void)
{
	const char *s = "Hello World! This is Mars";
	printf("'%s' has %d lower case letters\n", s, lccounter(s));
	return 0;
}
