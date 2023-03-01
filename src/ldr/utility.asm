;;; CannibalOS/Loader
;;; ------------------------------
;;; Copyright 2023 (C) Laura Raine

;;; https://git.sr.ht/~queso_fuego/amateur_os_video_sources/tree/master/item/03_include_files_hex_printing

printasm:                               ; print sub-routine
    pusha                               ; push all registers to stack
    mov ah, 0x0e                        ; enter teletype mode
.print_asm_char:
    mov al, [bx]                        ; move string into AL by deref
    cmp al, 0                           ; check if al is empty
    je .return                          ; stop running
    int 0x10                            ; call interrupt
    add bx, 1                           ; move one forward in CX
    jmp .print_asm_char                 ; loop over for next char
.return:
    popa                                ; pop all register from stack
    ret

printxasm:
    pusha                               ; push to stack
    mov cx, 0                           ; init counter for loop
.hex_loop:
    cmp cx, 4                           ; see if loop has run 4 times
    je .returnx
    mov ax, dx                          ; mov from ax into dx
    and ax, 0x000F                      ; get ascii from number
    add al, 0x30
    cmp al, 0x39                        ; is hex digit or letter
    jle .move_bx
    add al, 0x07                        ; get 'a' - 'f'
.move_bx:
    mov bx, szHex + 5                   ; base address of szHex + strlen
    sub bx, cx                          ; subtract loop counter
    mov [bx], al                        ; move al into derefed bx
    ror dx, 4                           ; rotate x4 right; eg.: 0x1234 -> 0x4123
    add cx, 1                           ; inc counter
    jmp .hex_loop                       ; continue loop
.returnx:
    mov bx, szHex
    call printasm                       ; print converted string
    popa                                ; restore stack registers
    ret

szHex:
    db "0x0000", 0