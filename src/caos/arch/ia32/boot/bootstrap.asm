global bootstrap

section .text
bits 32
bootstrap:
    mov esp, stack_top              ; move location of stack_top into stack pointer

    call was_loaded_by_multiboot    ; verify that the kernel was booted by a multiboot2 bootloader
    call verify_cpuid               ; verify that the CPU supports CPUID

    mov dword [0xb8000], 0x2f4b2f4f ; move OK into video memory and print
    hlt                             ; halt the execution

throw_error:                        ; eventually this will be replaced with a proper string writing error message
    mov dword [0xb8000], 0x4f524f45 ; write "ER" into video memory
    mov dword [0xb8004], 0x4f3a4f52 ; write "R:" into video memory
    mov dword [0xb8008], 0x4f204f20 ; write "  " into video memory
    mov byte  [0xb800a], bl         ; replace "  " with " {bl}" where bl is the error code in the bl register
    hlt

was_loaded_by_multiboot:
    cmp eax, 0x36D76289             ; check eax against multiboot magic number
    jne .not_loaded_by_multiboot    ; if the check failed, throw error
    ret
.not_loaded_by_multiboot:
    mov bl, "M"                     ; move ascii error code into bl register
    jmp throw_error                 ; throw error

verify_cpuid:
    pushfd                          ; push flags into onto the stack
    pop eax                         ; pop flags into EAX
    mov ecx, eax                    ; make copy of EAX (flags) into ECX
    xor eax, 1 << 21                ; flip bit 21 of the flags in EAX (CpuId bit)
    push eax                        ; push eax onto stack
    popfd                           ; pop flags back into flags register
    pushfd                          ; push flags back into the stack
    pop eax                         ; move flags into EAX register
    push ecx                        ; push original copy of the flags to the stack
    popfd                           ; restore flags to original state
    cmp eax, ecx                    ; compare eax (attempted flip) against ecx (original)
    je .no_cpuid_available          ; if eax == exc then no cpuid available, throw error
    ret
.no_cpuid_available:                ; same as .not_loaded_by_multiboot error and any similar errors
    mov bl, "C"                     ; if you need to know how this error works, check .not_loaded_by_multiboot
    jmp throw_error

section .bss
stack_bottom:
    resb 4096 * 4                   ; reserve 16 Kilobyte of stack memory
stack_top:
