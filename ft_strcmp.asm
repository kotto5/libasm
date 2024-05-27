section .text
global ft_strcmp

; int ft_strcmp(const char *s1, const char *s2);
ft_strcmp:
    ; NULL handling
    xor rcx, rcx

.loop:
    mov al, [rsi + rcx]
    cmp [rdi + rcx], al
    jne .done

    test al, al
    jz .done

;    mov al, [rdi + rcx]
;    jz .done
    
    inc rcx
    jmp .loop

.done:
    mov rdi, [rdi + rcx]
    mov rsi, [rsi + rcx]
    sub rdi, rsi
    mov rax, rdi
    ret




