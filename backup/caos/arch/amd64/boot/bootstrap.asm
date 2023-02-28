global bootstrap

section .text
bits 32
bootstrap:
    mov esp, stack_top              ; move location of stack_top into stack pointer

    call was_loaded_by_multiboot    ; verify that the kernel was booted by a multiboot2 bootloader
    call verify_cpuid               ; verify that the CPU supports CPUID
    call does_cpu_support_long_mode ; verify that the CPU supports Long Mode for 64-bit execution

;    call setup_page_tables          ; setup virtual memory paging
;    call enable_paging              ; activate paging

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

does_cpu_support_long_mode:
    mov eax, 0x80000000             ; move magic number into eax
    cpuid                           ; check if extended processor info is available
    cmp eax, 0x80000001             ; if eax != magic number +1 then no extended processor info
    jb .no_extended_processor_info  ; throw error about extended processor info

    mov eax, 0x80000001             ; move magic number +1 (extended processor info available) into EAX
    cpuid                           ; query for the LM (Long Mode) bit
    test edx, 1 << 29               ; check if LM is set
    jz .no_long_mode_support        ; throw error if LM bit was not set

    ret
.no_extended_processor_info:
    mov bl, "E"
    jmp throw_error
.no_long_mode_support:
    mov bl, "L"
    jmp throw_error

;setup_page_tables:
;    mov eax, page_table_l3          ; move address of level3 page table into eax
;    or eax, 0b11                    ; set present and writable flags
;    mov [page_table_level4], eax    ; place level3 table into index of level4 table

;    mov eax, page_table_l2          ; move address of level2 page table into eax
;    or eax, 0b11                    ; set huge page, present and writable flags
;    mov [page_table_level3], eax    ; place level2 table into index of level3 table



;enable_paging:


section .bss
;align 4096
;page_table_level4:
;    resb 4096
;page_table_level3:
;    resb 4096
;page_table_level2:
;    resb 4096

stack_bottom:
    resb 4096 * 4                   ; reserve 16 Kilobyte of stack memory
stack_top:
