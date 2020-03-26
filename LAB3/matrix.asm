	.model	small
	.stack	100h
	.486
	.data
n	db	5
m	db	6
nzcount	db	3
chain	dw	0,0,300, 4,4,11, 5,2,-7
matrix	dw	30 dup (?)
	.code
Start:	mov	ax, @data
	mov	ds, ax
	mov	si, offset matrix
	xor	ax, ax
	xor	bx, bx
	mov	al, n
	mov	bl, m
	mul	bx
	mov	bx, 0
	mov	di, ax ;count of elements

	;cmp	n, 0
	;jle	er
	;cmp	m, 0
	;jle	er
	cld
	
	xor	ecx, ecx
	mov	cl, n ;rows
	
	LROWS:
		mov	esp, ecx
		xor	ecx, ecx
		
		mov	cl, m ;cols
		LCOLS:
			
		loop LCOLS
		mov ecx, esp
		
	loop LROWS

	mov	ax, 4C00h
	int	21h
;;er:	mov	ax, 4C01h
;	jmp	ex
;	end
end Start
