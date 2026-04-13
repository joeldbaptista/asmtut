#include <stdio.h>

void *memmove(void *, const void *, size_t);

int
main(void)
{
	char str1[] = "Geeks"; 
	char str2[] = "Quiz"; 

	puts("str1 before memmove ");
	puts(str1);

	/* Copies contents of str2 to sr1 */
	memmove(str1, str2, sizeof(str2));

	puts("\nstr1 after memmove ");
	puts(str1);

	return 0;
}
