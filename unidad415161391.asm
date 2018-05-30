;Olmedo Ventura Yazmin Arleth IS_B
section .data

msg db "Ingrese un nuemro del 10 al 44",0Dh,0Ah,'$0'
leng1 equ $ - msg ;Longitud del mensaje

numero db 0, 0
leng4 equ $ - numero;Longitud del mensaje

completo db 0
leng3 equ $ - completo ;Longitud del mensaje 

numeros db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
leng2 equ $ - numeros ;Longitud del mensaje

section .text  ;indica el cuerpo del programa
global _start  ;para especificar cual ee el main

_start:  
                 
mov ah,09 ;instruccion para imprimir en pantalla
mov dl, msg ;Pongo en dl el número a imprimir
int 21h ;interrupcion pantalla  
 ;----------------lectura de las decenas-------------------------- 
mov ah,01h ;leectura en windows
int 21h
sub al, 48 ;le resta 48 al numero leido que fue guardado en al.
mov [numero], al  ;guarda el valor de al en la variable numero.
	
;---------------- lectura de las unidades------------------------ 
mov ah,01h ;leectura en windows
int 21h
sub al, 48 ;le resta 48 al numero leido que fue guardado en al.
mov [numero + 1], al ;guarda el valor de al en la variable numero mas uno.

mov esi, [numero + 1] ;  colocamos la direccion de memoria en el resgistro esi 
		       ; esto para mejorar la velocidad del programa
mov ecx, 20
mov edi, 3 
;-------------------Ciclos---------------------------------------
ciclo:
mov eax, [numero]
mov edx, eax
mul edx
mov [numero], eax
	
mov eax, esi ;multiplica la decena por su mismo valor
mov edx, eax
mul edx
		
add eax, [numero]
		
mov [completo], eax
call imprimedos ;manda a llamar al ciclo imprime dos
		
mov bl, [completo]
cmp bl, 1 ;resta el operando fuente al operando destino pero 
                           ;sin que éste almacene el resultado de la operación, 
                           ;solo se afecta el estado de las banderas.
je salir   ;Salta si es igual o salta si es cero.
                            ;El salto se realiza si ZF está activada. 
		
mov [numeros + edi], bl
add edi, 1
		
cmp edi, 4   ;Esta instrucción resta el operando fuente al operando destino 
				      ;pero sin que éste almacene el resultado de la operación, solo
				      ;se afecta el estado de las banderas.
je ciclo     ;Salta si es igual o salta si es cero.
				  ;El salto se realiza si ZF está activada. 	
mov edx, 3


infeliz: 
			mov bh, [numeros + edx]
			cmp bh, bl  ;Esta instrucción resta el operando fuente al operando destino 
				      ;pero sin que éste almacene el resultado de la operación, solo
				      ;se afecta el estado de las banderas.

			je salir ;Salta si es igual o salta si es cero.
				  ;El salto se realiza si ZF está activada. 
			
			mov eax, edi
			sub eax, 1
		
			add edx, 1
			
			cmp edx, eax  ;Esta instrucción resta el operando fuente al operando destino 
				      ;pero sin que éste almacene el resultado de la operación, solo
				      ;se afecta el estado de las banderas. 
			jb infeliz ;Salta si está abajo o salta si no está arriba o si no es igual.
				    ; Se efectúa el salto si CF esta activada. 	
  
loop ciclo ;La instrucción loop decrementa CX en 1, y transfiere el flujo del programa 
		   ;a la etiqueta dada como operando si CX es diferente a 1.

;---------------Imprimir en ciclo--------------------------------------------	
imprimedos:

	mov dx, 0Ah		; Salto de linea
	mov ah,02h
	int 21h
	
	 mov  al,  [completo] ;conversion a dos numeros
	 mov ah,0
	 mov dl,10
	 div dl
	
	mov [numero ], al ;Junta los resultados de las multiplicaciones
	mov [numero + 1], ah	
	mov esi, [numero + 1]
	
	mov dx, [numero]  ;imprime un solo caracter, corta la cadena
	add dx, 48    ;imprime el segundo numero
	mov ah, 02h
	int 21h
	
	mov dx, [numero + 1] ;imprime un solo caracter, corta la cadena
	add dx, 48  ;imprime el primer numero
	mov ah, 02h
	int 21h
	ret  ;Retorno de subrutina Ciclos:4
;----------------Salida----------------------------------------------
salir:
	mov ah, 4ch      ;termina el programa
	int 21h 