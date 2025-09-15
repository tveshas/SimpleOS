[bits 32]

; Don't use ORG - the linker handles addressing
global _start
_start:
    ; Set up stack
    mov esp, 0x90000
    
    ; Fill screen with purple (to prove kernel works)
    mov edi, 0xA0000
    mov ecx, 64000
    mov al, 5          ; Purple
    rep stosb
    
    ; Put white rectangle in center
    mov edi, 0xA0000
    add edi, 50*320 + 100  ; Position (100, 50)
    mov edx, 100           ; Height
draw_rect:
    mov ecx, 120           ; Width
    push edi
draw_row:
    mov byte [edi], 15     ; White
    inc edi
    loop draw_row
    pop edi
    add edi, 320
    dec edx
    jnz draw_rect
    
    ; Infinite halt
halt:
    hlt
    jmp halt
