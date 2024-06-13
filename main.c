#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>

#define GREEN "\033[0;32m"
#define RESET "\033[0m"
#define PINK "\033[0;35m"
#define GRAY "\033[0;37m"

extern size_t ft_strlen(char *s);
extern char *ft_strcpy(char *dst, char *src);
extern int ft_strcmp(const char *s1, const char *s2);
extern ssize_t  ft_write(int fd, const void *buf, size_t count);
extern ssize_t  ft_read(int fd, void *buf, size_t count);
extern char *ft_strdup(const char *s1);
extern int ft_atoi_base(const char *str, char *base);

/* ------------ strlen ---------------- */

void t_strlen(char *s) {
    // printf("%stesting [%s]%s\n", GRAY, s, RESET);

    assert(ft_strlen(s) == strlen(s));
}

void test_strlen(void) {
    printf("%s test_strlen() %s\n", PINK, RESET);

    t_strlen("");
    t_strlen("abc");
    t_strlen("a\0a");

    char *very_long = malloc(INT_MAX);
    memset(very_long, 'A', INT_MAX - 1);
    very_long[INT_MAX - 1] = '\0';
    t_strlen(very_long);
    free (very_long);

    // error cases

    // undefined behaviors
    // t_strlen(NULL); // segmentation fault
}

/* ------------ strcpy ---------------- */

void t_strcpy(char *dst, char *src, size_t dst_size) {
    printf("%stesting dst: [%s], src: [%s], dst_size: %zu%s\n", GRAY, dst, src, dst_size, RESET);

    char *dst1 = calloc(1, dst_size);
    char *dst2 = calloc(1, dst_size);

    strcpy(dst1, dst);
    strcpy(dst2, dst);

    char *src1 = strdup(src);
    char *src2 = strdup(src);

    char *strcpy_1 = ft_strcpy(dst1, src1);
    char *strcpy_2 = strcpy(dst2, src2);

    assert(strcmp(dst1, dst2) == 0);
    assert(strcmp(strcpy_1, strcpy_2) == 0);
    assert(strcmp(strcpy_1, dst1) == 0);
    assert(strcmp(strcpy_2, dst2) == 0);

    free(dst1);
    free(dst2);
    free(src1);
    free(src2);
}

void test_strcpy(void) {
    printf("%s test_strcpy() %s\n", PINK, RESET);

    t_strcpy("abc", "42Tokyo", 10);
    t_strcpy("abc", "42", 10);
    t_strcpy("abc", "", 4);
    t_strcpy("", "", 1);

    ssize_t very_long_size = INT_MAX / 2;
    // ssize_t very_long_size = INT_MAX;
    char *very_long = malloc(very_long_size);
    memset(very_long, 'A', very_long_size - 1);
    very_long[very_long_size - 1] = '\0';
    t_strcpy("", very_long, very_long_size);
    free (very_long);

    // error cases

    // undefined behaviors
    // t_strcpy("abc", "42Tokyo", 4); // Buffer Overflow
    // t_strcpy("abc", NULL, 10);
    // char *s = strdup("test");
    // strcpy(s, NULL); // I don't know how I should implement!
    // strcpy(NULL, s);
    // printf("org: %s\n", s);
}

/* ------------ strcmp ---------------- */

void    t_strcmp(const char *s1, const char *s2) {
    printf("%stesting s1: [%s], s2: [%s]%s\n", GRAY, s1, s2, RESET);

    assert(ft_strcmp(s1, s2) == strcmp(s1, s2));
}

void    test_strcmp(void) {
    printf("%s test_strcmp() %s\n", PINK, RESET);

    t_strcmp("aa", "ab");
    t_strcmp("ab", "aa");
    t_strcmp("a", "b");
    t_strcmp("a", "ab");
    t_strcmp("ab", "a");
    t_strcmp("", "");
    t_strcmp("", "a");
    t_strcmp("ab", "");

    // error cases

    // undefined behaviors
    // t_strcmp(NULL, NULL); // segv
    // t_strcmp(NULL, "a"); // segv
    // t_strcmp("a", NULL); // segv
}

/* ------------ write ---------------- */

