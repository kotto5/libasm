section .text
global ft_strcpy

; char *ft_strcpy(char *, char *)
ft_strcpy:
    mov rax, rdi ; rdi == first argument(dst)
    xor rcx, rcx

.loop:
    mov al, [rsi + rcx] ; rsi == second argument(src)

    mov [rdi + rcx], al ; *dst = *src

    test al, al
    jz .done

    inc rcx

    jmp .loop


.done:
    ret