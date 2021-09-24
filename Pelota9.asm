 
 
 
 
  
  
.model small
.stack
   
   
   

.data  
  nick db 'Ingrese un Nick:',10,13,'$'
  pass db 'Ingrese una Contrasena:',10,13,'$'
  inick db 'Nick:',10,13,'$'
  ipass db 'Contrasena:',10,13,'$'
  errorP db 'Contrasena Incorrecta:',10,13,'$'
  salto db 10,13,'$'
  
  Datasm db 'Informacion de Usuarios:',10,13,'$'
  ;variables----------------
  
  master db 'adminai',0,0,0
  cmaster db '4321',0,0,0,0,0,0
  
  buff db 250 dup(0) 
  
  buffx dw 5 dup(0)
  tbuff dw 0
  
  Registros db 200 dup(0) ;20 registros de 10 bytes
  Password  db 200 dup(0) ;20 registros de 10 bytes
  
  
  tRegistros db 0
  
  posiDI dw 0    
  

  IDSUSUARIOS db 10 dup(0)
  
  IDSTIEMPOS dw 10 dup(0)
  
  IDSNIVELES db 10 dup(0)  ; POR EL NUMERO
  
  IDSPUNTOS db  10 dup(0)
   
  tamaIDS dW 0
  
  
  cadeDatas db  '               ',10,13,'$'            
  
  logeadoUsu db 0

  Saleju db 0

MensajeMen db 'x-----------------------------------x',10,13,'|          BALL BRAKER              |',10,13,'|                                   |',10,13,'|     Seleccione una Opcion:        |',10,13,'|                                   |',10,13,'|  Registro   (1)                   |',10,13,'|  Login      (2)                   |',10,13,'|  Salir      (3)            *      |',10,13,'|                          =====    |',10,13,'|                                   |',10,13, '|Kevin Golwer Enrique Ruiz Barbales |',10,13,'|201603009                          |',10,13,'x-----------------------------------x',10,13,'$'
             
;FINAL DE INTERNO 9
   espacio db 0 
    
    retcarro db 8
    DatosX db '     user1     N1     000   000$'
    retos dw $-DatosX
    
    color db 04h
    colorP db 05h
    colorC db 04h
    borraB db 0 
    
    PUNTOSGAN dw 0
    
    TIEMPOHECHO dw 0
    
    tanterior db 0
    
    
    noBloquest db 10
    
    Nivel db 1
    
    Barra dw 130,160
    
    posicionDib db 0
    direcB dw 0
   TIME_AUX DB 0
    
   posx dw 145,146
              
   posy dw 180,181
  
   estadoP dw 0  
   
   estadoA dw 0   
   
   bloques1 db 1,1,1,1,1,1,1,1,1,1
   
   bloques2 db 1,1,1,1,1,1,1,1,1,1
   
   bloques3 db 1,1,1,1,1,1,1,1,1,1 
   
   
   
   ;Primeras 2
   ;Coordenadas Primarias de un bloque
   
   ;Otras 2
   ;Coordenadas de los bordes 
   
   coorPrimX dw 0,24,7,312
   coorPrimY dw 0,15,15,185
    
   
   
   ;            ^
;   Estado 1: ->|
;   
;               ^
;   Estado 2: <-|  
;   
;               |
;   Estado 3: <-v  
;   
;               |
;   Estado 4: ->v  
   
.code
  mov ax,@data
  mov ds,ax  
 Mens Macro texto
    push ax
    push dx
    
    mov ah,09
    mov dx,offset texto
    int 21h
    
    pop dx
    pop ax
 endm 
  
 MenuEntradas Macro
     
  
    push ax
    
     mov ax,0
     mov ah,1
     int 21h
     
     OpcionNo1:
     cmp al,'1'
     jne OpcionNo2
                  call Registrar
     jmp Nigunaxx
     OpcionNo2:
     cmp al,'2'
     jne OpcionNo3
                  call Login
     jmp Nigunaxx
     OpcionNo3:
     cmp al,'3'
     jne Nigunaxx
     
        jmp TerminaTodo
     Nigunaxx:
     
     
  
    pop ax
  
 endm 
  
 ;INICIA EL PROGRAMA999999999999999999999999999 
  
  
  call BorraPantalla 

  mov ah,00 ;set mode
  mov al,13h ;mode=13(CGA High resolution)
  int 10h ;invoke the interrupt to change mode
         
  CICLOm:       
  call BorraPantalla
  call RetrocedeMax
  
  Mens MensajeMen
  MenuEntradas
  
  
   
  ;call IniciaJuego 
  
  
  JMP CICLOm  
  
  TerminaTodo:
   
 ;FIN PROGRAMA99999999999999999999999999999999999
.exit 

BorraPantalla proc 
    push ax
    push bx
    push cx
    push dx
    
    mov ax,0
    mov bx,0
    mov cx,0
    mov dx,0
    
    mov ax,0600h ;scroll the screen
    mov bh,00 ;normal attribute
    mov cx,0000 ;from row=00,column=00
    mov dx,184fh ;to row=18h, column=4fh
    int 10h ;invoke the interrupt to clear screen 
    
    
    
    pop dx
    pop cx
    pop bx
    pop ax
 
 
 
 
 ret
endp 


