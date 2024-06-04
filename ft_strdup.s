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
    call ft_strlen
    push rdi ; save the address of the string
    mov rdi, rax
    add rdi, 1
    call malloc
    test rax, rax ; check if malloc failed
    jz .error
    mov rdi, rax ; address of the allocated memory
    pop rsi ; address of the string
    call ft_strcpy

    ret

.error:
    mov rax, 0
    ret
