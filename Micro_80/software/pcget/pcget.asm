USARTD  =	0e8h
USARTC  =	0e9h

XMTMASK	=	1		;MASK TO ISOLATE XMIT READY BIT
XMTRDY	=	1		;VALUE WHEN READY
RCVMASK	=	2		;MASK TO ISOLATE RECEIVE READY BIT
RCVRDY	=	2		;VALUE WHEN READY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;XMODEM Protocol Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SOH	=	1
EOT	=	4
ACK	=	6
NAK	=	21
CTRLC	=	3
LF	=	10
CR	=	13

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CP/M 2 BDOS Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RDCON	=	1
WRCON	=	2
PRINT	=	9
CONST	=	11	;CONSOLE STAT
OPEN	=	15	;0FFH=NOT FOUND
CLOSE	=	16	;   "	"
SRCHF	=	17	;   "	"
SRCHN	=	18	;   "	"
ERASE	=	19	;NO RET CODE
READ	=	20	;0=OK, 1=EOF
WRITE	=	21	;0=OK, 1=ERR, 2=?, 0FFH=NO DIR SPC
MAKE	=	22	;0FFH=BAD
REN	=	23	;0FFH=BAD
STDMA	=	26
BDOS	=	5
REIPL	=	0
FCB	=	5CH	;DEFAULT FCB
PARAM1	=	FCB+1	;COMMAND LINE PARAMETER 1 IN FCB
PARAM2	=	PARAM1+16	;COMMAND LINE PARAMETER 2

	.org 100h
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;START -- Get ready and begin the transfer
;
;This routine checks for the presence of a filename. If no
;filename is supplied, a help message is printed and we
;exit.
;
;Falls through to DOXFER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START:	LDA	PARAM1		;A=1st character of parameter 1
	CPI	' '		;make sure file name present
	JNZ	HAVEFN		;yes, have a file name
	LXI	D,MHELP		;display usage message
	MVI	C,PRINT
	CALL	BDOS
	RET			;return to CPM

HAVEFN:	
	LXI	D,MSENDC	;CONSOLE port send message

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DOXFER -- Switch to a local stack and start transfer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DOXFER:	
	LXI	H,0		;HL=0
	DAD	SP		;HL=STACK FROM CP/M
	SHLD	STACK		;..SAVE IT
	LXI	SP,STACK	;SP=MY STACK
	XRA	A
	STA	SECTNO		;init sector number to zero
	MVI	C,PRINT		;print the send message
	CALL	BDOS		;PRINT ID MESSAGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PURGE -- Consume garbage characters from the line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PURGE:	MVI	B,1		;times out after 1 second if no data
	CALL	RECV
	JC	RECEIVEFILE	;line is clear, go receive the file
	CPI	CTRLC		;exit if abort requested
	JZ	ABORT
	JMP	PURGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RECEIVE$FILE -- Receive the file via XMODEM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECEIVEFILE:
	CALL	ERASEOLDFILE
	CALL	MAKENEWFILE
	MVI	A,NAK
	CALL	SEND		;SEND NAK

RECVLOOP:
RECVHDR:
	MVI	B,3		;3 SEC TIMEOUT
	CALL	RECV
	JNC	RHNTO		;NO TIMEOUT

RECVHDRTIMEOUT:
RECVSECTERR:			;PURGE THE LINE OF INPUT CHARS
	MVI	B,1		;1 SEC W/NO CHARS
	CALL	RECV
	JNC	RECVSECTERR 	;LOOP UNTIL SENDER DONE
	MVI	A,NAK
	CALL	SEND		;SEND NAK
	JMP	RECVHDR

;GOT CHAR - MUST BE SOH OR CTRL-C TO ABORT

RHNTO:	CPI	SOH
	JZ	GOTSOH
	CPI	CTRLC		;control-c to abort?
	JZ	ABORT
	CPI	EOT
	JZ	GOTEOT
	JMP	RECVSECTERR

GOTSOH:
	MVI	B,1
	CALL	RECV
	JC	RECVHDRTIMEOUT
	MOV	D,A		;D=BLK #
	MVI	B,1
	CALL	RECV		;GET CMA'D SECT #
	JC	RECVHDRTIMEOUT
	CMA
	CMP	D		;GOOD SECTOR #?
	JZ	RECVSECTOR
	JMP	RECVSECTERR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RECV$SECTOR -- Get a sector via XMODEM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECVSECTOR:
	MOV	A,D		;GET SECTOR #
	STA	RSECTNO
	MVI	C,0		;INIT CKSUM
	LXI	H,80H		;POINT TO BUFFER

RECVCHAR:
	MVI	B,1		;1 SEC TIMEOUT
	CALL	RECV		;GET CHAR
	JC	RECVHDRTIMEOUT
	MOV	M,A		;STORE CHAR
	INR	L		;DONE?
	JNZ	RECVCHAR

				;VERIFY CHECKSUM
	MOV	D,C		;SAVE CHECKSUM
	MVI	B,1		;TIMEOUT
	CALL	RECV		;GET CHECKSUM
	JC	RECVHDRTIMEOUT
	CMP	D		;CHECK
	JNZ	RECVSECTERR

	LDA	RSECTNO		;GOT A SECTOR, WRITE IF = 1+PREV SECTOR
	MOV	B,A		;SAVE IT
	LDA	SECTNO		;GET PREV
	INR	A		;CALC NEXT SECTOR #
	CMP	B		;MATCH?
	JNZ	DOACK

	LXI	D,FCB		;GOT NEW SECTOR - WRITE IT
	MVI	C,WRITE
	CALL	BDOS
	ORA	A
	JNZ	WRITEERROR
	LDA	RSECTNO
	STA	SECTNO		;UPDATE SECTOR #
