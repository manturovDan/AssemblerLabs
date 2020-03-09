	.model small
	.stack 100h
	.486
	.data
a	db	40
b	db	100
c	db	20
d	db	5
e	db	7
	.code
Start:	mov	ax, @data
	mov	ds, ax
	
	mov	al, d
	mov	cl, c
	shl	cl, 1
	mul	al
	neg	ax

	xor	ch, ch
	add	cx, ax

	mov	al, a
	xor	ah, ah
	mul	cx
	shr	ax, 2

	xor ebx, ebx
	mov bl, e
	div bl
	xor ah, ah
	mul cx
	div bl

	push eax

	xor eax, eax
	mov al, a
	mul al
	mov cl, b
	xor ch, ch
	add ax, cx
	
	xor ecx, ecx
	mov cx, ax
	mov dx, 5h
	
	mul dx

	shr eax, 2
	div ebx
	mul ecx
	div ebx
	mul ecx

	pop ebx
	add eax, ebx
	
	mov ax, 4C00h
	int 21h
end Start
