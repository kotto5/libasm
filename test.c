#include <stdio.h>
#include <stdlib.h>

typedef struct s_list {
    struct s_list *next;
    void *data;
} t_list;

t_list *ft_create_elem(void *data) {
    t_list *elem = (t_list *)malloc(sizeof(t_list));
    elem->data = data;
    elem->next = NULL;
    return elem;
}

t_list *ft_list_push_front(t_list **begin_list, t_list *elem) {
    elem->next = *begin_list;
    *begin_list = elem;
    return elem;
}

void ft_list_sort(t_list **begin_list, int (*cmp)()) {
    if (!begin_list || !*begin_list)
        return ;
    t_list **_1st = begin_list;
    t_list **_2nd = &(*begin_list)->next;
    t_list **_3rd = &(*_2nd)->next;
    while (*_3rd) {
        printf("1st: %p, 2st: %p, 3rd: %p\n", (*_1st)->data, (*_2nd)->data, (*_3rd)->data);
        if (cmp((*_1st)->data, (*_2nd)->data) > 0) {
            printf("test\n");
            t_list *_1nd_tmp = *_1st;
            t_list *_2nd_tmp = *_2nd;
            t_list *_3rd_tmp = *_3rd;

            *_2nd = _3rd_tmp;
            *_3rd = _1nd_tmp;
            *_1st = _2nd_tmp;
        }
        printf("1st: %p, 2st: %p, 3rd: %p\n", (*_1st)->data, (*_2nd)->data, (*_3rd)->data);
        _1st = _2nd;
        printf("1st: %p, 2st: %p, 3rd: %p\n", (*_1st)->data, (*_2nd)->data, (*_3rd)->data);
        _2nd = _3rd;
        if (*_3rd)
            _3rd = &(*_3rd)->next;
        else
            break;
    }
}

int compare(void *a, void *b) {
    printf("a: %d b: %d\n", (int)a, (int)b);
    return (int)a - (int)b;
}

void    print_list(t_list *list) {
    while (list) {
        printf("%d\n", (int)list->data);
        list = list->next;
    }
}

int  main() {
    t_list *list = NULL;
    ft_list_push_front(&list, ft_create_elem((void *)2));
    ft_list_push_front(&list, ft_create_elem((void *)4));
    ft_list_push_front(&list, ft_create_elem((void *)3));
    ft_list_push_front(&list, ft_create_elem((void *)5));
    ft_list_push_front(&list, ft_create_elem((void *)1));
    print_list(list);
    ft_list_sort(&list, compare);
    print_list(list);
    return 0;
}