void    t_write_return_value_and_errno(int fd[2], const char *buf, size_t count) {
    printf("%ssubtest:  testing fd1: %d, fd2: %d, buf: [%s], count: %zu%s\n", GRAY, fd[0], fd[1], buf, count, RESET);

    errno = 0;
    ssize_t err_2 = ft_write(fd[0], buf, count);
    int errno_2 = errno;

    errno = 0;
    ssize_t err_1 = write(fd[1], buf, count);
    int errno_1 = errno;

    assert(err_1 == err_2);
    if (err_1 < 0) {
        assert(errno_1 == errno_2);
    }
}

void    t_write(char *s, size_t count) {
    printf("%smaintest: testing s: [%s], count: %zu%s\n", GRAY, s, count, RESET);

    // test is executed in such process
    // 1. create two test files.
    // 2. write to the files using write and ft_write
    // 3. compare the return value and errno
    // 4. compare the contents of the files
    // 5. remove the files
    const char *filename1 = "test1.txt";
    const char *filename2 = "test2.txt";

    // 1.
    int fd1 = open(filename1, O_CREAT | O_RDWR, 0644);
    assert(fd1 != -1);
    int fd2 = open(filename2, O_CREAT | O_RDWR, 0644);
    assert(fd2 != -1);

    // 2, 3
    int fds[2] = {fd1, fd2};
    t_write_return_value_and_errno(fds, s, count);

    // 4.
    char *buf1 = calloc(1, count);
    char *buf2 = calloc(1, count);
    lseek(fd1, 0, SEEK_SET);
    lseek(fd2, 0, SEEK_SET);
    read(fd1, buf1, count);
    read(fd2, buf2, count);
    assert(memcmp(buf1, buf2, count) == 0);
    free(buf1);
    free(buf2);

    // 5. remove the files
    close(fd1);
    close(fd2);
    unlink(filename1);
    unlink(filename2);
}

void    test_wrtie(void) {
    printf("%s test_write() %s\n", PINK, RESET);

    t_write("nn\n", 3);
    t_write("ab\0c", 4);

    int stdouts[2] = {1, 1};
    t_write_return_value_and_errno(stdouts, "test-abc\n", 9);

    // error cases
    int not_exist_fds[2] = {100, 100};
    t_write_return_value_and_errno(not_exist_fds, "abc", 3);
    int minus_fds[2] = {-1, -1};
    t_write_return_value_and_errno(minus_fds, "abc", 3);

    // undefined behaviors
    // t_write("abc", 5); // Buffer Overflow
    // t_write(NULL, 1); // segv
}

/* ------------ read ---------------- */

void    t_read_return_value_and_errno(int fd[2], size_t count) {
    printf("%ssubtest:  testing fd1: %d, fd2: %d, count: %zu%s\n", GRAY, fd[0], fd[1], count, RESET);

    char *buf1 = calloc(1, count);
    char *buf2 = calloc(1, count);
    lseek(fd[0], 0, SEEK_SET);
    lseek(fd[1], 0, SEEK_SET);

    // ssize_t err_2 = ft_read(fd[0], (void *)buf1, count);
    errno = 0;
    ssize_t err_2 = read(fd[0], (void *)buf1, count);
    int errno_2 = errno;

    errno = 0;
    ssize_t err_1 = ft_read(fd[1], (void *)buf2, count);
    int errno_1 = errno;

    // printf("%ld, %ld\n", err_2, err_1);
    assert(err_1 == err_2);
    if (err_1 < 0) {
        assert(errno_1 == errno_2);
    }
    assert(memcmp(buf1, buf2, count) == 0);
    free(buf1);
    free(buf2);
}

void    t_read(char *s, size_t count) {
    printf("%smaintest: testing s: [%s], count: %zu%s\n", GRAY, s, count, RESET);

    // test is executed in such process
    // 1. create a test file.
    // 2. write to the file.
    // 3. read from the file using read and ft_read
    // 4. compare the return value and errno
    // 5. compare the contents of the files
    // 6. remove the files
    const char *filename1 = "test1.txt";

    // 1.
    int fd1 = open(filename1, O_CREAT | O_RDWR, 0644);
    assert(fd1 != -1);
    int fd2 = open(filename1, O_CREAT | O_RDWR, 0644);
    assert(fd2 != -1);

    // 2
    write(fd1, s, count);

    // 3, 4, 5
    int fds[2] = {fd1, fd2};
    t_read_return_value_and_errno(fds, count);
    // 5. remove the files
    close(fd1);
    close(fd2);
    unlink(filename1);
}

