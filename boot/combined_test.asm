[org 0x7c00]
[bits 16]

mov bp, 0x9000
mov sp, bp

; Set VGA mode
mov ax, 0x0013
int 0x10

; Skip the kernel loading entirely - put kernel code right here
cli
lgdt [gdt_descriptor]
mov eax, cr0
or al, 1
mov cr0, eax
jmp CODE_SEG:mode32

[bits 32]
mode32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    
    ; Kernel code directly here (not at 0x1000)
    ; Fill screen with purple
    mov edi, 0xA0000
    mov ecx, 64000
    mov al, 5
    rep stosb
    
    ; White rectangle
    mov edi, 0xA0000
    add edi, 50*320 + 100
    mov edx, 100
draw_rect:
    mov ecx, 120
    push edi
draw_row:
    mov byte [edi], 15
    inc edi
    loop draw_row
    pop edi
    add edi, 320
    dec edx
    jnz draw_rect

halt:
    hlt
    jmp halt

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
