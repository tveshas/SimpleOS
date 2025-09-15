[org 0x7c00]
[bits 16]

mov bp, 0x9000
mov sp, bp

; Print message
mov si, msg
call print_string

; Set VGA mode
mov ah, 0x00
mov al, 0x13
int 0x10

; Fill screen with green directly in bootloader
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0202  ; Green pixels
rep stosw

; Infinite loop - stay here
jmp $

print_string:
    lodsb
    cmp al, 0
    je print_done
    mov ah, 0x0e
    int 0x10
    jmp print_string
print_done:
    ret

msg db 'Testing bootloader graphics...', 13, 10, 0

times 510-($-$$) db 0
dw 0xaa55
