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
		;dec di
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

guardarFuncionUnica macro func
LOCAL Mientras, Fin, AsignarFin

	;print msgFuncion
	;obtenerTexto func
	;print func
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
		mov al, func[di]
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
	limpiar func, SIZEOF func,24h ; 24h = $
	IntToString di, ultimoID
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;xor si, si
	;xor bx, bx
	;mov bl, inicioFunciones[0]
	;mov si, bx
	;IntToString si, lastPosition
	;print lineas
	;print salto
	;print lastPosition
	;xor si, si
	;xor bx, bx
	;mov bl, finFunciones[0]
	;mov si, bx
	;IntToString si, lastPosition
	;print salto
	;print lastPosition
	;print lineas
	
endm

analizarFuncion macro func
LOCAL MientrasTransIEE, FinIEE, sinExp, saltoLinea, negativo, finNeg, sigDolarLetra,IntegrarEnteroLetraExponente, IntegrarEntero, IntegrarEnteroLetra, MientrasNum, MientrasExp, MientrasLetra, sigElevado, sigDolarExp, sigSumaExp, sigRestaExp, sigDolarEnt, sigSumaEnt, sigRestaEnt, numCero, numUno, numDos, numTres, numCuatro, numCinco, numSeis, numSiete, numOcho, numNueve, Fin
push ax
push cx
push si
push di
push bx

	reiniciar
	xor di, di
	mov ultimoVal[0], 48
	
	mov al, func[di]
	
	saltoLinea:
		cmp al, 10
		jne negativo
		inc di
		mov al, func[di]
		jmp negativo
		
	negativo:
		cmp al, 45
		jne finNeg
		inc di
		mov ultimoVal[0], 49
		mov funcionIntegrada[0], 45
	
	finNeg:
	xor si, si
	xor bx, bx
	xor bl, bl
	xor al, al
	xor cx, cx
	MientrasNum:
	
		mov al, func[di]
		
		cmp al, 10
		jne numCero
		inc di
		mov al, func[di]
		
		numCero:
			cmp al, 48
			jne numUno
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numUno:
			cmp al, 49
			jne numDos
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numDos:	
			cmp al, 50
			jne numTres
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numTres:
			cmp al, 51
			jne numCuatro
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numCuatro:
			cmp al, 52
			jne numCinco
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numCinco:
			cmp al, 53
			jne numSeis
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numSeis:
			cmp al, 54 
			jne numSiete
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numSiete:
			cmp al, 55
			jne numOcho
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numOcho:
			cmp al, 56
			jne numNueve
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numNueve:
			cmp al, 57
			jne sigSumaEnt
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		sigSumaEnt:
			cmp al, 43
			jne sigRestaEnt
			jmp IntegrarEntero
			
		sigRestaEnt:
			cmp al, 45
			jne sigDolarEnt
			jmp IntegrarEntero
			
		sigDolarEnt:
			cmp al, 36
			jne MientrasLetra
			jmp IntegrarEntero
	
	MientrasLetra:
		xor si, si
		xor al,al 
		mov al, func[di]
		mov letraInte[si], al
		inc di 
		mov al, func[di]
		
		sigElevado:
			cmp al, 94
			jne sigDolarLetra
			inc di
			jmp MientrasExp
			
		sigDolarLetra:
			cmp al, 36
			jne IntegrarEnteroLetra
			inc di
			jmp IntegrarEnteroLetra
			
	MientrasExp:
		xor al, al
		xor si, si
		mov al, func[di]
		
		sigSumaExp:
			cmp al, 43
			je IntegrarEnteroLetraExponente
			jmp sigRestaExp
			
		sigRestaExp:
			cmp al, 45
			je IntegrarEnteroLetraExponente
			jmp sigDolarExp
			
		sigDolarExp:
			cmp al, 36
			je IntegrarEnteroLetraExponente
		
		add al, 1
		mov exponenteEnteroArr[si], al
		;mov 
	
		inc di
		inc si
		jmp MientrasExp
		
	IntegrarEntero: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov exponenteEnteroArr[0], 49
		jmp IntegrarEnteroLetraExponente
	
	IntegrarEnteroLetra: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov exponenteEnteroArr[0], 50
	
	IntegrarEnteroLetraExponente: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		xor bx, bx
		xor ax, ax
		StringToInt exponenteEnteroArr
		mov bx, ax
		mov exponenteEntero, bl
	
		xor ax, ax
		StringToInt numeroEnteroArr
		
		div exponenteEntero
		
		limpiar numeroEnteroArr, SIZEOF numeroEnteroArr,24h ; 24h = $
		xor si, si
		xor bx, bx
		mov bl, al
		mov si, bx
		IntToString si, numeroEnteroArr
		
		xor si, si
		xor ax, ax
		xor bx, bx
		StringToInt ultimoVal
		mov bx, ax
		mov si, bx
		
		xor bx, bx
		xor al, al
		MientrasTransIEE:
			mov al, numeroEnteroArr[bx]
			cmp al, 36
			je FinIEE
			mov funcionIntegrada[si], al
			inc si
			inc bx
			jmp MientrasTransIEE
		
		FinIEE:
			mov al, 120
			mov funcionIntegrada[si], al
			inc si
			
			mov al, exponenteEnteroArr[0]
			cmp al, 49
			je sinExp
			
			mov al, 94
			mov funcionIntegrada[si], al
			mov al, exponenteEnteroArr[0]
			inc si
			mov funcionIntegrada[si], al
			inc si
			sinExp:
			
		mov al, func[di]
		cmp al, 36
		je Fin
		mov funcionIntegrada[si], al
		inc si
		inc di
		IntToString si, ultimoVal
		reiniciar
		xor si, si
		xor al, al
		jmp MientrasNum
				
	Fin:	
	mov al, 43
	mov funcionIntegrada[si], al
	inc si
	mov al, 99
	mov funcionIntegrada[si], al
	inc si
	mov al, 59
	mov funcionIntegrada[si], al
	
	print salto 
	print lineas
	print resultado
	print funcionIntegrada
	print lineas
	print salto
	guardarFuncionUnica funcionIntegrada
	limpiar funcionIntegrada, SIZEOF funcionIntegrada,24h ; 24h = $	
