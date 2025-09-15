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

; Store boot drive (BIOS puts it in DL when loading us)
mov [boot_drive], dl

; Try to load kernel - use the drive BIOS loaded us from
mov bx, 0x1000      ; Load to 0x1000
mov ah, 0x02        ; Read sectors
mov al, 2           ; Read 2 sectors
mov ch, 0           ; Cylinder 0
mov cl, 2           ; Start from sector 2
mov dh, 0           ; Head 0
mov dl, [boot_drive] ; Use boot drive
int 0x13

; Check if read succeeded
jc disk_failed

; Disk read succeeded - change to green
mov ax, 0xA000
mov es, ax
xor di, di
mov cx, 32000
mov ax, 0x0202
rep stosw

; Small delay so you can see green
mov ecx, 50000000
delay:
    dec ecx
    jnz delay

; Switch to 32-bit and jump to kernel
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
    
    ; Jump to loaded kernel
    jmp 0x1000

disk_failed:
; Disk failed - change to red
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
