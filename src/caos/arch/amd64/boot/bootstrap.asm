global bootstrap

section .text
bits 32
bootstrap:
    mov dword [0xb8000], 0x2f4b2f4f ; move OK into video memory and print
    hlt                             ; halt the execution
