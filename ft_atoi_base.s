extern ft_strlen

; int ft_atoi_base(char *str, char *base);
;                 (rdi      , rsi)

section .text
global ft_atoi_base

ft_atoi_base:
    push rbp
    mov rbp, rsp
    mov rax, 0
    sub rsp, 0x64

    mov -0x8(rbp), rdi
    mov -0x16(rbp), rsi

    mov rdi, rsi
    call ft_strlen
    call end_ft_atoi_base

end_ft_atoi_base:
    mov rsp, rbp
    pop rbp
    ret

; validate input


; char *ft_strchr(char *str, char c);
;                (rdi      , rsi)
ft_strchr:
    mov rdi, rsi
    mov al, [rdi]
    cmp al, 0
    je ft_strchr_end
    mov rdi, rdx
    mov al, [rdi]
    cmp al, 0
    je ft_strchr_end
    mov rdi, rdx
    mov al, [rdi]
    cmp al, [rsi]
    je ft_strchr_end
    inc rsi
    jmp ft_strchr

ft_strchr_end:
    mov rax, rsi
    ret