IniciaJuego proc
     call BorraPantalla
     
     call RestauraVJ
     
     call copiaUsuario
     
     mov ax,0
      push ax ;Limpia lo que leyo
      mov ah,0ch
      mov al,0
      int 21h
     
     pop ax
        
        call DibIniNivel               
                       
                       
        call Limite
        call dibujaBarr
       
        Mens DatosX  
       
        
    CHECK_TIME:
		    
		 call LeeEntrada 
		 
		 cmp Saleju,0
		 jne FindelJuego
		 
		  
		 
		 cmp noBloquest,0
		 je FindelJuego
		 
		 
		 mov colorP,05h  
		 call dibujaPelota
		    
		    
			MOV AH,2Ch ;get the system time
			INT 21h    ;CH = hour CL = minute DH = second DL = 1/100 seconds
			
			
			
			cmp dh,tanterior
			 je noagrega  
			 
			   cmp estadoP,0
			   je noAumenta
			   
			    inc TIEMPOHECHO
			    call RetrocedeLetra
                call MuestraTiempo
                Mens DatosX  
             noAumenta:   
             mov tanterior,dh 
			noagrega:
			
			
			
			
			CMP DL,TIME_AUX  ;is the current time equal to the previous one(TIME_AUX)?
			JE CHECK_TIME    ;if it is the same, check again
			;if it's different, then draw, move, etc.
			
			MOV TIME_AUX,DL ;update time
			
			 
			 
			 
			         
			;call borraPelota 
			
			call AnaNivel
			
			;call dibujaPelota 
			
			
			 
			 
			;int 21		
	        ;mov colorc,4h
;            call dibujaBarr
             
	JMP CHECK_TIME ;after everything checks time again
    
   FindelJuego:
    mov ah,0
    int 16h 
   mov Saleju,0 
ret
endp 
   
 ;MovBarra
 ;parametBarra              
 ;dibujaBarr
 


DibIniNivel proc
    
       
       
       
                 
        mov dx,20
        mov color,10
        mov si,offset bloques1 
        call BlockL1
                     
       cmp Nivel,2              
       jnae NoDibNivx
                     
        mov dx,35
        mov color,4
        mov si,offset bloques2 
        call BlockL1
       NoDibNivx:
        
        
       cmp Nivel,3
       jne NoDibNivx2 
        mov dx,50
        mov color,5
        mov si,offset bloques3 
        call BlockL1             
       NoDibNivx2:          
    
ret
endp



AnaNivel proc
            
          call borraPelota  
                mov posicionDib,1
    			mov color,10
    			;mov bx,offset bloques1
    			;mov si,19 
    			call ReboteP
			    
		  ;call dibujaPelota 
			
			
		  ;call borraPelota
			cmp Nivel,2              
            jnae NoDibNivxx
			
    			mov posicionDib,2
    			mov color,5
    			;mov bx,offset bloques2
    			;mov si,34
    			call ReboteP
			NoDibNivxx:
		  ;call dibujaPelota
			
		  ;call borraPelota	
			cmp Nivel,3
            jne NoDibNivxx2:
       
    			mov posicionDib,3
    			mov color,5
    			;mov bx,offset bloques3
    			;mov si,49
    			call ReboteP  
            NoDibNivxx2:
         mov colorP,05h 
         call dibujaPelota
ret
endp


 
borraPelota proc
    
             mov colorP,00  ;borra la pelota
			 CALL dibujaPelota
			 mov colorP,05h  
    
ret
endp 
                
               
dibujaPelota proc 
    
    push ax
    push cx
    push dx
    
  mov ah,0ch ;ah=0ch to draw a line
  mov al,colorP ;pixels=light grey 
  mov cx,0
  mov dx,0
   
  mov cx,posx 
  mov dx,posy 
  int 10h 
        
  mov cx,posx+2 
  int 10h 
   
  mov cx,posx 
  mov dx,posy+2 
  int 10h 
        
  mov cx,posx+2
  int 10h  
    
    pop dx
    pop cx
    pop ax
 
ret
endp

 
 
movPelota proc
    
  
  cmp estadoP,0
      jne movPelota1
      
      jmp FestadoP
  movPelota1:
      cmp estadoP,1
      jne movPelota2
        inc posx
        inc posx+2 
        
        dec posy
        dec posy+2
        
      jmp FestadoP
  movPelota2:
      cmp estadoP,2
      jne movPelota3
        dec posx
        dec posx+2 
        
        dec posy
        dec posy+2
      jmp FestadoP
  movPelota3:
      cmp estadoP,3
      jne movPelota4
        dec posx
        dec posx+2 
        
        inc posy
        inc posy+2
      jmp FestadoP
  movPelota4:
        inc posx
        inc posx+2 
        
        inc posy
        inc posy+2
  
      jmp FestadoP
    
  FestadoP:  
    
ret
endp 
 
 
  ;MovBarra
 ;parametBarra              
 ;dibujaBarr

ReboteP proc
  ;antes de llamar pasar valor 0
  ;a el indicador de arreglo  
    
  mov cx,10 
  mov di,0
  mov dx,5 ;no es ningu estado
  
  
  call movPelota 
  
  call ReboteParametros 
  call parametBarra
  
  cicloy0:
    ;recoje el offset del arreglo 
    ;y verifica si el bloque existe
    
    mov bx,offset bloques1
    mov si,19
    
    cmp [bx+di],1
    jne AnalizaNive2 
               ;comparacion en tres hacia abajo sin offset ni si
           call CmpParam
           cmp borraB,1
           jne AnalizaNive2 
           
           ;suma un punto
           inc PUNTOSGAN
           dec noBloquest
           
           call RetrocedeLetra
           call MuestraPuntos
           Mens DatosX
           
           mov borraB,0
           mov [bx+di],0 ;quita el bloque como activo
           call RedibujadoAc
     
    AnalizaNive2:
    cmp Nivel,2
    jnae NoanaNivel 
     mov bx,offset bloques2 
     mov si,34
     
       cmp [bx+di],1
       jne NoanaNivel 
     
           call CmpParam
           cmp borraB,1
           jne NoanaNivel 
           
           ;suma un punto
           inc PUNTOSGAN
           dec noBloquest
           
           call RetrocedeLetra
           call MuestraPuntos
           Mens DatosX 
              
           mov borraB,0
           mov [bx+di],0 ;quita el bloque como activo
           call RedibujadoAc
    NoanaNivel:
    
    
    cmp Nivel,3
    jne NoanaNivel3
    mov si,49
    
      mov bx,offset bloques3
         cmp [bx+di],1
         jne NoanaNivel3 
     
           call CmpParam
           cmp borraB,1
           jne NoanaNivel3 
           
           ;suma un punto
           inc PUNTOSGAN
           dec noBloquest
           
           call RetrocedeLetra
           call MuestraPuntos
           Mens DatosX
           
           mov borraB,0
           mov [bx+di],0 ;quita el bloque como activo
           call RedibujadoAc
    NoanaNivel3:
            
          ;;;;call RedibujadoAc  
                      

        ;Original correcto
