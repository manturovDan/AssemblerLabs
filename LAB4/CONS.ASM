	.model small
	.stack 100h
	.data
string db 'Lorem ipsum dolor sit amet, consectetur adipiscing elit', 0
cons db 'BCDFGHJKLMNPRSTVWXZbcdfghjklmnprstvwxz', 0
consstring db 100 dup(?)
count   dw  0
    .code
Start: mov ax, @data
    mov ds, ax
    mov es, ax

    lea si, string
    lea di, cons
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
        mov si, count
        inc si
        mov count, si
        inc dx
        pop si
        jmp m3

        m3: pop si
            jmp m1
m5:
       mov dx, count
       dec dx
       srt: xor bx, bx
            mov si, offset consstring
            nc:     mov al, [si + bx]
                    mov cl, [si + bx + 1]
                    cmp al, cl
                    jnc ns

                    mov [si + bx], cl
                    mov [si + bx + 1], al

                    ns:
                        cmp bx, dx
                        je cond
                        inc bx
                        jmp nc

                        cond:   dec dx
                                jz all
                                jmp srt
    all:
    mov ax, 4C00h
    int 21h
    end Start

sort proc