pop bx
pop di
pop si
pop cx
pop ax
endm 

reiniciar macro 
push si
push cx
	limpiar numeroEnteroArr, SIZEOF numeroEnteroArr,24h ; 24h = $
	limpiar exponenteEnteroArr, SIZEOF exponenteEnteroArr,24h ; 24h = $
	limpiar letraInte, SIZEOF letraInte,24h ; 24h = $
pop cx
pop si
endm

;=================================================================================================================

;[MACARIO-201905837]
printFunc macro
LOCAL mientras,fin, noprintBuffer,nosalto
xor si,si
xor di,di
	mientras:
		mov al, bufferInformacion[si]
		cmp al, 10
		je nosalto
		mov bufferAux[di], al
		inc di
		nosalto:
		cmp al,59
		jne noprintBuffer
	
		print bufferAux
		print salto
		limpiar bufferAux, SIZEOF bufferAux, 024h
		xor di,di
	noprintBuffer:
		cmp al,36
		je fin
		inc si
		jmp mientras
	
	fin:
endm


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


analizarFuncionGraficar macro func
LOCAL L1,L2,escero,espositivo,MientrasTransIEE, FinIEE, sinExp, saltoLinea, negativo, finNeg, sigDolarLetra, MientrasNum, MientrasExp, MientrasLetra, sigElevado, sigDolarExp, sigSumaExp, sigRestaExp, sigDolarEnt, sigSumaEnt, sigRestaEnt, numCero, numUno, numDos, numTres, numCuatro, numCinco, numSeis, numSiete, numOcho, numNueve, Fin,moverCoeficienteLetra,moverCoeficienteLetraExponete,moverConstante,finmientrasConstante,finmientrasCoefiente,mientrasCoeficiente,noMover,notaddUno
push ax
push cx
push si
push di
push bx
mov exponenteGraficar[0],48
	reiniciar
	xor di, di
	mov ultimoVal[0], 48
	
	mov al, func[di]
	
	saltoLinea:
		cmp al, 10
		jne negativo
		inc di
		mov al, func[di]
		jmp negativo
		
	negativo:
		cmp al, 45
		jne finNeg
		inc di
		mov ultimoVal[0], 49
		mov funcionIntegrada[0], 45
	
	finNeg:
	xor si, si
	xor bx, bx
	xor bl, bl
	xor al, al
	xor cx, cx
	MientrasNum:
		
		cmp di,48
		je escero
		dec di
		mov al,func[di]
		cmp al,45
		jne espositivo
		mov numeroEnteroArr[si],45
		inc si
		espositivo:
			inc di
		escero:
		
		mov al, func[di]
		
		cmp al, 10
		jne numCero
		inc di
		mov al, func[di]
		
		numCero:
			cmp al, 48
			jne numUno
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numUno:
			cmp al, 49
			jne numDos
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numDos:	
			cmp al, 50
			jne numTres
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numTres:
			cmp al, 51
			jne numCuatro
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numCuatro:
			cmp al, 52
			jne numCinco
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numCinco:
			cmp al, 53
			jne numSeis
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numSeis:
			cmp al, 54 
			jne numSiete
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numSiete:
			cmp al, 55
			jne numOcho
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
		
		numOcho:
			cmp al, 56
			jne numNueve
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		numNueve:
			cmp al, 57
			jne sigSumaEnt
			mov numeroEnteroArr[si], al
			inc si
			inc di
			
			jmp MientrasNum
			
		sigSumaEnt:
			cmp al, 43
			jne sigRestaEnt
			jmp moverConstante
			
		sigRestaEnt:
			cmp al, 45
			jne sigDolarEnt
			jmp moverConstante
			
		sigDolarEnt:
			cmp al, 36
			jne MientrasLetra
			jmp moverConstante
		
	MientrasLetra:
		mov al,numeroEnteroArr[0]
		cmp al,45
		jne L1
			mov al,numeroEnteroArr[1]
			cmp al,36
			jne notaddUno
			
			mov numeroEnteroArr[1],49
			jmp notaddUno
		L1:
		xor al,al							
		mov al, numeroEnteroArr[0]
		cmp al,36
		jne notaddUno
		mov numeroEnteroArr[0],49
		notaddUno:	
		xor si, si
		xor al,al 
		mov al, func[di]
		mov letraInte[si], al
		inc di 
		mov al, func[di]
		
		sigElevado:
			cmp al, 94
			jne sigDolarLetra
			inc di
			jmp MientrasExp
			
		sigDolarLetra:
			cmp al, 36
			jne moverCoeficienteLetra
			inc di
			jmp moverCoeficienteLetra
			
	MientrasExp:
		xor al, al
		xor si, si
		mov al, func[di]
		
		sigSumaExp:
			cmp al, 43
			je moverCoeficienteLetraExponete
			jmp sigRestaExp
			
		sigRestaExp:
			cmp al, 45
			je moverCoeficienteLetraExponete
			jmp sigDolarExp
			
		sigDolarExp:
			cmp al, 36
			je moverCoeficienteLetraExponete
		
		mov exponenteEnteroArr[si], al
	
		inc di
		inc si
		jmp MientrasExp
	
	
	moverConstante: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		xor si,si
		mientrasConstante:
			mov al,numeroEnteroArr[si]
			cmp al,36
			je	finmientrasConstante 
			mov constanteGraficar[si],al
			inc si
			jmp mientrasConstante
		finmientrasConstante:
		reiniciar
		mov al,func[di]
		cmp al,36
		je Fin
		inc di
		xor si,si
		jmp MientrasNum
	moverCoeficienteLetra: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov exponenteEnteroArr[0],49
		jmp moverCoeficienteLetraExponete
		
		
	moverCoeficienteLetraExponete: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov al, exponenteEnteroArr[0]
		cmp al,exponenteGraficar[0]
		jb noMover
		limpiar exponenteGraficar, SIZEOF exponenteGraficar,36
		mov exponenteGraficar[0],al
		
		xor si,si
		limpiar coeficienteGraficar,SIZEOF coeficienteGraficar,36
		mientrasCoeficiente:
			mov al,numeroEnteroArr[si]
			cmp al,36
			je finmientrasCoefiente
			
			mov coeficienteGraficar[si],al
			inc si
			jmp mientrasCoeficiente
			
		finmientrasCoefiente:
		noMover:
		reiniciar 
		mov al,func[di]
		cmp al,36
		je Fin
		inc di
		xor si,si
		jmp MientrasNum
	Fin:
	
	StringToInt coeficienteGraficar
	xor bx,bx
	mov bx,ax
	mov coeficienteNum, bx

	
	StringToInt exponenteGraficar
	xor bx,bx
	mov bx,ax
	mov exponenteNum, bx
	
	StringToInt constanteGraficar
	xor bx,bx
	mov bx,ax
	mov constanteNum, bx
	
	graficarFuncion exponenteNum,coeficienteGraficar,constanteNum,func
			
	