;        mov dx,20
;        mov color,10
;        mov si,offset bloques1 
;        call BlockL1
        
        
    
    omiteBloque:
   inc di
  loop cicloy0
  

    
ret
endp   
          
          
          

RedibujadoAc proc 
    
    
        push dx
        push si

            mov dx,20 
            mov si,offset bloques1
            call BlockL1
        
        pop si
        pop dx    
        
        
        
        
        cmp Nivel,2
        jnae NoRedibu
        
        push dx
        push si

            mov dx,35 
            mov si,offset bloques2
            call BlockL1
        
        pop si
        pop dx
        NoRedibu:
        
        
        
        
        cmp Nivel,3
        jne NoRedibu2
        push dx
        push si

            mov dx,50 
            mov si,offset bloques3
            call BlockL1
        
        pop si
        pop dx
        NoRedibu2:
ret
endp




;   0                       24
;   x-----------------------x
;   |                       |
;   |                       |
;   |                       |      xx
;   |                       |      xx
;   x-----------------------x____________
;   15                      |
;                           |
;   xx                      |xx
;   xx                      |xx
;                           |
;                           |
           
;  14   4  x       24            x      24
;|----|----|----------------|----|---------------|    
     
CmpParam proc
   push ax
   push bx
   push dx
   push si
   
   ;mov dx,20 ;pos inicial
   
   mov dx,0 ;dice si hubo acierto
   
   mov ax,di
   mov bx,29
   mul bx
   
   add ax,17 ; se reubica x
   
   ;push cx
;   push dx
;   push ax
;   
;   mov cx,ax
;   mov dx,si
;   
;   call dibuCoord
;   
;   pop  ax
;   pop  dx
;   pop  cx
   
   
   ;ax es x0
   ;si es y0 
    
;   posx db    120,121   
;   posy db 160       160
;          ,161       161
;              120,121
     
   ;primero compara profundidad si esta sobre la linea
   ;luego compara rango
   ;tiene que tocar la linea para que rebote     
     
   ;Compara Arriba Horizontal
   
   
   ; ArribaBloque  Abajo Pelota 
   ArribBloAbaP:
   cmp posy+2,si
   jne AbaBloArribP  
            ;cambia estado y elimina bloque
            call CompXrango
                 cmp dx,1
                 jne NoTocaBloque ;no toca el bloque
                  mov dx,0
                  mov borraB,1
                  cmp estadoP,3
                  jne otroEstadox
                   mov estadoP,2
                  
                  jmp NoTocaBloque
                 otroEstadox:
                   mov estadoP,1
   
   jmp NoTocaBloque         
   ; AbajoBloque  Arriba Pelota 
   AbaBloArribP:
   add si,11
    cmp posy,si
    jne DerBloIzqP
      sub si,11
            ;cambia estado y elimina bloque
            call CompXrango
                 cmp dx,1
                 jne NoTocaBloque ;no toca el bloque
                  mov dx,0 
                  mov borraB,1
                  cmp estadoP,1
                  jne otroEstadox2
                   mov estadoP,4
                  
                  jmp NoTocaBloque
                 otroEstadox2:
                   mov estadoP,3
  
   jmp NoTocaBloque
   ; DerechaBloque Izquierda Pelota
   DerBloIzqP:
   sub si,11 
   add ax,25
     cmp posx,ax
     jne IzqBloDerP
       sub ax,25
            ;cambia estado y elimina bloque
            call CompYrango
                 cmp dx,1
                 jne NoTocaBloque ;no toca el bloque
                  mov dx,0 
                  mov borraB,1
                  cmp estadoP,2
                  jne otroEstadox3
                   mov estadoP,1
                  
                  jmp NoTocaBloque
                 otroEstadox3:
                   mov estadoP,4
   
   jmp NoTocaBloque       
   ; IzquierdaBloque Derecha Pelota
   IzqBloDerP:
   sub ax,25
    cmp posx+2,ax
    jne NoTocaBloque
            ;cambia estado y elimina bloque
            call CompYrango
                 cmp dx,1
                 jne NoTocaBloque ;no toca el bloque
                  mov dx,0 
                  mov borraB,1
                  cmp estadoP,1
                  jne otroEstadox4
                   mov estadoP,2
                  
                  jmp NoTocaBloque
                 otroEstadox4:
                   mov estadoP,3
   NoTocaBloque:
  
   pop si
   pop dx     
   pop bx     
   pop ax
   
    
