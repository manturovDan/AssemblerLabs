	.model small
	.stack 100h
	.data
string db 'hello     world   hihihi!!!aaaa    loLol --432ffff ruru      coRonavirus ', 0
cons db 'BCDFGHJKLMNPRSTVWXZbcdfghjklmnprstvwxz', 0
consstring db 100 dup(?)
    .code
Start: mov ax, @data
    mov ds, ax
    mov es, ax

    lea si, string
    lea di, cons
    cld
    xor bx, bx
    xor cx, cx
    xor ax, ax
    mov dx, offset consstring
m1: lodsb
    cmp al, 0
    je m5
    mov bl, al
    push si
    mov si, di

    m2: lodsb
        cmp al, 0
        je m3
        cmp al, bl
        jne m2
        push si
        mov si, dx
        mov [si], al
        pop si
        inc dx
        jmp m3

        m3: pop si
            jmp m1
m5: int 21h
    end Start