;=================================================================================
;---------------------------------| TIC TAC TOE |---------------------------------
;=================================================================================


;-----------------| Group Members: Awais Mansoor & Talha Balaj |------------------


.386 
.MODEL flat, stdcall
.STACK
INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDE Macros.inc

leftPressed PROTO, leftSum:DWORD
upPressed PROTO, upSum:DWORD
rightPressed PROTO, rightSum:DWORD
downPressed PROTO, downSum:DWORD
;---------------------------------------------------------------

.data

BufferInfo CONSOLE_SCREEN_BUFFER_INFO <>
;---------------------------------------------
boardArray1 BYTE ' ' , ' ' , '|' , ' ' , ' ' , ' ' , '|' ,' ' ,' '
;----------------------------------------------------------------
boardArray2 BYTE ' ' , ' ' , '|' , ' ' , ' ' , ' ' , '|' ,' ' ,' '
;----------------------------------------------------------------
boardArray3 BYTE ' ',  ' ' , '|' , ' ' , ' ' , ' ' , '|' ,' ' ,' '
;----------------------------------------------------------------
turn BYTE 2
;-----------
toggle DWORD ?
;-------------
sumForCursor DWORD ?
sumForChar BYTE 0
;----------
x DWORD ?
;--------
y DWORD ?
;--------


.code 

main PROC

jmp startFirst

restartRequest:
	call clrscr

startFirst:

	call board
    call game
    
	call crlf
	call crlf
	
	mov EAX, cyan
	call setTextColor

	mov DH, 14
	mov DL, 0
	call gotoxy
	mWrite "Press 1 to Play Again or any other no. to exit: "

	call readDec
	mov EBX, EAX
	cmp EBX, 1
	je restartRequest
	
	call crlf
	call crlf
	
	mov EAX, magenta
	call setTextColor
	mWrite "Thank You for playing!"
	
	call crlf
	call crlf
	
	mov EAX, white
	call setTextColor

INVOKE ExitProcess, 0
main ENDP
;---------------------------------------------------------------

winCond PROC, count:DWORD
	
	cmp count, 4
	ja evaluate

	ret
evaluate:
	


winCond ENDP

;---------------------------------------------------------------
board PROC

;----------------------------------
;TO DISPLAY TIC TAC TOE GAME

	mov EAX, yellow
	call setTextColor
	mov DH, 2		;row
	mov DL, 44   	;colomn
	call gotoxy
	mWrite "TIC TAC TOE"

	call crlf
	call crlf

	
;----------------------------------
;TO DISPLAY PLAYER INFO

	mov EAX, lightBlue
	call setTextColor
	mov DH, 5		;row
	mov DL, 35		;colomn
	call gotoxy
	mWrite "PLAYER 1 (O) | PLAYER 2 (X)"

	call crlf
	call crlf
	
;----------------------------------
;LOOP TO DISPLAY FIRST ARRAY

	mov ECX, LENGTHOF boardArray1
	lea ESI, boardArray1
	mov EAX, lightRed
	call setTextColor
	mov DH, 8		;row
	mov DL, 45   	;colomn
	call gotoxy
fstAry:
	mov AL, [ESI]
	call writechar
	inc ESI
loop fstAry

	call crlf
	
	mov DH, 9		;row
	mov DL, 45   	;colomn
	call gotoxy
	mWrite "--+---+--"	
	call crlf

;----------------------------------
;LOOP TO DISPLAY SECOND ARRAY

	mov ECX, LENGTHOF boardArray2
	lea ESI, boardArray2
	mov DH, 10		;row
	mov DL, 45   	;colomn
	call gotoxy
scdAry:
	mov AL, [ESI]
	call writechar
	inc ESI
loop scdAry

	call crlf

	mov DH, 11		;row
	mov DL, 45   	;colomn
	call gotoxy
	mWrite "--+---+--"	
	call crlf

