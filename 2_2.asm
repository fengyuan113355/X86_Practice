STACK1         SEGMENT   PARA STACK
STACK_AREA     DW        100H DUP(?)
STACK_BTM      EQU       $ - STACK_AREA
STACK1         ENDS

DATA1          SEGMENT
src            DB        '1','5','0','6','1','0','9','9'
			   DB        '$'
name1          DB        '1','0','9','9','$'
name2          DB        'f','e','n','g','y','u','a','n','$'
DATA1          ENDS

CODE1          SEGMENT
               ASSUME    CS:CODE1, DS:DATA1, SS:STACK1, ES:DATA1
MAIN           PROC      FAR

               MOV       AX,STACK1
			   MOV       SS,AX
			   MOV       SP,STACK_BTM
			   MOV       AX,DATA1
			   MOV       DS,AX
			   MOV       ES,AX
			   
			   mov       dx,offset src;dx寄存器用于记录源串的开始匹配位置
turn:   	   mov       si,dx
               mov       al,[si]
			   cmp       al,'$'
			   jne       broad
			   mov       ax,4c00h
               int       21h
			   
broad:
               mov       di,offset name1
conti:		   mov       al,[di]
               cmp       al,'$'
			   jz        substi
               cmpsb
               jz        conti
               sub       si,1
               sub       di,1
               mov       al,[di]
               cmp       al,'$'
               jz        substi
               add       dx,1
			   jmp       turn


substi:		   sub       si,1
               mov       bx,si
               ;源串中dx位置偏移开始替换,替换到bx结束
               ;需要判断name1和name2两个串长度的关系
               push      bx
			   push      dx
			   mov       si,offset name1
			   mov       bx,0
cal_1:		   lodsb
			   cmp       al,'$'
			   jz        cal_1end
			   add       bx,1
			   jmp       cal_1   
cal_1end:      

               mov       si,offset name2
			   mov       cx,0
cal_2:		   lodsb
			   cmp       al,'$'
			   jz        cal_2end
			   add       cx,1
			   jmp       cal_2   
cal_2end:      
			   ;bx cx--->name1  name2 长度
			   cmp       bx,cx
			   ja        n1big
			   jmp       n2big
			   
			   
n1big:         pop       dx
               pop       bx
			   ;cx为name2长度
			   mov       di,dx
			   mov       si,offset name2
sa1:		   mov       al,[di]
               cmp       al,'$'
               jz        sa1_end	
               movsb
			   jmp       sa1
sa1_end:	   mov       si,bx
               mov       di,dx
               add       di,cx
sa2:           mov       al,[si]
               cmp       al,'$'
               jz        EXIT
               movsb
               jmp       sa2			   


n2big:		   ;cx为name2长度
			   mov       si,offset src
temp:		   lodsb
			   cmp       al,'$'
			   jnz       temp
			   sub       si,1
			   mov       ax,cx
			   sub       ax,bx
			   pop       dx
               pop       bx
			   mov       di,si
			   add       di,ax
			   sub       si,1
			   sub       di,1
sa3:           std
               movsb
			   cmp       bx,si
			   jbe       sa3


			   mov       si,offset name2
			   mov       di,dx
sa4:           mov       al,[si]
               cmp       al,'$'
			   je        EXIT
			   cld
			   movsb
			   jmp       sa4
			   
EXIT:          mov       ax,4c00h
               int       21h			   			   
			  
CODE1          ENDS
               END       MAIN

























