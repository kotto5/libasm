section .text
global ft_list_size

; int ft_list_size(t_list *begin_list);
;                 (rdi)

ft_list_size:
    push rbp
    mov rbp, rsp
    mov rax, 0
    sub rsp, 0x64

    test rdi, rdi
    jz end

    mov [rbp-0x8], rdi ; begin_list
    mov rcx, 1 ; count = 1
    mov rdi, [rdi] ; *begin_list
    mov [rbp-0x16], rdi ; *begin_list

ft_list_size_loop:
    mov rdi, [rbp-0x16] ; *begin_list
    mov rdi, [rdi+8] ; *begin_list->next
    test rdi, rdi
    jz end_ft_list_size
    inc rcx
    mov [rbp-0x16], rdi ; *begin_list = *begin_list->next
    jmp ft_list_size_loop

end_ft_list_size:
    mov rax, rcx

end:
    mov rsp, rbp
    pop rbp
    ret
    
