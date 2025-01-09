section .text
global ft_list_push_front

extern ft_create_elem

; void ft_list_push_front(t_list **begin_list, void *data);
;                        (rdi,                 rsi)

ft_list_push_front:
    push rbp
    mov rbp, rsp
    mov rax, 0
    sub rsp, 0x70

    test rdi, rdi
    jz end

    mov [rbp-0x8], rdi ; begin_list
    mov [rbp-0x16], rsi ; data
    mov rdi, [rdi] ; *begin_list
    mov [rbp-0x32], rdi ; *begin_list

    mov rdi, [rbp-0x16]
    call ft_create_elem
    test rax, rax
    jz end
    mov [rbp-0x24], rax ; elem

    mov rax, [rbp-0x24] ; elem
    mov rsi, [rbp-0x8] ; *begin_list
    mov rcx, [rsi] ; rcx == original head of list
    mov [rsi], rax ; *begin_list = elem
    test rsi, rsi
    ; jz end
    mov [rax+8], rcx ; elem->next = *begin_list

end:
    mov rsp, rbp
    pop rbp
    ret
