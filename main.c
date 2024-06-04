#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>

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

/* ------------ strlen ---------------- */

void t_strlen(char *s) {
    printf("%stesting [%s]%s\n", GRAY, s, RESET);

    assert(ft_strlen(s) == strlen(s));
}

void test_strlen(void) {
    printf("%s test_strlen() %s\n", PINK, RESET);

    t_strlen("");
    t_strlen("abc");
    t_strlen("a\0a");

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

    // error cases

    // undefined behaviors
    // t_strcmp(NULL, NULL); // segv
    // t_strcmp(NULL, "a"); // segv
    // t_strcmp("a", NULL); // segv
}

/* ------------ write ---------------- */

void    t_write_return_value_and_errno(int fd[2], const char *buf, size_t count) {
    printf("%stesting fd1: %d, fd2: %d, buf: [%s], count: %zu%s\n", GRAY, fd[0], fd[1], buf, count, RESET);

    ssize_t err_2 = ft_write(fd[0], buf, count);
    int errno_2 = errno;

    ssize_t err_1 = write(fd[1], buf, count);
    int errno_1 = errno;

    assert(err_1 == err_2);
    if (err_1 < 0) {
        assert(errno_1 == errno_2);
    }
}

void    t_write(char *s, size_t count) {
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
    printf("%stesting fd1: %d, fd2: %d, count: %zu%s\n", GRAY, fd[0], fd[1], count, RESET);

    char *buf1 = calloc(1, count);
    char *buf2 = calloc(1, count);
    lseek(fd[0], 0, SEEK_SET);
    lseek(fd[1], 0, SEEK_SET);

    // ssize_t err_2 = ft_read(fd[0], (void *)buf1, count);
    ssize_t err_2 = read(fd[0], (void *)buf1, count);
    int errno_2 = errno;

    ssize_t err_1 = ft_read(fd[1], (void *)buf2, count);
    int errno_1 = errno;

    assert(err_1 == err_2);
    if (err_1 < 0) {
        assert(errno_1 == errno_2);
    }
    assert(memcmp(buf1, buf2, count) == 0);
    free(buf1);
    free(buf2);
}

void    t_read(char *s, size_t count) {
    printf("%stesting s: [%s], count: %zu%s\n", GRAY, s, count, RESET);

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

    // error cases

    // undefined behaviors
    // t_strdup(NULL); // segv
}

int main() {
    test_strlen();
    test_strcpy();
    test_strcmp();
    test_wrtie();
    test_read();
    test_strdup();
    return 0;
}
