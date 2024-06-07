; int ft_atoi_base(char *str, char *base);
                ;  (rdi     , rsi)

section .text
global ft_atoi_base

ft_atoi_base:
    push rbp
    mov rbp, rsp
    mov rax, 0
