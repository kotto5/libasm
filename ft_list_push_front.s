section .text
global ft_list_push_front

; void ft_list_push_front(t_list **begin_list, void *data);
;                        (rdi,                 rsi)

ft_list_push_front: