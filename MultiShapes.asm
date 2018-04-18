<<<<<<< HEAD
bits 16
org 0x7C00



cli

mov ah , 0x02
mov al ,8
mov dl , 0x80
mov ch , 0
mov dh , 0
mov cl , 2
mov bx, code_starts_here
int 0x13
jmp code_starts_here


times (510 - ($ - $$)) db 0
db 0x55, 0xAA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code_starts_here:
     
      xor eax , eax 
      mov edi, 0xB8000
      xor ebx,ebx
      
ChanegVedioGraphics:    
       mov ah , 0
       mov al , 13h
       int 10h

coloyrScreenred:
mov ah,0ch
mov al, 4 
mov cx,0
mov dx,0
red2:
mov dx,0
;call Halt3
hlt
;nop
red1:

int 10h
inc dx
cmp dx ,200
jle red1

inc cx
inc cx
inc cx
inc cx
cmp cx,320
jle red2
PrintRadiusA:
    mov dh,13
    mov dl,15
    mov bh,0
    mov ah,2
    int 10h
    mov bh ,0
    ;mov esi,msg1
    mov esi,start2
    mov bl,4;red
    ;mov cx,8
    mov ah,14
    print_option_r20:
    lodsb
    cmp al ,0
    je end_option_r20
    int 10h
    jmp print_option_r20
    end_option_r20:

Check111:
    in al,0x64
    and al,1
    jz Check111 
PrintRadiusB:
    mov dh,13
    mov dl,15
    mov bh,0
    mov ah,2
    int 10h
    mov bh ,0
    ;mov esi,msg1
    mov esi,start2
    mov bl,0;red
    ;mov cx,8
    mov ah,14
    print_option_r25:
    lodsb
    cmp al ,0
    je end_option_r25
    int 10h
    jmp print_option_r25
    end_option_r25:

coloyrScreenBlack:
mov ah,0ch
mov al, 0 
mov cx,0
mov dx,0
red20:
mov dx,0
;call Halt3
hlt
;nop
red10:

int 10h
inc dx
cmp dx ,200
jle red10

inc cx
inc cx
inc cx
inc cx
cmp cx,320
jle red20


ChanegVedioGraphics2:    
       mov ah , 0
       mov al , 13h
       int 10h
       
PrintRadius1:
    mov dh,1
    mov dl,35
    mov bh,0
    mov ah,2
    int 10h
    mov bh ,0
    ;mov esi,msg1
    mov esi,size
    mov bl, [BlColour];red
    ;mov cx,8
    mov ah,14
    print_option_r2:
    lodsb
    cmp al ,0
    je end_option_r2
    int 10h
    jmp print_option_r2
    end_option_r2:
SetCourser1:
    mov dh,1
    mov dl,3
    mov bh,0
    mov ah,2
    int 10h
  ;  mov bh ,0
    mov esi,msg1
    mov bl, [BlColour]
    ;mov cx,8
    mov ah,14
    print_option_r:
    lodsb
    cmp al ,0
    je end_option_r
    int 0x10
    jmp print_option_r
    end_option_r:
    
    call triangle
CheckKeyPressed:
     xor cx,cx
     xor dx,dx
     in al,0x64
     and al,1
     jz CheckKeyPressed
     in al,0x60
     cmp al, 0x25 
     je Shapes
     cmp al, 0xA5
     je Shapes
CheckKeyPressed2: 
     in al,0x64
     and al,1
     jz CheckKeyPressed2
     in al,0x60
     cmp al,0x24
     je incSize
     cmp al,0xA4
     je incSize
     cmp al,0x26
     je decSize
     cmp al,0xA6
     je decSize
     cmp al,0x2E
     je ChangeColourb
     cmp al,0xAE
     je ChangeColourb
     cmp al, 0x20
     je ChangePositionToRight
     cmp al, 0xA0
     je  ChangePositionToRight
     cmp al, 0x1E
     je ChangePositionToLeft
     cmp al, 0x9E
     je ChangePositionToLeft
     cmp al,0x2f
     je ChangeShape
     cmp al,0xAf
     je ChangeShape  
     jmp CheckFires
     ret
CheckFires:
    pushad
    mov eax,[ShapeNumber]     
    cmp eax,0
    je CheckFire
    cmp eax,1
    je CheckFireT
    cmp eax,2
    je CheckFireC
    popad
Shapes:
     pushad
     mov eax,[ShapeNumber]     
     cmp eax,0
     je Fire
     cmp eax,1
     je FireT
     cmp eax,2
     je FireC
     popad 
     ret
ChangeShape:     
     pushad
     mov eax,[ShapeNumber]
     inc eax
     cmp eax,3 
     ;jne continue
     je notcontinue
     continue:
     mov [ShapeNumber],eax
     call ShapeName
     call Shapes
     jmp endTT 
     notcontinue:
     jmp ShapeReturn
     endTT:
     popad
     ret
ShapeName:
     pushad
     mov eax,[ShapeNumber]     
     cmp eax,0
     je ChangeToPryamid
     cmp eax,1
     je ChangeToTriangle
     cmp eax,2
     je ChangeToCircle
     endTTT:
     popad 
     ret   
ChangeToPryamid:
    ;pushad
    mov esi,ctp
    ;mov [msg1],eax
    call SetCourser2
   jmp endTTT
ret
ChangeToTriangle:
    mov esi,ctt
    call SetCourser2
    jmp endTTT
ret
ChangeToCircle:
    
    mov esi,ctc
    call SetCourser2
    jmp endTTT