void    test_read(void) {
    printf("%s test_read() %s\n", PINK, RESET);

    t_read("abc", 3);
    t_read("ab", 3);
    t_read("abc", 0);
    t_read("abc", 4);

    int stdins[2] = {0, 0};
    t_read_return_value_and_errno(stdins, 3);

    // error cases
    int not_exist_fds[2] = {100, 100};
    t_read_return_value_and_errno(not_exist_fds, 3);

    int minus_fds[2] = {-1, -1};
    t_read_return_value_and_errno(minus_fds, 3);

    // undefined behaviors
}

/* ------------ strdup ---------------- */

void    t_strdup(char *s) {
    printf("%stesting s: [%s]%s\n", GRAY, s, RESET);

    char *s1 = strdup(s);
    char *s2 = ft_strdup(s);

    assert(strcmp(s1, s2) == 0);

    free(s1);
    free(s2);
}

void    test_strdup(void) {
    printf("%s test_strdup() %s\n", PINK, RESET);

    t_strdup("I am not a robot");
    t_strdup("hmm");
    t_strdup("");
    t_strdup("");

    ssize_t very_long_size = INT_MAX / 2;
    // ssize_t very_long_size = INT_MAX;
    char *very_long = malloc(very_long_size);
    memset(very_long, 'A', very_long_size - 1);
    very_long[very_long_size - 1] = '\0';
    t_strcpy("", very_long, very_long_size);
    free (very_long);

    // error cases

    // undefined behaviors
    // t_strdup(NULL); // segv
}

/* ------------ ft_atoi_base ---------------- */

void    t_ft_atoi_base(const char *s) {
    printf("%stesting s: [%s]%s\n", GRAY, s, RESET);

    int atoi_base = ft_atoi_base(s, "0123456789");
    int atoi_base_ = atoi(s);

    if (atoi_base != atoi_base_) {
        printf("result: my: %d, original: %d\n\n", atoi_base, atoi_base_);
    }

    assert(atoi_base == atoi_base_);
}

void    test_ft_atoi_base(void) {
    printf("%s test_ft_atoi_base() %s\n", PINK, RESET);

    t_ft_atoi_base("42");
    t_ft_atoi_base("0");
    t_ft_atoi_base("2147483647");
    t_ft_atoi_base("2147483648");
    t_ft_atoi_base("2147483649");
    t_ft_atoi_base(" 1");
    t_ft_atoi_base("+1");
    t_ft_atoi_base("-1");
    t_ft_atoi_base("-0");
    t_ft_atoi_base("+0");
    t_ft_atoi_base("-2147483647");
    t_ft_atoi_base("-2147483648");
    t_ft_atoi_base("-2147483649");

    // different from atoi, but it is ok in subject
    assert(ft_atoi_base("++1", "0123456789") == 1); // 0 in atoi
    assert(ft_atoi_base("--1", "0123456789") == 1); // 0 in atoi
    assert(ft_atoi_base("---1", "0123456789") == -1); // 0 in atoi
    assert(ft_atoi_base("---+1", "0123456789") == -1); // 0 in atoi

    // error (return 0)
    // - length (0 ~ 1)
    assert(ft_atoi_base("a", "") == 0);
    assert(ft_atoi_base("a", "a") == 0);
    // - have ('+', '-'. ' ')
    assert(ft_atoi_base("a", "-") == 0);
    assert(ft_atoi_base("a", "-abc") == 0);
    assert(ft_atoi_base("a", "abc-") == 0);
    assert(ft_atoi_base("a", "+") == 0);
    assert(ft_atoi_base("a", "+abc") == 0);
    assert(ft_atoi_base("a", "abc+") == 0);
    assert(ft_atoi_base("a", " ") == 0);
    assert(ft_atoi_base("a", " abc") == 0);
    assert(ft_atoi_base("a", "abc ") == 0);

    // undefined behavior
    // assert(ft_atoi_base("abc", NULL) == 0);
    // assert(ft_atoi_base(NULL, NULL) == 0);
    // assert(ft_atoi_base(NULL, "abc") == 0);
}

