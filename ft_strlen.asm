section .text
global test

; size_t ft_strlen(char *)
ft_strlen:
    test rdi, rdi
    jz .return_zero

    xor rcx, rcx

.loop:
    mov al, [rdi + rcx]

    test al, al
    jz .done

    inc rcx

    jmp .loop

.done
    mov rax, rcx
    ret

.return_zero:
    cor rax, rax
    ret


