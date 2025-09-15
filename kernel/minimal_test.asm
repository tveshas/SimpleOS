[bits 32]
[org 0x1000]

; Fill screen with yellow
mov edi, 0xA0000
mov ecx, 64000
mov al, 14
rep stosb

; Put red square in top-left
mov edi, 0xA0000
mov ecx, 2000
mov al, 4
rep stosb

; Infinite halt
halt:
    hlt
    jmp halt