ret
ShapeReturn:
   ;pushad
    mov eax,0
    mov [ShapeNumber],eax
    call ShapeName
    call Shapes
    ;popad
    jmp endTT
    ;ret    
ChangePositionToRight:
     xor dx,dx
     xor cx,cx
     call Deletetriangle
     mov ax,[xequtc]
     add ax,6
     mov [xequtc],ax
     call triangle
     call Halt
     jmp CheckKeyPressed
     ret
ChangePositionToLeft:
     xor dx,dx
     xor cx,cx
     call Deletetriangle
     mov ax,[xequtc]
     sub ax,6
     mov [xequtc],ax
     call triangle
     call Halt
     
     jmp CheckKeyPressed
     ret
ChangeColourb:
    pushad
    mov ax,[ChangeColour]
    inc ax
    cmp ax,16
    je endt
    mov [ChangeColour],ax
    mov [equtrianglecolour],ax
    mov [BlColour],ax
    ;mov esi,
    call ShapeName
    mov esi,size
    call PrintRadius2
    call Deletetriangle
    call triangle
    popad 
    jmp CheckKeyPressed
    ret
endt:
    pushad
    mov ax,1
    mov [ChangeColour],ax
    popad 
    ret
    
incSize:
     pushad
     mov eax,[radiuspry2]
     add eax,2
     mov [radiuspry2],eax
     mov ebx,[radiuspry1]
     add ebx,4
     mov [radiuspry1],ebx
     mov ecx,[radiusequtK]
     add ecx,2
     mov [radiusequtK],ecx
     mov edx,[radiusfck1]
     add edx,2
     mov [radiusfck1],edx
     ;mov esi,size1  ;size:db 'size  ',0      size1: db 'size++',0      size : db 'size--',0
     ;call PrintRadius2
     mov esi,size1
     call PrintRadius2
     call Halt2
     call Halt
     call Halt
     call Halt
     call Halt
     mov esi,size
     call PrintRadius2
     ;mov esi,size  ;size:db 'size  ',0      size1: db 'size++',0      size : db 'size--',0
     ;call PrintRadius2
     popad
     jmp CheckKeyPressed
     ret
     
decSize:
     pushad
     mov eax,[radiuspry2]
     sub eax,2
     mov [radiuspry2],eax
     mov ebx,[radiuspry1]
     sub ebx,4
     mov [radiuspry1],ebx
     mov ecx,[radiusequtK]
     sub ecx,2
     mov [radiusequtK],ecx
     popad
     mov edx,[radiusfck1]
     sub edx,2
     mov [radiusfck1],edx
     mov esi,size2
     call PrintRadius2
     call Halt2
     call Halt
     call Halt
     call Halt
     call Halt
     mov esi,size
     call PrintRadius2
     popad
     jmp CheckKeyPressed
     ret
SetCourser2:
    mov dh,1
    mov dl,2
    mov bh,0
    mov ah,2
    int 10h
    mov bh ,0
    ;mov esi,msg1
    mov bl, [BlColour]
    ;mov cx,8
    mov ah,14
    print_option_r1:
    lodsb
    cmp al ,0
    je end_option_r1
    int 10h
    jmp print_option_r1
    end_option_r1:
    ret
PrintRadius2:
    mov dh,1
    mov dl,35
    mov bh,0
    mov ah,2
    int 10h
    mov bh ,0
    mov bl, [BlColour]
    mov ah,14
    print_option_r3:
    lodsb
    cmp al ,0
    je end_option_r3
    int 10h
    jmp print_option_r3
    end_option_r3:
    ret
     
               
radiusequt: dw 10
xequtc: dw 160
yequtc: dw 200
xequt1: dw 0
yequt1: dw 0
xequt2: dw 0
yequt2: dw 0
xequt3: dw 0
yequt3: dw 0
fireX: dw 0
fireY: dw 0
ShapeNumber: dw 0
dequtrianglecolour: dw 0
equtrianglecolour: dw 4
radiuspry1: dw 8
radiuspry2: dw 4;;;;;;;;;;;;;;;;;;;;main radiu
 xpryc: dw 0;;;
 ypryc: dw 0;;;;
 xpry1: dw 0
 ypry1: dw 0
 xpry2: dw 0
 ypry2: dw 0
 xpry3: dw 0
 ypry3: dw 0
 xpry4: dw 0
 ypry4: dw 0
 prycolour: dw 9
 resetcolour:dw 0
 radiusequtK: dw 4
 radiusequtK2: db '4      ',0
 xequtcK: dw 0
 yequtcK: dw 0
 xequt1K: dw 0
 yequt1K: dw 0
 xequt2K: dw 0
 yequt2K: dw 0
 xequt3K: dw 0
 yequt3K: dw 0
ChangeColour: dw 4
BlColour:dw 4
radiusfck: dw 0
size:db '**',0   
size1: db '++',0  
size2: db '--',0
start2: db 'PRESS ANY KEY',0 
 xcck: dw 0
 ycck: dw 0
 xck: dw 0
 yck: dw 0
 xr: dw 0
 yr: dw 0
 circleerrork: dw 0
 columnck: dw 0
 rowck: dw 0
 msg1:db 'pryamid ',0
 ctp: db 'pryamid ',0
 ctt: db 'triangle',0
 ctc: db 'circle  ',0
 CheckPry1:dw 0
 nn:dw 0
 start:db'press any key',0
EnableVM:
   mov ah, 0
   mov al , 0x13
   int 0x10
   ret
