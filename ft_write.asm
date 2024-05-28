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
    mov rsi, rax
    cmp rax, 0
    
    call __errno_location
    mov [rax], esi

    ret
