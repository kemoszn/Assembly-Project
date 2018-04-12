bits 16
org 0x7C00

mov ah ,0x02
mov al ,8
mov dl ,0x80
mov dh ,0
mov ch ,0
mov cl ,2
mov bx ,Start
int 0x13
jmp Start
    

;;;;;;;;;;;;
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
;;;;;;;;;;
Start:

TheBigLoop:
	
	 xor eax , eax 
	 mov edi, 0xB8000
	 mov esi, 0xB8000
	 xor ebx,ebx
	 mov edx, MainMenu
	 loopA:
	 mov al, [edx]
	 mov byte [edi], al
	 inc edi
	 inc edi
	 inc edx
	 inc bx
	 call cursor
	 cmp byte[edx],0
	 jne loopA;
checkStatus:
	in  al , 0x64
	and al, 1
	jz checkStatus
	in al, 0x60
        mov bl,al
        cmp bl , 0x82
	je _activateMouse 
	cmp al , 0x83
	je Activate_Keyboard
	call Clear_Screen
	jmp TheBigLoop
	
cursor:
pushad
mov al,0x0f
mov dx,0x03D4
out dx,al

mov al,bl
mov dx,0x03D5
out dx,al

xor eax,eax

mov al,0x0e
mov dx,0x03D4
out dx,al

mov al,bh
mov dx ,0x03D5
out dx,al

popad
ret

 _activateMouse:
jmp Mouse


Clear_Screen:
cmp edi,0xB8000
je LET
loopC:
	mov al,0x20
	mov [edi],al
	sub edi,2
	cmp edi,0xB8000
	jg loopC

LET:
xor ebx,ebx
call cursor
ret

Activate_Keyboard:
call Clear_Screen
mov edx,ShapeMenu
LoopD:
mov al,[edx]
mov byte [edi],al
inc edi
inc edi
inc edx
inc ebx
call cursor
cmp byte[edx],0
jne LoopD

Check_Pressed_Key:
in al,0x64
and al,1
jz Check_Pressed_Key
in al, 0x60
cmp al,0x1C
jne LET2


LET2:
cmp al,0x01
je Activate_Keyboard
cmp al,0x1C
je Activate_Keyboard
cmp al,0x36
je Activate_Keyboard
cmp al,0x2A
je Activate_Keyboard
cmp al,0x0E
je Activate_Keyboard
cmp al,0x1E
je Activate_Keyboard
je Blue

cmp al,0x30
je Activate_Keyboard
je Red
cmp al,0x2E
je Activate_Keyboard
je Green

cmp al,0x02
je Circle
cmp al,0x03
je Square
cmp al,0x04
je Rectanfull
cmp al,0x05
je Rectangle
call Clear_Screen
jmp Activate_Keyboard


exit:
		cli
		mov ah , 0
		mov al , 3h
		int 0x10

	call Clear_Screen
	jmp TheBigLoop

MainMenu: db 'A.Press 1 for free drawing',10
          db'B.Press 2 for Shapes',10,0
ColorMenu: db'-Press A for Blue',10
            db '-Press B for Red',10
            db '-Press C for Green',10
            db '-Press F for White',10,0
ShapeMenu: db 'i.Press 1 for Circle',10
           db 'ii.Press 2 for Square',10
           db 'iii.Press 3 for Filled Rectangle',10
           db 'iv.Press 4 for Rectangle Outline',10
           db ' press ESC in ShapesMenu to return to MainMenu',10,0

;;;;;;;;;;;;;;;;


	
Mouse:
cli
         mov al,13h ;Graphics video mode
        int 10h
        jmp Activate_Keyboard 
 mov esi,ColorMenu
 LoopN:
mov al,[edx]
mov byte [edi],al
inc edi
inc edi
inc esi
inc ebx
call cursor
cmp byte[esi],0
jne LoopN
     
biglop:
    call writecheck
    mov al,0xf4
    call writetomouse ;;;;;;;;;; enable
    xor eax,eax
    xor ecx,ecx
    nokey:
    
    in al, 0x64
    and al, 0x20 ;;;;;;;;;;check if it's a mouse not a keyboard
    jz nokey
    
    call readfrommouse;;;; status

    
    and al,03h
    cmp al,0
    je nothing
    cmp al,01h 
    je draw
    
    jmp delete
    
delete:
    mov ah,0Ch 	; function 0Ch
    mov al,0 	; color 4 - black
    mov cx,[xm] 	; x position 
    mov dx,[ym] 	; y position 
    int 10h 	;    call BIOS service
    
    
    