typedef struct s_list
{
    void *data;
    struct s_list *next;
} t_list;

/* ------------ ft_create_elem ---------------- */
extern t_list *ft_create_elem(void *data);

void    t_ft_create_elem(void *data) {
    printf("%stesting data: [%s]%s\n", GRAY, (char *)data, RESET);

    t_list *elem = ft_create_elem(data);

    assert(elem->data == data);
    assert(elem->next == NULL);
}

void    test_ft_create_elem(void) {
    printf("%s test_ft_create_elem() %s\n", PINK, RESET);

    t_ft_create_elem("abc");
    t_ft_create_elem(NULL);
    // error cases

    // undefined behaviors
}

/* ------------ ft_list_push_front ---------------- */
extern void ft_list_push_front(t_list **begin_list, void *data);

void    t_ft_list_push_front(t_list **begin_list, void *data) {
    printf("%stesting data: [%p]%s\n", GRAY, (char *)data, RESET);
    t_list *org = NULL;
    if (begin_list != NULL) {
        org = *begin_list;
    }

    // printf("begin_list: %p\n", begin_list);
    // printf("*begin_list: %p\n", *begin_list);
    ft_list_push_front(begin_list, data);
    // printf("begin_list: %p\n", begin_list);
    // printf("*begin_list: %p\n", *begin_list);

    if (begin_list == NULL) {
        assert(begin_list == NULL);
        return;
    }
    else if (org == NULL) {
        assert((*begin_list)->data == data);
        assert((*begin_list)->next == NULL);
        return;
    }
    else {
        assert((*begin_list)->data == data);
        // printf("*begin_list_next: %p\n", (*begin_list)->next);
        // printf("org: %p\n", org);
        assert((*begin_list)->next == org);
        return ;
    }
}

void    test_ft_list_push_front(void) {
    printf("%s test_ft_list_push_front() %s\n", PINK, RESET);

    t_list *begin_list2 = ft_create_elem("abc");
    t_ft_list_push_front(&begin_list2, "def");

    t_list *begin_list = NULL;
    t_ft_list_push_front(&begin_list, "abc");


    // error cases

    // undefined behaviors
    // t_ft_list_push_front(NULL, "abc"); // segv
}

/* ------------ ft_list_size ---------------- */
extern int ft_list_size(t_list *begin_list);

void    t_ft_list_size(t_list *begin_list, int expected) {
    printf("%stesting expected: %d%s\n", GRAY, expected, RESET);

    assert(ft_list_size(begin_list) == expected);
}

void    test_ft_list_size(void) {
    printf("%s test_ft_list_size() %s\n", PINK, RESET);

    t_ft_list_size(NULL, 0);

    t_list *begin_list = ft_create_elem("abc");
    t_ft_list_size(begin_list, 1);

    ft_list_push_front(&begin_list, "def");
    t_ft_list_size(begin_list, 2);

    // error cases

    // undefined behaviors
}

// #if 1
/* test */

#if 0
void    swap(void **a, void **b) {
    // printf("swapping\n");
    // printf("swapping %p, %p\n", a, b);
    void *tmp = *a;
    *a = *b;
    *b = tmp;
}
#else
extern void    swap(void **a, void **b);
#endif

#if 0
void    rotate(void **a, void **b, void **c) {
    printf("rotate\n");
    void *tmp = *a;
    *a = *b;
    *b = *c;
    *c = tmp;
}
#else
extern void    rotate(void **a, void **b, void **c);
#endif

#if 0
void    proceed_next(t_list ***_1st, t_list ***_2nd, t_list ***_3rd) {
    // printf("proceed_next\n");
    printf("proceed_next %p, %p, %p\n", _1st, _2nd, _3rd);
    printf("proceed_next %p, %p, %p\n", *_1st, *_2nd, *_3rd);
    printf("proceed_next %p, %p, %p\n", **_1st, **_2nd, **_3rd);
    // printf("proceed_next %p, %p, %p\n", **_1st, **_2nd, **_3rd);
    // printf("data %ld\n", (**_1st)->data);
    *_1st = &(**_1st)->next;
    *_2nd = &(**_1st)->next;
    *_3rd = &(**_2nd)->next;
}
#else
extern void    proceed_next(t_list ***_1st, t_list ***_2nd, t_list ***_3rd);
#endif

