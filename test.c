#include <stdio.h>
#include <stdlib.h>

typedef struct s_list {
    struct s_list *next;
    void *data;
} t_list;

void    print_list(t_list *list);

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

void    swap(void **a, void **b) {
    void *tmp = *a;
    *a = *b;
    *b = tmp;
}

void    rotate(void **a, void **b, void **c) {
    void *tmp = *a;
    *a = *b;
    *b = *c;
    *c = tmp;
}

void ft_list_sort(t_list **begin_list, int (*cmp)()) {
    if (!begin_list || !*begin_list)
        return ;
    t_list **_1st = begin_list;
    t_list **_2nd = &(*_1st)->next;
    t_list **_3rd = &(*_2nd)->next;
    printf("test-2\n");
    while (1) {
        printf("AA 1st: %p, 2st: %p, 3rd: %p\n", (*_1st), (*_2nd), (*_3rd));
        if (*_3rd != NULL)
            printf("AA 1st: %p, 2st: %p, 3rd: %p\n", (*_1st)->data, (*_2nd)->data, (*_3rd)->data);
        if (cmp((*_1st)->data, (*_2nd)->data) > 0) {
            rotate(_1st, _2nd, _3rd);
            swap(&_2nd, &_3rd);
        }
        _1st = _2nd;
        _2nd = _3rd;
        if (*_3rd == NULL)
            break;
        else
            _3rd = &(*_3rd)->next;
    }
}

int ft_list_size(t_list *begin_list) {
    int i = 0;
    while (begin_list) {
        i++;
        begin_list = begin_list->next;
    }
    return i;
}

void    ft_bubble_sort(t_list **begin_list, int (*cmp)()) {
    t_list **itr = begin_list;
    int i = 0;
    int list_len = ft_list_size(*begin_list);
    while (i < list_len) {
        printf("========================\n");
        print_list(*begin_list);
        ft_list_sort(begin_list, cmp);
        i++;
    }
    print_list(*begin_list);
}

// void    ft_bubble_sort(t_list **begin_list, int (*cmp)()) {
//     t_list **itr = begin_list;
//     while (*itr) {
//         t_list **itr2 = &(*itr)->next;
//         while (*itr2) {
//             if (cmp((*itr)->data, (*itr2)->data) > 0) {
//                 void *tmp = (*itr)->data;
//                 (*itr)->data = (*itr2)->data;
//                 (*itr2)->data = tmp;
//             }
//             itr2 = &(*itr2)->next;
//         }
//         itr = &(*itr)->next;
//     }
// }

int compare(void *a, void *b) {
    printf("a: %d b: %d\n", (int)a, (int)b);
    return (int)a - (int)b;
}

void    print_list(t_list *list) {
    while (list) {
        printf("%ld, %p\n", (int)list->data, list->next);
        list = list->next;
    }
}

int  main() {
    t_list *list = ft_create_elem((void *)2);
    ft_list_push_front(&list, ft_create_elem((void *)4));
    ft_list_push_front(&list, ft_create_elem((void *)3));
    ft_list_push_front(&list, ft_create_elem((void *)5));
    ft_list_push_front(&list, ft_create_elem((void *)1));
    // print_list(list);
    // ft_list_sort(&list, compare);
    ft_bubble_sort(&list, compare);
    // print_list(list);
    return 0;
}