;----------------------------------
;LOOP TO DISPLAY THIRD ARRAY

	mov ECX, LENGTHOF boardArray3
	lea ESI, boardArray3
	mov DH, 12		;row
	mov DL, 45   	;colomn
	call gotoxy
trdAry:
	mov AL, [ESI]
	call writechar
	inc ESI
loop trdAry
	call crlf
	call crlf 
	
ret

board ENDP
;---------------------------------------------------------------



;---------------------------------------------------------------
game PROC
	
	mov DH, 8
	mov DL, 45
	call gotoxy

	mov ECX, 0
	
again:

	PUSH ECX
	invoke GetStdHandle, STD_OUTPUT_HANDLE
    invoke GetConsoleScreenBufferInfo, EAX, ADDR BufferInfo

    movzx EAX, BufferInfo.dwCursorPosition.X
	mov y, EAX
	mov sumForCursor, EAX
    movzx EAX, BufferInfo.dwCursorPosition.Y
	mov x, EAX
	add sumForCursor, EAX

	POP ECX
	call readChar
	
	cmp AL, 'a'
	je l
	
	cmp AL, 'w'
	je u
	
	cmp AL, 'd'
	je r
	
	cmp AL, 's' 
	je d

	jmp input
	
l:
	INVOKE leftPressed, sumForCursor
	jmp again
u:
	INVOKE upPressed, sumForCursor
	jmp again
r:
	INVOKE rightPressed, sumForCursor
	jmp again
d:
	INVOKE downPressed, sumForCursor
	jmp again

input:
	PUSH ECX
	mov BL, AL

	invoke GetStdHandle, STD_OUTPUT_HANDLE
    invoke GetConsoleScreenBufferInfo, EAX, ADDR BufferInfo

    movzx EAX, BufferInfo.dwCursorPosition.X
	mov DL, AL
    movzx EAX, BufferInfo.dwCursorPosition.Y
	mov DH, AL
	mov AL, BL

	call writeChar

	call gotoxy	
	POP ECX
	add ECX, 1
	cmp ECX, 9
	je nextTurn
	jmp again

nextTurn:
ret
game ENDP
;---------------------------------------------------------------

;---------------------------------------------------------------
leftPressed PROC, leftSum:DWORD
	cmp leftSum, 53
	je leftCel1

	cmp leftSum, 55
	je leftCel4

	cmp leftSum, 59
	je leftCel5

	cmp leftSum, 63
	je leftCel6

	cmp leftSum, 65
	je leftCel9

	cmp leftSum, 57
	je leftDupCase57

	cmp leftSum, 61
	je leftDupCase61

leftCel1:
	mov DH, 8
	mov DL, 53
	call gotoxy
	ret

leftCel4:
	mov DH, 10
	mov DL, 53
	call gotoxy
	ret

leftCel5:
	mov DH, 10
	mov DL, 45
	call gotoxy
	ret

leftCel6:
	mov DH, 10
	mov DL, 49
	call gotoxy
	ret

leftCel9:
	mov DH, 12
	mov DL, 49
	call gotoxy
	ret
	
leftDupCase57:
	cmp y, 49
	je leftEight1
	
	mov DH, 12
	mov DL, 53
	call gotoxy
	ret

leftEight1:
	mov DH, 8
	mov DL, 45
	call gotoxy
	ret
	
leftDupCase61:
	cmp y, 49
	je leftEight2
	
	mov DH, 8
	mov DL, 49
	call gotoxy
	ret

leftEight2:
	mov DH, 12
	mov DL, 45
	call gotoxy
	ret

leftPressed ENDP
;---------------------------------------------------------------



;---------------------------------------------------------------
upPressed PROC, upSum:DWORD
	cmp upSum, 53
	je upCel1

	cmp upSum, 55
	je upCel4

	cmp upSum, 59
	je upCel5

	cmp upSum, 63
	je upCel6

	cmp upSum, 65
	je upCel9

	cmp upSum, 57
	je upDupCase57

	cmp upSum, 61
	je upDupCase61

