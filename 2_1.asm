STACK1         SEGMENT   PARA STACK
STACK_AREA     DW        100H DUP(?)
STACK_BTM      EQU       $ - STACK_AREA
STACK1         ENDS

DATA1          SEGMENT
               DW        25 DUP(?)
src            DB        '1','5','0','6','1','0','9','9'
               DB        '1','5','0','6'
dst  		   DB        '1','4'
			   DB        '$'
DATA1          ENDS

CODE1          SEGMENT
               ASSUME    CS:CODE1, DS:DATA1, SS:STACK1
MAIN           PROC      FAR

               MOV       AX,STACK1
			   MOV       SS,AX
			   MOV       SP,STACK_BTM
			   MOV       AX,DATA1
			   MOV       DS,AX
			   
			   mov       si,offset src
			   mov       bx,0
calcu:		   lodsb
               add       bx,1
               cmp       al,'$'
			   jnz       calcu
			   ; bx存放src的长度，包含$
			   
			   mov       cx,offset src
			   mov       dx,offset dst
			   cmp       cx,dx
			   jb        srcpre
			   ja        dstpre
			   jmp       EXIT

			   
			   
srcpre:        mov       ax,offset src
               add       ax,bx
			   cmp       ax,offset dst
			   ja        has_1  ;src   重叠   dst
               
			   mov       si,offset src
			   mov       cx,offset dst
carr1:		   lodsb
			   push      si
               mov       si,cx
			   mov       byte ptr[si],al
			   add       cx,1
			   cmp       al,'$'
			   jz        EXIT
			   pop       si
			   jmp       carr1
			   
has_1:         mov       si,offset src
			   mov       di,offset dst
			   add       si,bx
			   add       di,bx
spe:		   sub       si,1
			   sub       di,1
			   mov       al,[si]
               mov       byte ptr[di],al
			   cmp       si,offset src
			   jz        EXIT
               jmp       spe

dstpre:        mov       si,offset src
			   mov       cx,offset dst
carr2:		   lodsb
			   push      si
               mov       si,cx
			   mov       byte ptr[si],al
			   add       cx,1
			   cmp       al,'$'
			   jz        EXIT
			   pop       si
			   jmp       carr2   
			   
EXIT:          mov       ax,4c00h
               int       21h			   			   
			  
CODE1          ENDS
               END       MAIN

























