;
;  PCPUT - This CP/M program sends a file from the CP/M machine to a PC using
;	a serial port. The file transfer uses the XMODEM protocol. 
;
;  Note this program is gutted from the Ward Christenson Modem program.
;
;  Hacked together by Mike Douglas for the Altair 2SIO serial interface board.
;	Ver	Date	Desc
;	1.0    11/8/12	Initial version
;	1.1    2/20/14  Allow transfer to occur over 2SIO port B
;	1.2   12/21/14  Support CRC as well as checksum
;	1.3   10/16/15	Set initial CRC flag state in software. Was
;			previously random from load.
;
;  Serial Port Equates

USARTD  =     0a0h
USARTC  =     0a1h

XMTMASK	=	1		;MASK TO ISOLATE XMIT READY BIT
XMTRDY	=	1		;VALUE WHEN READY
RCVMASK	=	2		;MASK TO ISOLATE RECEIVE READY BIT
RCVRDY	=	2		;VALUE WHEN READY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;XMODEM Protocol =ates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SOH	=	1
EOT	=	4
ACK	=	6
NAK	=	21
CTRLC	=	3
LF	=	10
CR	=	13

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CP/M 2 BDOS =ates
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
;PARAM2	=	PARAM1+16	;COMMAND LINE PARAMETER 2

;SIOACR	=	010H		;2SIO port A control register
;SIOADR	=	011H		;2SIO port A data register
;SIOBCR	=	012H		;2SIO port B control register
;SIOBDR	=	013H		;2SIO port B data register

;XMTMASK	=	2		;MASK TO GET XMIT READY BIT
;XMTRDY	=	2		;VALUE WHEN READY
;RCVMASK	=	1		;MASK TO GET RECEIVE DATA AVAILABLE
;RCVRDY	=	1		;BIT ON WHEN READY

ERRLMT	=	5		;MAX ALLOWABLE ERRORS

;DEFINE ASCII CHARACTERS USED

;SOH	=	1
;EOT	=	4
;ACK	=	6
;NAK	=	15H
;CTRLC	=	3		;Control-C
;LF	=	10
;CR	=	13

	.org	100h

;  Verify a file name was specified

	lda	PARAM1		;A=1st character of parameter 1
	cpi	' '		;make sure something entered
	jnz	havep1
	lxi	d,mHelp		;display usage message
	mvi	c,PRINT
	call	BDOS
	ret			;return to CPM

;  See if port "B" specified (2nd parameter)

havep1:	;mvi	b,0		;assume port b not used
	;lda	PARAM2		;A=1st character of parameter 2
	;ani	5fh		;force upper case
	;cpi	'B'		;port b specified?
	;jnz	doXfer		;no, go do the transfer
	;inr	b		;force flag to non-zero value
	
;  doXfer - Switch to local stack and do the transfer

doXfer:	;mov	a,b		;store the port b flag
	;sta	fPortB
	LXI	H,0		;HL=0
	DAD	SP		;HL=STACK FROM CP/M
	SHLD	STACK		;..SAVE IT
	LXI	SP,STACK	;SP=MY STACK
	xra	a		
	sta	SECTNO		;initialize sector number to zero
	CALL	OPEN_FILE	;OPEN THE FILE
	CALL	INIT_ACIA	;MASTER RESET THE ACIA
	lxi	d,mRcvA		;assume using port A
;	lda	fPortB		;using port B?
;	ora	a
;	jz	sendA
;	lxi	d,mRcvB		;using port B
sendA:	MVI	C,PRINT
	CALL	BDOS		;PRINT ID MESSAGE

;  GOBBLE UP GARBAGE CHARS FROM THE LINE

purge:	MVI	B,1		;times out after 1 second if no data
	CALL	RECV
	jc	lineClr		;line is clear, go wait for initial NAK
	cpi	CTRLC		;exit if abort r=ested
	jz	abort
	jmp	purge

; WAIT FOR INITIAL NAK, THEN SEND THE FILE
	