Halt:
mov esi,1000
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
Halt3:
mov esi,10
Halt_loop3:
mov ecx,1000
halt_loop3:
nop
nop
nop
nop
loop halt_loop3
dec esi
cmp esi,0
jle halt_done3
jmp Halt_loop3

halt_done3:
ret
Halt2:
mov esi,10000
Halt_loop1:
mov ecx,1000
halt_loop1:
nop
nop
nop
nop
loop halt_loop1
dec esi
cmp esi,0
jle halt_done1
jmp Halt_loop1

halt_done1:
ret
Fire:
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    jmp CheckFire2
FireLoopR:
    jmp CheckKeyPressed
    ret
FireLoopRe:
   dec dx
    dec dx
    dec dx
    dec dx
    dec dx
    mov [fireY],dx
    call MakeFireGraphics
    ;cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoopRe
    FireLoopEnd:
    jmp FireLoopR
    ret
MakeFireGraphics:
    mov cx,[fireX]
    mov dx,[fireY]
    inc dx
    inc dx
    inc dx
    inc dx
    inc dx
    mov [xpryc],cx
    mov [ypryc],dx
    call deletepryamid
    call Halt
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xpryc],cx
    mov [ypryc],dx
    call pryamid
    CheckFire2:
    jmp CheckKeyPressed2
    CheckFire:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopRe
    
    jmp FireLoopEnd
    ret
   
FireT:
 
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    jmp CheckFireT2
FireLoopTR:
    jmp CheckKeyPressed
    ret
FireLoopTRe:
   
    dec dx
    dec dx
    dec dx
    dec dx
    dec dx
    mov [fireY],dx
    ;cmp dx,3    
    call MakeFireGraphicsT            ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoopTRe
    FireLoopTEnd:
    ;jmp DeleteFireGraphics 
    ;DeleteFireGraphicsR:
    jmp FireLoopTR
    ret
MakeFireGraphicsT:
    

    mov cx,[fireX]
    mov dx,[fireY] 
    inc dx
    inc dx
    inc dx
    inc dx
    inc dx
    mov [xequtcK],cx
    mov [yequtcK],dx
    call equtriangleKd
    call Halt
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xequtcK],cx
    mov [yequtcK],dx
    call equtriangleK
    ;int 10h
    CheckFireT2:
    jmp CheckKeyPressed2
    CheckFireT:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopTRe
    
    jmp FireLoopTEnd
    ret
    
FireC:
    ;mov eax,[nn];;
    ;call triangle
    ;call EnableVM
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    ;cmp eax,0
    ;jne FireLoopCRe
    jmp CheckFireC2
FireLoopCR:
    mov eax,0
    mov [nn],eax
    popad
    jmp CheckKeyPressed
    ret   
FireLoopC:
 call MakeFireGraphicsC
    FireLoopCRe:
    call Halt
    call DeleteFireGraphicsC
    dec dx
    dec dx
  
    mov [fireY],dx
    ;cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoopC
    FireLoopCEnd:
    ;jmp DeleteFireGraphics 
    ;DeleteFireGraphicsR:
    jmp FireLoopCR
    ret
MakeFireGraphicsC:
    
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[equtrianglecolour];
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xr],cx
    mov [yr],dx
    call circlek
    jmp CheckFireC3
    ;int 10h
    CheckFireC2:
    dec dx
    dec dx
    call DeleteFireGraphicsC
   
    CheckFireC3:
    jmp CheckKeyPressed2
    CheckFireC:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopCRe
    
    jmp FireLoopCEnd
    ret
    ;jmp  MakeFireGraphicsR
    
DeleteFireGraphicsC:
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[dequtrianglecolour]
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xr],cx
    mov [yr],dx
    call circlekd
    call circlekd
    ;int 10h
    ret
  

    ;jmp  MakeFireGraphicsR
    
triangle:
;videographicsequtriangle:
   ; mov ah, 0
    ;mov al, 0x13
    ;int 0x10
;jmp EnableVM
Drawequtriangle:

 
equtrianglepixels:
mov ah,0ch
mov al, [equtrianglecolour]
 
Drawequtriangleloop: 
getcoordinatesforequtriangle:
mov cx,[xequtc]
mov dx,[yequtc]
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
 
cmp dx, [yequt2]
jne equtline1 
;;;;;;;;;;;;;;;
mov cx,[xequt3]
mov dx,[yequt3]
equtline2:
int 10h
inc cx
dec dx
 ;cmp cx, [xequt1]
cmp dx, [yequt2]
jne equtline2
 ;;;;;;;;;;
 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline3:
 int 10h
 inc cx
 cmp cx, [xequt1]
 jne equtline3

 ret

Deletetriangle:

Drawequtriangle2:

 
equtrianglepixels2:
mov ah,0ch
mov al, [dequtrianglecolour]
 
Drawequtriangleloop2: 
getcoordinatesforequtriangle2:
mov cx,[xequtc]
mov dx,[yequtc]
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
 
 
 
getlineequtriangle2:
mov cx,[xequt1]
mov dx,[yequt1] 
equtline12:
int 10h
dec cx
dec dx
 
cmp dx, [yequt2]
jne equtline12 
;;;;;;;;;;;;;;;
mov cx,[xequt3]
mov dx,[yequt3]
equtline22:
int 10h
inc cx
dec dx
 ;cmp cx, [xequt1]
cmp dx, [yequt2]
jne equtline22
 ;;;;;;;;;;
 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline32:
 int 10h
 inc cx
 cmp cx, [xequt1]
 jne equtline32

 ret
 
 