pop bx
pop di
pop si
pop cx
pop ax
endm

graficarFuncion macro exponente,valorVariable,valor,funcion
LOCAL Lpositiva,Lnegativa,salir,validar,Constante,Lineal,Cuadratica,Cubica,AlaCuarta,Lpositiva1,Lnegativa1,Lpositiva2,Lnegativa2,Lpositiva3,Lnegativa3,Lpositiva4,Lnegativa4
push ax
push di
xor ax,ax
mov ax,exponente

cmp ax,0
je Constante
cmp ax,1
je Lineal
cmp ax,2
je Cuadratica
cmp ax,3
je Cubica
cmp ax,4
je AlaCuarta
jmp salir

Constante:
	xor bl,bl
	mov bl, valorVariable[0]
	cmp bl, 45
	je  Lnegativa ;cambios recientes por si da error 
	jmp Lpositiva

	Lpositiva:
		ModoVideo
		pintarMargen 7
		
		constantePositiva valor
		jmp salir
	Lnegativa:
		ModoVideo
		pintarMargen 7
		constanteNegativa valor
		jmp salir
Lineal:
	xor bl,bl
	mov bl, valorVariable[0]
	cmp bl, 45
	je  Lnegativa1 ;cambios recientes por si da error 
	jmp Lpositiva1

	Lpositiva1:
		ModoVideo
		pintarMargen 7
		linealPosiiva valor
		jmp salir
	Lnegativa1:
		ModoVideo
		pintarMargen 7
		linealNegativa valor
		jmp salir

