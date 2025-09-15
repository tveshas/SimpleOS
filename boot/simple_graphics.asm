[org 0x7c00]
[bits 16]

mov bp, 0x9000
mov sp, bp

; Brief hello message
mov si, hello_msg
call print_string

; Set VGA graphics mode
mov ah, 0x00
mov al, 0x13
int 0x10

; Switch to 32-bit protected mode
cli
lgdt [gdt_descriptor]
mov eax, cr0
or al, 1
mov cr0, eax
jmp CODE_SEG:protected_mode

[bits 32]
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    
    ; Clear screen to blue
    mov edi, 0xA0000
    mov ecx, 64000
    mov al, 1
    rep stosb
    
    ; Draw red rectangle (50,50) 100x100
    mov edi, 0xA0000
    add edi, 50*320 + 50
    mov edx, 100
red_rect:
    mov ecx, 100
    push edi
red_row:
    mov byte [edi], 4
    inc edi
    loop red_row
    pop edi
    add edi, 320
    dec edx
    jnz red_rect
    
    ; Draw green rectangle (200,50) 80x80
    mov edi, 0xA0000
    add edi, 50*320 + 200
    mov edx, 80
green_rect:
    mov ecx, 80
    push edi
green_row:
    mov byte [edi], 2
    inc edi
    loop green_row
    pop edi
    add edi, 320
    dec edx
    jnz green_rect
    
    ; Halt
halt:
    hlt
    jmp halt

[bits 16]
print_string:
    lodsb
    cmp al, 0
    je print_done
    mov ah, 0x0e
    int 0x10
    jmp print_string
print_done:
    ret

hello_msg db 'SimpleOS Graphics', 13, 10, 0

; Minimal GDT
gdt_start:
    dd 0, 0
gdt_code:
    dw 0xFFFF, 0
    db 0, 10011010b, 11001111b, 0
gdt_data:
    dw 0xFFFF, 0
    db 0, 10010010b, 11001111b, 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510-($-$$) db 0
dw 0xaa55