pryamid:
pushad
;call pryamidX2
jmp DrawAPryamid

 

 
 
 DrawAPryamid:
 
 pryamidpixels:
 mov ah,0ch
 mov al,[equtrianglecolour]
 
 
 Drawpryamidloop: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
 getlinepryamid:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
 ;;;;;
 mov cx,[xpry2]
 mov dx,[ypry2]
 pryline5:
 int 10h
 inc dx
 cmp dx, [ypry4]
 jne pryline5
 ;;;;;
 ;;;;;;;;;;
 mov cx,[xpry3]
 add cx ,1
 mov dx,[ypry3]
 add dx ,1
 pryline6:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx,[ypry4]
 jne pryline6
 ;;;;;
 mov cx,[xpry1]
 sub cx,1
 mov dx,[ypry1]
 add dx,1
 pryline7:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline7
 ;;;;;
;;;;;
popad
ret


deletepryamid:
pushad
jmp DrawAPryamidd

 

 
 
 DrawAPryamidd:
 
 pryamidpixelsd:
 mov ah,0ch
 mov al,0
 
 
 Drawpryamidloopd: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 getcoordinatesforpryamidd:
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
 getlinepryamidd:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 mov cx,[xpry1]
 mov dx,[ypry1] 
 pryline1d:
 int 10h
 dec cx
 dec dx
 cmp dx, [ypry2]
 jne pryline1d
;;;;;;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline2d:
 int 10h
 inc cx
 dec dx
 cmp dx, [ypry2]
 jne pryline2d
 ;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline3d:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx, [ypry4]
 jne pryline3d

 mov cx,[xpry1]
 mov dx,[ypry1]
 pryline4d:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline4d
 ;;;;;
 mov cx,[xpry2]
 mov dx,[ypry2]
 pryline5d:
 int 10h
 inc dx
 cmp dx, [ypry4]
 jne pryline5d
 ;;;;;
 ;;;;;;;;;;
 mov cx,[xpry3]
 add cx ,1
 mov dx,[ypry3]
 add dx ,1
 pryline6d:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx,[ypry4]
 jne pryline6d
 ;;;;;
 mov cx,[xpry1]
 sub cx,1
 mov dx,[ypry1]
 add dx,1
 pryline7d:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline7d
 ;;;;;
;;;;;
popad
ret



equtriangleK: 
pushad
jmp DrawequtriangleK




DrawequtriangleK:
 
 equtrianglepixelsK:
 mov ah,0ch
 mov al,[equtrianglecolour]
 
 DrawequtriangleloopK: 
 getcoordinatesforequtriangleK:
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 add cx,[radiusequtK]
 mov [xequt1K],cx
 mov [yequt1K],dx
 int 10h
 
  mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub dx,[radiusequtK]
 mov [xequt2K],cx
 mov [yequt2K],dx
  int 10h
  
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub cx,[radiusequtK]
 mov [xequt3K],cx
 mov [yequt3K],dx
  int 10h
 
 
 
getlineequtriangleK:
 mov cx,[xequt1K]
 mov dx,[yequt1K] 
equtline1K:
 int 10h
 dec cx
 dec dx
 cmp cx, [xequt3K]
 cmp dx, [yequt2K]
 jnz equtline1K 

 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline2K:
 int 10h
 inc cx
 dec dx
 cmp cx, [xequt1K]
 cmp dx, [yequt2K]
 jnz equtline2K
 
 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline3K:
 int 10h
 inc cx
 cmp cx, [xequt1K]
 jnz equtline3K
popad
 ret
 ;;;;;;
 
equtriangleKd: 
pushad
jmp DrawequtriangleKd
DrawequtriangleKd:
 
 equtrianglepixelsKd:
 mov ah,0ch
 mov al, 0
 
 DrawequtriangleloopKd: 
 getcoordinatesforequtriangleKd:
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 add cx,[radiusequtK]
 mov [xequt1K],cx
 mov [yequt1K],dx
 int 10h
 
  mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub dx,[radiusequtK]
 mov [xequt2K],cx
 mov [yequt2K],dx
  int 10h
  
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub cx,[radiusequtK]
 mov [xequt3K],cx
 mov [yequt3K],dx
  int 10h
 
 
 
getlineequtriangleKd:
 mov cx,[xequt1K]
 mov dx,[yequt1K] 
equtline1Kd:
 int 10h
 dec cx
 dec dx
 cmp cx, [xequt3K]
 cmp dx, [yequt2K]
 jnz equtline1Kd

 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline2Kd:
 int 10h
 inc cx
 dec dx
 cmp cx, [xequt1K]
 cmp dx, [yequt2K]
 jnz equtline2Kd
 
 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline3Kd:
 int 10h
 inc cx
 cmp cx, [xequt1K]
 jnz equtline3Kd
popad
 ret
 
 ;;;;;;;;;;
circlek:
call intial
call getcc
jmp Drawcirclek

 
 
 circlepixelsk:
 mov ah,0ch
 mov al, [equtrianglecolour]
 mov cx,[columnck]
 mov dx,[rowck]
 int 10h
 ret
 
 Drawcirclek:

 Drawcircleloopk:
 mov bx, [radiusfck]
 mov [xck],bx 
 
Plotcirclepixelsk:

