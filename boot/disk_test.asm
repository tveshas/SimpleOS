[org 0x7c00]
[bits 16]

; Set VGA mode
mov ax, 0x0013
int 0x10

; Fill screen with blue (before loading)
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0101  ; Blue pixels
rep stosw

; Try to load from disk
mov bx, 0x1000
mov ah, 0x02
mov al, 2
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 0
int 0x13

; If load successful, change to red
jnc load_ok
; If failed, stay blue
jmp $

load_ok:
; Fill screen with red
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0404  ; Red pixels
rep stosw

jmp $

times 510-($-$$) db 0
dw 0xaa55
