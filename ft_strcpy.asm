section .text
global ft_strcpy

; char *ft_strcpy(char *, char *)
ft_strcpy:
    mov rax, rdi
    xor rcx, rcx

.loop:
    mov al, [rdi + rcx]

    test al, al
    jz .done

    mov [rsi + rcx], al ; *dst = *src

    inc rcx

    jmp .loop


.done:
    ret