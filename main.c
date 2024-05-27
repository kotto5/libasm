#include <stdio.h>
#include <assert.h>
#include <string.h>

extern size_t test(size_t a);

// int main() {
//     size_t result = test(30000000000000);
//     printf("Result: %ld\n", result);
//     return 0;
// }

extern size_t ft_strlen(char *s);

int main() {
    char *s = "42Tokyo";

    // assert(ft_strlen(s), strlen(s));
    printf("%ld\n", ft_strlen(s));
    printf("%ld\n", strlen(s));
}