ret
endp     
     
  
  
     
 CompXrango proc
    
     comp1x:
            cmp posx,ax ;si coor1 de pelota no es 
            jna comp2x 
                 add ax,25
                     subxx1:
                     cmp posx,ax
                     ja subxx2
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                         mov dx,1      
                     jmp FinalAPx1        
                     subxx2:
                     cmp posx+2,ax
                     ja NoCumplex1;hace resta y sigue comparando
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                         mov dx,1
            jmp FinalAPx1 
            comp2x:
            cmp posx+2,ax;compara otra coor2 de pelota
            jna FinalAPx1
                         
                 add ax,25
                     subxxx1:
                     cmp posx,ax
                     ja subxxx2
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                          mov dx,1  
                     jmp FinalAPx1        
                     subxxx2:
                     cmp posx+2,ax
                     ja NoCumplex1;hace resta y sigue comparando
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                          mov dx,1
            jmp FinalAPx1
            NoCumplex1: 
              sub ax,25
              
            FinalAPx1:
    
    
 ret
 endp    
 
 
 CompYrango proc
    
            comp1y:
            cmp posy,si ;si coor1 de pelota no es 
            jna comp2y 
                 add si,11
                     subxy1:
                     cmp posy,si
                     ja subxy2
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                         mov dx,1      
                     jmp FinalAPy1        
                     subxy2:
                     cmp posy+2,si
                     ja NoCumpley1;hace resta y sigue comparando
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                         mov dx,1
            jmp FinalAPy1 
            comp2y:
            cmp posy+2,si;compara otra coor2 de pelota
            jna FinalAPy1
                         
                 add si,11
                     subxxy1:
                     cmp posy,si
                     ja subxxy2
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                          mov dx,1  
                     jmp FinalAPy1        
                     subxxy2:
                     cmp posy+2,si
                     ja NoCumpley1;hace resta y sigue comparando
                     ;si fue mayor y menor o igual
                     ;cambia estado y elimina bloque
                          mov dx,1
            jmp FinalAPy1
            NoCumpley1: 
              sub si,11
              
            FinalAPy1:
    
    
 ret
 endp
  
  
  
  
 
 
 
 ReboteParametros proc
    
     
     IzqPared:
     cmp posx,8
     ja DerPared
          cmp estadoP,2
          jne CamEsP1
              mov estadoP,1        
          jmp FinCamEsP1 
          CamEsP1:
              mov estadoP,4            
          FinCamEsP1:
          
     jmp NotocaPared
     DerPared:
     cmp posx+2,311
     jnae ArrPared
          cmp estadoP,1
          jne CamEsP2
              mov estadoP,2        
          jmp FinCamEsP2 
          CamEsP2:
              mov estadoP,3            
          FinCamEsP2:
     
     jmp NotocaPared
     ArrPared:
     cmp posy,16
     ja AbaPared
          cmp estadoP,1
          jne CamEsP3
              mov estadoP,4        
          jmp FinCamEsP3 
          CamEsP3:
              mov estadoP,3            
          FinCamEsP3:
     
     jmp NotocaPared
     AbaPared:    
     cmp posy+2,184
     jnae NotocaPared 
     
        mov Saleju,1
        call guardaAdminData
          ;cmp estadoP,3
