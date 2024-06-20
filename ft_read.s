extern __errno_location

section .text
global ft_read

; ssize_t ssize_t read(int fildes, void *buf, size_t nbyte);
;                     (rdi       , rsi      , rdx         )

; sycall (syscall_id, fd, buf, nbyte)
;        (rax       ,rdi, rsi, rdx  )

; rdi -> rdi
; rsi -> rsi
; rdx -> rdx
; rax -> 1

ft_read:
    mov     rax, 0
    syscall
    cmp rax, 0
    jl set_errno
    ret

set_errno:
    mov rsi, rax
    call __errno_location wrt ..plt
    neg esi
    mov [rax], esi
    mov rax, -1
    ret