Cuadratica:
	xor bl,bl
	mov bl, valorVariable[0]
	cmp bl, 45
	je  Lnegativa2 ;cambios recientes por si da error 
	jmp Lpositiva2

	Lpositiva2:
		ModoVideo
		pintarMargen 7
		
		cuadraticaPositiva valor
		jmp salir
	Lnegativa2:
		ModoVideo
		pintarMargen 7
		
		cuadraticaNegativa valor
		jmp salir

Cubica:
	xor bl,bl
	mov bl, valorVariable[0]
	cmp bl, 45
	je  Lnegativa3 ;cambios recientes por si da error 
	jmp Lpositiva3

	Lpositiva3:
		ModoVideo
		pintarMargen 7
		
		cubicaPositiva valor
		jmp salir
	Lnegativa3:
		ModoVideo
		pintarMargen 7
		
		cubicaNegativa valor
		jmp salir

AlaCuarta :
	
	xor bl,bl
	mov bl, valorVariable[0]
	cmp bl, 45
	je  Lnegativa4 ;cambios recientes por si da error 
	jmp Lpositiva4

	Lpositiva4:
		ModoVideo
		pintarMargen 7
		
		;printTexto funcion
		
		alacuartaPositiva valor
		jmp salir
	Lnegativa4:
		ModoVideo
		pintarMargen 7
		
		alacuartaNegativa valor
		jmp salir


salir:
pop di
pop ax	
endm

printTexto macro funcion_asldjajsdkljasldzxc
LOCAL mientras,fin
push si
push bx
xor al,al
xor di,di
xor si,si
xor bx,bx
	mientras:
	
	mov al, funcion_asldjajsdkljasldzxc[bx]
	cmp al,36d
	je fin
	add bx,1
	jmp mientras
	
	fin:
	
pop bx
pop si

endm

constantePositiva macro valor
LOCAL ejex,ciclo
mov dl,2
mov ax,0
mov si,0
ciclo:
	inc si
	add ax,320
	cmp si,valor
	jne ciclo
	
mov di,32010
sub di,ax
xor bx,bx
mov bx,32309
sub bx,ax
ejex:
	mov [di],dl
	inc di
	
	cmp di,bx
	jne ejex
endm

constanteNegativa macro valor
LOCAL ejex,ciclo
mov dl,2
mov ax,0
mov si,0
ciclo:
	inc si
	add ax,320
	cmp si,valor
	jne ciclo
	
mov di,32010
add di,ax
xor bx,bx
mov bx,32309
add bx,ax
ejex:
	mov [di],dl
	inc di
	
	cmp di,bx
	jne ejex
endm