;          jne CamEsP4
;              mov estadoP,2        
;          jmp FinCamEsP4 
;          CamEsP4:
;              mov estadoP,1            
;          FinCamEsP4:
     
     
     NotocaPared:
     
 ret
 endp
 
 
 
 
 
 
 
 
 
 
 


 BlockL1 proc
    
   ;Recibe en bx offset de arreglo para borar o crear
   push ax
   push bx
   push cx
   push dx
   push di
   
   
    ;mov dx,20 ; en dx esta la fila en donde comienza 
    
    mov cx,10
    
    ciclo4:
      mov ax,0
      mov bx,0
      
      mov di,14 ;era parte del otro metodo 

      call dibLineaB

      inc dx
    loop ciclo4
   
   
   pop di
   pop dx
   pop cx
   pop bx
   pop ax
   
  
 ret
 endp
 
 
 
 
  
 dibLineaB proc
    
 push cx
 push si
 
    mov espacio,0
    mov cx,292 ;numero de iteraciones total
    ;mov dx,20  ;row=75     valor original funciona
    
    ;mov di,14
    
    ;mov si,0 
     
     
    ciclo0:
    
    cmp espacio,4 ; si hizo 4 espacios
    jne incrementos
            
            push ax  
               mov ah,0
               mov al,byte ptr[si]
            
            pop ax 
            
            cmp byte ptr[si],1
            jne saltoxx
            mov color,10
            jmp Fincamcolo
            saltoxx:
            ; cambia a negro
             
            mov color,0 
            Fincamcolo:
            inc si
            
            push cx
            
            mov cx,24
            
                ciclo1: 
                push cx
                
                mov cx,di
                 
                mov ah,0ch ;ah=0ch to draw a line
                
                mov al,color ;pixels=light red  
                
                int 10h ;invoke the interrupt to draw the line
                
                pop cx
                inc di
                loop ciclo1
            
            pop cx
            
            
            
            
        sub cx,24
        mov espacio,0 
        ;dec di
        ;dec di
        dec espacio
        
        mov ax,2
        add ax,ax
        
        cmp ch,1
        jna incrementos
        mov cx,1
        
        
    incrementos:
    
    inc di
    inc espacio    
    loop ciclo0
 pop si 
 pop cx   
    
 ret
 endp 

 
 
 
 dibuCoord proc
  push ax  
  ;mov cx,120 ;start line at column=130 and 319
  ;mov dx,160 ;row=75                   200 max
         
  mov ah,0ch ;ah=0ch to draw a line
  mov al,colorC ;pixels=light grey
  int 10h ;invoke the interrupt to draw the line
        
   pop ax 
 ret
 endp
 
  
   
   
 
 Limite proc 
       push ax
       push bx
       push cx
       push dx
       push si
       push di
     
  
          ;LINEA HORIZONTAL ARRIBA
          mov dx,15 ;fila   
          mov si,0
          
          paraRepetir:
          
          mov cx,305 

          mov di,7  ;inicia en pos 7 en x
          
                ciclo5: 
                
                push cx
                
                mov cx,di
                 
                mov ah,0ch ;ah=0ch to draw a line
                
                mov al,3h ;pixels=light red  
                
                int 10h ;invoke the interrupt to draw the line
                 
                pop cx
                
                inc di
                loop ciclo5 
           cmp si,0   ;LINEA HORIZONTAL ABAJO
           jne norepite 
            mov si,1 
            mov dx,185
           jmp paraRepetir
           
          norepite:
          
          
          
          
          ;LINEA HORIZONTAL IZQUIERDA
          
          mov si,0
          
          regresass:
          
          mov cx,171 ;iteraciones de fila
          
          mov di,15  ;posicion para dibujar
          
          
          
          ciclo6:
              push cx ;guarda contador       
                 
                mov cx,7  ;posicion de columna constante 
                 
                cmp si,1
                jne snohace 
                
                mov cx,312  ;posicion de columna constante 
                
                snohace:
                
                
                mov dx,di ;posicion de fila aumenta
                
                mov ah,0ch ;ah=0ch to draw a line
                    
                mov al,3h ;pixels=light red  
                    
                int 10h ;invoke the interrupt to draw the line       
              
              pop cx  ;restaura contador
              inc di  
          
          loop ciclo6
          
          cmp si,0       ;LINEA DERECHA
          jne finallin
           mov si,1
          jmp regresass
          
          finallin:
          
          
       pop di
       pop si
       pop dx
       pop cx
       pop bx   
       pop ax
       
       
       
       
       
       
 ret
 endp   
   
  
 
 
 dibujaBarr proc
   push cx
   push bx
   push dx
   push ax
   
    mov cx,30
    
    mov bx,Barra ;contiene su posicion real
    
    cicloxy3:
        
        push cx
        
        
        mov cx,bx
        mov dx,182
        ;mov colorC,04h
        call dibuCoord
         
        inc dx 
        ;mov colorC,04h
        call dibuCoord
        
        inc dx
        ;mov colorC,04h
        call dibuCoord
    
    
        pop cx
      inc bx  
    loop cicloxy3
   
   pop ax
   pop dx
   pop bx
   pop cx
 ret
 endp
 
     
     
     
 
 MovBarra proc
    
    cmp al,'a'
    jne otraletramov
     
     
     dec barra
     dec barra+2
     
     cmp Nivel,2
     jnae nosumx
       dec barra
       dec barra+2
     nosumx:
     
     cmp Nivel,3
     jne nosumx3
       dec barra
       dec barra+2
     nosumx3:
     
    jmp FinCambiomo
    otraletramov:
    cmp al,'d'
    jne FinCambiomo
    
    inc barra
    inc barra+2
    
    
    cmp Nivel,2
     jnae nosumxx
       inc barra
       inc barra+2
     nosumxx:
     
     cmp Nivel,3
     jne nosumx3x
       inc barra
       inc barra+2
     nosumx3x:
    
    FinCambiomo:
    
    ;verifica si se puede mover a esa direccion
    
    cmp barra,8
    jae ladoderbarr
    
         mov barra,8
       
    jmp FinBarraAn
    ladoderbarr:
    cmp barra,282
    jnae HaceMovBarr
         mov barra,282
    
    jmp FinBarraAn
    HaceMovBarr:
     
     
    FinBarraAn:
    
 
    
    mov ax,0
 ret
 endp
 
      
      
      
 
 parametBarra proc 
    
    
     push ax
     
     
     cmp posy+2,181  ;compara primera coory
     
     jnae NoEstParamB
       ; si coor de pelota es mayor o igual a posde barra
      ; si coorx inf ,mayor a param barr inf
      mov ax,posx
      cmp ax,barra
      jna otracompposx
      
           cmp ax,barra+2
             ja otracompposx
                ;hace cambio de estado
                 call cambioEstbarr
       jmp NoEstParamB      
       otracompposx:
       mov ax,posx+2
       cmp ax,barra
      jna NoEstParamB
      
           cmp ax,barra+2
             ja NoEstParamB
                ;hace cambio de estado
                 call cambioEstbarr
      
     NoEstParamB:
     
     pop ax
 ret
 endp
 
 
 cambioEstbarr proc
    cmp estadoP,3
    jne otroepe
       mov  estadoP,2
    
    jmp finotroepe
    otroepe:
    cmp estadoP,4
    jne finotroepe
       mov  estadoP,1
    
    finotroepe:
 ret
 endp
 
 
 
 
 
 
 
 
 LeeEntrada proc
    ;lee el char
    push ax
     
    
    mov ah,1
    int 16h
    
    
    
    compn0:
    cmp al,'a'
    jne compn1
            ;int 21h
            mov colorc,0 
            
	        call dibujaBarr 
	    mov al,'a'    
        call MovBarra
        
        mov colorc,4h
        call dibujaBarr
    jmp Fcompn0
    compn1:
    cmp al,'d'
    jne compn2
           ;int 21h 
           mov colorc,0
	       call dibujaBarr
	    mov al,'d'   
        call MovBarra
        
        mov colorc,4h
        call dibujaBarr
    jmp Fcompn0
    compn2:
    cmp al,'1'
    jne compn3 
        
         
         call BorraPantalla 
         call RestauraVJ
        mov Nivel,1  
        call DibIniNivel                              
        call Limite
        call dibujaBarr
        mov noBloquest,10
        call RetrocedeLetra 
        call copiaUsuario
        mov DatosX[16],'1'
        Mens DatosX
         
    jmp Fcompn0
    compn3:
    cmp al,'2'
    jne compn4
        
        
         call BorraPantalla 
         call RestauraVJ 
        mov Nivel,2 
        call DibIniNivel                              
        call Limite
        call dibujaBarr
        mov noBloquest,20
        call RetrocedeLetra 
        call copiaUsuario
        mov DatosX[16],'2'
        Mens DatosX
        
         
    jmp Fcompn0
    compn4:
    cmp al,'3'
    jne compn5 
        
         call BorraPantalla 
         call RestauraVJ
        mov Nivel,3
        call DibIniNivel                              
        call Limite
        call dibujaBarr
        mov noBloquest,30
        call RetrocedeLetra 
        call copiaUsuario
        mov DatosX[16],'3'
        Mens DatosX
         
    jmp Fcompn0
    compn5:
    cmp al,1Bh ;ESC
    jne compn6
         ;pausa pero guarda estado
         cmp estadoA,0
         jne GuardaEstado
           
            push ax
                 mov ax,estadoP
                 mov estadoA,ax
                 mov estadoP,0
           pop ax 
         jmp FinGuEst
         GuardaEstado:
         ;si tiene algo guardado restaura
           push ax
                 mov ax,estadoA
                 mov estadoP,ax
                 mov estadoA,0
           pop ax
           
        FinGuEst:
           
    jmp Fcompn0
    compn6:
    cmp al,' '
    jne Fcompn0
         
         ;SI ESTA EN MOVIMIENTO
         ;se sale de todo
         ;si esta en pausa
         ;borra vars
         cmp estadoP,0
         jne YaPresionoIni
          cmp estadoA,0
          jne YaPresionoIni
          
            mov estadoP,1
         jmp FinalProceso  
         YaPresionoIni:



          call guardaAdminData
          
          
          mov posiDI,0 
         ;se va al menu
          mov Saleju,1
         
         FinalProceso:
         
         
         
         
    Fcompn0:
    
    
    ;limpia la lectura 
    mov ah,0ch
    mov al,0
   int 21h
   
    pop ax
 ret
 endp
 
 
 
 
 RestauraVJ proc
  mov ax,0
  mov bx,0
  mov cx,0
  mov dx,0
  mov si,0
  mov di,0
  mov espacio,0
  
  mov color,4
  mov colorp,5
  mov colorc,4
  mov borrab,0
  mov nivel,1
  mov barra,130
  mov barra+2,160
  mov posicionDib,0 
  
  mov direcB,ax
  mov TIME_AUX,0
  
  mov posx,145
  mov posx+2,146
  
  mov posy,180
  mov posy+2,181
  
  mov estadoP,0
  mov estadoA,0  
  
  mov cx,10
  mov di,0
  
  mov PUNTOSGAN,0
  
  mov DatosX[23],'0'
  mov DatosX[22],'0'
  mov DatosX[16],'1'   
  
  mov DatosX[30],'0'
  mov DatosX[29],'0'
  mov DatosX[28],'0'
  
  
  mov TIEMPOHECHO,0
  mov tanterior,0
  mov noBloquest,10
  
  
  
  restauraBloque:
     
     
     mov bloques1[di],1
    
     mov bloques2[di],1
     
     mov bloques3[di],1  
     
    inc di
  loop restauraBloque
  
  mov cx,0
  mov di,0
  
  
    
    mov cx,10
    mov si,0
    
    hace101:
       mov DatosX[si],' '
       inc si
    loop hace101

  mov cx,0
  mov si,0
  
 ret
 endp
        
        
        
  
  
  RetrocedeLetra proc
     push cx
     push ax
     
     mov cx,retos
     
     retoscic:
     
         mov ah, 02
         mov dl, 08h ;07h is the value to produce the beep tone
         int 21h
     
     loop retoscic
     
     pop ax
     pop cx
  ret
  endp
  
  
  RetrocedeMax proc
     push cx
     push ax
     
     mov cx,50000
     
     retoscicx:
     
         mov ah, 02
         mov dl, 08h ;07h is the value to produce the beep tone
         int 21h
     
     loop retoscicx
     
     pop ax
     pop cx
  ret
  endp
  
  
  MuestraPuntos proc
    push ax
      ;DatosX
      ;000 25
      
      mov buffx[0],'0'
      mov buffx[1],'0'
      mov buffx[2],'0'
      
      
      mov ax,PUNTOSGAN
      call RtoC 
      mov tbuff,0
      
      mov ax,buffx[0]
      mov DatosX[23],al
      
      mov ax,buffx[1]
      mov DatosX[24],al
      
    pop ax
  ret
  endp 
  
  
  MuestraTiempo proc
    push ax
      ;DatosX
      ;000 25
      
      mov buffx[0],'0'
      mov buffx[1],'0'
      mov buffx[2],'0'
      
      mov ax,TIEMPOHECHO
      call RtoC 
      mov tbuff,0
      
      mov ax,buffx[0]
      mov DatosX[28],al
      
      mov ax,buffx[1]
      mov DatosX[29],al 
      
      mov ax,buffx[2]
      mov DatosX[30],al
      
    pop ax
  ret
  endp 
  
  
  
 guardaAdminData proc
    
      
