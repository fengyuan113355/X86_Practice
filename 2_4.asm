STACK1        SEGMENT      PARA   STACK
STACK_AREA    DW           100h DUP(?)
STACK_BTM     EQU          $ - STACK_AREA
STACK1        ENDS

DATA1         SEGMENT
num           EQU          6
singlen       EQU          5
str1          DB           "efsr$"
str2          DB           "adnf$"
str3          DB           "bsrt$"
str4          DB           "jetr$"
str5          DB           "bsrt$"
str6          DB           "jdtr$"
temp          DB           "     "
DATA1         ENDS

CODE1         SEGMENT
              ASSUME       CS:CODE1, DS:DATA1, SS:STACK1, ES:DATA1
MAIN          PROC         FAR
              mov          ax,STACK1
			  mov          ss,ax
			  mov          bp,STACK_BTM
			  mov          ax,DATA1
			  mov          ds,ax
			  mov          es,ax
			  
			  mov          ax,num
turn1:		  mov          bx,0
turn2:	      cmp          bx,ax
              jae          bre
			  mov          cx,offset str1
			  push         ax
			  mov          al,singlen
			  mul          bl
			  add          cx,ax
			  pop          ax
			  mov          si,cx
			  add          cx,singlen
			  mov          di,cx
			  call         onerous
			  add          bx,1
			  jmp          turn2	
			  
bre:          sub          ax,1
              cmp          ax,0
              ja           turn1
			   
			  mov          ax,4c00h
			  int          21h 
			  
			  
			  
			  
onerous       proc
              ; si  ;di
			  push         di
			  push         si
              mov          cx,singlen
			  cld
			  repe         cmpsb
			  jbe          endd
			  pop          si
			  pop          di
			  ;;1  2互换位置
			  ;2--->temp
			  push         di
			  push         si
			  mov          si,di
			  mov          di,offset temp
			  mov          cx,singlen
			  cld
			  rep          movsb
			  pop          si
			  pop          di
			  ;1--->2
			  push         di
			  push         si
			  mov          cx,singlen
			  cld
			  rep          movsb
			  pop          si
			  pop          di
			  ;temp--->1
			  push         di
			  push         si
			  mov          di,si
			  mov          si,offset temp
              mov          cx,singlen
              cld
              rep          movsb			  		  
endd:         pop          si
              pop          di
			  
			  
			  
			  
			  ret
onerous       endp




CODE1         ENDS
              END          MAIN






















