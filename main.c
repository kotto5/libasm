#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>

extern size_t ft_strlen(char *s);
extern char *ft_strcpy(char *dst, char *src);
extern int ft_strcmp(const char *s1, const char *s2);

void t_strlen(char *s) {
    assert(ft_strlen(s) == strlen(s));
}

void test_strlen(void) {
    t_strlen("");
    t_strlen("abc");
    t_strlen("a\0a");

    // error cases
    // t_strlen(NULL); // segmentation fault
}

void t_strcpy(char *dst, char *src, size_t dst_size) {
    char *dst1 = calloc(1, dst_size);
    char *dst2 = calloc(1, dst_size);

    strcpy(dst1, dst);
    strcpy(dst2, dst);

    char *src1 = strdup(src);
    char *src2 = strdup(src);

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

void test_strcpy(void) {
    t_strcpy("abc", "42Tokyo", 10);
    t_strcpy("abc", "42", 10);

    // error case
    // t_strcpy("abc", "42Tokyo", 4); // Buffer Overflow
    // t_strcpy("abc", NULL, 10);
    // char *s = strdup("test");
    // strcpy(s, NULL); // I don't know how I should implement!
    // strcpy(NULL, s);
    // printf("org: %s\n", s);
}

void    t_strcmp(const char *s1, const char *s2) {
    printf("og: %d\n", strcmp(s1, s2));
    printf("me: %d\n", ft_strcmp(s1, s2));
    // assert(ft_strcmp(s1, s2) == strcmp(s1, s2));
}

void    test_strcmp(void) {
    t_strcmp("aa", "ab");
    t_strcmp("ab", "aa");
    t_strcmp("a", "b");
    t_strcmp("a", "ab");
    t_strcmp("ab", "a");
    // t_strcmp(NULL, NULL); // segv
}

int main() {
    // test_strlen();
    // test_strcpy();
    test_strcmp();
    return 0;
}