nnxt:    
    draw:
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add ax,[xm]
    mov [xm],ax
    
    mov ax,[deltay]
    
    sub [ym],ax
 
    Blue:
    
    mov al,1
    mov ah,0ch
    mov cx,[xm]
    mov dx,[ym]
    int 10h
    
    Red:
    
    mov al,4
    mov ah,0ch
    mov cx,[xm]
    mov dx,[ym]
    int 10h
    
    Green:
    
    mov al,2
    mov ah,0ch
    mov cx,[xm]
    mov dx,[ym]
    int 10h
    
    White:
    
    mov al,15
    mov ah,0ch
    mov cx,[xm]
    mov dx,[ym]
    int 10h

    
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
    nothing:
    
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add [xm],ax
    
    mov ax,[deltay]
    
    sub [ym],ax
            
    mov al,0h
    mov ah,0ch
    mov cx,[xm]
    mov dx,[ym]
    int 10h
    
    call readfrommouse ;;;; scroll
    jmp nokey

writecheck:
    mov ecx,1000
    one:    
    in al,0x64
    and al,02h ;;;;;;;;is there a something that can write to
    jz nxt
    loop one
    
nxt:
    ret
readcheck:
    mov ecx,1000
    two:
    in al,0x64
    and al,01h ;;;;;;;;is theresomething can read from
    jnz nxxt
    loop two
    
nxxt:
    ret
writetomouse:
    mov dh,al
    call writecheck ;;;;can you w
    mov al,0xd4
    out 0x64,al
    call writecheck
    mov al,dh
    out 0x60,al
    call readcheck
    in al,0x60
    ret
readfrommouse:
call readcheck
in al,0x60
ret

deltax: dw 0
deltay: dw 0
xm: dw 0
ym: dw 0





;;;;;;;;;;;;;;;;;;
Square:

cli

jmp Drawsquare
;;;;;;;;;;;;;;
 length: dw 75
 xsc: dw 160
 ysc: dw 100
 xs: dw 0
 ys: dw 0
 squareerror: dw 0
 coloursquare: dw 9 ;blue
 
 ;;;;;;;;;;;;;;;;;;;;;
 Drawsquare:; use the bresenhams algorithms
 videographicssquare:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 squarepixels:
 mov ah,0ch
 mov al, [coloursquare]
 
 
 Drawloop:
 mov bx, [length]
 mov [xs],bx
 ;condition is x>y
 ;sinc we are creating a square the condition is only tested once 
 mov bx,[xs] 
 cmp bx,[ys]
 jl done
 
 
Plotpixels:
 ;(xsc+x,ysc+y)
 mov cx, [xsc]
 add cx, [xs]
 mov dx, [ysc]
 add dx,[ys]
 int 10h
 ;(xsc+x,ysc-y)
 mov cx, [xsc]
 add cx, [xs]
 mov dx, [ysc]
 sub dx,[ys]
 int 10h
 ;(xsc-x,ysc+y)
 mov cx, [xsc]
 sub cx, [xs]
 mov dx, [ysc]
 add dx,[ys]
 int 10h
 ;(xsc-x,ysc-y)
 mov cx, [xsc]
 sub cx, [xs]
 mov dx, [ysc]
 sub dx,[ys]
 int 10h
 ;(xsc+y,ysc+x)
 mov cx, [xsc]
 add cx, [ys]
 mov dx, [ysc]
 add dx,[xs]
 int 10h
 ;(xsc+y,ysc-x)
 mov cx, [xsc]
 add cx, [ys]
 mov dx, [ysc]
 sub dx,[xs]
 int 10h
 ;(xsc-y,ysc+x)
 mov cx, [xsc]
 sub cx, [ys]
 mov dx, [ysc]
 add dx,[xs]
 int 10h
 ;(xsc-y,ysc-x)
 mov cx, [xsc]
 sub cx, [ys]
 mov dx, [ysc]
 sub dx,[xs]
 int 10h
 
 ; Update state values and check square error:
 mov dx,[ys]
 inc dx
 mov [ys],dx
 add dx,dx
 inc dx
 add dx,[squareerror]
 mov [squareerror],dx
 sub dx,[xs]
 add dx,dx
 js Drawloop
 inc dx
 
  dec cx
  mov [xs],cx
  add cx,cx
  neg cx
  inc cx
  add [squareerror],cx
  jmp Drawloop
   
done:
ret      

;;;;;;;
;;;;;;;;;;;
Rectanfull:
cli
;;;;;;;
mov ax,13h
int 10h

mov byte [alt],50
mov byte [comp],100
mov dx,100
mov cx,100
tang:
rec:
mov ah,0ch
mov al,23h
mov bh,0
int 10h
dec cx
dec byte [comp]
jnz rec
mov cx,100
mov byte [comp],100
dec dx
dec byte [alt]
jnz tang