upCel1:
	mov DH, 12
	mov DL, 45
	call gotoxy
	ret

upCel4:
	mov DH, 8
	mov DL, 45
	call gotoxy
	ret

upCel5:
	mov DH, 8
	mov DL, 49
	call gotoxy
	ret

upCel6:
	mov DH, 8
	mov DL, 53
	call gotoxy
	ret

upCel9:
	mov DH, 10
	mov DL, 53
	call gotoxy
	ret
	
upDupCase57:
	cmp y, 49
	je upEight1
	
	mov DH, 10
	mov DL, 45
	call gotoxy
	ret

upEight1:
	mov DH, 12
	mov DL, 49
	call gotoxy
	ret
	
upDupCase61:
	cmp y, 49
	je upEight2
	
	mov DH, 12
	mov DL, 53
	call gotoxy
	ret

upEight2:
	mov DH, 10
	mov DL, 49
	call gotoxy
	ret

upPressed ENDP
;---------------------------------------------------------------



;---------------------------------------------------------------
rightPressed PROC, rightSum:DWORD
	cmp rightSum, 53
	je rightCel1

	cmp rightSum, 55
	je rightCel4

	cmp rightSum, 59
	je rightCel5

	cmp rightSum, 63
	je rightCel6

	cmp rightSum, 65
	je rightCel9

	cmp rightSum, 57
	je rightDupCase57

	cmp rightSum, 61
	je rightDupCase61

rightCel1:
	mov DH, 8
	mov DL, 49
	call gotoxy
	ret

rightCel4:
	mov DH, 10
	mov DL, 49
	call gotoxy
	ret

rightCel5:
	mov DH, 10
	mov DL, 53
	call gotoxy
	ret

rightCel6:
	mov DH, 10
	mov DL, 45
	call gotoxy
	ret

rightCel9:
	mov DH, 12
	mov DL, 45
	call gotoxy
	ret
	
rightDupCase57:
	cmp y, 49
	je rightEight1
	
	mov DH, 12
	mov DL, 49
	call gotoxy
	ret

rightEight1:
	mov DH, 8
	mov DL, 53
	call gotoxy
	ret
	
rightDupCase61:
	cmp y, 49
	je rightEight2
	
	mov DH, 8
	mov DL, 45
	call gotoxy
	ret

rightEight2:
	mov DH, 12
	mov DL, 53
	call gotoxy
	ret

rightPressed ENDP
;---------------------------------------------------------------



;---------------------------------------------------------------
downPressed PROC, downSum:DWORD
	cmp downSum, 53
	je downCel1

	cmp downSum, 55
	je downCel4

	cmp downSum, 59
	je downCel5

	cmp downSum, 63
	je downCel6

	cmp downSum, 65
	je downCel9

	cmp downSum, 57
	je downDupCase57

	cmp downSum, 61
	je downDupCase61

downCel1:
	mov DH, 10
	mov DL, 45
	call gotoxy
	ret

downCel4:
	mov DH, 12
	mov DL, 45
	call gotoxy
	ret

downCel5:
	mov DH, 12
	mov DL, 49
	call gotoxy
	ret

downCel6:
	mov DH, 12
	mov DL, 53
	call gotoxy
	ret

downCel9:
	mov DH, 8
	mov DL, 53
	call gotoxy
	ret
	
downDupCase57:
	cmp y, 49
	je downEight1
	
	mov DH, 8
	mov DL, 45
	call gotoxy
	ret

downEight1:
	mov DH, 10
	mov DL, 49
	call gotoxy
	ret
	
downDupCase61:
	cmp y, 49
	je downEight2
	
	mov DH, 10
	mov DL, 53
	call gotoxy
	ret

downEight2:
	mov DH, 8
	mov DL, 49
	call gotoxy
	ret

downPressed ENDP
;---------------------------------------------------------------


END main
;============================================================================================