;condition is x>y
mov bx,[xck]
cmp bx,[yck]
jl donecirclek
 ;(xc+x,yc+y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+x,yc-y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-x,yc+y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-x,yc-y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+y,yc+x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+y,yc-x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-y,yc+x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-y,yc-x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 
 ; Update state values and check error:
        cmp word [circleerrork], 0
	jge greatercirclek
	inc word [yck]
	mov ax ,[yck]
	add ax,ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax
	jmp Plotcirclepixelsk

   greatercirclek:
	dec word [xck]
	mov ax , [xck]
	add ax,ax
        neg ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax	
	jmp Plotcirclepixelsk
  
donecirclek: 
ret 

circlekd:
call intial
call getcc
jmp Drawcirclekd

 
 
 circlepixelskd:
 mov ah,0ch
 mov al,0
 mov cx,[columnck]
 mov dx,[rowck]
 int 10h
 ret
 
 Drawcirclekd:
 
 
 
 Drawcircleloopkd:
 mov bx, [radiusfck]
 mov [xck],bx 
 
Plotcirclepixelskd:

;condition is x>y
mov bx,[xck]
cmp bx,[yck]
jl donecirclekd
 ;(xc+x,yc+y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+x,yc-y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-x,yc+y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-x,yc-y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+y,yc+x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+y,yc-x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-y,yc+x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-y,yc-x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 
 ; Update state values and check error:
        cmp word [circleerrork], 0
	jge greatercirclekd
	inc word [yck]
	mov ax ,[yck]
	add ax,ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax
	jmp Plotcirclepixelskd

   greatercirclekd:
	dec word [xck]
	mov ax , [xck]
	add ax,ax
        neg ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax	
	jmp Plotcirclepixelskd
        call donecirclekd
        ret
donecirclekd:
pushad 
mov eax,0
mov ebx,0
mov [xcck],eax
mov [ycck],ebx
popad
ret  
intial:
pushad 
    mov word[xck],0
    mov word[xcck],0
    mov word[yck],0
    mov word[ycck],0
    mov word[circleerrork],0
    mov word[columnck],0
    mov word[rowck],0
    mov eax,[radiusfck1]
    add eax,1
    mov [radiusfck],eax
popad
ret
 
getcc:
    pushad
    mov eax,[xr]
    mov ebx,[yr]
    mov [xcck],eax
    mov [ycck],ebx
    popad
    ret
    
 radiusfck1: dw 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
=======
bits 16
org 0x7C00



cli

mov ah , 0x02
mov al ,8
mov dl , 0x80
mov ch , 0
mov dh , 0
mov cl , 2
mov bx, code_starts_here
int 0x13
jmp code_starts_here


times (510 - ($ - $$)) db 0
db 0x55, 0xAA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code_starts_here:
     
      xor eax , eax 
      mov edi, 0xB8000
      xor ebx,ebx

ChanegVedioGraphics:    
       mov ah , 0
       mov al , 13h
       int 10h
CheckKeyPressed:
     xor cx,cx
     xor dx,dx
     in al,0x64
     and al,1
     jz CheckKeyPressed
     in al,0x60
     cmp al, 0x25 
     je Shapes
     cmp al, 0xA5
     je Shapes
CheckKeyPressed2: 
     in al,0x64
     and al,1
     jz CheckKeyPressed2
     in al,0x60
     cmp al,0x24
     je incSize
     cmp al,0xA4
     je incSize
     cmp al,0x26
     je decSize
     cmp al,0xA6
     je decSize
     cmp al,0x2E
     je ChangeColourb
     cmp al,0xAE
     je ChangeColourb
     cmp al, 0x20
     je ChangePositionToRight
     cmp al, 0xA0
     je  ChangePositionToRight
     cmp al, 0x1E
     je ChangePositionToLeft
     cmp al, 0x9E
     je ChangePositionToLeft
     cmp al,0x2f
     je ChangeShape
     cmp al,0xAf
     je ChangeShape  
     jmp CheckFires
    
     ret
CheckFires:
    pushad
    mov eax,[ShapeNumber]     
    cmp eax,0
    je CheckFire
    cmp eax,1
    je CheckFireT
    cmp eax,2
    je CheckFireC
    popad
Shapes:
     pushad
     mov eax,[ShapeNumber]     
     cmp eax,0
     je Fire
     cmp eax,1
     je FireT
     cmp eax,2
     je FireC
     popad 
     ret
ChangeShape:     
     pushad
     mov eax,[ShapeNumber]
     inc eax
     cmp eax,3
     jne continue
     je notcontinue
     continue:
     mov [ShapeNumber],eax
     call Shapes
     notcontinue:
     jmp ShapeReturn
     popad
     ret
ShapeReturn:
    pushad
    mov eax,0
    mov [ShapeNumber],eax
    call Shapes
    popad
    ret    
ChangePositionToRight:
     xor dx,dx
     xor cx,cx
     call Deletetriangle
     mov ax,[xequtc]
     add ax,3
     mov [xequtc],ax
     call triangle
     call Halt
     jmp CheckKeyPressed
     ret
ChangePositionToLeft:
     xor dx,dx
     xor cx,cx
     call Deletetriangle
     mov ax,[xequtc]
     sub ax,3
     mov [xequtc],ax
     call triangle
     call Halt
     
     jmp CheckKeyPressed
     ret
ChangeColourb:
    pushad
    mov ax,[ChangeColour]
    inc ax
    cmp ax,16
    je endt
    mov [ChangeColour],ax
    mov [equtrianglecolour],ax
    popad 
    jmp CheckKeyPressed
    ret
endt:
    pushad
    mov ax,1
    mov [ChangeColour],ax
    popad 
    ret
    
incSize:
     pushad
     mov eax,[radiuspry2]
     add eax,2
     mov [radiuspry2],eax
     mov ebx,[radiuspry1]
     add ebx,4
     mov [radiuspry1],ebx
     mov ecx,[radiusequtK]
     add ecx,2
     mov [radiusequtK],ecx
     mov edx,[radiusfck1]
     add edx,2
     mov [radiusfck1],edx
     popad
     jmp CheckKeyPressed
     ret
     
decSize:
     pushad
     mov eax,[radiuspry2]
     sub eax,2
     mov [radiuspry2],eax
     mov ebx,[radiuspry1]
     sub ebx,4
     mov [radiuspry1],ebx
     mov ecx,[radiusequtK]
     sub ecx,2
     mov [radiusequtK],ecx
     popad
     mov edx,[radiusfck1]
     sub edx,2
     mov [radiusfck1],edx
     popad
     jmp CheckKeyPressed
     ret
     
radiusequt: dw 15
xequtc: dw 160
yequtc: dw 200
xequt1: dw 0
yequt1: dw 0
xequt2: dw 0
yequt2: dw 0
xequt3: dw 0
yequt3: dw 0
fireX: dw 0
fireY: dw 0
ShapeNumber: dw 0
dequtrianglecolour: dw 0
equtrianglecolour: dw 15
radiuspry1: dw 8
radiuspry2: dw 4;;;;;;;;;;;;;;;;;;;;main radius
 ;xfull1: dw 0
 ;yfull1: dw 0
 ;xfull2: dw 320
 ;yfull2: dw 200
 xpryc: dw 0;;;
 ypryc: dw 0;;;;
 xpry1: dw 0
 ypry1: dw 0
 xpry2: dw 0
 ypry2: dw 0
 xpry3: dw 0
 ypry3: dw 0
 xpry4: dw 0
 ypry4: dw 0
 ;fillcolour: dw 15
 prycolour: dw 9
 resetcolour:dw 0
  radiusequtK: dw 4
 xequtcK: dw 0
 yequtcK: dw 0
 xequt1K: dw 0
 yequt1K: dw 0
 xequt2K: dw 0
 yequt2K: dw 0
 xequt3K: dw 0
 yequt3K: dw 0
ChangeColour: dw 1
radiusfck: dw 0

 xcck: dw 0
 ycck: dw 0
 xck: dw 0
 yck: dw 0
 xr: dw 0
 yr: dw 0
 circleerrork: dw 0
 columnck: dw 0
 rowck: dw 0

 
 
EnableVM:
   mov ah, 0
   mov al , 0x13
   int 0x10
   ret
Halt:
mov esi,1000
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
Fire:
    ;call triangle
    ;call EnableVM
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    jmp FireLoop
    FireLoopR:
    jmp CheckKeyPressed
    ret
    
FireLoop:
    call MakeFireGraphics
    FireLoopRe:
    call Halt
    call DeleteFireGraphics
    dec dx
    dec dx
    mov [fireY],dx
    ;cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoop
    FireLoopEnd:
    ;jmp DeleteFireGraphics 
    ;DeleteFireGraphicsR:
    jmp FireLoopR
    ret
MakeFireGraphics:
    
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[equtrianglecolour];
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xpryc],cx
    mov [ypryc],dx
    call pryamid
    ;int 10h
    jmp CheckKeyPressed2
    CheckFire:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopRe
    
    jmp FireLoopEnd
    ret
    ;jmp  MakeFireGraphicsR
    
DeleteFireGraphics:
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[dequtrianglecolour]
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xpryc],cx
    mov [ypryc],dx
    call deletepryamid
    ;int 10h
    ret
