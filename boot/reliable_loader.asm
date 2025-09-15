[org 0x7c00]
[bits 16]

; Set up stack
mov bp, 0x9000
mov sp, bp

; Set VGA mode 13h
mov ax, 0x0013
int 0x10

; Store boot drive
mov [boot_drive], dl

; Load kernel to higher address (0x10000 = 64KB)
mov ax, 0x1000      ; ES = 0x1000 (segment)
mov es, ax
mov bx, 0x0000      ; BX = 0x0000 (offset)
                    ; Physical address = 0x10000

; Read kernel from disk
mov ah, 0x02        ; Read function
mov al, 4           ; Read 4 sectors
mov ch, 0           ; Cylinder 0
mov cl, 2           ; Start sector 2  
mov dh, 0           ; Head 0
mov dl, [boot_drive] ; Drive
int 0x13
jc disk_error

; Success - show blue screen briefly
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0101
rep stosw

; Wait
mov ecx, 50000000
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
    
    ; Jump to kernel at 0x10000
    jmp 0x10000

disk_error:
; Red screen for error
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
