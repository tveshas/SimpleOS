[bits 32]

; Simple kernel that directly writes to VGA memory
start:
    ; Set up stack
    mov esp, 0x90000
    
    ; Write "KERNEL WORKS!" to screen in text mode
    mov edi, 0xb8000
    mov esi, kernel_message
    mov ecx, kernel_message_len
    mov ah, 0x0F  ; Bright white on black
    
write_loop:
    lodsb         ; Load character from ESI
    mov [edi], al ; Write character
    inc edi
    mov [edi], ah ; Write attribute
    inc edi
    loop write_loop
    
    ; Wait a moment
    mov ecx, 50000000
wait_loop:
    nop
    dec ecx
    jnz wait_loop
    
    ; Now try to switch to VGA graphics mode
    ; We can't use BIOS interrupts in 32-bit mode, so let's try direct VGA
    
    ; Clear VGA graphics memory to blue (color 1)
    mov edi, 0xA0000    ; VGA memory address
    mov ecx, 64000      ; 320x200 pixels
    mov al, 1           ; Blue color
    rep stosb           ; Fill memory with blue
    
    ; Draw a red rectangle
    mov edi, 0xA0000
    add edi, 50*320 + 50  ; Position (50, 50)
    mov ecx, 100          ; Width
    mov edx, 100          ; Height
    
draw_rect:
    push ecx
    push edi
rect_row:
    mov al, 4             ; Red color
    stosb
    loop rect_row
    pop edi
    add edi, 320          ; Next row
    pop ecx
    dec edx
    jnz draw_rect
    
    ; Infinite loop
halt:
    hlt
    jmp halt

kernel_message db 'KERNEL WORKS!'
kernel_message_len equ $ - kernel_message
