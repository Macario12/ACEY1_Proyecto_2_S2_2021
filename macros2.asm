;[KATERINE-201908321]
close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al, al
	int 21h
endm

cargar macro 
	limpiar bufferentrada, SIZEOF bufferentrada,24h ; 24h = $
	obtenerRuta bufferentrada
	abrir bufferentrada,handlerentrada
	limpiar bufferInformacion, SIZEOF bufferInformacion,24h
	leer handlerentrada, bufferInformacion, SIZEOF bufferInformacion
	cerrar handlerentrada
	print bufferInformacion
	print msgCargo
endm 

separarFuncion macro arreglo
LOCAL Mientras, Fin, AsignarFin
	xor si, si 
	xor al, al
	xor di, di
	mov inicioFunciones[di], 0
		Mientras:  						;While(arreglo[si]!=$)
			cmp al, 24h					; 24h es $
			je Fin
			mov al, arreglo[si]			;arreglo[si] = al
			cmp al, 59					;verificamos que el caracter sea diferente a ;
			je AsignarFin
			inc si
			jmp Mientras
			
		AsignarFin:
			xor bx, bx
			mov bx, si
			dec bx						;para que guarde la posicion antes del puntoComa
			mov finFunciones[di], bl	
			inc si 						;si = si + 1
			mov al, arreglo[si]
			cmp al, 24h					; 24h es $
			je Fin
			inc si						;si = si + 1
			inc di
			xor bx, bx
			mov bx, si 
			mov inicioFunciones[di], bl
			jmp Mientras
			
		Fin:
		dec di
		IntToString di, ultimoID
endm

obtenerFuncion macro id, arreglo, funciones
LOCAL Mientras, Fin
	xor si, si
	xor di, di

	mov di, id

	xor bx, bx
	mov bl, inicioFunciones[di] 			;bl tiene la posicion inicial
	mov si, bx							;si tiene la posicion inicial

	xor bx, bx
	mov bl, finFunciones[di]

	xor di, di	

	inc bx 
	xor ax, ax						;si posocion inicial, bx posicion final
	Mientras:
		cmp si, bx
		je Fin
		mov al, funciones[si]
		mov arreglo[di], al
		inc si
		inc di
		jmp Mientras
	Fin:
endm

seleccionarFuncion macro msg, numero
	print msg
	limpiar numero, SIZEOF numero,24h
	obtenerTexto numero
	StringToInt numero ;ax tiene el valor numerico del arreglo
	dec ax
	limpiar funcion, SIZEOF funcion,24h 
	obtenerFuncion ax, funcion, bufferInformacion
	print funcion
endm

guardarFuncionUnica macro
LOCAL Mientras, Fin, AsignarFin
	print msgFuncion
	obtenerTexto funcionUnica
	print funcionUnica
	xor al, al
	xor ax, ax
	xor di, di
	xor bx, bx							;aca esta 
	StringToInt ultimoID 				;ax tiene el valor numerico del arreglo
	mov di, ax
	mov bl, finFunciones[di] 			;bl tiene la posicion inicial
	mov si, bx
	inc si
	inc si
	xor bx, bx
	mov bx, si
	inc di								;Para escribir en la siguiente posicion
	mov inicioFunciones[di], bl		
	
	mov si, bx	
	xor di, di
	Mientras:
		mov al, funcionUnica[di]
		mov bufferInformacion[si], al
		cmp al, 59						; si es igual a puntoComa	
		je AsignarFin
		inc di
		inc si
		jmp Mientras
		
	AsignarFin:
		xor bx, bx
		xor di, di
		dec si
		mov bx, si
		StringToInt ultimoID 			;ax tiene el valor numerico del arreglo
		mov di, ax 
		inc di
		mov finFunciones[di], bl
		jmp Fin
		
	Fin:
	
	limpiar ultimoID, SIZEOF ultimoID,24h ; 24h = $
	limpiar funcionUnica, SIZEOF funcionUnica,24h ; 24h = $
	IntToString di, ultimoID
	print bufferInformacion
	
	;xor si, si
	;xor bx, bx
	;mov bl, inicioFunciones[5]
	;mov si, bx
	;IntToString si, lastPosition
	;print lineas
	;print salto
	;print lastPosition
	;xor si, si
	;xor bx, bx
	;mov bl, finFunciones[5]
	;mov si, bx
	;IntToString si, lastPosition
	;print salto
	;print lastPosition
	;print lineas

endm

;=================================================================================================================

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