[bits 32]

; This will be loaded at 0x1000
global _start
_start:
    ; Set up stack first
    mov esp, 0x90000
    
    ; Fill screen with cyan (different color to prove separate kernel works)
    mov edi, 0xA0000
    mov ecx, 64000
    mov al, 3          ; Cyan
    rep stosb
    
    ; Yellow rectangle to prove it's the separate kernel
    mov edi, 0xA0000
    add edi, 100*320 + 200
    mov edx, 50
rect_loop:
    mov ecx, 80
    push edi
row_loop:
    mov byte [edi], 14  ; Yellow
    inc edi
    loop row_loop
    pop edi
    add edi, 320
    dec edx
    jnz rect_loop
    
halt:
    hlt
    jmp halt
