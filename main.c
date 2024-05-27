#include <stdio.h>

extern size_t test(size_t a);

int main() {
    size_t result = test(30000000000000);
    printf("Result: %ld\n", result);
    return 0;
}