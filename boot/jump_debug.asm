[org 0x7c00]
[bits 16]

mov bp, 0x9000
mov sp, bp

; Set VGA mode
mov ax, 0x0013
int 0x10

; Blue screen initially
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0101
rep stosw

; Store boot drive
mov [boot_drive], dl

; Load kernel
mov bx, 0x1000
mov ah, 0x02
mov al, 2
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, [boot_drive]
int 0x13
jc disk_failed

; Green = disk read OK
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 16000
mov ax, 0x0202
rep stosw

; Before switching modes, wait
mov ecx, 100000000
wait1:
    dec ecx
    jnz wait1

; Try 32-bit switch
cli
lgdt [gdt_descriptor]
mov eax, cr0
or al, 1
mov cr0, eax

; Jump to 32-bit code
jmp CODE_SEG:mode32

[bits 32]
mode32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    
    ; If we get here, fill with yellow
    mov edi, 0xA0000
    mov ecx, 32000
    mov eax, 0x0E0E0E0E
    rep stosd
    
    ; Wait
    mov ecx, 100000000
wait2:
    dec ecx
    jnz wait2
    
    ; Now try to jump to kernel
    jmp 0x1000
    
    ; If kernel returns, fill with red
    mov edi, 0xA0000
    mov ecx, 32000
    mov eax, 0x04040404
    rep stosd

halt:
    hlt
    jmp halt

disk_failed:
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0404
rep stosw
jmp $

boot_drive db 0

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
