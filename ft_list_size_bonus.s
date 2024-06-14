section .text
global ft_list_size

; int ft_list_size(t_list *begin_list);
;                 (rdi)

ft_list_size:
    mov rcx, 0 ; count = 0
    test rdi, rdi
    jz end

_loop:
    inc rcx
    mov rdi, [rdi+8] ; begin_list->next
    test rdi, rdi
    jz end
    jmp _loop

end:
    mov rax, rcx
    ret
