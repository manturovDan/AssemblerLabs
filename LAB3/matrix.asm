	.model	small
	.stack	100h
	.486
	.data
n	db	5
m	db	6
nzcount	db	3
chain	dw	1,2,300, 4,4,11, 5,2,-7
matrix	dw	30 dup (?)
	.code
Start:	mov	ax, @data
	mov	ds, ax
	mov	di, ax

	xor ax, ax
	mov al, n
	mul m ; full count of elements
	shl ax, 1
	xor bx,	bx 
	xor cx, cx
	mov cx, ax
	
	xor ax, ax
	xor si, si
	LP:	cmp	bx, cx
	jge CD
		mov si,	offset matrix
		mov [si + bx], ax
		inc	bx
		inc	bx
		jmp LP

	CD:	xor ax, ax
	mov	al, nzcount 
	mov	bl, 3
	mul	al ;count of nz elements
	mov	cx, ax ; end of triades array
	shl cx, 1

	xor	bx, bx
	L: cmp bx, cx
	jge	CE
		mov	si, offset chain
		mov ax, [si + bx] ;number of row
		push cx
		inc bx
		inc bx
		mov cx, [si + bx] ;number of column
		inc	bx
		inc bx
		mov	dx, [si + bx] ;value
		inc bx
		inc bx

		mov si, offset matrix
		mul	n
		add	ax, cx
		push bx
		mov bx, ax
		shl	bx, 1
		mov [si + bx], dx

		pop bx
		pop cx
		jmp	L



CE:	mov	ax, 4C00h
	int	21h
end Start
