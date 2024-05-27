section .text
global ft_strlen

; size_t ft_strlen(char *)
ft_strlen:
;    test rdi, rdi   ; strlen() dosen't handle NULL pointer.
;    jz .return_zero 

    xor rcx, rcx

.loop:
    mov al, [rdi + rcx]

    test al, al
    jz .done

    inc rcx

    jmp .loop

.done:
    mov rax, rcx
    ret

.return_zero:
    xor rax, rax
    ret
