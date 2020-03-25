	.model	small
	.stack	100h
	.486
	.data
n	db	5
m	db	6
chain	dw	0,0,300, 4,4,11, 5,2,-7
	.code
Start:	mov	ax, @data
	mov	ds, ax

	cmp	n, 0
	jle	er
	cmp	m, 0
	jle	er
	cld
	
	push	0
	push	0
	push	0
	push	0

	mov	ax, 4C00h
ex:	int	21h
er:	mov	ax, 4C01h
	jmp	ex
	end
end Start
