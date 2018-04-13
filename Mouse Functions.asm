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
mov bx ,BeginEveryThing
int 0x13
jmp BeginEveryThing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BeginEveryThing:
        
        mov al,13h 
        int 10h  ;;;;;;; VGA Mode	
biglop:
    call Color_Screen_red
    call Halt
    call Color_Screen_green
    call Halt
    call Color_Screen_blue
    call Halt          
bigloop:
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
    mov al,[background_color] ; color 4 - white
    mov cx,[x] 	; x position 
    mov dx,[y] 	; y position 
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
    add ax,[x]
    mov [x],ax
    
    mov ax,[deltay]
    
    sub [y],ax
    call check_border
    mov cx,[x]
    cmp cx,319
    jl noend
    mov dx,[y]
    cmp dx,199
    jge bigloop
noend:    
    mov cx,[x]
    cmp cx,60
    jg same    
    call color_menu_background
    jmp next2
same:
    mov ax,15
    mov [background_color],ax
    next1:    
    mov al,[draw_color]
    mov ah,0ch
    mov cx,[x]
    mov dx,[y]
    int 10h
    
    
    call readfrommouse ;;;; scroll
    jmp nokey
    
    nothing:
    
    mov ah,0Ch 	; function 0Ch
    mov al,[background_color] 	; color 15 - white
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
;    mov [background_color],ax
    call color_menu_background
    jmp next2
same1:                 
    mov ax,15
    mov [background_color],ax
    next2:
    mov al,[draw_color]
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


;;;;;;;;;;;;;; colors the screen white
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







;;;;;;;;;;;; draws the left window to choose your color
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

;;;;;;;;;;; each color takes 40 and has 5 above and underneath and left and right
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


color_menu_background:
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
mov [background_color],ax
cmp word[status],1
je pressblack
jmp nopressblack
pressblack:
mov [draw_color],ax
nopressblack:
jmp color_menu_background_done
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
mov [background_color],ax
cmp word[status],1
je pressred
jmp nopressred
pressred:
mov [draw_color],ax
nopressred:
jmp color_menu_background_done
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
mov [background_color],ax
cmp word[status],1
je pressblue
jmp nopressblue
pressblue:
mov [draw_color],ax
nopressblue:
jmp color_menu_background_done
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
mov [background_color],ax
cmp word[status],1
je pressgreen
jmp nopressgreen
pressgreen:
mov [draw_color],ax
nopressgreen:
jmp color_menu_background_done

outofgreen:
jmp now

color_menu_background_done:
ret



now:
mov ax,1000b
mov [background_color],ax
jmp color_menu_background_done



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
;nop
;nop
;nop
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
draw_color: dw 0
background_color: dw 15
status: dw 0
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