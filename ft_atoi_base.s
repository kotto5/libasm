extern ft_strlen
extern ft_strchr
extern strchr
extern ft_isspace

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
    ; - length
    cmp rax, 1
    jle error_ft_atoi_base
    cmp rax, 2147483647
    jg error_ft_atoi_base

    ; if base has '+'
    mov rdi, [rbp-0x16]
    mov sil, 43
    call ft_strchr
    test rax, rax
    jnz error_ft_atoi_base

    ; if base has '-'
    mov rdi, [rbp-0x16]
    mov sil, 45
    call ft_strchr
    test rax, rax
    jnz error_ft_atoi_base

    ; if base has whitespace
    mov rdi, [rbp-0x16]
    mov sil, 32
    call ft_strchr
    test rax, rax
    jnz error_ft_atoi_base

    ; if base has duplicate
    mov rcx, 0
loop_duplicate:
    mov rdi, [rbp-0x16]
    add rdi, rcx
    mov sil, [rdi]
    add rdi, 1
    call ft_strchr
    test al, al
    jnz error_ft_atoi_base
    inc rcx
    cmp rcx, [rbp-0x24]
    jl loop_duplicate

    mov rdi, [rbp-0x8]
    call get_initial_portion
    mov [rbp-0x32], rax ; initial portion of str
    mov DWORD [rbp-0x40], 0 ; result

get_sign:
    mov rdi, [rbp-0x32]
    mov sil, [rdi]
    cmp sil, 43
    jne get_sign_negative
    mov rdi, [rbp-0x32]
    ; inc rdi
    add rdi, 1
    mov [rbp-0x32], rdi
    jmp get_sign

get_sign_negative:
    mov rdi, [rbp-0x32]
    mov sil, [rdi]
    cmp sil, 45
    jne calculate
    mov rdi, [rbp-0x32]
    ; inc rdi
    add rdi, 1
    mov [rbp-0x32], rdi
    mov rax, [rbp-0x48]
    neg rax
    mov [rbp-0x24], rax ; result *= -1
    jmp calculate

calculate:
    mov rdi, [rbp-0x16] ; base
    mov rsi, [rbp-0x32] ; initial portion of str

    mov sil, [rsi] ; *str
    call ft_strchr
    test rax, rax
    jz calc_end_atoi
    mov sil, [rax]
    test sil, sil
    jz calc_end_atoi
    
    mov rbx, [rbp-0x32]
    ; inc rbx
    add rbx, 1
    mov [rbp-0x32], rbx
    ; inc DWORD [rbp-0x32] ; str++

    ; mov rdi, [rbp-0x16]
    ; sub rdi, rax ; value = strchr(base, *str) - base
    ; mov rax, rdi ; value = strchr(base, *str) - base
    sub rax, [rbp-0x16]
    mov rdx, [rbp-0x40] ; result
    imul rdx, [rbp-0x24] ; result *= base length
    add rdx, rax ; result += value
    mov [rbp-0x40], rdx ; result
    jmp calculate

end_ft_atoi_base:
    mov rsp, rbp
    pop rbp
    ret

calc_end_atoi:
    mov rax, [rbp-0x40]
    imul rax, [rbp-0x48]
    jmp end_ft_atoi_base

error_ft_atoi_base:
    mov rax, 0
    jmp end_ft_atoi_base

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
