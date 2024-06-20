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
    mov     rax, 1
    syscall
    cmp rax, 0 ; TODO: Is it okey compairing with 0? maybe 0xfffff001
    jl set_errno
    ret

set_errno:
    mov rsi, rax
    call __errno_location wrt ..plt
    neg esi
    mov [rax], esi
    mov rax, -1
    ret