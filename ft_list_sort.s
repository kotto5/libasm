extern ft_list_size

section .text
    global ft_list_sort

swap:
    ; 引数:
    ; rdi: a
    ; rsi: b

    ; プロローグ
   push rbp            ; ベースポインタを保存
   mov rbp, rsp        ; ベースポインタを設定

   ; void *tmp = *a;
   mov rax, [rdi]      ; raxに*aの値をロード

   ; *a = *b;
   mov rcx, [rsi]      ; rcxに*bの値をロード
   mov [rdi], rcx      ; *aにrcxの値をストア

   ; *b = tmp;
   mov [rsi], rax      ; *bにraxの値をストア

   ; エピローグ
   pop rbp             ; ベースポインタを復元
   ret                 ; 関数から戻る

rotate:
; 引数:
; rdi: a
; rsi: b
; rdx: c

; プロローグ
    push rbp            ; ベースポインタを保存
    mov rbp, rsp        ; ベースポインタを設定

    ; void *tmp = *a;
    mov rax, [rdi]      ; raxに*aの値をロード

    ; *a = *b;
    mov rcx, [rsi]      ; rcxに*bの値をロード
    mov [rdi], rcx      ; *aにrcxの値をストア

    ; *b = *c;
    mov rcx, [rdx]      ; rcxに*cの値をロード
    mov [rsi], rcx      ; *bにrcxの値をストア

    ; *c = tmp;
    mov [rdx], rax      ; *cにraxの値をストア

    ; エピローグ
    pop rbp             ; ベースポインタを復元
    ret                 ; 関数から戻る


proceed_next:
    ; 引数:
    ; rdi: _1st
    ; rsi: _2nd
    ; rdx: _3rd

    ; プロローグ
    push rbp
    mov rbp, rsp
    push rbx

    ; *_1st = &(**_1st)->next
    mov rax, [rdi]      ; rax = *_1st
    mov rax, [rax]      ; rax = **_1st
    lea rax, [rax+8]    ; rax = &(**_1st)->next
    mov [rdi], rax      ; *_1st = rax

    ; *_2nd = &(**_1st)->next
    mov rax, [rdi]      ; rax = *_1st
    mov rax, [rax]      ; rax = **_1st
    lea rax, [rax+8]    ; rax = &(**_1st)->next
    mov [rsi], rax      ; *_2nd = rax

    ; *_3rd = &(**_2nd)->next
    mov rax, [rsi]      ; rax = *_2nd
    mov rax, [rax]      ; rax = **_2nd
    lea rax, [rax+8]    ; rax = &(**_2nd)->next
    mov [rdx], rax      ; *_3rd = rax

    ; エピローグ
    pop rbx
    pop rbp
    ret

ft_list_sort_one_liner:
    ; call compare_integer
    ; 引数:
    ; rdi: begin_list
    ; rsi: cmp

    ; プロローグ
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40
; call ((void (*)())0x402a57(1, 2)
    ; 引数をレジスタから保存
    mov r12, rdi  ; r12 = begin_list
    mov r13, rsi  ; r13 = cmp

    ; if (!begin_list || !*begin_list)
    mov rax, [r12]
    test rax, rax
    jz .liner_done

    ; t_list **_1st = begin_list;
    mov [rbp-24], r12 ; [rbp-24] = _1st
    ; t_list **_2nd = &(*_1st)->next;
    mov rbx, [rbp-24]
    mov rbx, [rbx]
    add rbx, 8
    mov [rbp-8], rbx ; [rbp-8] = &(*_1st)->next (rbx + 8 offset for 'next')

    ; t_list **_3rd = &(*_2nd)->next;
    mov rbx, [rbp-8]
    mov rbx, [rbx]
    add rbx, 8
    mov [rbp-16], rbx ; [rbp-16] = &(*_2nd)->next

._liner_loop_start:
    jmp .check_cmp

.check_cmp:
    ; if (cmp((*_1st)->data, (*_2nd)->data) > 0)
    mov rdi, [rbp-24]
    mov rdi, [rdi]
    mov rdi, [rdi]
    mov rsi, [rbp-8]
    mov rsi, [rsi]
    mov rsi, [rsi]
    mov rax, r13
    call rax
    cmp eax, 0
    jl .no_swap

.swapping:
    ; rotate(_1st, _2nd, _3rd);
    mov rdi, [rbp-24]
    mov rsi, [rbp-8]
    mov rdx, [rbp-16]
    call rotate

    ; swap(&_2nd, &_3rd);
    lea rdi, [rbp-8]
    lea rsi, [rbp-16]
    call swap

.no_swap:
    ; if (*_3rd == NULL) break;
    mov rax, [rbp-16]
    mov rax, [rax]
    test rax, rax
    jz .liner_done

    ; proceed_next(&_1st, &_2nd, &_3rd);
    lea rdi, [rbp-24]
    lea rsi, [rbp-8]
    lea rdx, [rbp-16]
    call proceed_next

    ; _2ndと_3rdをスタックから取得
    mov r15, [rbp-8]
    mov rdx, [rbp-16]

    jmp ._liner_loop_start

.liner_done:
    ; レジスタをスタックから復元
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

; ft_list_sort関数の定義
ft_list_sort:
    ; 引数:
    ; rdi: begin_list
    ; rsi: cmp

    ; プロローグ
    push rbp
    mov rbp, rsp
    sub rsp, 0x20

    ; 引数をレジスタから保存
    mov [rbp-0x8], rdi  ; [rbp-0x8] = begin_list
    mov [rbp-0x10], rsi ; [rbp-0x10] = cmp

    ; list_len = ft_list_size(*begin_list);
    mov rdi, [rbp-0x8] ; rdi = begin_list
    mov rdi, [rdi]
    call ft_list_size
    mov [rbp-0x18], rax ; [rbp-0x18] = list_len

.loop_start:
    ; while (list_len-- > 0)
    mov rax, [rbp-0x18] ; rax = list_len
    dec rax
    test rax, rax
    jz .done
    mov [rbp-0x18], rax ; list_len = rax

    ; ft_list_sort_one_liner(begin_list, cmp);
    mov rdi, [rbp-0x8]  ; rdi = begin_list
    mov rsi, [rbp-0x10] ; rsi = cmp
    call ft_list_sort_one_liner

    jmp .loop_start

.done:
    ; エピローグ
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
