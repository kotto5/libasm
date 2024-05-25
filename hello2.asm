section .data
message: db 'hello, world!', 10

section .text
global _start
_start:
    mov rax, 1       ; システムコールの番号をraxに入れる
    mov rdi, 1       ; 1は書き込み先(descriptor)
    mov rsi, message ; messageは文字の先頭
    mov rdx, 14      ; 14は書き込むバイト数
    syscall          ; システムコールの呼び出し

    mov rax, 60      ; 60は'exit'のsyscall番号
    xor rdi, rdi
    syscall