lineClr:	xra	a		;clear crc flag = checksum mode
	sta	crcFlag
WAITNAK:	MVI	B,1		;TIMEOUT DELAY
	CALL	RECV
	JC	WAITNAK
	cpi	CTRLC		;abort r=ested?
	jz	abort
	CPI	NAK		;NAK RECEIVED?
	jz	SENDB		;yes, send file in checksum mode
	cpi	'C'		;'C' for CRC mode received?
	JNZ	WAITNAK		;no, keep waiting
	sta	crcFlag		;set CRC flag non-zero = true
				;fall through to start the send operation
;
;*****************SEND A FILE***************
;

;READ SECTOR, SEND IT

SENDB:	CALL	READ_SECTOR
	LDA	SECTNO		;INCR SECT NO.
	INR	A
	STA	SECTNO

;SEND OR REPEAT SECTOR

REPTB:	MVI	A,SOH
	CALL	SEND
	LDA	SECTNO
	CALL	SEND
	LDA	SECTNO
	CMA
	CALL	SEND
	lxi	h,0		;init crc to zero
	shld	crc16
	mov	c,h		;init checksum in c to zero
	LXI	H,80H
SENDC:	MOV	A,M
	CALL	SEND
	call	calCrc		;update CRC
	INX	H
	MOV	A,H
	CPI	1		;DONE WITH SECTOR?
	JNZ	SENDC

; Send checksum or CRC based on crcFlag

	lda	crcFlag		;crc or checksum?
	ora	a
	jz	sndCsum		;flag clear = checksum
	lda	crc16+1		;a=high byte of CRC
	call	SEND		;send it
	lda	crc16		;a=low byte of crc
	jmp	sndSkip		;skip next instruction	
sndCsum:	mov	a,c		;send the checksum byte
sndSkip:	call	SEND

;GET ACK ON SECTOR

	MVI	B,4		;WAIT 4 SECONDS MAX
	CALL	RECV
	JC	REPTB		;TIMEOUT, SEND AGAIN

;NO TIMEOUT SENDING SECTOR

	CPI	ACK		;ACK RECIEVED?
	JZ	SENDB		;..YES, SEND NEXT SECT
	cpi	CTRLC		;control-c to abort?
	jz	abort
	JMP	REPTB		;PROBABLY NAK - TRY AGAIN
;
;
; S U B R O U T I N E S
;
;OPEN FILE
OPEN_FILE: LXI	D,FCB
	MVI	C,OPEN
	CALL	BDOS
	INR	A		;OPEN OK?
	RNZ			;GOOD OPEN
	CALL	ERXIT
	.db	13,10,"Can't Open File",13,10,"$"

; - - - - - - - - - - - - - - -
;EXIT PRINTING MESSAGE FOLLOWING 'CALL ERXIT'
ERXIT:	POP	D		;GET MESSAGE
	MVI	C,PRINT
	CALL	BDOS		;PRINT MESSAGE
EXIT:	LHLD	STACK		;GET ORIGINAL STACK
	SPHL			;RESTORE IT
	RET			;--EXIT-- TO CP/M

; - - - - - - - - - - - - - - -
;MODEM RECV
;-------------------------------------
RECV:	PUSH	D		;SAVE
MSEC:	LXI	D,(159 << 8)	;49 cycle loop, 6.272ms/wrap * 159 = 1 second
;	lda	fPortB		;using port B?
;	ora	a
;	jnz	MWTIB

;  port A input

;MWTI	IN	SIOACR
;	ANI	RCVMASK
;	CPI	RCVRDY
;	JZ	MCHAR		;GOT CHAR
;	DCR	E		;COUNT DOWN
;	JNZ	MWTI		;FOR TIMEOUT
;	DCR	D
;	JNZ	MWTI
;	DCR	B		;DCR # OF SECONDS
;	JNZ	MSEC

;MODEM TIMED OUT RECEIVING

;	POP	D		;RESTORE D,E
;	STC			;CARRY SHOWS TIMEOUT
;	RET
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

