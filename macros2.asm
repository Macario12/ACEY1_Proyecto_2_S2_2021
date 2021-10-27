close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al, al
	int 21h
endm