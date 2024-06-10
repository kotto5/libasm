section .text
global ft_isspace

; bool ft_isspace(char c);
ft_isspace:
    mov al, dil
    cmp al, 0x20
    je ft_isspace_end
    cmp al, 0x9
    je ft_isspace_end
    cmp al, 0xA
    je ft_isspace_end
    cmp al, 0xD
    je ft_isspace_end
    mov al, 0
    ret

ft_isspace_end:
    mov al, 1
    ret