;GOT MODEM CHAR

;MCHAR	IN	SIOADR
;	POP	D		;RESTORE DE
;	PUSH	PSW		;CALC CHECKSUM
;	ADD	C
;	MOV	C,A
;	POP	PSW
;	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
;	RET
MCHAR:	IN	USARTD
	POP	D		;RESTORE DE
	PUSH	PSW		;CALC CHECKSUM
	ADD	C
	MOV	C,A
	POP	PSW
	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
	RET

;  port B input. Look for Ctrl-C on port A to abort

;MWTIB	IN	SIOBCR
;	ANI	RCVMASK
;	CPI	RCVRDY
;	JZ	MCHARB		;GOT CHAR
;	DCR	E		;COUNT DOWN
;	JNZ	MWTIB		;FOR TIMEOUT
;	in	SIOACR		;see if a ctrl-c pressed on console
;	rrc			;character present?
;	jnc	noCtrlC		;no
;	in	SIOADR
;	cpi	CTRLC		;is it a Ctrl-C?
;	jnz	noCtrlC		;no
;	pop	d		;restore d,e
;	ret			;carry is clear (no timeout), exit

;noCtrlC	DCR	D
;	JNZ	MWTIB
;	DCR	B		;DCR # OF SECONDS
;	JNZ	MSEC

;MODEM TIMED OUT RECEIVING

;	POP	D		;RESTORE D,E
;	STC			;CARRY SHOWS TIMEOUT
;	RET

;GOT MODEM CHAR

;MCHARB	IN	SIOBDR
;	POP	D		;RESTORE DE
;	PUSH	PSW		;CALC CHECKSUM
;	ADD	C
;	MOV	C,A
;	POP	PSW
;	ORA	A		;TURN OFF CARRY TO SHOW NO TIMEOUT
;	RET

; - - - - - - - - - - - - - - -
;MODEM SEND CHAR ROUTINE
;----------------------------------
;
;SEND	PUSH	PSW		;CHECK IF MONITORING OUTPUT
;	ADD	C		;CALC CKSUM
;	MOV	C,A
;	lda	fPortB		;using port B?
;	ora	a
;	jnz	SENDWB

; Use port A

;SENDW	IN	SIOACR
;	ANI	XMTMASK
;	CPI	XMTRDY
;	JNZ	SENDW
;	POP	PSW		;GET CHAR
;	OUT	SIOADR
;	RET
SEND:	PUSH	PSW		;CHECK IF MONITORING OUTPUT
	ADD	C		;CALC CKSUM
	MOV	C,A

SENDW:	IN	USARTC
	ANI	XMTMASK
	CPI	XMTRDY
	JNZ	SENDW
	POP	PSW		;GET CHAR

	OUT	USARTD
	RET

; Use port B

;SENDWB	IN	SIOBCR
;	ANI	XMTMASK
;	CPI	XMTRDY
;	JNZ	SENDWB
;	POP	PSW		;GET CHAR
;	OUT	SIOBDR
;	RET

; INITITIALIZE THE SERIAL PORT

INIT_ACIA:
;	lda	fPortB		;using port B?
;	ora	a
;	jnz	initB		;yes
;;	mvi	a,003h		;don't reset console port
;;	out	SIOACR
;	mvi	a,015h		;rts on, 8N1
;	out	SIOACR
	ret

; initB - init port B instead

;initB	mvi	a,3	
;	out	SIOBCR
;	mvi	a,015h		;rts on, 8N1
;	out	SIOBCR
;	ret

;
;FILE READ ROUTINE
;
READ_SECTOR:
	LXI	D,FCB
	MVI	C,READ
	CALL	BDOS
	ORA	A
	RZ
	DCR	A		;EOF?
	JNZ	RDERR

;EOF

	XRA	A
	STA	ERRCT
