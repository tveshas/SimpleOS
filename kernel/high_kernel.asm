[bits 32]

; Entry point for kernel loaded at 0x10000
_start:
    ; Set stack
    mov esp, 0x90000
    
    ; Fill screen with cyan
    mov edi, 0xA0000
    mov ecx, 64000
    mov al, 3
    rep stosb
    
    ; Orange rectangle to prove this is the high-memory kernel
    mov edi, 0xA0000
    add edi, 80*320 + 120
    mov edx, 60
rect_loop:
    mov ecx, 100
    push edi
row_loop:
    mov byte [edi], 12  ; Orange
    inc edi
    loop row_loop
    pop edi
    add edi, 320
    dec edx
    jnz rect_loop

halt:
    hlt
    jmp halt
