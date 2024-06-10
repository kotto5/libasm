section .text
global ft_strchr

; char *ft_strchr(char *str, char c);
;                (rdi      , sil)
ft_strchr:
    mov rax, rdi

ft_strchr_loop:
    ; inc rax
    ; jmp ft_strchr_end

    mov dil, [rax]
    cmp dil, sil
    je ft_strchr_end
    test dil, dil
    jz ft_strchr_end
    inc rax
    jmp ft_strchr_loop

ft_strchr_end:
    ret
