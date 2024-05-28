extern __errno_location

section .text
global ft_write

; ssize_t ft_write(int fd, const void *buf, size_t count)
;                 (rdi   , rsi            , rdx         )

; sycall (syscall_id, fd, buf, count)
;        (rax       ,rdi, rsi, rdx  )

; rdi -> rdi
; rsi -> rsi
; rdx -> rdx
; rax -> 1

ft_write:
    mov rax, 1
    syscall
    ; TODO rax(write の返り値を見て、error でなければreturn. )
    cmp rax, 0
    jne set_errno
    mov rax, 0
    ret

set_errno:
    mov rsi, rax
    call __errno_location
    mov [rax], esi
    ; TODO rax に -1 を入れる
    mov rax, -1
    ret