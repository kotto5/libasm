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

    mov [rbp-0x8], rdi ; str
    mov [rbp-0x16], rsi ; base

    mov rdi, rsi
    call ft_strlen
    mov [rbp-0x24], rax ; length of base
    
    ; validate base
    cmp rax, 1
    jle end_ft_atoi_base
    cmp rax, 2147483647
    jg end_ft_atoi_base

    call get_initial_portion
    mov [rbp-0x30], rax ; initial portion of str
    mov DWORD [rbp-0x38], 0 ; result
; get_sign

; calculate result
    mov rdi, [rbp-0x16] ; base
    mov rsi, [rbp-0x30] ; initial portion of str
    call ft_strchr
    test rax, rax
    jz calc_end_atoi
    inc rsi ; str++
    sub rax, rdi ; value = strchr(base, *str) - base
    mov rdx, [rbp-0x38] ; result
    imul rdx, [rbp-0x24] ; result *= base length
    add rdx, rax ; result += value
    mov [rbp-0x38], rdx ; result
    jmp ft_atoi_base

end_ft_atoi_base:
    mov rsp, rbp
    pop rbp
    ret

calc_end_atoi:
    mov rax, 10
    ; mov rax, [rbp-0x38]
    jmp end_ft_atoi_base

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

; bool ft_isspace(char c);
ft_isspace:
    mov al, dil
    cmp al, 0x20
    je ft_isspace_end
    cmp al, 0x9
    je ft_isspace_end
    cmp al, 0xA
    je ft_isspace_end
    cmp al, 0xD
    je ft_isspace_end
    mov al, 0
    ret

ft_isspace_end:
    mov al, 1
    ret

; char *get_initial_portion(char *str); return pointer to first non-whitespace character
get_initial_portion:
    mov rsi, rdi

; skip whitespace
get_initial_portion_skip_whitespace:
    mov dil, [rsi]
    call ft_isspace
    cmp al, 0
    je get_initial_portion_end
    inc rsi
    jmp get_initial_portion_skip_whitespace

get_initial_portion_end:
    mov rax, rsi
    ret
