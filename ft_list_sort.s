section .data
    ; データセグメントはここでは使いません

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

section .text
    global proceed_next

proceed_next:
    ; 引数:
    ; rdi: _1st
    ; rsi: _2nd
    ; rdx: _3rd

    ; プロローグ
    push rbp            ; ベースポインタを保存
    mov rbp, rsp        ; ベースポインタを設定

    ; *_1st = &(**_1st)->next;
    mov rax, [rdi]      ; rax = *_1st
    mov rax, [rax]      ; rax = **_1st
    mov rax, [rax]      ; rax = (**_1st)->next
    mov [rdi], rax      ; *_1st = rax

    ; *_2nd = &(**_1st)->next;
    mov rax, [rdi]      ; rax = *_1st
    mov rax, [rax]      ; rax = **_1st
    mov rax, [rax]      ; rax = (**_1st)->next
    mov [rsi], rax      ; *_2nd = rax

    ; *_3rd = &(**_2nd)->next;
    mov rax, [rsi]      ; rax = *_2nd
    mov rax, [rax]      ; rax = **_2nd
    mov rax, [rax]      ; rax = (**_2nd)->next
    mov [rdx], rax      ; *_3rd = rax

    ; エピローグ
    pop rbp             ; ベースポインタを復元
    ret                 ; 関数から戻る

ft_list_sort_one_liner:
    ; 引数:
    ; rdi: begin_list
    ; rsi: cmp

    ; プロローグ
    push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; 引数をレジスタから保存
    mov r12, rdi  ; r12 = begin_list
    mov r13, rsi  ; r13 = cmp

    ; if (!begin_list || !*begin_list)
    mov rax, [r12]
    test rax, rax
    jz .done

    ; t_list **_1st = begin_list;
    mov r14, r12  ; r14 = _1st

.loop_start:
    ; proceed_next(&_1st, &_2nd, &_3rd);
    lea rdi, [r14]    ; 引数1: &_1st
    lea rsi, [rsp-8]  ; 引数2: &_2nd（スタックに一時的に保存）
    lea rdx, [rsp-16] ; 引数3: &_3rd（スタックに一時的に保存）
    call proceed_next

    ; _2ndと_3rdをスタックから取得
    mov r15, [rsp-8]  ; r15 = _2nd
    mov rbx, [rsp-16] ; rbx = _3rd

    ; if (cmp((*_1st)->data, (*_2nd)->data) > 0)
    mov rdi, [r14]    ; rdi = *_1st
    mov rdi, [rdi+8]  ; rdi = (*_1st)->data
    mov rsi, [r15]    ; rsi = *_2nd
    mov rsi, [rsi+8]  ; rsi = (*_2nd)->data
    mov rax, r13      ; 関数ポインタcmpをraxに移動
    call rax          ; cmp((*_1st)->data, (*_2nd)->data)

    ; 結果をチェック
    test eax, eax
    jle .no_swap

    ; rotate(_1st, _2nd, _3rd);
    mov rdi, r14      ; 引数1: _1st
    mov rsi, r15      ; 引数2: _2nd
    mov rdx, rbx      ; 引数3: _3rd
    call rotate

    ; swap(&_2nd, &_3rd);
    lea rdi, [rsp-8]  ; 引数1: &_2nd
    lea rsi, [rsp-16] ; 引数2: &_3rd
    call swap

.no_swap:
    ; if (*_3rd == NULL) break;
    mov rax, [rbx]
    test rax, rax
    jz .done

    jmp .loop_start

.done:
    ; レジスタをスタックから復元
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
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
    push rbx
    push r12
    push r13

    ; 引数をレジスタから保存
    mov r12, rdi  ; r12 = begin_list
    mov r13, rsi  ; r13 = cmp

    ; list_len = ft_list_size(*begin_list);
    mov rdi, [r12]  ; rdi = *begin_list
    call ft_list_size
    mov ebx, eax    ; ebx = list_len

.loop_start:
    ; while (list_len-- > 0)
    dec ebx
    js .done

    ; ft_list_sort_one_liner(begin_list, cmp);
    mov rdi, r12  ; rdi = begin_list
    mov rsi, r13  ; rsi = cmp
    call ft_list_sort_one_liner

    jmp .loop_start

.done:
    ; エピローグ
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
