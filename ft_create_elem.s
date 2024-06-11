section .text
global ft_create_elem

; t_list *ft_create_elem(void *data);
;                        (rdi)
ft_create_elem:
    push rbp
    mov rbp, rsp
    mov rax, 0
    sub rsp, 0x64

    mov [rbp-0x8], rdi ; data

    mov rdi, 16; sizeof(t_list)
    call malloc
    test rax, rax
    jz end
    mov [rbp-0x16], rax ; elem

    mov rax, [rbp-0x16]
    mov rdi, [rbp-0x8]
    mov [rax], rdi ; elem->data

    mov rax, [rbp-0x16]
    mov [rax+8], 0 ; elem->next

end:
    mov rsp, rbp
    pop rbp
    ret