;  IDSUSUARIOS db 10 dup(0)
;  
;  IDSTIEMPOS dw 10 dup(0)
;  
;  IDSNIVELES db 10 dup(0)  ; POR EL NUMERO
;  
;  IDSPUNTOS db  10 dup(0)
;   
;  tamaIDS dw 0  

          push di 
          push ax
          
          mov di,tamaIDS      
          
          mov ah,0
          
          mov ax,posiDI      
          mov IDSUSUARIOS[di],al      
          
          
          
          
          mov ax,TIEMPOHECHO 
           
           push di
           push ax
           push bx
             mov ax,di
             mov bx,2
             mul bx
             mov di,ax
           
              mov IDSTIEMPOS[di],ax
           
           
           pop bx
           pop ax
           pop di
         
         
          
          mov al,Nivel
          mov IDSNIVELES[di],al       
          
          mov ax,PUNTOSGAN
          mov IDSPUNTOS[di],al
          
          inc tamaIDS 
          
          
          pop ax      
          pop di
    
 ret
 endp 
  
;INICIA PARTE DE LOGIN******************************************




      
      
      
      
      
      
      
      
      
      
      
      
      
      
      



 Registrar proc 
    ;no controla si mismo nick 
    ;no controla nick vacio 
    call BorraPantalla
    
    mov si,0 ;guarda usuario
    Mens nick
    call NewR
    call BorraPantalla
    mov si,1 ;guarda usuario
    Mens pass
    call NewR
    
    inc tregistros
    ;luego de guardar los dos incrementa pos
    mov si,0
 ret
 endp 
 
 NewR proc 
   ;si SI=0 guarda Registros
   ;si SI=1 guarda Contrasena
   
   ;halla la casilla donde empieza
   mov ah,0
   mov al,tregistros
   mov bx,10
   mul bx
   
   ;inicializa la posicion a escribir
   mov di,ax
   mov cx,10
   
   ciclox0:
   
      mov ah,1h
      int 21h
      
      cmp al,13    ; si presiono enter
      je SeRegistro
      
      cmp si,0 
      jne contrax
        mov Registros[di],al
      jmp nocontrax
      contrax:
        mov Password[di],al
      nocontrax:

    inc di
   loop ciclox0
  
  SeRegistro:
  ;inc tregistros
  Mens salto
   
 ret
 endp
 
 
 
 
 Login proc 
    
    call BorraPantalla
    Mens inick
    call ComReg
             call BorraPantalla
    ;mov si,1 ;guarda usuario
    ;Mens ipass
    ;call NewR 
    
 ret   
 endp
 
 ComReg proc 
    
    
   mov bx,0;se usa abajo
   ;hace lectura de cadena: Pass o nick
   mov dx,0
   
   ReiniciaLectura:
   
   mov cx,10
   mov di,0
   mov si,0 
   
   mov tbuff,0
   
   ;recibe la cadena para comparar  
   ;si presiona enter
   ;si tam=3,rellena lo demas con 0
   
   
   ciclox2:
       
       
     cmp si,0
     je saltaComparacion
     
        mov buff[di],0                        
     jmp FinalCiclox  
     saltaComparacion:  
       mov ah,01h
       int 21h
       
       cmp al,13   ;si presiona enter
       je PresioEnter

        mov buff[di],al 
       
       jmp FinalCiclox 
       PresioEnter:
        mov si,1 
        dec di
        dec tbuff
       jmp FinalCiclox
       FinalCiclox:  
        inc di
        inc tbuff 
      
   
   loop ciclox2
   
    mov si,0
   
   
  cmp bx,1
  je HizoLecturaBuff          
             
             
             
             
             
         
   mov di,0  
   mov ch,0       
   mov cl,tRegistros
   mov bx,0
   
   ;Compara Registros
   cmp cx,0
   je esCero     ;no hay nadie registrado
     cmp tbuff,0
     je esCero   ;no ingreso usuario
    
   ciclox1:
      ;Obtiene cadena por cadena
      ;pueden haber varios iguales
           
           push cx
           
           
           
           ;comparara la cadena
           mov cx,10
           mov si,0;posicion buffer
           mov ax,0
           mov bx,2;dice si no igual
           
           ciclox3:
             mov ah,0 
             mov al,Registros[di]
               cmp al,buff[si]
               jne NoCadIgual 
             inc si
             inc di
           loop ciclox3   
           
               mov bx,1   ;si fue igual porque termino el ciclo
               pop cx
               sub di,10   ;se posiciona en lugar de origen de cadena
               mov posiDI,di
           jmp Fueigual   ;sale de las comparaciones de cadena
           NoCadIgual:
                mov bx,0
           
           SaleCiclox3:
           
           pop cx
           
      
      
      add di,10
   
   loop ciclox1
   
   
   jmp Fueigual 
   esCero:  ;no hubo comparaciones
   jmp noSehallo
   ;no se encontro         
            
            
            
   Fueigual:
   
   ;1 si fue igual
   ;0 no fue igual
   ;si fue igual en di esta la posicion de la contrasena
    cmp bx,1 
    jne otraCondi 
    
    cmp dx,1
    je ReiniciaLectura
     Mens salto 
     Mens ipass 
    jmp ReiniciaLectura  
    otraCondi:
     
    ;Lee la contrasena
    jmp noSehallo
    HizoLecturaBuff:
    
    cmp dx,1
    je LecturaPAdmin
    
    mov di ,posiDI
    ;inicia la comparacion de contrasena
           mov cx,10
           mov si,0
           ciclox6:
              mov al,buff[si]
              cmp al,Registros[di]
              jne contraMala
           
           loop ciclox6
         
         call BorraPantalla
         call IniciaJuego;INICIA EL JUEGO
         
    jmp FinalLoginx
    contraMala:
    Mens salto
    Mens errorP
     mov cx,0  
    ;pregunta si salir o reescribir  
      
    jmp ReiniciaLectura
    noSehallo:
    ;No se encontro el usuario
    ;iniciaria la comparacion de admin 
           mov cx,10
           mov di,0
           ciclox7:
              mov al,master[di]
              cmp al,buff[di]
              jne NoEsNada
             inc di
           loop ciclox7
          mov bx,1
          mov dx,1
       Mens salto
       Mens ipass
       jmp ReiniciaLectura
       LecturaPAdmin:  
           mov cx,10
           mov di,0
           ciclox8:
              mov al,buff[di]
              cmp al,cmaster[di]
              jne contraMala
             inc di
           loop ciclox8
      ;si finaliza si fue toda igual cadena
      ;seria administrador
      ;limpia registros
      ;guarda login actual
      call MuestraDatas
       
    jmp FinalLoginx
    NoEsNada:
    ;no fue admin ni usuario normal
    
    FinalLoginx:
    
    
 ret
 endp
 
 
 
 RtoC proc 
    
    push ax
    push bx
    push cx
    push dx
    push di
     ;recibe numero en ax origen
     ;buffer sera final cadena
     ;tamano buff tambien
    ;ax cociente
    ;dx residuo
    ;limpiar registros
    mov dx,0
    ;mov ax,0
    mov tbuff,0
    
    
    mov di,0
    mov cx,5
    ;mov si,bx
    ;mov ax,bx; lo pone en el numerador
    ;bx sera el denominador
    
                ;mov ax,5000 ;arriba
