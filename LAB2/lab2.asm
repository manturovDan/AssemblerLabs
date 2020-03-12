	.model small
	.stack 100h
	.486
	.data
;a	dw	1011010110111000b
a	dw	0110011001100110b
	.code
Start:	mov	ax, @data
	mov	ds, ax

	mov	ax, a

	xor	ebx, ebx
	xor	edx, edx
	mov	bx, 1111000000000000b
	mov	dx, 0110000000000000b

	mov	ecx, 13
	xor	di, di

L:	mov	si, bx
	and	si, ax
	cmp	dx, si
	jne	C
	inc	di
C:	shr	bx, 1
	shr	dx, 1
loop	L

	mov	ax, 4C00h
	int	21h
end Start
