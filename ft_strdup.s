extern ft_strlen
extern malloc
extern ft_strcpy
; In implementation to this function, One point is different from other fucntions.
; It is I have to call the C library function (malloc)
; And also asm function (strcpy)

section .text
global ft_strdup

; char * strdup(const char *s1);
;              (rdi           )

ft_strdup:
    push rbp
    mov rbp, rsp
    sub rsp, 0x64

    call ft_strlen
    mov [rbp-0x8], rdi
    mov rdi, rax
    add rdi, 1
    call malloc wrt ..plt
    test rax, rax ; check if malloc failed
    jz .error
    mov rdi, rax ; address of the allocated memory
    mov rsi, [rbp-0x8] ; address of the string
    call ft_strcpy
    jmp .end

.error:
    mov rax, 0
    jmp .end

.end
    mov rsp, rbp
    pop rbp
    ret
