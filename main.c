#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>

extern size_t ft_strlen(char *s);
extern char *ft_strcpy(char *dst, char *src);
extern int ft_strcmp(const char *s1, const char *s2);

void _test_ft_strlen(char *s) {
    assert(ft_strlen(s) == strlen(s));
}

void test_ft_strlen(void) {
    _test_ft_strlen("a");
    _test_ft_strlen("a\0a");

    _test_ft_strlen("");
    ft_strlen("");
    printf("%ld\n", ft_strlen(""));
    printf("%ld\n", strlen(""));

    // error cases
    // test_ft_strlen(NULL); // segmentation fault
    // strlen(NULL);
    // ft_strlen(NULL);
}

void _test_ft_strcpy(char *dst, char *src, size_t dst_size) {
    char *dst1 = malloc(dst_size);
    char *dst2 = malloc(dst_size);

    strcpy(dst1, dst);
    strcpy(dst2, dst);

    char *src1 = strdup(src);
    char *src2 = strdup(src);

    ft_strcpy(dst1, src1);
    strcpy(dst2, src2);

    printf("tst: %s\n", dst1);
    printf("org: %s\n", dst2);

    // assert(strcmp(dst1, dst2) == 0);

    free(dst1);
    free(dst2);
    free(src1);
    free(src2);
}

void test_ft_strcpy() {
    _test_ft_strcpy("abc", "42Tokyo", 10);
    _test_ft_strcpy("abc", "42", 10);

    // error case
    // _test_ft_strcpy("abc", "42Tokyo", 4); // Buffer Overflow
    // _test_ft_strcpy("abc", NULL, 10);
    // char *s = strdup("test");
    // strcpy(s, NULL); // I don't know how I should implement!
    // strcpy(NULL, s);
    // printf("org: %s\n", s);
}

void    _test_strcmp(const char *s1, const char *s2) {
    printf("og: %d\n", strcmp(s1, s2));
    printf("me: %d\n", ft_strcmp(s1, s2));
    // assert(ft_strcmp(s1, s2) == strcmp(s1, s2));
}

void    test_strcmp() {
    _test_strcmp("aa", "ab");
}

int main() {
    // test_ft_strlen();
    // test_ft_strcpy();
    test_strcmp();
    return 0;
}
