	.model medium
	.stack 100h
	public	start
    extrn	items:byte
    extrn	fn:byte
    extrn	ibuf:byte
    extrn	obuf:byte
    extrn	msg:byte
    extrn	frm:byte
    extrn	qws:byte
    extrn	inp:byte
    extrn	bye:byte
    extrn	input:far
    extrn	inputline:far
    extrn	readfile:far
    extrn	output:far
    extrn	writefile:far
    extrn	menu:far
    extrn	algorithm:far
	.data
string db 'AsSe-MB Ly', 0
cons db 'BCDFGHJKLMNPRSTVWXZbcdfghjklmnprstvwxz', 0
consstring db 100 dup(?)
count   dw  0
    .code
Start: mov ax, @data
    mov ds, ax
    mov es, ax
    cld
m1:

    lea si, string
    lea di, cons
    xor bx, bx
    xor cx, cx
    xor ax, ax
    mov dx, offset consstring
mi1: lodsb
    cmp al, 0
    je mi5
    mov bl, al
    push si
    mov si, di

    mi2: lodsb
        cmp al, 0
        je mi3
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
        jmp mi3

        mi3: pop si
            jmp mi1
mi5:
       mov dx, count
       dec dx
       srt: xor bx, bx
            xor di, di
            mov si, offset consstring
            nc:     mov al, [si + bx]
                    mov cl, [si + bx + 1]
                    cmp al, cl
                    jnc ns

                    mov [si + bx], cl
                    mov [si + bx + 1], al
                    mov di, 1

                    ns: inc bx

                        xor ax, ax
                        cmp ax, di
                        jne  all

                        cmp bx, dx
                        je  srt
                        jmp nc
    all:
    mov ax, 4C00h
    int 21h
    end Start

sort proc
