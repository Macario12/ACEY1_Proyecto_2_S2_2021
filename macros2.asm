close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al, al
	int 21h
endm

;[MACARIO-201905837]
ModoVideo macro ; Modo video para graficar
	mov ah, 00h
	mov al, 13h
	int 10h
	mov ax,0A000h
	mov ds,ax
endm

ModoTexto macro ;Modo texto
	mov ah,00h
	mov al, 03h
	int 10h
endm

posicionarCursor macro x,y
	mov ah,02h
	mov dh,x
	mov dl,y
	mov bh,0
	int 10h
endm

imprimirVideo macro caracter, color
	mov ah, 09h
	mov al, caracter ;al guarda el valor que vamos a escribir
	mov bh, 0
	mov bl, color ; valor binario rojo
	mov cx,1
	int 10h
endm

pintarMargen macro color
LOCAL primera, segunda, tercera, cuarta,ejey,ejex

mov dl, color

mov di, 6410
primera: 
	mov [di],dl
	inc di
	cmp di,6709
	jne primera
	
mov di, 57610
segunda:
	mov [di],dl
	inc di
	cmp di, 57909
	jne segunda

mov di,6410
tercera:
	mov [di],dl
	add di,320
	cmp di, 57610
	jne tercera
	
mov di,6709
cuarta:
	mov [di],dl
	add di,320
	cmp di,57909
	jne cuarta

mov di,32010
ejex:
	mov [di],dl
	inc di
	cmp di,32309
	jne ejex
	
mov di, 6560	
ejey:
	mov [di], dl
	add di,320
	cmp di,57760
	jne ejey
endm