    .model medium
public	inputline, input, readfile, output, writefile, menu, algorithm
extrn	start : far
    .data
        cons db 'BCDFGHJKLMNPRSTVWXZbcdfghjklmnprstvwxz', 13, 10, 0
        consstring db 100 dup(?)
    .code
    inputline proc
        locals @@
        @@buffer equ [bp+6]
        push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov ah, 3fh
    	xor bx, bx
    	mov cx, 80
    	mov dx, @@buffer
    	int 21h
    	jc @@ex
    	cmp ax, 80
    	jne @@m
    	stc
    	jmp short @@ex
    @@m: mov di, @@buffer
    	dec ax
    	dec ax
    	add di, ax
    	xor al, al
    	stosb
    @@ex:	pop di
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp
    	ret
    	endp

    input	proc
    	locals @@
    @@buffer	equ [bp+6]
    	push bp
    	mov bp, sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	xor bx,bx
    	mov cx, 4095
    	mov dx, @@buffer
    @@m1:	mov ah, 3fh
    	int 21h
    	jc @@ex
    	cmp ax,2
    	je @@m2
    	sub cx,ax
    	jcxz @@m2
    	add dx,ax
    	jmp @@m1
    @@m2:	mov di,@@buffer
    	add di,4095
    	sub di,cx
    	xor al,al
    	stosb
    @@ex:	pop di
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp
    	ret
    	endp
    output	proc
    	locals @@
    @@buffer	equ [bp+6]
    	push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov di, @@buffer
    	xor al, al
    	mov cx, 0ffffh
    	repne scasb
    	neg cx
    	dec cx
    	dec cx
    	jcxz @@ex
    	cmp cx, 4095
    	jbe @@m;
    	mov cx,4095
    @@m:	mov ah, 40h
    	xor bx,bx
    	inc bx
    	mov dx,@@buffer
    	int 21h
    @@ex:	pop di
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp
    	ret
    	endp

    readfile	proc
    	locals @@
    @@buffer	equ [bp+6]
    @@filnam	equ [bp+8]
    	push bp
    	mov bp, sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov ax, 3d00h
    	mov dx, @@filnam
    	int 21h
    	jc @@ex
    	mov bx,ax
    	mov cx, 4095
    	mov dx,@@buffer
    @@m1:	mov ah,3fh
    	int 21h
    	jc @@er
    	or ax, ax
    	je @@m2
    	sub cx, ax
    	jcxz @@m2
    	add dx,ax
    	jmp @@m1
    @@m2:	mov di, @@buffer
    	add di, 4095
    	sub di, cx
    	xor al, al
    	stosb
    	mov ah, 3eh
    	int 21h
    @@ex:	pop di
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp
    	ret
    @@er:	mov ah,3eh
    	int 21h
    	stc
    	jmp @@ex
    	endp
    writefile proc
    	locals @@
    @@filnam	equ [bp+8]
    @@buffer	equ [bp+6]
    	push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov ah, 3ch
    	xor cx, cx
    	mov dx, @@filnam
    	int 21h
    	jc @@ex
    	mov bx, ax
    	mov di, @@buffer
    	xor al, al
    	mov cx, 0ffffh
    	repne scasb
    	neg cx
    	dec cx
    	dec cx
    	jcxz @@ex1
    	cmp cx, 4095
    	jbe @@m
    	mov cx, 4095
    @@m:	mov ah, 40h
    	mov dx,@@buffer
    	int 21h
    	jc @@er
    @@ex1:	mov ah, 3eh
    	int 21h
    @@ex:	pop di
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp
    	ret
    @@er:	mov ah,3eh
    	int 21h
    	stc
    	jmp @@ex
    	endp

    menu	proc
        locals @@
        @@ax		equ [bp-82]
        @@buffer	equ [bp-80]
        @@items	equ	[bp+6]
        push bp
        mov bp,sp
        sub sp,80

        push ax
    @@m:	push @@items
        call output
        pop ax
        jc @@ex
        push ds
        push es
        push ss
        push ss
        pop ds
        pop es
        mov ax, bp
        sub ax, 80
        push ax
        call inputline
        pop ax
        pop es
        pop ds
        jc @@ex
        mov al, @@buffer
        cbw
        sub ax, '0'
        cmp ax, 0
        jl @@m
        cmp ax, @@ax
        jg @@m
        clc
    @@ex:	mov sp,bp
        pop bp
        ret
        endp

    algorithm	proc
    	locals @@
    @@ibuf	equ [bp+6]; буфер с исходными строками. equ - аналогично сишному define
    @@obuf	equ [bp+8]; буфер, куда надо записать ответ
    	push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push si
    	push di

    	xor ax, ax
    	xor bx, bx
    	xor cx, cx
    	xor dx, dx
    	xor si, si
    	xor di, di

    	mov cx,0ffffh
    	mov di,@@ibuf
    	xor al,al
    	repne scasb
    	neg cx
    	dec cx
    	dec cx
    	jcxz @@ex
    	cmp cx,4095
    	jbe @@m1
    	stc
    	jmp short @@ex
    @@m1:	mov si, @@ibuf
            mov di, @@obuf
    	mov al,10
    	xor bx,bx
    	push di
    @@m2: inc bx
        mov di, offset consstring
        xor dx, dx
        @@m5:	lodsb; считываем символ
                dec cx
                push cx
                mov cl, al
                push si
                mov si, offset cons

                @@mc:   lodsb
                        cmp al, 0
                        je @@me
                        cmp al, cl
                        jne @@mc
                        mov [di], al
                        inc di
                        inc dx
                @@me: pop si

                pop cx
                cmp al,10
                jne @@m5
    	jcxz @@ex; могли достигнуть конца буфера
        jmp @@m5b

        @@m5b: push si
            push dx
            push cx
            push bx
            cmp dx, 3
            jle @@alls
            sub dx, 3
            @@srt:
                xor bx, bx
                mov si, offset consstring
                @@nc:   mov al, [si + bx]
                        mov cl, [si + bx + 1]
                        cmp al, cl
                        jnc @@ns

                        mov [si + bx], cl
                        mov [si + bx + 1], al

                        @@ns: cmp bx, dx
                            je @@cond
                            inc bx
                            jmp @@nc

                            @@cond: dec dx
                                    jz @@alls
                                    jmp @@srt
            @@alls: pop bx
                    pop cx
                    pop dx
                    pop si

        @@m5s: pop di
            push si
            mov si, offset consstring
            @@it:
            lodsb
            stosb
            dec dx
            jnz @@it

            @@all:
            pop si
            push di
            jmp @@m2

    @@er: shl bx,1
    	add sp,bx
    	stc
    @@ex: clc
        pop di
        pop di
    	pop si
    	pop dx
    	pop cx
    	pop bx
    	pop ax
    	pop bp

    	ret
    	endp
    	end start