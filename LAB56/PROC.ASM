    .model medium
public	inputline,input,readfile,output,writefile,menu,algorithm
extrn	start:far
    .code
    inputline proc
        locals @@
        @@buffer edu[db+6];
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
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	xor bx,bx
    	mov cx,4095
    	mov dx,@@buffer
    @@m1:	mov ah,3fh
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
    	mov di,@@buffer
    	xor al,al
    	mov cx,0ffffh
    	repne scasb
    	neg cx
    	dec cx
    	dec cx
    	jcxz @@ex; если нул байт хранится сразу - буфер пустой, выводить нечего
    	cmp cx,4095; не оказался ли буфер случайно больше - например, не закрыт нулём, защита от дурака
    	jbe @@m;
    	mov cx,4095; принудительное ограничение буфера
    @@m:	mov ah,40h; запись в файл
    	xor bx,bx
    	inc bx; 1 - вывод на экран
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
    @@buffer	equ [bp+6]; процедура принимает два параметра
    @@filnam	equ [bp+8]
    	push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov ax,3d00h; открыть файл на чтение
    	mov dx,@@filnam
    	int 21h
    	jc @@ex; неудача - файл не найден.
    	mov bx,ax; в ах будет дескриптор. Его потом надо будет заносить в bx.
    	mov cx,4095; формируем информацию для чтения - лимит
    	mov dx,@@buffer; и буфер - куда читать
    @@m1:	mov ah,3fh; чтение из файла
    	int 21h
    	jc @@er; неудача - но тут ещё надо файл закрыть.
    	or ax,ax; файл пустой или достигли конца файла
    	je @@m2
    	sub cx,ax; могли прочитать не всё
    	jcxz @@m2; всё прочитали
    	add dx,ax
    	jmp @@m1; повторяем чтение
    @@m2:	mov di,@@buffer; в конец буфера надо записать нулевой байт.
    	add di,4095
    	sub di,cx; сколько мы прочитали. di будет указывать на конец прочитанной информации.
    	xor al,al
    	stosb; закрываем нулем.
    	mov ah,3eh; закрываем файл
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
    	stc; сообщаем внешней функции об ошибке
    	jmp @@ex
    	endp
    writefile proc
    	locals @@
    @@filnam	equ [bp+8]; куда писать
    @@buffer	equ [bp+6]; что писать
    	push bp
    	mov bp,sp
    	push ax
    	push bx
    	push cx
    	push dx
    	push di
    	mov ah,3ch; создать файл или сделать его пустым.
    	xor cx,cx; никаких атрибутов
    	mov dx,@@filnam
    	int 21h
    	jc @@ex; ошибка
    	mov bx,ax; файловый дескриптор переносим в bx
    	mov di,@@buffer; нужно вычислить длину информации, заносимой в файл.
    	xor al,al; ищем нулевой байт
    	mov cx,0ffffh; 0 сначала, чтобы не было ошибки - в начале дб допустимый символ 0-9
    	repne scasb
    	neg cx
    	dec cx
    	dec cx
    	jcxz @@ex1; ничего не надо писать
    	cmp cx,4095
    	jbe @@m
    	mov cx,4095; слишком много писать
    @@m:	mov ah,40h
    	mov dx,@@buffer
    	int 21h
    	jc @@er
    @@ex1:	mov ah,3eh
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