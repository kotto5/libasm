section .text
global test

; int test(int)
test:
    mov rax, rdi

    add rax, 1

    ret

