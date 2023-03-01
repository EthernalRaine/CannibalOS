;;; CannibalOS/Loader
;;; ------------------------------
;;; Copyright 2023 (C) Laura Raine

org 0x7c00                              ; set origin of execution

mov ax, 0x0003                          ; set video mode to 80x25 text mode
int 0x10                                ; trigger interrupt to change mode

mov ah, 0xB                             ; flip background color enable
mov bx, 0x0009                          ; set background color to blue
int 0x10                                ; trigger change background color

mov bx, szWelcome
call printasm

mov bx, szVersionInfo
call printasm

mov bx, szBaseAddress
call printasm

mov dx, 0x7c00                   ; print cur base address
call printxasm

mov bx, szNewLine
call printasm

szWelcome:
    db "Welcome to CannibalOS! Booting using caosldr...", 0xA, 0xD, 0
szVersionInfo:
    db "Pre-Milestone 0; Version 0.0.1", 0xA, 0xD, 0
szBaseAddress:
    db "Current Base Address: ", 0
szNewLine:
    db ' ', 0xA, 0xD, 0

%include 'src/ldr/utility.asm'

jmp _stop                               ; jmp to end

_stop:
hlt                                     ; halt execution
times 510-($-$$) db 0                   ; fill with 0
dw 0xaa55                               ; magic boot sector number

