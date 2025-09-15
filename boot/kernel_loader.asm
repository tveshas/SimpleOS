[org 0x7c00]
[bits 16]

mov bp, 0x9000
mov sp, bp

mov si, loading_msg
call print_string

; Set VGA graphics mode
mov ah, 0x00
mov al, 0x13
int 0x10

; Load kernel
mov bx, 0x1000
mov dh, 2
mov dl, 0x00
call disk_load

mov si, loaded_msg
call print_string

; Wait so you can see the message
mov ecx, 100000000
wait_loop:
    dec ecx
    jnz wait_loop

; Switch to 32-bit mode
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
    
    ; Jump to kernel
    jmp 0x1000

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

disk_load:
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    int 0x13
    ret

loading_msg db 'Loading kernel...', 13, 10, 0
loaded_msg db 'Kernel loaded!', 13, 10, 0

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
