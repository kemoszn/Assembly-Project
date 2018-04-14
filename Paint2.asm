bits 16
org 0x7C00
	cli
	;WRITE YOUR CODE HERE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

mov ah ,0x02
mov al ,8
mov dl ,0x80
mov dh ,0
mov ch ,0
mov cl ,2
mov bx ,Start
int 0x13
jmp Start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
cmp al,0x50
je Activate_Keyboard
cmp al,0x48
je Activate_Keyboard
cmp al,0x0E
je Activate_Keyboard


cmp al,0x02
je Circle
cmp al,0x03
je Square
cmp al,0x04
je Pyramid
cmp al,0x05
je Rectangle
cmp al,0x06
je RigTriangle
cmp al,0x07
je IsoTriangle
cmp al,0x08
je EquTriangle
cmp al,0x09
je Trapizum
cmp al,0x0A
je Diamond
cmp al,0x1E
je FilledCircle
cmp al,0x30
je FilledRectangle
call Clear_Screen
jmp Activate_Keyboard

Activate_Keyboard2:
call Clear_Screen
mov edx,ColourMenu
LoopD2:
mov al,[edx]
mov byte [edi],al
inc edi
inc edi
inc edx
inc ebx
cmp byte[edx],0
jne LoopD2

Check_Pressed_Key2:
in al,0x64
and al,1
jz Check_Pressed_Key2
in al, 0x60
cmp al,0x1C
jne LET22


LET22:
cmp al,0x02
je white
cmp al,0x03
je green
cmp al,0x04
je red
cmp al,0x05
je blue
call Clear_Screen
jmp Activate_Keyboard2

white:
   mov dx,15
   mov [colour],dx
   ret 
green:
   mov dx,2
   mov [colour],dx
   ret 
red:
   mov dx,4
   mov [colour],dx
   ret 
blue:
   mov dx,1
   mov [colour],dx
   ret 
   
exit:
		cli
		mov ah , 0
		mov al , 3h
		int 0x10

	call Clear_Screen
	jmp TheBigLoop

MainMenu: db 'A.Press 1 for free drawing',10
          db'B.Press 2 for Shapes',10,0

ShapeMenu: db 'i.Press 1 for Circle',10
           db 'ii.Press 2 for Square',10
           db 'iii.Press 3 for Pyramid',10
           db 'iv.Press 4 for Rectangle',10
           db 'v.Press 5 for Rightangle Triangle',10
           db 'vi.Press 6 for IsoscelesTriangle ',10
           db 'vii.Press 7 for EquilateralTriangle',10
           db 'viii.Press 8 for Trapizum',10
           db 'ix.Press 9 for Diamond',10
           db 'x.Press A for Filled Circle',10
           db 'xi.Press B for Filled Rectangle',10
           db ' press ESC in ShapesMenu to return to MainMenu',10,0

ColourMenu: db 'A.press 1 for white',10
           db 'B.press 2 for green',10
           db 'C.press 3 for red',10
           db 'D.press 4 for blue',10,0
colour: dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mouse:
        
        mov al,13h 
        int 10h  ;;;;;;; VGA Mode	
    ;;;;;;;;;;; A little something
    call Color_Screen_red
    call Halt
    call Color_Screen_green
    call Halt
    call Color_Screen_blue
    call Halt          
bigloop: 
    ;;;;;;;; setups
    call Color_Screen
    call Draw_Color_Menue
    ;;;;;;;; Enabling The mouse
    call writecheck
    mov al,0xf4
    call writetomouse ;;;;;;;;;; enable
    xor eax,eax
    xor ecx,ecx
    nokey:
    
    
    in al, 0x64
    and al, 0x20 ;;;;;;;;;;check if it's a mouse not a keyboard ,,, bit number 5 is always 1 in case of the mouse
    jz nokey
    
    call readfrommouse;;;; status

    
    and al,11b
    mov [status],al
    cmp al,0
    je nothing
    cmp al,01h 
    je draw
    jmp delete
    
