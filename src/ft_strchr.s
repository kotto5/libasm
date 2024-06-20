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
    jz end_not_found
    inc rax
    jmp ft_strchr_loop

ft_strchr_end:
    ret

end_not_found:
    mov rax, 0
    jmp ft_strchr_end
