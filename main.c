#include <stdio.h>

extern int test(int a);

int main() {
    int result = test(5);
    printf("Result: %d\n", result);
    return 0;
}