mov ah,07h
int 21h
mov ah,4ch
int 21h

ret 
comp db 1
alt  db 1
;;;;;;;;;;;;;;;;
Rectangle:
cli
jmp Drawrectangle
;;;;;;;;;;;;;;;;;
 xr1: dw 25
 yr1: dw 100
 xr2: dw 250
 yr2: dw 50
 xr: dw 0
 yr: dw 0
rectangulecolour: dw 9
;;;;;;;;;;;;;;;;;
rectanglepixels:
 mov ah,0ch
 mov al, [rectangulecolour]
 mov cx, [xr]
 mov dx, [yr]
 int 10h
 ret

Drawrectangle:; use the bresenhams algorithms
videographicsrectangle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 
 
 
 Drawrectangleloop: 
 mov cx,[xr1]
 mov [xr],cx
 mov dx,[yr1]
 mov [yr],dx
 
 width1:
 call rectanglepixels
 inc cx
 mov [xr],cx
 cmp cx, [xr2]
 jl width1
 
 
mov ax,[xr2]
mov [xr],ax
mov ax,[yr1]
mov [yr],ax

 height1:
 call rectanglepixels
 dec dx
 mov [yr],dx
 cmp dx,[yr2]
 jg height1

 mov ax,[xr2]
 mov [xr],ax
 mov ax,[yr2]
 mov [yr],ax
 
 width2:
 call rectanglepixels
 dec cx
 mov [xr],cx
 cmp cx, [xr1]
 jg width2
 
 
mov ax,[xr1]
mov [xr],ax
mov ax,[yr2]
mov [yr],ax

 height2:
 call rectanglepixels
 inc dx
 mov [yr],dx
 cmp dx,[yr1]
 jl height2
 ret


;;;;;;;
Circle:

cli
jmp Drawcircle
;;;;;;;;;;;;;;;;;;;;;;;;;;;
 radius: dw 75
 xc: dw 160
 yc: dw 100
 x: dw 0
 y: dw 0
 err: dw 0
 column: dw 0
 row: dw 0
 ;;;;;;;;;;;;;;;;;;
 circlepixels:
 mov ah,0ch
 mov al, 9
 mov cx,[column]
 mov dx,[row]
 int 10h
 ret
 
 Drawcircle:
 videographics:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 
 DrawloopCircle:
 mov bx, [radius]
 mov [x],bx 
 
PlotpixelsCircle:

;condition is x>y
mov bx,[x]
cmp bx,[y]
jl done
 ;(xc+x,yc+y)
 mov cx, [xc]
 add cx, [x]
 mov [column],cx
 mov dx, [yc]
 add dx,[y]
 mov [row], dx
 call circlepixels
 ;(xc+x,yc-y)
 mov cx, [xc]
 add cx, [x]
 mov [column],cx
 mov dx, [yc]
 sub dx,[y]
 mov [row], dx
 call circlepixels
 ;(xc-x,yc+y)
 mov cx, [xc]
 sub cx, [x]
 mov [column],cx
 mov dx, [yc]
 add dx,[y]
 mov [row], dx
 call circlepixels
 ;(xc-x,yc-y)
 mov cx, [xc]
 sub cx, [x]
 mov [column],cx
 mov dx, [yc]
 sub dx,[y]
 mov [row], dx
 call circlepixels
 ;(xc+y,yc+x)
 mov cx, [xc]
 add cx, [y]
 mov [column],cx
 mov dx, [yc]
 add dx,[x]
 mov [row], dx
 call circlepixels
 ;(xc+y,yc-x)
 mov cx, [xc]
 add cx, [y]
 mov [column],cx
 mov dx, [yc]
 sub dx,[x]
 mov [row], dx
 call circlepixels
 ;(xc-y,yc+x)
 mov cx, [xc]
 sub cx, [y]
 mov [column],cx
 mov dx, [yc]
 add dx,[x]
 mov [row], dx
 call circlepixels
 ;(xc-y,yc-x)
 mov cx, [xc]
 sub cx, [y]
 mov [column],cx
 mov dx, [yc]
 sub dx,[x]
 mov [row], dx
 call circlepixels
 
 ; Update state values and check error:
        cmp word [err], 0
	jge greater
	inc word [y]
	mov ax ,[y]
	add ax,ax
	inc ax
	add ax,[err]
        mov [err],ax
	jmp PlotpixelsCircle

	greater:
	dec word [x]
	mov ax , [x]
	add ax,ax
        neg ax
	inc ax
	add ax,[err]
        mov [err],ax	
	jmp PlotpixelsCircle
  
Done:   
ret   
      ;;;;;;   
      
      
      ;;;;;;;;
     
times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00