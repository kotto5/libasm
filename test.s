.intel_syntax noprefix
.grobl _start

; int test(int)
_start:
    mov rax, rdi

    add rax, 1

    ret

    