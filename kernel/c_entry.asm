[bits 32]

extern kernel_main

global _start
_start:
    ; Set up stack
    mov esp, 0x90000
    
    ; Call C function
    call kernel_main
    
    ; If C returns, halt
halt:
    hlt
    jmp halt