#if 0
void ft_list_sort_one_liner(t_list **begin_list, int (*cmp)()) {
    if (!begin_list || (*begin_list) == NULL)
        return ;
    t_list **_1st = begin_list;
    t_list **_2nd = &(*_1st)->next;
    t_list **_3rd = &(*_2nd)->next;
    while (1) {
        if (*_3rd)
            printf("datas: %p, %p, %p\n", (*_1st)->data, (*_2nd)->data, (*_3rd)->data);
        else
            printf("ptrs:  %p, %p, %p\n", (*_1st), (*_2nd), (*_3rd));
        if (cmp((*_1st)->data, (*_2nd)->data) > 0) {
            rotate(_1st, _2nd, _3rd);
            swap(&_2nd, &_3rd);
        }
        if (*_3rd == NULL)
            break;
        proceed_next(&_1st, &_2nd, &_3rd);
    }
}
#else
extern void ft_list_sort_one_liner(t_list **begin_list, int (*cmp)());
#endif

#if 0
void    ft_list_sort(t_list **begin_list, int (*cmp)()) {
    // printf("begin: %p\n",begin_list);
    // t_list *head = *begin_list;
    // printf("2nd: %p\n", &(head->next));

    if (begin_list == NULL)
        return ;
    int list_len = ft_list_size(*begin_list);
    while (list_len-- > 0) {
        // cmp(1, 2);
        // print_list(begin_list);
        ft_list_sort_one_liner(begin_list, cmp);
    }
}
#else
extern void ft_list_sort(t_list **begin_list, int (*cmp)());
#endif

// #endif

/* ------------ ft_list_sort ---------------- */

void    t_ft_list_sort(t_list **begin_list, int (*cmp)()) {
    printf("%stesting%s\n", GRAY, RESET);
    int before_size = begin_list ? ft_list_size(*begin_list) : 0;
    int is_null = begin_list == NULL;

    printf("sorting!\n");
    ft_list_sort(begin_list, cmp);
    if (is_null) {
        assert(begin_list == NULL);
        return ;
    }
    printf("finished to sort!\n");
    assert(before_size == ft_list_size(*begin_list));
    print_list(*begin_list);
    if (*begin_list == NULL)
        return ;
    for (t_list *tmp = *begin_list; tmp->next; tmp = tmp->next) {
        assert(cmp(tmp->data, tmp->next->data) <= 0);
    }
}

int compare_integer(void *a, void *b) {
    int ret = a - b;
    printf("compare a: %p b: %p, a - b = %d\n", (int)a, (int)b, ret);
    return ret;
}

void    print_list(t_list *lst) {
    printf("====================\n");
    while (lst) {
        printf("value:%d , ptr:%p\n", lst->data, lst);
        lst = lst->next;
    }
    printf("====================\n");
}

void    test_ft_list_sort(void) {
    printf("%s test_ft_list_sort() %s\n", PINK, RESET);

    t_ft_list_sort(NULL, compare_integer);

    t_list *begin_list = NULL;
    t_ft_list_sort(&begin_list, compare_integer);

    ft_list_push_front(&begin_list, (void *)1);
    t_ft_list_sort(&begin_list, compare_integer);

    ft_list_push_front(&begin_list, (void *)2);
    t_ft_list_sort(&begin_list, compare_integer);

    ft_list_push_front(&begin_list, (void *)0);
    ft_list_push_front(&begin_list, (void *)5);
    ft_list_push_front(&begin_list, (void *)10);
    ft_list_push_front(&begin_list, (void *)7);
    ft_list_push_front(&begin_list, (void *)9);
    ft_list_push_front(&begin_list, (void *)6);
    t_ft_list_sort(&begin_list, compare_integer);

    // error cases

    // undefined behaviors
}

int main() {
    // test_strlen();
    // test_strcpy();
    // test_strcmp();
    // test_wrtie();
    // test_read();
    // test_strdup();
    // test_ft_atoi_base();
    // test_ft_create_elem();
    // test_ft_list_push_front();
    // test_ft_list_size();
    test_ft_list_sort();
    return 0;
}
