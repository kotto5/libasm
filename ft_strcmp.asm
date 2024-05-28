section .text
global ft_strcmp

; int ft_strcmp(const char *s1, const char *s2);
ft_strcmp:
    ; NULL handling
    xor rcx, rcx

.loop:
    mov al, [rdi + rcx]
    cmp BYTE [rsi + rcx], al
    jne .done

    test al, al
    jz .done ; al == 0

    inc rcx
    jmp .loop

.done:
    xor rax, rax ; rax = 0
    xor rbx, rbx ; rbx = 0

    mov [rdi + rcx], eax ; "aa" -> 'a' = ebx
    mov [rsi + rcx], ebx ; "ab" -> 'b' = eax
    sub eax, ebx ; eax = 'a' - 'b'
    ret