;                mov bx,10000;abajo
;                div bx
    ciclo991:
       
      
      
      cmp ax,0
      je ffetix 
       
        eeti5:
        cmp cx,5
        jne eeti4            
                mov bx,10000;abajo
                div bx
                call simple
        jmp ffetix
        eeti4:
        cmp cx,4
        jne eeti3
                mov bx,1000;abajo
                div bx
                call simple
        jmp ffetix
        eeti3:
        cmp cx,3
        jne eeti2
                mov bx,100;abajo
                div bx
                call simple
        jmp ffetix
        eeti2:
        cmp cx,2
        jne eeti1
                mov bx,10;abajo
                div bx
                call simple
        jmp ffetix
        eeti1:
        cmp cx,1
        jne ffetix
                mov bx,1;abajo
                div bx
                call simple
        jmp ffetix 
        
        
        
    ;mov ax,5000 ;arriba
;    mov bx,10000;abajo
;    div bx
     ffetix:
    
    
    loop ciclo991
    mov tbuff,0     
         
    pop di     
    pop dx     
    pop cx     
    pop bx     
    pop ax  
    
 ret
 endp
 
 
 
 simple proc
    
     cmp ax,0
     je CopResiduo
     
       mov di,tbuff
       add ax,'0'
       
       mov buffx[di],ax
       
       mov ax,dx
       inc tbuff
       
     jmp FinChari
     CopResiduo:
        ; si ya hay numero agrega los ceros
               cmp tbuff,0
                je asfss
                  mov di,tbuff
                  mov buffx[di],'0' 
                  inc tbuff
               asfss:
      mov ax,dx
   
   
   FinChari:
   mov dx,0  
    
 ret 
 endp
 
 
 
 
 
 copiaUsuario proc
    
    push cx
    push di
    push si
    
    
    mov cx,10
    mov di,posiDI
    mov si,0
    
    hace10:
    
       mov al,Registros[di]
       mov DatosX[si],al
     inc si
     inc di
     
    loop hace10
          
    pop si      
    pop di      
    pop cx
 ret
 endp
      
      
      
 
 MuestraDatas proc
