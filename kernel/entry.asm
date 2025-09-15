[bits 32]

global _start
extern kernel_main

_start:
    ; Set up stack pointer
    mov esp, 0x90000
    
    ; Write 'X' to screen to show we got to assembly
    mov byte [0xb8000], 'X'
    mov byte [0xb8001], 0x07
    
    ; Small delay so you can see the X
    mov ecx, 10000000
delay_loop:
    dec ecx
    jnz delay_loop
    
    ; Now call C kernel
    call kernel_main
    
    ; If we get here, something went wrong
    mov byte [0xb8002], '!'
    mov byte [0xb8003], 0x07
    
halt:
    hlt
    jmp halt