;;;;;;;;;;;;;;;;;;;;;;
FireT:
    ;call triangle
    ;call EnableVM
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    jmp FireLoopT
    FireLoopTR:
    jmp CheckKeyPressed
    ret
    
FireLoopT:
    call MakeFireGraphicsT
    FireLoopTRe:
    call Halt
    call DeleteFireGraphicsT
    dec dx
    dec dx
    mov [fireY],dx
    ;cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoopT
    FireLoopTEnd:
    ;jmp DeleteFireGraphics 
    ;DeleteFireGraphicsR:
    jmp FireLoopTR
    ret
MakeFireGraphicsT:
    
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[equtrianglecolour];
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xequtcK],cx
    mov [yequtcK],dx
    call equtriangleK
    ;int 10h
    jmp CheckKeyPressed2
    CheckFireT:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopTRe
    
    jmp FireLoopTEnd
    ret
    ;jmp  MakeFireGraphicsR
    
DeleteFireGraphicsT:
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[dequtrianglecolour]
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xequtcK],cx
    mov [yequtcK],dx
    call equtriangleKd
    ;int 10h
    ret
  
FireC:
    ;call triangle
    ;call EnableVM
    xor cx,cx
    xor dx,dx
    mov cx,[xequt2]
    mov dx,[yequt2]
    mov [fireX],cx
    mov [fireY],dx
    jmp FireLoopC
FireLoopCR:
    jmp CheckKeyPressed
    ret   
    FireLoopC:
    call MakeFireGraphicsC
    FireLoopCRe:
    call Halt
    call DeleteFireGraphicsC
    dec dx
    dec dx
  
    mov [fireY],dx
    ;cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jmp FireLoopC
    FireLoopCEnd:
    ;jmp DeleteFireGraphics 
    ;DeleteFireGraphicsR:
    jmp FireLoopCR
    ret
MakeFireGraphicsC:
    
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[equtrianglecolour];
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xr],cx
    mov [yr],dx
    call circlek
    ;int 10h
    jmp CheckKeyPressed2
    CheckFireC:
    
    cmp dx,3                ;;;;;;;last coloured pixel[colouredpixel] bx
    jge FireLoopCRe
    
    jmp FireLoopCEnd
    ret
    ;jmp  MakeFireGraphicsR
    