linealPosiiva macro valor
LOCAL graph1,graph3
mov dl, 2
mov di,32160
add di,valor

graph1:
	mov[di],dl
	sub di,320
	
	inc di
	
	xor ax,ax
	mov ax,6640
	add ax,valor
	
	cmp di,ax
	jne graph1

mov di,32160
add di,valor
graph3:
	mov[di],dl
	add di,320
	
	dec di
	xor ax,ax
	mov ax,57680
	
	add ax,valor
	
	cmp di,ax
	jne graph3
endm

linealNegativa macro valor
LOCAL graph1,graph3
mov dl, 2
mov di,32160
add di,valor

graph1:
	mov[di],dl
	sub di,320
	
	dec di
	
	xor ax,ax
	mov ax,6480
	add ax,valor
	
	cmp di,ax
	jne graph1

mov di,32160
add di,valor
graph3:
	mov[di],dl
	add di,320
	
	inc di
	xor ax,ax
	mov ax,57840
	
	add ax,valor
	
	cmp di,ax
	jne graph3
endm

cuadraticaPositiva macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
add di,1
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl



graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo

	inc di
	add di,320
	xor bx,bx
	mov bx,12650
	add bx,valor
	
	cmp di,bx
	
	jne graph1
	

mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo2

	dec di
	add di,320
	xor bx,bx
	mov bx,12630
	add bx,valor
	
	cmp di,bx
	
	jne graph3

endm

cuadraticaNegativa macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl



graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo

	inc di
	sub di,320
	xor bx,bx
	mov bx,56812
	add bx,valor
	
	cmp di,bx
	
	jne graph1
	

mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo2

	dec di
	sub di,320
	xor bx,bx
	mov bx,56788
	add bx,valor
	
	cmp di,bx
	
	jne graph3

endm



cubicaPositiva macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
add di,1
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl

graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo

	inc di
	add di,320
	xor bx,bx
	mov bx,10091
	add bx,valor
	
	cmp di,bx
	
	jne graph1
	

mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo2

	dec di
	sub di,320
	xor bx,bx
	mov bx,56788
	add bx,valor
	
	cmp di,bx
	
	jne graph3

endm

cubicaNegativa macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov bx,di
			;activar modo video 
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl



graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo

	inc di
	sub di,320
	xor bx,bx
	mov bx,56812
	add bx,valor
	
	cmp di,bx
	
	jne graph1

mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo2

	dec di
	add di,320
	xor bx,bx
	mov bx,10069
	add bx,valor
	
	cmp di,bx
	
	jne graph3
endm


alacuartaPositiva macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
add di,1
mov[di],dl
add di,1
mov[di],dl
add di,1
mov[di],dl
add di,1
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
add di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl



graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo

	inc di
	add di,320
	xor bx,bx
	mov bx,10094
	add bx,valor
	
	cmp di,bx
	
	jne graph1
	

mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
mov[di],dl
sub di,1
mov[di],dl
sub di,1
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl
sub di,1
sub di,320
mov[di],dl
sub di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		sub di,320
		cmp si,9
		jne ciclo2

	dec di
	add di,320
	xor bx,bx
	mov bx,10066
	add bx,valor
	
	cmp di,bx
	
	jne graph3

endm

alacuartaNegativa macro valor
LOCAL graph1,graph3,ciclo,ciclo2
mov dl, 2 ;color de la graficca
mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
add di,1
mov[di],dl
add di,1
mov[di],dl
add di,1
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
add di,1
add di,320
mov[di],dl
add di,320
mov[di],dl



graph1:
	mov si,0
	ciclo:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo

	inc di
	sub di,320
	xor bx,bx
	mov bx,56815
	add bx,valor
	
	cmp di,bx
	
	jne graph1
	

mov di,32160 ; posicion inicial centro 
add di,valor
mov[di],dl
sub di,1
mov[di],dl
sub di,1
mov[di],dl
sub di,1
mov[di],dl
sub di,1
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl
sub di,1
add di,320
mov[di],dl
add di,320
mov[di],dl

graph3:
	mov si,0
	ciclo2:
		inc si
		mov[di],dl
		add di,320
		cmp si,9
		jne ciclo2

	dec di
	sub di,320
	xor bx,bx
	mov bx,56785
	add bx,valor
	
	cmp di,bx
	
	jne graph3

endm
