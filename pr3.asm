include macros.asm ;archivo con los macros
include macros2.asm ;archivo con los macros

.model small
;---------------------SEGMENTO DE PILA ----------------
.stack
;---------------------SEGMENTO DE DATO ----------------
.data
encabezado db 0ah, 0dh, '==================================================', 0ah, 0dh, 'Universidad de San Carlos de Guatemala', 0ah, 0dh, 'Arquitectura de Ensambladores y Computadores 1', 0ah, 0dh, 'Erick Estrada Aroche - 201603071', 0ah, 0dh, 'Ariel Rubelce Macario Coronado - 201905837', 0ah, 0dh, 'Katerine Adalinda Santos Ramirez - 201908321', 0ah, 0dh, 'Practica 4',0ah, 0dh, '==================================================','$'
salto db 0ah, 0dh, '$', '$'
opciones db 0ah, 0dh, 'Ingese una opcion', 0ah, 0dh, '1) Derivar funcion', 0ah, 0dh, '2) Integrar funcion', 0ah, 0dh, '3) Ingresar funciones', 0ah, 0dh, '4) Imprimir funciones ingresadas', 0ah, 0dh, '5) Graficar', 0ah, 0dh, '6) Resolver ecuacion', 0ah, 0dh, '7) Enviar a arduino', 0ah, 0dh, '8) Salir', '$'
subOpciones db 0ah, 0dh, 'Ingese una opcion', 0ah, 0dh, '1) Ingresar funcion', 0ah, 0dh, '2) Cargar archivo', 0ah, 0dh, '3) Regresar al menu principal', '$'
entro db 0ah, 0dh, 'Entro', '$'

.code
main proc
		Menu:
		print encabezado
		print salto
		print opciones
		print salto
		getChar
		cmp al, 49d
		je DerivarFuncion
		cmp al, 50d
		je IntegrarFuncion
		cmp al, 51d
		je IngresarFunciones
		cmp al, 52d
		je ImprimirFunciones
		cmp al, 53d
		je Graficar
		cmp al, 54d
		je ResolverEcuaciones
		cmp al, 55d
		je EnviarArduino
		cmp al, 56d
		je Salir
		
		
		DerivarFuncion:
			print entro
			print salto
			getChar
			jmp Menu
			
		IntegrarFuncion:
			print entro
			print salto
			getChar
			jmp Menu
			
		IngresarFunciones:
			print subOpciones
			print salto
			getChar
			cmp al, 49d
			je IngresarFuncion
			cmp al, 50d
			je CargarArchivo
			cmp al, 51d
			je RegresarMenu
			
			IngresarFuncion:	
				print entro
				print salto
				getChar
				jmp Menu
			
			CargarArchivo:
				print entro
				print salto
				getChar
				jmp Menu
			
			RegresarMenu:
				jmp Menu
			
		ImprimirFunciones:
			print entro
			print salto
			getChar
			jmp Menu
			
		Graficar:
			print entro
			print salto
			
			ModoVideo
			pintarMargen 7
			
			getChar
			ModoTexto
			jmp Menu
			
		ResolverEcuaciones:
			print entro
			print salto
			getChar
			jmp Menu
			
		EnviarArduino:
			print entro
			print salto
			getChar
			jmp Menu
		
		Salir:
			close
main endp
end main