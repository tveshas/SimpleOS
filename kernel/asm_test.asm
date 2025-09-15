[bits 32]
[org 0x1000]

; Fill screen with yellow (color 14)
mov edi, 0xA0000
mov ecx, 64000
mov al, 14
rep stosb

; Put blue square in corner
mov edi, 0xA0000
mov ecx, 1000
mov al, 1
rep stosb

; Infinite halt
halt:
    hlt
    jmp halt
