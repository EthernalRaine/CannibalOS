mov ds, 0x7c0
mov ah, 0x0e
mov bx, hi_mom

print:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp print
end:

jmp $

hi_mom:
    db "Hi mom", 0

times 510-($-$$) db 0
dw 0xaa55
