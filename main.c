#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>

// extern size_t test(size_t a);

// int main() {
//     size_t result = test(30000000000000);
//     printf("Result: %ld\n\n", result);
//     return 0;
// }

extern size_t ft_strlen(char *s);
extern char *ft_strcpy(char *dst, char *src);

void _test_ft_strlen(char *s) {
    assert(ft_strlen(s) == strlen(s));
}

void test_ft_strlen() {
    // test_ft_strlen(NULL); // segmentation fault
    // strlen(NULL);
    // ft_strlen(NULL);

    test_ft_strlen("a");
    test_ft_strlen("a\0a");
    test_ft_strlen("");
    // ft_strlen("");
    printf("%ld\n", ft_strlen(""));
    printf("%ld\n", strlen(""));
    test_ft_strlen("aa");
}

void _test_ft_strcpy(char *dst, char *src, size_t dst_size) {
    char *dst1 = malloc(dst_size);
    char *dst2 = malloc(dst_size);

    strcpy(dst1, dst);
    strcpy(dst2, dst);

    char *src1 = strdup(src);
    char *src2 = strdup(src);

    printf("test!\n");
    ft_strcpy(dst1, src1);
    strcpy(dst2, src2);

    printf("tst: %s\n", dst1);
    printf("org: %s\n", dst2);

    assert(strcmp(dst1, dst2) == 0);

    free(dst1);
    free(dst2);
    free(src1);
    free(src2);
}

void test_ft_strcpy() {
    _test_ft_strcpy("", "42Tokyo", 10);
}

int main() {
    // test_ft_strlen();
    test_ft_strcpy();
    return 0;
}