SEOT:	MVI	A,EOT
	CALL	SEND
	MVI	B,3		;WAIT 3 SEC FOR TIMEOUT
	CALL	RECV
	JC	EOTTOT		;EOT TIMEOUT
	CPI	ACK
	JZ	XFER_CPLT

;ACK NOT RECIEVED

EOTERR:	LDA	ERRCT
	INR	A
	STA	ERRCT
	CPI	ERRLMT
	JC	SEOT
	CALL	ERXIT
	.db	13,10,10
	.db	"No ACK received on EOT, but transfer is complete.",13,10,"$"
;
;TIMEOUT ON EOT
;
EOTTOT:	JMP	EOTERR
;
;READ ERROR
;
RDERR:	CALL	ERXIT
	.db	13,10,"File Read Error",13,10,"$"

;DONE - CLOSE UP SHOP

XFER_CPLT:
	CALL	ERXIT
	.db	13,10,10,"Transfer Complete",13,10,"$"

abort:	call	ERXIT
	.db	13,10,10,"Transfer Aborted",13,10,"$"

;-----------------------------------------------------------------------------
; calCrc - update the 16-bit CRC with one more byte. 
;    (Copied from M. Eberhard)
; On Entry:
;   a has the new byte
;   crc16 is current except this byte
; On Exit:
;   crc16 has been updated
;   Trashes a,de
;-----------------------------------------------------------------------------
calCrc:	push	b		;save bc, hl
	push	h
	lhld	crc16		;get CRC so far
	xra	h		;XOR into CRC top byte
	mov	h,a
	lxi	b,1021h		;bc=CRC16 polynomial
	mvi	d,8		;prepare to rotate 8 bits

; do 8 bit shift/divide by CRC polynomial

cRotLp:	dad	h		;16-bit shift
	jnc	cClr		;skip if bit 15 was 0
	mov	a,h		;CRC=CRC xor 1021H
	xra	b
	mov	h,a
	mov	a,l
	xra	c
	mov	l,a
cClr:	dcr	d
	jnz	cRotLp		;rotate 8 times

; save the updated CRC and exit

	shld	crc16		;save updated CRC
	pop	h		;restore hl, bc
	pop	b
	ret

; Messages

mRcvA	.db	"Start XMODEM file receive now...$"
;mRcvB	.db	"Start XMODEM file receive on Port B now...$"
mHelp	.db	CR,LF,"PCPUT Ver 1.4 for OKEAH-240",CR,LF,LF
	.db	"Transmits a file to a PC through a",CR,LF
	.db	"serial port using the XMODEM protocol.",CR,LF,LF
	.db	"Usage: PCPUT file.ext",CR,LF,"$"


; Data area

	.DS	40	;STACK AREA
STACK	.DS	2	;STACK POINTER
SECTNO	.DS	1	;CURRENT SECTOR NUMBER 
ERRCT	.DS	1	;ERROR COUNT
;fPortB	.ds	1	;flag to use 2SIO port B instead of A
crcFlag	.ds	1	;non-zero if using CRC
crc16	.ds	2	;computed crc
;
; BDOS =ATES (VERSION 2)
;
;RDCON	=	1
;WRCON	=	2
;PRINT	=	9
;CONST	=	11	;CONSOLE STAT
;OPEN	=	15	;0FFH=NOT FOUND
;CLOSE	=	16	;   "	"
;SRCHF	=	17	;   "	"
;SRCHN	=	18	;   "	"
;ERASE	=	19	;NO RET CODE
;READ	=	20	;0=OK, 1=EOF
;WRITE	=	21	;0=OK, 1=ERR, 2=?, 0FFH=NO DIR SPC
;MAKE	=	22	;0FFH=BAD
;REN	=	23	;0FFH=BAD
;STDMA	=	26
;BDOS	=	5
;REIPL	=	0
;FCB	=	5CH	;SYSTEM FCB
;PARAM1	=	FCB+1	;COMMAND LINE PARAMETER 1 IN FCB
;PARAM2	=	PARAM1+16	;COMMAND LINE PARAMETER 2
	.END