DeleteFireGraphicsC:
    ;call EnableVM
    ;mov ah,0ch
    ;mov al,[dequtrianglecolour]
    mov cx,[fireX]
    mov dx,[fireY]
    mov [xr],cx
    mov [yr],dx
    call circlekd
    call circlekd
    ;int 10h
    ret
    
triangle:
;videographicsequtriangle:
   ; mov ah, 0
    ;mov al, 0x13
    ;int 0x10
;jmp EnableVM
Drawequtriangle:

 
equtrianglepixels:
mov ah,0ch
mov al, [equtrianglecolour]
 
Drawequtriangleloop: 
getcoordinatesforequtriangle:
mov cx,[xequtc]
mov dx,[yequtc]
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
 
cmp dx, [yequt2]
jne equtline1 
;;;;;;;;;;;;;;;
mov cx,[xequt3]
mov dx,[yequt3]
equtline2:
int 10h
inc cx
dec dx
 ;cmp cx, [xequt1]
cmp dx, [yequt2]
jne equtline2
 ;;;;;;;;;;
 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline3:
 int 10h
 inc cx
 cmp cx, [xequt1]
 jne equtline3

 ret

Deletetriangle:
;videographicsequtriangle:
   ; mov ah, 0
    ;mov al, 0x13
    ;int 0x10
;jmp EnableVM
Drawequtriangle2:

 
equtrianglepixels2:
mov ah,0ch
mov al, [dequtrianglecolour]
 
Drawequtriangleloop2: 
getcoordinatesforequtriangle2:
mov cx,[xequtc]
mov dx,[yequtc]
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
 
 
 
getlineequtriangle2:
mov cx,[xequt1]
mov dx,[yequt1] 
equtline12:
int 10h
dec cx
dec dx
 
cmp dx, [yequt2]
jne equtline12 
;;;;;;;;;;;;;;;
mov cx,[xequt3]
mov dx,[yequt3]
equtline22:
int 10h
inc cx
dec dx
 ;cmp cx, [xequt1]
cmp dx, [yequt2]
jne equtline22
 ;;;;;;;;;;
 mov cx,[xequt3]
 mov dx,[yequt3]
 equtline32:
 int 10h
 inc cx
 cmp cx, [xequt1]
 jne equtline32

 ret
 
 
pryamid:
pushad
;call pryamidX2
jmp DrawAPryamid

 

 
 
 DrawAPryamid:
 
 pryamidpixels:
 mov ah,0ch
 mov al,[equtrianglecolour]
 
 
 Drawpryamidloop: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
 getlinepryamid:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
 ;;;;;
 mov cx,[xpry2]
 mov dx,[ypry2]
 pryline5:
 int 10h
 inc dx
 cmp dx, [ypry4]
 jne pryline5
 ;;;;;
 ;;;;;;;;;;
 mov cx,[xpry3]
 add cx ,1
 mov dx,[ypry3]
 add dx ,1
 pryline6:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx,[ypry4]
 jne pryline6
 ;;;;;
 mov cx,[xpry1]
 sub cx,1
 mov dx,[ypry1]
 add dx,1
 pryline7:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline7
 ;;;;;
;;;;;
popad
ret


deletepryamid:
pushad
jmp DrawAPryamidd

 

 
 
 DrawAPryamidd:
 
 pryamidpixelsd:
 mov ah,0ch
 mov al,0
 
 
 Drawpryamidloopd: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 getcoordinatesforpryamidd:
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
 getlinepryamidd:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 mov cx,[xpry1]
 mov dx,[ypry1] 
 pryline1d:
 int 10h
 dec cx
 dec dx
 cmp dx, [ypry2]
 jne pryline1d
;;;;;;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline2d:
 int 10h
 inc cx
 dec dx
 cmp dx, [ypry2]
 jne pryline2d
 ;;;;;;;;;;
 mov cx,[xpry3]
 mov dx,[ypry3]
 pryline3d:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx, [ypry4]
 jne pryline3d

 mov cx,[xpry1]
 mov dx,[ypry1]
 pryline4d:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline4d
 ;;;;;
 mov cx,[xpry2]
 mov dx,[ypry2]
 pryline5d:
 int 10h
 inc dx
 cmp dx, [ypry4]
 jne pryline5d
 ;;;;;
 ;;;;;;;;;;
 mov cx,[xpry3]
 add cx ,1
 mov dx,[ypry3]
 add dx ,1
 pryline6d:
 int 10h
 inc cx
 inc cx
 inc dx
 cmp dx,[ypry4]
 jne pryline6d
 ;;;;;
 mov cx,[xpry1]
 sub cx,1
 mov dx,[ypry1]
 add dx,1
 pryline7d:
 int 10h
 dec cx
 dec cx
 inc dx
 cmp dx, [ypry4]
 jne pryline7d
 ;;;;;
;;;;;
popad
ret



equtriangleK: 
pushad
jmp DrawequtriangleK




DrawequtriangleK:
 
 equtrianglepixelsK:
 mov ah,0ch
 mov al,[equtrianglecolour]
 
 DrawequtriangleloopK: 
 getcoordinatesforequtriangleK:
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 add cx,[radiusequtK]
 mov [xequt1K],cx
 mov [yequt1K],dx
 int 10h
 
  mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub dx,[radiusequtK]
 mov [xequt2K],cx
 mov [yequt2K],dx
  int 10h
  
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub cx,[radiusequtK]
 mov [xequt3K],cx
 mov [yequt3K],dx
  int 10h
 
 
 
