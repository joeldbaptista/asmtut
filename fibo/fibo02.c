#include <stdio.h>
#include <inttypes.h>

uint64_t factorial(unsigned n);

int main(void)
{
    for (unsigned i = 0; i < 20; i++) {
        printf("factorial(%2u) = %lu\n", i, factorial(i));
    }
}
