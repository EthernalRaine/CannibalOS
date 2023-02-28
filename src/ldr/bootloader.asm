;;; CannibalOS/Loader/ia32
;;; ------------------------------
;;; Copyright 2023 (C) Laura Raine

[org 0x7c00]                            ; set origin of execution

mov ax, 0x0003                          ; set video mode to 80x25 text mode
int 0x10                                ; trigger interrupt to change mode

mov ah, 0xB                             ; flip background color enable
mov bx, 0x0001                          ; set background color to green?
int 0x10                                ; trigger change background color

mov ah, 0x0e                            ; enter teletype mode

mov bx, teststr                         ; index test str
call printasm                           ; print subroutine call

mov bx, teststr2                        ; index test str 2
call printasm                           ; print teststr2

jmp _stop                               ; jmp to end

printasm:                               ; print sub-routine
    mov al, [bx]                        ; move string into AL by deref
    cmp al, 0                           ; check if al is empty
    je .return                          ; stop running
    int 0x10                            ; call interrupt
    add bx, 1                           ; move one forward in CX
    jmp printasm                        ; loop over for next char
.return:
    ret                                 

teststr: 
    db "16-Bit Real Mode!", 0xA, 0xD, 0    
teststr2:
    db "Also from 16-Bit Real Mode! Teststr2 fr :p", 0xA, 0xD, 0

_stop:
jmp $                                   ; jump the current memory address
times 510-($-$$) db 0                   ; fill up 510 bytes with null bytes
dw 0xaa55                               ; magic boot sector number