;  IDSUSUARIOS db 10 dup(0)
;  
;  IDSTIEMPOS dw 10 dup(0)
;  
;  IDSNIVELES db 10 dup(0)  ; POR EL NUMERO
;  
;  IDSPUNTOS db  10 dup(0)
;   
;  tamaIDS dw 0   
    push cx
    push di
    push ax
    
    mov cx,15;limpia data
    mov di,0
    
    ciccc10:
    
        mov cadeDatas[di],' '        
           
    loop ciccc10
    
    Mens Datasm
    
    mov cx,10
    mov di,0
    
     
    cicc10:
    
    mov al,IDSUSUARIOS[di]
    add al,'0'
    mov cadeDatas[0],al
                        
    
        mov cadeDatas[1],' '
    
    
    
    
                        
    mov ax,IDSTIEMPOS[di]
                 
    cmp ax,0
    je meteceros
    
    call RtoC
    
    mov al,buff[0]
    mov cadeDatas[2],al
    mov al,buff[1]
    mov cadeDatas[3],al
    mov al,buff[2]
    mov cadeDatas[4],al 
    
    JMP FINmeteceros
    meteceros:
    mov cadeDatas[2],'0'
    mov cadeDatas[3],'0'
    mov cadeDatas[4],'0'
    FINmeteceros:
    
    
    
    
    
     
        mov cadeDatas[5],' '
     
    mov al,IDSNIVELES[di]
    add al,'0'
    mov cadeDatas[6],al
    
     
         mov cadeDatas[7],' '
    
    mov ah,0 
    mov al,IDSPUNTOS[di]
    
    cmp ax,0
    je meteceros2
    
    call RtoC
    
    mov al,buff[0]
    mov cadeDatas[8],al
    mov al,buff[1]
    mov cadeDatas[9],al 
    
    jmp FINmeteceros2
    meteceros2:
    mov cadeDatas[8],'0'
    mov cadeDatas[9],'0'
   
    FINmeteceros2:
    
    
    
    Mens cadeDatas
    
   loop cicc10 
   
    mov al,0
    mov ah,1
    int 21h 
    
    pop ax
    pop di 
    pop cx 
 ret
 endp
 
 
 
end    


 

    

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 