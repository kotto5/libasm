section .text
    global ft_list_remove_if
    extern free

ft_list_remove_if:
    ; 引数:
    ; rdi: begin_list
    ; rsi: data_ref
    ; rdx: cmp
    ; rcx: free_fct

    ; プロローグ
    push rbp
    mov rbp, rsp
    sub rsp, 0x64
    push rbx
    push r12
    push r13
    push r14

    ; 引数を保存
    mov r12, rdi      ; r12 = begin_list
    mov r13, rsi      ; r13 = data_ref
    mov r14, rdx      ; r14 = cmp
    mov rbx, rcx      ; rbx = free_fct

    ; if (!begin_list)
    test r12, r12
    jz .done

    ; t_list **change = begin_list;
    ; mov [rbp-0x8], r12
    mov [rbp-0x8], rdi ; [rbp-0x8] = change

.loop_start:
    ; while (*change)
    mov rax, [rbp-0x8]
    mov rax, [rax]
    test rax, rax
    jz .done

    ; if (cmp((*change)->data, data_ref) == 0)
    mov rdi, [rbp-0x8]
    mov rdi, [rdi]   ; rdi = (*change)->data
    mov rdi, [rdi]   ; rdi = (*change)->data
    mov rsi, r13
    mov rax, r14       ; rax = cmp
    call rax
    test eax, eax
    jnz .next

    ; t_list *tmp = *change;
    mov rax, [rbp-0x8] ; rax = change
    mov rax, [rax]
    mov [rbp-0x16], rax ; tmp = *change
                        ; [rbp-0x16] = tmp

    ; *change = tmp->next;
    mov rdi, [rbp-0x16] ; rdi = tmp
    add rdi, 8 ; rdi = &(tmp->next)
    mov rdi, [rdi]
    mov rax, [rbp-0x8]
    mov [rax], rdi ; change = tmp->next

    ; free_fct(tmp->data);
    mov rdi, [rbp-0x16]   ; rdi = tmp->data
    mov rdi, [rdi]
    mov rax, rbx       ; rax = free_fct
    call rax

    ; free(tmp);
    mov rdi, [rbp-0x16]   ; rdi = tmp
    call free

    jmp .loop_start

.next:
    ; change = &(*change)->next;
    mov rdi, [rdi]     ; rdi = *change
    lea rdi, [rdi]     ; rdi = &(*change)->next
    jmp .loop_start

.done:
    ; エピローグ
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