DOACK:	MVI	A,ACK
	CALL	SEND
	JMP	RECVLOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;WRITE$ERROR -- Print file write error and exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WRITEERROR:
	CALL	ERXIT
	.DB	CR,LF,LF,"Error Writing File",CR,LF,"$"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GOT$EOT -- Handle end-of-transfer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GOTEOT:
	MVI	A,ACK		;ACK THE EOT
	CALL	SEND
	LXI	D,FCB
	MVI	C,CLOSE
	CALL	BDOS
	INR	A
	JNZ	XFERCPLT
	CALL	ERXIT
	.DB	CR,LF,LF,"Error Closing File",CR,LF,"$"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ERASE$OLD$FILE -- Delete any existing file before transfer
;
;Caution! If the transfer fails, the old file will stilll
;have been deleted!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERASEOLDFILE:
	LXI	D,FCB
	MVI	C,SRCHF		;SEE IF IT EXISTS
	CALL	BDOS
	INR	A		;FOUND?
	RZ			;NO, RETURN
ERAY:	LXI	D,FCB
	MVI	C,ERASE
	CALL	BDOS
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MAKE$NEW$FILE -- Create a new empty file to write to
;
;This empty file will be what's left if the transfer fails,
;since we call ERASE$OLD$FILE first.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAKENEWFILE:
	LXI	D,FCB
	MVI	C,MAKE
	CALL	BDOS
	INR	A		;FF=BAD
	RNZ			;OPEN OK


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DIRFUL -- Print directory full error and exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DIRFUL:	CALL	ERXIT
	.DB	CR,LF,LF,"Error - Can't Make File"
	.DB     CR,LF
	.DB	"(directory must be full)",CR,LF,"$"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ERXIT -- Exit and print an error message
;
;The error message to be printed by this routine should be
;a $-terminated string following the call to ERXIT.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ERXIT:	POP	D		;GET MESSAGE
	MVI	C,PRINT
	CALL	BDOS		;PRINT MESSAGE
EXIT:	LHLD	STACK		;GET ORIGINAL STACK
	SPHL			;RESTORE IT
	RET			;Back to CP/M


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RECV -- XMODEM receive routine
;
;This routine contains code that will be modified at run
;time if a non-default port is selected for the transfer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECV:	PUSH	D		;Save DE
MSEC:	LXI	D,2000h		;63 cycles, 4.032ms/wrap*248=1s (4MHz)


MWTI:	IN	USARTC		;(10)
	ANI	RCVMASK		;(7)
	CPI	RCVRDY		;(7)
	JZ	MCHAR		;(10) GOT CHAR

	CPI	0		;(7) No char present, decrement countdown
	CPI	0		;(7) waste some time
	DCR	E		;(5) COUNT DOWN
	JNZ	MWTI		;(10) FOR TIMEOUT
	DCR	D		;do msb every 256th time
	JNZ	MWTI
	DCR	B		;DCR # OF SECONDS
	JNZ	MSEC

	POP	D		;Receive timed out, restore DE
	STC			;Set carry flag to show timeout
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MCHAR -- Process XMODEM character
;
;This routine contains code that will be modified at run
;time if a non-default port is selected for the transfer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MCHAR:	IN	USARTD
	POP	D		;RESTORE DE
	PUSH	PSW		;CALC CHECKSUM
	ADD	C
	MOV	C,A
	POP	PSW
	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
	RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SEND -- Transmit an XMODEM character
;
;This routine contains code that will be modified at run
;time if a non-default port is selected for the transfer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SEND	PUSH	PSW		;CHECK IF MONITORING OUTPUT
	ADD	C		;CALC CKSUM
	MOV	C,A

SENDW	IN	USARTC
	ANI	XMTMASK
	CPI	XMTRDY
	JNZ	SENDW
	POP	PSW		;GET CHAR

	OUT	USARTD
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;XFER$CPLT -- XMODEM transfer done, clean up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
XFERCPLT:
	CALL	ERXIT
	.DB	CR,LF,LF,"Transfer Complete",CR,LF,"$"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ABORT -- Exit from a user abort
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ABORT:	call	ERXIT
	.db	CR,LF,LF,"Transfer Aborted",CR,LF,"$"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Message Strings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MSENDC:	.db	"Send file using XMODEM on RS232...$"
MHELP:	.db	CR,LF,"PCGET v1.0.1 for Micro 80",CR,LF,LF
	.db	"Receives a file from a PC through",CR,LF
	.db	"a serial portusing the XMODEM protocol.",CR,LF,LF
	.db	"Usage: PCGET file.ext",CR,LF,'$'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Variables and Storage Defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.DS	40	;STACK AREA
STACK:	.DS	2	;STACK POINTER
RSECTNO:.DS	1	;RECEIVED SECTOR NUMBER
SECTNO:	.DS	1	;CURRENT SECTOR NUMBER

	.END
