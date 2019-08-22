STACK1        SEGMENT   PARA     STACK 
STACK_AREA    DW        100H DUP(?)
STACK_BTM     EQU       $ - STACK_AREA
STACK1        ENDS

DATA1         SEGMENT   
len           EQU       11
buff1         DB        '1','5','0','6','a','A','b','c','D','9','9'
temp          DW        10 DUP(?)
found         DB        "FOUND$"
notfound      DB        "NOT "
buff2         DW        10 DUP(?)
DATA1         ENDS 

CODE1         SEGMENT
              ASSUME   CS:CODE1, DS:DATA1, SS:STACK1, ES:DATA1
MAIN          PROC     FAR
			  ;大小写转换，复制，在转换后的串中查找
			  mov      ax,STACK1
			  mov      ss,ax
			  mov      bp,STACK_BTM
			  mov      ax,DATA1
			  mov      ds,ax
			  mov      es,ax
			  
			  mov      si,offset buff1
			  cld
			  mov      cx,len
turn:		  lodsb
			  cmp      al,'a'
              jb   	   skip	  
			  cmp      al,'z'
			  ja       skip
			  sub      al,32
			  sub      si,1
			  mov      BYTE ptr[si],al
			  add      si,1
skip:    	  sub      cx,1
              cmp      cx,0
			  ja       turn
			  
			  
			  
duplica:      mov      si,offset buff1
              mov      di,offset buff2
			  mov      cx,len
			  cld
			  rep      movsb

sear:         mov      di,offset buff1
              mov      al,'A'
			  mov      cx,len
			  cld
			  repne    scasb
			  jz       Fo
			  mov      ax,0900h
			  mov      dx,offset notfound
			  int      21h

Fo:           mov      ax,0900h
              mov      dx,offset found
			  int      21h
			  
			  
			  
EXIT:         mov      ax,4c00h
              int      21h
			  
			  
			  
CODE1         ENDS
              END      MAIN