delete:
    mov ah,0Ch 	; function 0Ch
    mov al,[background_colour] ; colour 4 - white
    mov cx,[x] 	; x position 
    mov dx,[y] 	; y position 
    int 10h 	;    call BIOS service
    
    
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add ax,[x]
    mov [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    call check_border
    mov cx,[x]
    cmp cx,319
    jl noend_delete
    mov dx,[y]
    cmp dx,199
    jge bigloop
noend_delete:    
    mov cx,[x]
    cmp cx,60
    jg same_delete    
    call colour_menu_background
    jmp next1_delete
same_delete:
    mov ax,15
    mov [background_colour],ax
    next1_delete:    
    mov al,58
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
    draw:
    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add ax,[x]
    mov [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    call check_border
    ;mov cx,[x]
;    cmp cx,319
;    jl noend
;    mov dx,[y]
;    cmp dx,199
;    jge bigloop
;noend:    
    mov cx,[x]
    cmp cx,60
    jg same    
    call colour_menu_background
    jmp next1
same:
    mov ax,15
    mov [background_colour],ax
    next1:    
    mov al,[draw_colour]
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
    
    
    nothing:
    
    mov ah,0Ch 	; function 0Ch
    mov al,[background_colour] 	; colour 15 - white
    mov cx,[x] 	; x position 
    mov dx,[y] 	; y position 
    int 10h 	;    call BIOS service
    
    
    

    call readfrommouse ;;;;;; delta x
    movsx dx,al
    mov [deltax],dx
    call readfrommouse ;;;;;; delta y
    movsx ax,al
    mov [deltay],ax
    
    mov ax,[deltax]
    add ax,[x]
    mov [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    
   call check_border
    
    mov cx,[x]
    cmp cx,60
    jg same1    
    ;mov ax,1000b
;    mov [background_colour],ax
    call colour_menu_background
    jmp next2
same1:                 
    mov ax,15
    mov [background_colour],ax
    next2:
    mov al,[draw_colour]
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
  
    check_border:
    mov ax,[x]
    cmp ax,0
    jge  bo1
    mov ax,0
    mov [x],ax
    bo1:
    mov ax,[x]
    cmp ax,319
    jle bo2
    mov ax,319
    mov [x],ax
    bo2:
    
    mov ax,[y]
    cmp ax,0
    jge  bo3
    mov ax,0
    mov [y],ax
    bo3:
    mov ax,[y]
    cmp ax,199
    jle bo4
    mov ax,199
    mov [y],ax
    bo4:      
    ret
      
;;;;;;;;;;;;; Check if the mouse can be written to          
writecheck:
    mov ecx,1000
    one:    
    in al,0x64
    and al,02h ;;;;;;;;is there a something that can write to
    jz nxt
    loop one
    
nxt:
    ret
    
;;;;;;;;;;;;;;;; check if the mouse can be read from    
readcheck:
    mov ecx,1000
    two:
    in al,0x64
    and al,01h ;;;;;;;;is theresomething can read from
    jnz nxxt
    loop two
    
nxxt:
    ret
;;;;;;;;;;;;;; send a massage to the mouse 
writetomouse:
    mov dh,al ;;;; al = 0xf4
    call writecheck ;;;;can you w
    mov al,0xd4 ;;;;; notify the mouse that its going to recive a msg from user
    out 0x64,al
    call writecheck
    mov al,dh
    out 0x60,al
    call readcheck
    in al,0x60 ;;;;;; read response
    ret
    
;;;;;;;;;;;;; read a massage from the mouse    
readfrommouse:
call readcheck
in al,0x60
ret


;;;;;;;;;;;;;; colours the screen white
Color_Screen:
    mov cx,320
Color_Screen_cxloop:
    mov dx,200
Color_Screen_dxloop: 
    mov al,15
    mov ah,0ch
    int 10h
    dec dx
    cmp dx,0
    jl Color_Screen_dxdone
    jmp Color_Screen_dxloop
Color_Screen_dxdone:
    dec cx
    cmp cx,0
    jl Color_Screen_cxdone
    jmp Color_Screen_cxloop    
Color_Screen_cxdone:
ret  







;;;;;;;;;;;; draws the left window to choose your colour
Draw_Color_Menue:
    mov cx,60
Draw_Color_Menue_cxloop:
    mov dx,0
Draw_Color_Menue_dxloop: 
    mov al,1000b
    mov ah,0ch
    int 10h
    inc dx
    cmp dx,200
    jge Draw_Color_Menue_dxdone
    jmp Draw_Color_Menue_dxloop
Draw_Color_Menue_dxdone:
    dec cx
    cmp cx,0
    jl Draw_Color_Menue_cxdone
    jmp Draw_Color_Menue_cxloop    
Draw_Color_Menue_cxdone:

;;;;;;;;;;; each colour takes 40 and has 5 above and underneath and left and right
;;;;;;;;;;; x starts at 5 and ends at 55
;;;;;;;;;;; y  starts at 5 and ends at 195 
    
    mov cx,5
    mov si,55      
    mov dx,5
    mov di,45
    mov bx,0 ;;;;;;; black
    call Draw_Square
    mov cx,5
    mov dx,55
    mov di,95
    mov bx,0100b ;;;;;; red
    call Draw_Square
    mov cx,5
    mov dx,105
    mov di,145
    mov bx,0001b ;;;;;;;; blue
    call Draw_Square
    mov cx,5
    mov dx,155
    mov di,195
    mov bl,0010b ;;;;;;;; green 
    call Draw_Square
       
ret   

Draw_Square:
    mov word[tmp],dx
Draw_Square_cxloop:
    mov dx,[tmp]
Draw_Square_dxloop: 
    mov al,bl
    mov ah,0ch
    int 10h
    inc dx
    cmp dx,di
    jge Draw_Square_dxdone
    jmp Draw_Square_dxloop
Draw_Square_dxdone:
    inc cx
    cmp cx,si
    jg Draw_Square_done
    jmp Draw_Square_cxloop   
 
Draw_Square_done: 
ret


colour_menu_background:
mov cx,[x]
mov dx,[y]


cmp cx,5
jge forward
jmp now
forward:
cmp cx,55
jg now
cmp dx,5
jge l
jmp now
l:
cmp dx,195
jg now

black1:
cmp dx,44
jg outofblack
mov ax,0
mov [background_colour],ax
cmp word[status],1
je pressblack
jmp nopressblack
pressblack:
mov [draw_colour],ax
nopressblack:
jmp colour_menu_background_done
outofblack:
cmp dx,55
jl border1
jmp red1
border1:
cmp dx,44
jg now
red1:
cmp dx,94
jg outofred
mov ax,0100b
mov [background_colour],ax
cmp word[status],1
je pressred
jmp nopressred
pressred:
mov [draw_colour],ax
nopressred:
jmp colour_menu_background_done
outofred:
cmp dx,105
jl border2
jmp blue1
border2:
cmp dx,94
jg now
blue1:
cmp dx,144
jg outofblue
mov ax,0001b
mov [background_colour],ax
cmp word[status],1
je pressblue
jmp nopressblue
pressblue:
mov [draw_colour],ax
nopressblue:
jmp colour_menu_background_done
outofblue:
cmp dx,155
jl border3
jmp green1
border3:
cmp dx,144
jg now
green1:
cmp dx,194
jg outofgreen
mov ax,0010b
mov [background_colour],ax
cmp word[status],1
je pressgreen
jmp nopressgreen
pressgreen:
mov [draw_colour],ax
nopressgreen:
jmp colour_menu_background_done

outofgreen:
jmp now

colour_menu_background_done:
ret



now:
mov ax,1000b
mov [background_colour],ax
jmp colour_menu_background_done



Color_Screen_red:
    mov dx,200
Color_Screen_red_dxloop:
    mov cx,320
Color_Screen_red_cxloop: 
    mov al,0100b
    mov ah,0ch
    int 10h
    dec cx
    cmp cx,0
    jl Color_Screen_red_cxdone
    jmp Color_Screen_red_cxloop
Color_Screen_red_cxdone:
    dec dx
    cmp dx,0
    jl Color_Screen_red_dxdone
    jmp Color_Screen_red_dxloop    
Color_Screen_red_dxdone:
ret  

Color_Screen_green:
    mov cx,0
Color_Screen_green_cxloop:
    mov dx,0
Color_Screen_green_dxloop: 
    mov al,0010b
    mov ah,0ch
    int 10h
    inc dx
    cmp dx,200
    jg Color_Screen_green_dxdone
    jmp Color_Screen_green_dxloop
Color_Screen_green_dxdone:
    inc cx
    cmp cx,320
    jg Color_Screen_green_cxdone
    jmp Color_Screen_green_cxloop    
Color_Screen_green_cxdone:
ret


Color_Screen_blue:
    mov dx,0
Color_Screen_blue_dxloop:
    mov cx,0
Color_Screen_blue_cxloop: 
    mov al,0001b
    mov ah,0ch
    int 10h
    inc cx
    cmp cx,320
    jg Color_Screen_blue_cxdone
    jmp Color_Screen_blue_cxloop
Color_Screen_blue_cxdone:
    inc dx
    cmp dx,200
    jg Color_Screen_blue_dxdone
    jmp Color_Screen_blue_dxloop    
Color_Screen_blue_dxdone:
ret



Halt:
mov esi,10000
Halt_loop:
mov ecx,1000
halt_loop:
nop
nop
nop
nop
loop halt_loop
dec esi
cmp esi,0
jle halt_done
jmp Halt_loop

halt_done:
ret

tmp: dw 0
deltax: dw 0
deltay: dw 0
x: dw 0
y: dw 0
draw_colour: dw 0
background_colour: dw 15
status: dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Circle:
call Activate_Keyboard2
cli

jmp Drawcircle
;;;;;;;;;;;;
 radiusfc: dw 75
 xcc: dw 160
 ycc: dw 100
 xc: dw 0
 yc: dw 0
 circleerror: dw 0
 columnc: dw 0
 rowc: dw 0
 ;colour: dw 0
 
 
 circlepixels:
 mov ah,0ch
 mov al, [colour]
 mov cx,[columnc]
 mov dx,[rowc]
 int 10h
 ret
 
 Drawcircle:
 videographicsforcircle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 
 Drawcircleloop:
 mov bx, [radiusfc]
 mov [xc],bx 
 
Plotcirclepixels:

;condition is x>y
mov bx,[xc]
cmp bx,[yc]
jl donecircle
 ;(xc+x,yc+y)
 mov cx, [xcc]
 add cx, [xc]
 mov [columnc],cx
 mov dx, [ycc]
 add dx,[yc]
 mov [rowc], dx
 call circlepixels
 ;(xc+x,yc-y)
 mov cx, [xcc]
 add cx, [xc]
 mov [columnc],cx
 mov dx, [ycc]
 sub dx,[yc]
 mov [rowc], dx
 call circlepixels
 ;(xc-x,yc+y)
 mov cx, [xcc]
 sub cx, [xc]
 mov [columnc],cx
 mov dx, [ycc]
 add dx,[yc]
 mov [rowc], dx
 call circlepixels
 ;(xc-x,yc-y)
 mov cx, [xcc]
 sub cx, [xc]
 mov [columnc],cx
 mov dx, [ycc]
 sub dx,[yc]
 mov [rowc], dx
 call circlepixels
 ;(xc+y,yc+x)
 mov cx, [xcc]
 add cx, [yc]
 mov [columnc],cx
 mov dx, [ycc]
 add dx,[xc]
 mov [rowc], dx
 call circlepixels
 ;(xc+y,yc-x)
 mov cx, [xcc]
 add cx, [yc]
 mov [columnc],cx
 mov dx, [ycc]
 sub dx,[xc]
 mov [rowc], dx
 call circlepixels
 ;(xc-y,yc+x)
 mov cx, [xcc]
 sub cx, [yc]
 mov [columnc],cx
 mov dx, [ycc]
 add dx,[xc]
 mov [rowc], dx
 call circlepixels
 ;(xc-y,yc-x)
 mov cx, [xcc]
 sub cx, [yc]
 mov [columnc],cx
 mov dx, [ycc]
 sub dx,[xc]
 mov [rowc], dx
 call circlepixels
 
 ; Update state values and check error:
        cmp word [circleerror], 0
	jge greatercircle
	inc word [yc]
	mov ax ,[yc]
	add ax,ax
	inc ax
	add ax,[circleerror]
        mov [circleerror],ax
	jmp Plotcirclepixels

   greatercircle:
	dec word [xc]
	mov ax , [xc]
	add ax,ax
        neg ax
	inc ax
	add ax,[circleerror]
        mov [circleerror],ax	
	jmp Plotcirclepixels
  
donecircle: 
ret      

;;;;;;;;;;;;;;;;
Diamond:
call Activate_Keyboard2
cli
jmp Drawdiamond


 radiusdiam: dw 75
 xdiamc: dw 160
 ydiamc: dw 100
 xdiam1: dw 0
 ydiam1: dw 0
 xdiam2: dw 0
 ydiam2: dw 0
 xdiam3: dw 0
 ydiam3: dw 0
 xdiam4: dw 0
 ydiam4: dw 0
diamonderror: dw 0
;diamondcolour: dw 9


Drawdiamond:; use the bresenhams algorithms
videographicsdiamond:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 diamondpixels:
 mov ah,0ch
 mov al, [colour]
 
 Drawdiamondloop: 
 getcoordinates:
 mov cx, [xdiamc]
 mov dx, [ydiamc]
 add cx,[radiusdiam]
 mov [xdiam1],cx
 mov [ydiam1],dx
 int 10h
 
  mov cx, [xdiamc]
 mov dx, [ydiamc]
 sub dx,[radiusdiam]
 mov [xdiam2],cx
 mov [ydiam2],dx
  int 10h
  
 mov cx, [xdiamc]
 mov dx, [ydiamc]
 sub cx,[radiusdiam]
 mov [xdiam3],cx
 mov [ydiam3],dx
  int 10h
 
 mov cx, [xdiamc]
 mov dx, [ydiamc]
 add dx,[radiusdiam]
 mov [xdiam4],cx
 mov [ydiam4],dx
  int 10h
 
 xor cx,cx
 xor dx,dx
 
 
  getline:
 mov cx,[xdiam1]
 mov dx,[ydiam1] 
diamline1:
 int 10h
 dec cx
 dec dx
 cmp cx, [xdiam3]
 cmp dx, [ydiam2]
 jnz diamline1 

 mov cx,[xdiam3]
 mov dx,[ydiam3]
 diamline2:
 int 10h
 inc cx
 dec dx
 cmp cx, [xdiam1]
 cmp dx, [ydiam2]
 jnz diamline2
 
 mov cx,[xdiam4]
 mov dx,[ydiam4]
 diamline3:
 int 10h
 dec cx
 dec dx
 cmp cx, [xdiam3]
 cmp dx, [ydiam1]
 jnz diamline3
 
 mov cx,[xdiam1]
 mov dx,[ydiam1]
 
 diamline4:
 int 10h
 dec cx
 inc dx
 cmp cx, [xdiam3]
 cmp dx, [ydiam4]
 jnz diamline4
 ret
 
 
 ;;;;;;;;;;;;;;;;;;;;;;
 EquTriangle:
call Activate_Keyboard2
 cli
 
 jmp Drawequtriangle

 radiusequt: dw 75
 xequtc: dw 160
 yequtc: dw 100
 xequt1: dw 0
 yequt1: dw 0
 xequt2: dw 0
 yequt2: dw 0
 xequt3: dw 0
 yequt3: dw 0

;equtrianglecolour: dw 9


Drawequtriangle:
videographicsequtriangle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 equtrianglepixels:
 mov ah,0ch
 mov al, [colour]
 
 Drawequtriangleloop: 
 getcoordinatesforequtriangle:
 mov cx, [xequtc]
 mov dx, [yequtc]
 add cx,[radiusequt]
 mov [xequt1],cx
 mov [yequt1],dx
 int 10h
 
  mov cx, [xequtc]
 mov dx, [yequtc]
 sub dx,[radiusequt]
 mov [xequt2],cx
 mov [yequt2],dx
  int 10h
  
 mov cx, [xequtc]
 mov dx, [yequtc]
 sub cx,[radiusequt]
 mov [xequt3],cx
 mov [yequt3],dx
  int 10h
 
 
 
  getlineequtriangle:
 mov cx,[xequt1]
 mov dx,[yequt1] 
equtline1:
 int 10h
 dec cx
 dec dx
 cmp cx, [xequt3]
 cmp dx, [yequt2]
 jnz equtline1 

 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline2:
 int 10h
 inc cx
 dec dx
 cmp cx, [xequt1]
 cmp dx, [yequt2]
 jnz equtline2
 
 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline3:
 int 10h
 inc cx
 cmp cx, [xequt1]
 jnz equtline3

 ret
 ;;;;;;;;;;;;;;;;;;;;;;;;
 FilledCircle:
 call Activate_Keyboard2
 cli
 
 jmp Drawfilledcircle
    
 radiusfic: dw 75
 xfc: dw 160
 yfc: dw 100
 xf: dw 0
 yf: dw 0
 filledcircleerror: dw 0
 columnfc: dw 0
 rowfc: dw 0
 circlefc: dw 0
 ;filledcolour: dw 9
 
 filledcirclepixels:
 mov ah,0ch
 mov al, [colour]
 mov cx,[columnfc]
 mov dx,[rowfc]
 int 10h
 ret
 
 Drawfilledcircle:
 videographicsforfilledcircle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 
 Drawfilledcircleloop:
 mov bx, [radiusfic]
 mov [xf],bx 
 mov word [yf],0
 mov word [filledcircleerror],0
 xor esi,esi
Plotfilledcirclepixels:
;condition is x>y to continue
        mov bx,[xf]
        cmp bx,[yf]	
	jl donefilledcircleloop
 ;(xc+x,yc+y)
 mov cx, [xfc]
 add cx, [xf]
 mov [columnfc],cx
 mov dx, [yfc]
 add dx,[yf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc+x,yc-y)
 mov cx, [xfc]
 add cx, [xf]
 mov [columnfc],cx
 mov dx, [yfc]
 sub dx,[yf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc-x,yc+y)
 mov cx, [xfc]
 sub cx, [xf]
 mov [columnfc],cx
 mov dx, [yfc]
 add dx,[yf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc-x,yc-y)
 mov cx, [xfc]
 sub cx, [xf]
 mov [columnfc],cx
 mov dx, [yfc]
 sub dx,[yf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc+y,yc+x)
 mov cx, [xfc]
 add cx, [yf]
 mov [columnfc],cx
 mov dx, [yfc]
 add dx,[xf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc+y,yc-x)
 mov cx, [xfc]
 add cx, [yf]
 mov [columnfc],cx
 mov dx, [yfc]
 sub dx,[xf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc-y,yc+x)
 mov cx, [xfc]
 sub cx, [yf]
 mov [columnfc],cx
 mov dx, [yfc]
 add dx,[xf]
 mov [rowfc], dx
 call filledcirclepixels
 ;(xc-y,yc-x)
 mov cx, [xfc]
 sub cx, [yf]
 mov [columnfc],cx
 mov dx, [yfc]
 sub dx,[xf]
 mov [rowfc], dx
 call filledcirclepixels
 
 ; Update state values and check error:
        cmp word [filledcircleerror], 0
	jge greaterfilledcircle
	inc word [yf]
	mov ax ,[yf]
	add ax,ax
	inc ax
	add ax,[filledcircleerror]
        mov [filledcircleerror],ax
	jmp Plotfilledcirclepixels

   greaterfilledcircle:
	dec word [xf]
	mov ax , [xf]
	add ax,ax
        neg ax
	inc ax
	add ax,[filledcircleerror]
        mov [filledcircleerror],ax
        jmp Plotfilledcirclepixels
        
  

donefilledcircleloop:
dec word [radiusfic]
call Drawfilledcircleloop
inc esi
cmp esi,75
jl donefilledcircleloop
ret      

;;;;;;;;;;;;;;;;;;;
IsoTriangle:
call Activate_Keyboard2
cli

jmp Drawisotriangle

 xisot1: dw 130
 yisot1: dw 75
 xisot2: dw 216
 yisot2: dw 75
 xisot3: dw 173
 yisot3: dw 32
isotriangleerror: dw 0
;isotrianglecolour: dw 9


Drawisotriangle:; use the bresenhams algorithms
videographicsisotriangle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 isotrianglepixels:
 mov ah,0ch
 mov al, [colour]
 
 Drawisotriangleloop: 
 mov cx,[xisot1]
 mov dx,[yisot1]

 isoline1:
 int  10h
 inc cx
 cmp cx,[xisot2]
 jnz isoline1
 
 
 mov cx,[xisot1]
 mov dx,[yisot1]
 
isoline2:
 int 10h
 inc cx
 dec dx
 cmp cx, [xisot3]
 cmp dx, [yisot3]
 jnz isoline2
 
 mov cx,[xisot3]
 mov dx,[yisot3]
 
 isoline3:
 int 10h
 inc cx
 inc dx
 cmp cx, [xisot2]
 cmp dx, [yisot2]
 jnz isoline3
ret



;;;;;;;;;;;;;;;;;
RigTriangle:
call Activate_Keyboard2
cli

jmp Drawrigtriangle

 radiusrigt: dw 75
 xrigtc: dw 160
 yrigtc: dw 100
 xrigt1: dw 0
 yrigt1: dw 0
 xrigt2: dw 0
 yrigt2: dw 0
 xrigt3: dw 0
 yrigt3: dw 0

;rigtrianglecolour: dw 9


Drawrigtriangle:
videographicsrigtriangle:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 rigtrianglepixels:
 mov ah,0ch
 mov al, [colour]
 
 Drawrigtriangleloop: 
 getcoordinatesforrigtriangle:
 mov cx, [xrigtc]
 mov dx, [yrigtc]
 add cx,[radiusrigt]
 mov [xrigt1],cx
 mov [yrigt1],dx
 int 10h
 
  mov cx, [xrigtc]
 mov dx, [yrigtc]
 sub dx,[radiusrigt]
 mov [xrigt2],cx
 mov [yrigt2],dx
  int 10h
  
 mov cx, [xrigtc]
 mov dx, [yrigtc]
 mov [xrigt3],cx
 mov [yrigt3],dx
  int 10h
 
 
 
  getlinerigtriangle:
 mov cx,[xrigt1]
 mov dx,[yrigt1] 
rigtline1:
 int 10h
 dec cx
 dec dx
 cmp cx, [xrigt3]
 cmp dx, [yrigt2]
 jnz rigtline1 

 mov cx,[xrigt3]
 mov dx,[yrigt3]
 rigtline2:
 int 10h
 dec dx
 cmp dx, [yrigt2]
 jnz rigtline2
 
 mov cx,[xrigt3]
 mov dx,[yrigt3]
 rigtline3:
 int 10h
 inc cx
 cmp cx, [xrigt1]
 jnz rigtline3

 ret



;;;;;;;;;;;;;;;;;
Pyramid:
call Activate_Keyboard
cli

jmp DrawAPryamid

 
 radiuspry1: dw 80
 radiuspry2: dw 40
 xpryc: dw 160
 ypryc: dw 120
 xpry1: dw 0
 ypry1: dw 0
 xpry2: dw 0
 ypry2: dw 0
 xpry3: dw 0
 ypry3: dw 0
 xpry4: dw 0
 ypry4: dw 0
 
 ;prycolour: dw 9
 
 DrawAPryamid:
 videographicspry:
 mov ah, 0
 mov al , 0x13 ;;;;;
 int 0x10
 ;;;;;;;;;;;;
 pryamidpixels:
 mov ah,0ch
 mov al, [colour]
 
 Drawpryamidloop: 
 getcoordinatesforpryamid:
 mov cx, [xpryc]
 mov dx, [ypryc]
 add cx,[radiuspry1]
 mov [xpry1],cx
 mov [ypry1],dx
 int 10h
 
 mov cx, [xpryc]
 mov dx, [ypryc]
 sub dx,[radiuspry1]
 mov [xpry2],cx
 mov [ypry2],dx
 int 10h
  
 mov cx, [xpryc]
 mov dx, [ypryc]
 sub cx,[radiuspry1]
 mov [xpry3],cx
 mov [ypry3],dx
 int 10h
 
 mov cx, [xpryc]
 mov dx, [ypryc]
 add dx,[radiuspry2]
 mov [xpry4],cx
 mov [ypry4],dx
 int 10h
 
 ;;;;;
 getlinepryamid:
 mov cx,[xpry1]
 mov dx,[ypry1] 
 pryline1:
 int 10h
 dec cx
 dec dx
 cmp dx, [ypry2]
 jne pryline1 
;;;;;;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline2:
 int 10h
 inc cx
 dec dx
 cmp dx, [ypry2]
 jne pryline2
 ;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline3:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx, [ypry4]
 jne pryline3

 mov cx,[xpry1]
 mov dx,[ypry1]
 pryline4:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline4
 
 mov cx,[xpry2]
 mov dx,[ypry2]
 pryline5:
 int 10h
 inc dx
 cmp dx, [ypry4]
 jne pryline5
 ;;;;;
 
 ret
 



;;;;;;;;;;
Trapizum:
call Activate_Keyboard2
cli


jmp DrawTrapizum

 heightTrapizum: dw 50
 widthTrapizum: dw 75
 heightminuswithtrapizium: dw 0
 xTrapizumc: dw 160
 yTrapizumc: dw 100
 xTrapizum1: dw 0
 yTrapizum1: dw 0
 xTrapizum2: dw 0
 yTrapizum2: dw 0
 xTrapizum3: dw 0
 yTrapizum3: dw 0
 xTrapizum4: dw 0
 yTrapizum4: dw 0
;colour: dw 9


DrawTrapizum:
videographicsTrapizum:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 Trapizumpixels:
 mov ah,0ch
 mov al, [colour]
 
 DrawTrapizumloop: 
 mov dx,[heightTrapizum]
 mov cx,[widthTrapizum]
 neg dx
 add cx,dx
 mov [heightminuswithtrapizium],cx
 getcoordinatesforTrapizum:
 mov cx, [xTrapizumc]
 mov dx, [yTrapizumc]
 add cx,[widthTrapizum]
 mov [xTrapizum1],cx
 mov [yTrapizum1],dx
 int 10h
 
 mov cx, [xTrapizumc]
 mov dx, [yTrapizumc]
 add cx,[heightminuswithtrapizium]
 sub dx,[heightTrapizum]
 mov [xTrapizum2],cx
 mov [yTrapizum2],dx
  int 10h
  
 mov cx, [xTrapizumc]
 mov dx, [yTrapizumc]
 sub cx,[widthTrapizum]
 mov [xTrapizum3],cx
 mov [yTrapizum3],dx
  int 10h
 
 mov cx, [xTrapizumc]
 mov dx, [yTrapizumc]
 sub cx,[heightminuswithtrapizium]
 sub dx,[heightTrapizum]
 mov [xTrapizum4],cx
 mov [yTrapizum4],dx
  int 10h
 
getlineTrapizum:
 mov cx,[xTrapizum1]
 mov dx,[yTrapizum1] 
Trapizumline1:
 int 10h
 dec cx
 dec dx
 cmp cx, [xTrapizum3]
 cmp dx, [yTrapizum2]
 jnz Trapizumline1 

 mov cx,[xTrapizum2]
 mov dx,[yTrapizum2]
 Trapizumline2:
 int 10h
 dec cx
 cmp cx, [xTrapizum4]
 jnz Trapizumline2
 
 mov cx,[xTrapizum3]
 mov dx,[yTrapizum3]
 Trapizumline3:
 int 10h
 inc cx
 cmp cx, [xTrapizum1]
 jnz Trapizumline3
 
 mov cx,[xTrapizum4]
 mov dx,[yTrapizum4]
 Trapizumline4:
 int 10h
 dec cx
 inc dx
 cmp cx, [xTrapizum3]
 cmp dx, [yTrapizum1]
 jnz Trapizumline4

 ret





;;;;;;;;;;;
 FilledRectangle:
 call Activate_Keyboard2
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
 
 
 ;;;;;;;;;;;
Rectangle:
call Activate_Keyboard2
cli
jmp Drawrectangle
;;;;;;;;;;;;;;;;;
 xr1: dw 25
 yr1: dw 100
 xr2: dw 250
 yr2: dw 50
 xr: dw 0
 yr: dw 0
;rectangulecolour: dw 9
;;;;;;;;;;;;;;;;;
rectanglepixels:
 mov ah,0ch
 mov al, [colour]
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
 
 
 ;;;;;;;;;;;;
 Square:
 call Activate_Keyboard2
 cli

jmp Drawsquare
;;;;;;;;;;;;;;
 length: dw 75
 xsc: dw 160
 ysc: dw 100
 xs: dw 0
 ys: dw 0
 squareerror: dw 0
 ;coloursquare: dw 9 ;blue
 
 ;;;;;;;;;;;;;;;;;;;;;
 Drawsquare:; use the bresenhams algorithms
 videographicssquare:
 mov ah, 0
 mov al , 0x13
 int 0x10
 
 squarepixels:
 mov ah,0ch
 mov al, [colour]
 
 
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