getlineequtriangleK:
 mov cx,[xequt1K]
 mov dx,[yequt1K] 
equtline1K:
 int 10h
 dec cx
 dec dx
 cmp cx, [xequt3K]
 cmp dx, [yequt2K]
 jnz equtline1K 

 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline2K:
 int 10h
 inc cx
 dec dx
 cmp cx, [xequt1K]
 cmp dx, [yequt2K]
 jnz equtline2K
 
 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline3K:
 int 10h
 inc cx
 cmp cx, [xequt1K]
 jnz equtline3K
popad
 ret
 ;;;;;;
 
equtriangleKd: 
pushad
jmp DrawequtriangleKd
DrawequtriangleKd:
 
 equtrianglepixelsKd:
 mov ah,0ch
 mov al, 0
 
 DrawequtriangleloopKd: 
 getcoordinatesforequtriangleKd:
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 add cx,[radiusequtK]
 mov [xequt1K],cx
 mov [yequt1K],dx
 int 10h
 
  mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub dx,[radiusequtK]
 mov [xequt2K],cx
 mov [yequt2K],dx
  int 10h
  
 mov cx, [xequtcK]
 mov dx, [yequtcK]
 sub cx,[radiusequtK]
 mov [xequt3K],cx
 mov [yequt3K],dx
  int 10h
 
 
 
getlineequtriangleKd:
 mov cx,[xequt1K]
 mov dx,[yequt1K] 
equtline1Kd:
 int 10h
 dec cx
 dec dx
 cmp cx, [xequt3K]
 cmp dx, [yequt2K]
 jnz equtline1Kd

 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline2Kd:
 int 10h
 inc cx
 dec dx
 cmp cx, [xequt1K]
 cmp dx, [yequt2K]
 jnz equtline2Kd
 
 mov cx,[xequt3K]
 mov dx,[yequt3K]
 equtline3Kd:
 int 10h
 inc cx
 cmp cx, [xequt1K]
 jnz equtline3Kd
popad
 ret
 
 ;;;;;;;;;;
circlek:
call intial
call getcc
jmp Drawcirclek

 
 
 circlepixelsk:
 mov ah,0ch
 mov al, [equtrianglecolour]
 mov cx,[columnck]
 mov dx,[rowck]
 int 10h
 ret
 
 Drawcirclek:

 Drawcircleloopk:
 mov bx, [radiusfck]
 mov [xck],bx 
 
Plotcirclepixelsk:

;condition is x>y
mov bx,[xck]
cmp bx,[yck]
jl donecirclek
 ;(xc+x,yc+y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+x,yc-y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-x,yc+y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-x,yc-y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+y,yc+x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc+y,yc-x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-y,yc+x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 ;(xc-y,yc-x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelsk
 
 ; Update state values and check error:
        cmp word [circleerrork], 0
	jge greatercirclek
	inc word [yck]
	mov ax ,[yck]
	add ax,ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax
	jmp Plotcirclepixelsk

   greatercirclek:
	dec word [xck]
	mov ax , [xck]
	add ax,ax
        neg ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax	
	jmp Plotcirclepixelsk
  
donecirclek: 
ret 

circlekd:
call intial
call getcc
jmp Drawcirclekd

 
 
 circlepixelskd:
 mov ah,0ch
 mov al,0
 mov cx,[columnck]
 mov dx,[rowck]
 int 10h
 ret
 
 Drawcirclekd:
 
 
 
 Drawcircleloopkd:
 mov bx, [radiusfck]
 mov [xck],bx 
 
Plotcirclepixelskd:

;condition is x>y
mov bx,[xck]
cmp bx,[yck]
jl donecirclekd
 ;(xc+x,yc+y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+x,yc-y)
 mov cx, [xcck]
 add cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-x,yc+y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-x,yc-y)
 mov cx, [xcck]
 sub cx, [xck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[yck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+y,yc+x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc+y,yc-x)
 mov cx, [xcck]
 add cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-y,yc+x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 add dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 ;(xc-y,yc-x)
 mov cx, [xcck]
 sub cx, [yck]
 mov [columnck],cx
 mov dx, [ycck]
 sub dx,[xck]
 mov [rowck], dx
 call circlepixelskd
 
 ; Update state values and check error:
        cmp word [circleerrork], 0
	jge greatercirclekd
	inc word [yck]
	mov ax ,[yck]
	add ax,ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax
	jmp Plotcirclepixelskd

   greatercirclekd:
	dec word [xck]
	mov ax , [xck]
	add ax,ax
        neg ax
	inc ax
	add ax,[circleerrork]
        mov [circleerrork],ax	
	jmp Plotcirclepixelskd
        call donecirclekd
        ret
donecirclekd:
pushad 
mov eax,0
mov ebx,0
mov [xcck],eax
mov [ycck],ebx
popad
ret  
intial:
pushad 
    mov word[xck],0
    mov word[xcck],0
    mov word[yck],0
    mov word[ycck],0
    mov word[circleerrork],0
    mov word[columnck],0
    mov word[rowck],0
    mov eax,[radiusfck1]
    add eax,1
    mov [radiusfck],eax
popad
ret
 
getcc:
    pushad
    mov eax,[xr]
    mov ebx,[yr]
    mov [xcck],eax
    mov [ycck],ebx
    popad
    ret
    
 radiusfck1: dw 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
>>>>>>> parent of 33abaae... Revert "Merge branch 'master' of https://github.com/kemoszn/Assembly-Project"
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00