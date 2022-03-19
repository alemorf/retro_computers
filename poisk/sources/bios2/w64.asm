;---------DISK CHANGE LINE EQUATES
;NOCHGLN                 EQU     001H                    ; NO DISK CHANGE LINE AVAILABLE
;CHGLN                   EQU     002H                    ; DISK CHANGE LINE AVAILABLE
;
;WDC_RATE	EQU	0000B 	; 35 mkS
;LONG_FLAG	EQU	0010B	; LONG opn active
;MULT_TRANS	EQU	0100B	; Multiple Sector flag
;RESTORE_CMD	EQU	10H+WDC_RATE
;SEEK_CMD	EQU	70H+WDC_RATE
;READ_CMD	EQU	28H+MULT_TRANS	; Retries Enable
;
;WRITE_CMD	EQU	30H+MULT_TRANS	; Retries Enable
;RD_LONG_CMD	EQU	READ_CMD+LONG_FLAG  ;
;WR_LONG_CMD	EQU	WRITE_CMD+LONG_FLAG ;
;SCAN_ID_CMD	EQU	40H		; Retries Enable
;WR_FORMAT_CMD	EQU	50H
;	GAP_1	EQU	30D		; GAP length for format
;COMPUTE_CMD	EQU	08H
;SET_PARM_CMD	EQU	00H		; 5-bit Span
;
;
;
;WDC_PORT		EQU	1F0H       ;320H
;HD_PORT	        EQU	1F8H       ;328H
;DSEL_0_BIT             EQU	00001000B
;HD_RES_BIT	        EQU	00100000B
;IR_DMA_EN	        EQU	01000000B
;BF_RES_BIT	        EQU	10000000B
;LONG_MODE_BIT	        EQU	40H		; !!!
;I64_FMT_CMD	        EQU	01010000B ; Format command
;
;FD_INT_NO		EQU	0DH	; Hardware INT vector
;INT_CTL_PORT		EQU	20H	; 8259 Control port
;EOI			EQU	20H	; END OF INTERRUPT command
;FD_INT_MASK		EQU	(1 SHL (FD_INT_NO-8))	;


;-- INT 13 -----------------------------------------------------
;								;
; ’…”…‰‘ †…‘’ƒ „‘€					;
;								;
;	’€ –…„“€ „„…†‚€…’ ’‹‹… †.„‘€       	;
;	‚›‹…›‰ €  Intel'82064 „‹	 ‘          	;
;								;
;---------------------------------------------------------------
;
;---------------------------------------------------------------
;	…„“…†„……: „‹ “‚……‰ €’› ‘ †.„‘         ;
;	‹‡“‰’…‘ ”“– …„…‹…› ‚ …›‚€  	;
;---------------------------------------------------------------
;
; ‚•„ 	(AH = HEX ‡€—……)
;
;	AH = 00	‘‘ „‘€ (DL = 80H/81H)/„‘…’
;	AH = 01 —’…… ‘’€’“‘€ ‘‹…„…‰ „‘‚‰ …€– ‚ AL
;	    ‡€…’	DL < 80H - „‘…’›
;			DL > 80H - „‘
;	AH = 02 —’…… ‚›€ƒ ‘…’€ ‚ €’
;	AH = 03 ‡€‘ ‚›€ƒ ‘…’€ ‚ €’
;	AH = 04 ‚›”€– ‚›€ƒ ‘…’€
;	AH = 05 ”€’‚€… ‚›€ƒ ’…€
;	AH = 06 ”€’‚€… ‚›€ƒ ’…€ ‘ “‘’€‚‰ ”‹€ƒ€
;		‹•• ‘…’‚
;	AH = 07 ”€’‚€… „‘€ €—€ ‘ ‚›€ƒ ’…€
;	AH = 08 ‚®§Άΰ ι ¥β β¥ªγι¨¥ ― ΰ ¬¥βΰλ ¤¨αª 
;
;	AH = 09 Initialize drive pair characteristics
;			interrupt 41 points to data block
;	AH = 0A „‹… —’……
;       AH = 0B „‹€ ‡€‘
;	   ‡€…’	Read and Write LONG encompass 512+4 bytes ECC
;	AH = 0C ‘ ’…€
;	AH = 0D €‹’…€’‚›‰ ‘‘ (‘’ DL)
;	AH = 0E Read Sector Buffer
;	AH = 0F Write Sector Buffer
;	AH = 10 ’…‘’ —’€…‘’ „‘€
;	AH = 11 …€‹€–
;	AH = 12 „€ƒ‘’€ RAM ’‹‹…€
;	AH = 13 „€ƒ‘’€ „‘€
;	AH = 14 ‚“’… „€ƒ‘’€ ’‹‹…€
;	AH = 15 —’…… ’€ ‘’…‹
;	AH = 16-18 ‡€…‡…‚€‚ „‹ „‘‚„‚
;	AH = 19 €‚€ ƒ‹‚
;
;	…ƒ‘’› ‘‹‡“…›… „‹ ”“–‰:
;
;		DL - … „‘€     (80H-87H „‹ „‘€. ‡€—…… ‚……’‘)
;		DH - … ƒ‹‚   (0-7 ‡€—…… … ‚……’‘)
;		CH - … –‹„€  (0-1023. ‡€—…… … ‚……’‘,‘’ CL)
;		CL - … ‘…’€   (1-17. ‡€—…… … ‚……’‘)
;		    ‡€…’ 	‘’€… 2 €‰’€ …€ –‹„€ €‘‹†…›
;				‚ 2 ‘’€• €‰’€• …ƒ‘’€ CL
;				(‚‘…ƒ 10 ’)
;		AL - —‘‹ ‘…’‚ (€‘€‹… 1-80H,
;				     „‹ „‹›‰ —’…/‡€‘  1-79H)
;			(—……„‚€… ‘…’‚ „‹ ”€’‚€ 1-16D)
;	     ES:BX - €„…‘ “”…€ „‹ —’…  ‡€‘
;
; ‚›•„
;	AH = ‘’€’“‘ ’…“™…‰ …€–
;		‘€… ’ ‘’€’“‘€ …‚…„… †…
;	CY = 0  “‘…€ …€– (AH=0  ‚‡‚€’…)
;	CY = 1  … “‘…€ …€– (AH ‘„…†’ “)
;
;     ‡€…’	€ 11H  €‡›‚€…’, —’  —’… ›‹€ ‘€‚‹…€ -
;		€  ECC €‹ƒ’“.  —’€›… „€›… ‚‡† •….
;		„€ BIOS €‡›‚€…’ “, ’“ ‚›‡›‚€™€ ƒ€€
;		„‹†€ ‘€€ ‚›€’ €‹ƒ’ €’ ’• „€›•
;
;	’‚…’ € ‡€‘ €€…’‚ „‘€:
;
;	DL = —‘‹ „‹—…›• „‘‚ (0-2)
;		(„‘—…’ —‘‹€ ’‹‹…‚)
;	DH = €‘€‹€ ƒ‹‚€
;	CH = €‘€‹… —‘‹ –‹„‚
;	CL = €‘€‹… —‘‹ ‘…’‚  2 ‘’€… ’€ ’ ‘’€…
;		’› —‘‹€ –‹„‚
;
;	‚‘… …ƒ‘’›, ‡€ ‘‹—…… ‚‡‚€™€™• ”€– … ‡…’‘
;
;  ‡€…’ 	›—›‰ €‹ƒ’ €’  ’ ‘‘ ‘‘’…› 
;		‚’…… …€–.
;
;----------------------------------------------------------------------------
;-----------------------------------------------
;	’—€ ‚•„€                		;
;-----------------------------------------------

DISK_IO		Proc FAR
	Assume	CS:CODE, DS:DATA

	CMP	DL,80H			; ’…‘’ †.„‘ ‹ ƒ‰
	JAE	HARD_DISK		; „€,†.„‘
	INT	40H			; ‘‹“†‚€… „‘…’
	JMP	short RET_2		; ‚‡‚€’ ‚ ‚›‡›‚€™“
HARD_DISK:
	STI				; €‡……… …›‚€‰
	OR	AH,AH			; €„€ ‘‘€ ?
	JNZ	A0			; …’, „‹†……
	INT	40H			; ‘‘ NEC
	XOR	AH,AH			; “‹……
A0:
	PUSH	SI
	PUSH	DS
	PUSH	ES
        CALL	DDS    		        ; “‘’€‚€ ‘…ƒ…’€ „€›• BIOS
	CMP	AH,8			; €„€ —’… €€…’‚ ?
	JNE	HHA1			; …’
	JMP	short READ_PARMS
HHA1:
	CMP	AH,15H			; —’…… DASD ’€ ?
	JNE	HHA2			; …’
	JMP	short RD_DASD_TYPE
HHA2:
	PUSH	BP			; ‡€‘ “€…’…‹
	PUSH	DI
	PUSH	DX
	PUSH	BX			; ‡€‘ …ƒ‘’‚ …€–
	PUSH	CX
	PUSH	DS
	PUSH	AX
	AND	DL,7FH			; ‘‘ ‘’€• ’
	CMP	DL,[HF_NUM]		; €‚‹›‰ … ?
	JAE	RET_BAD_CMD		; …’, …€‚‹›‰
	CMP	AH,(H1L SHR 1)		; ‹•€ €„€ ?
	JB	DIO_0			; …’, „‹†……
RET_BAD_CMD:
	MOV	AH,18H			; „€, “‘’€€‚‹‚€… BAD_COMMAND.
DIO_0:
	MOV	AL,AH			; ‹“—…… ‹€„…ƒ €‰’€
	XOR	AH,AH			; “‹…… ‘’€…ƒ €‰’€
	SHL	AX,1			; *2 „‹ ‘’€ ’€‹–›
	MOV	SI,AX			; ‡€ƒ“†€…‚ SI „‹ ……•„€  CALL
	POP	AX			; ‚‘‘’€‚‹…… AX
	XOR	AH,AH
	MOV	DI,AX			; DI = ‘—…’— ‹‚
	XCHG	AH,[HDISK_STATUS]	; ‘‘ ‘’€’“‘€

	CALL	Word ptr CS:H_COM[SI]	; ‚›‡‚ …•„‰ …€–

	PUSH	AX
	MOV	DX,HD_PORT		; €„…‘ ’€
	MOV	AL,(HD_RES_BIT or BF_RES_BIT or IR_DMA_EN)
	OUT	DX,AL			; ‘›‹€ DX = HD_PORT
	POP	AX
	POP	DS			; ‚‘‘’€‚‹…… …ƒ‘’€ „€›•
	MOV	[HDISK_STATUS],AH	; ‹“—…… ‘’€’“‘€ …€–
	POP	CX
	POP	BX
	POP	DX
	POP	DI
	POP	BP
	CMP	AH,1			; “‘’€‚€ ”‹€ƒ€ „‹ „€–
	CMC				; “‘…•€ ‹ …“‘…•€ …€–
RET_8:
	POP     ES
	POP	DS
	POP	SI
RET_2:
	RET	2
DISK_IO		EndP

;-------------------------------------------------------
; ‹“—…… ‘’€’“‘€ (AH=1)				;
;-------------------------------------------------------
HREAD_STATUS	Proc	near
	MOV	AL,AH			; AH ‘„…†’ DISK STATUS
	XOR	AH,AH			; ‘‘ ‘’€’“‘€
	RET
HREAD_STATUS	EndP
;-------------------------------------------------------
; ‹“—…… €€…’‚ „‘€ (AH=8)			;
;-------------------------------------------------------
READ_PARMS	Proc	near
	Assume	DS:DATA

	PUSH    DS			; ‡€‘ …ƒ‘’€ BIOS
	CALL	TST_DRV_NUM
	JB	RP0			; „€.
	XOR	DX,DX			; …€‚‹›‰ … „‘€
	MOV	AX,700H			; INIT_FAIL €
	STC				; ‚›•„  …
RP_RET:
	POP	DS
	MOV	[HDISK_STATUS],AH
	JMP	short   RET_8		; ‚›•„
RP0:
	LODSW				; ‹“—…… —‘‹€ –‹„‚
	DEC	AX			; €—€…’‘ “…€– ‘ 0
	XCHG	AL,AH
	ROR	AL,1
	ROR	AL,1			; ‹“—…… ‘’€• ’ —‘‹€ –‹„‚
	OR	AL,0CH[SI]		; ‘…‚€…
	XCHG	CX,AX			; AX=0
	MOV	DL,DH			; “‘’€‚€ —‘‹€ „‘‚
	MOV	DH,[SI]			; SI “€‡€’…‹ € —‘‹ ƒ‹‚
	DEC	DH			; €—€…’‘ ‘ 0
	JMP	short RP_RET		; Carry = 0
READ_PARMS	EndP
;-------------------------------------------------------
; —’…… ’€ DASD  (AH=15)				;
;-------------------------------------------------------
RD_DASD_TYPE	proc	near
	CALL	TST_DRV_NUM
	MOV	AX,CX			; AX=0
	MOV	DX,CX			; DX=0
	JNB	RD_RET			; …€‚‹›‰ … „‘€, ‚›•„
	MOV	AL,2[SI]		; ‹“—…… —‘‹€ ƒ‹‚
	IMUL	byte ptr 0EH[SI]	; “†…… —‘‹€ ‘…’‚ €
	IMUL	word ptr [SI]		; —‘‹ ’…‚
	MOV	CX,DX
	MOV	DX,AX
	MOV	AX,300H			; ’ „‘€ - ”‘‚€›‰
RD_RET:
	JMP	short   RET_8		; ‚›•„ (CY=0)
RD_DASD_TYPE	EndP
;
;------
	Assume	DS:DATA

TST_DRV_NUM:
	AND	DL,7FH			; ‘‘ ‘’€• ’
	XOR	CX,CX			; CX=0
	MOV	DH,[HF_NUM]		; ‡€‘ …€ „‘€ ‚ DH
	CALL	SET_PARAM_PTR
	CMP	DL,DH			; €‚‹›‰ … ?
	RET				; ‚‡‚€’ ‘’€’“‘€
;-------------------------------------------------------
; BAD_COMMAND						;
;	’€ –…„“€ ‚‡‚€™€…’ “           	;
; ‚‡‚€™€…’   						;
;	AH = 01						;
;-------------------------------------------------------
HDISK_SEEK: mov    di,1
            jmp    HDISK_VERF
PARK_HEAD:
FMT_BAD:
FMT_DRV:
RD_BUFF:
WR_BUFF:
BAD_COMMAND:
	MOV	AX,BAD_CMD*256
	RET
;-------------------------------------------------------
; ‘‘ †.„‘€ (AH=0)					;
;-------------------------------------------------------
HDISK_RESET	proc	near
HDISK_RECAL:
	CALL	DRIVE_SELECT
	PUSH	AX
	AND	AL,not (HD_RES_BIT or BF_RES_BIT)
        CLI
	OUT	DX,AL			; ‘‘ ’‹‹…€
	POP	AX
	OUT	DX,AL			; ‚‹—€…’ ’‹‹…  ‚›„…‹…’ „‘
	DEC	DX			; 327, …ƒ‘’ €„
	MOV	AL,RESTORE_CMD
	OUT	DX,AL			; ‘’€’ ‚‘‘’€‚‹…
	MOV	AX,TIME_OUT*256+10H	; –€‹‡€– TIME_OUT
	CALL	WAIT_START
	JC      RESET_DONE		; AH=€ TIMEOUT
	IN	AL,DX			; ‹“—…… ‘’€’“‘€
	XOR	AH,AH			; ‘’€’“‘ O.K.
	SHR	AL,1			; € ?
	JNC	RESET_DONE		; …’, ‚›•„
	MOV	AH,BAD_RESET		; „€,“‘’€‚€ ‘’€’“‘€ BAD_RESET
RESET_DONE:
	RET
HDISK_RESET	EndP
;
;------ ’€ –…„“€ ‚‹—€…’ ‚›€›‰ „‘
;
DRIVE_SELECT:
	MOV	AL,DSEL_0_BIT		; DSEL_0 ’
	MOV	CL,DL
	SHL	AL,CL			; ‘„‚ƒ „‘‚„€
	OR	AL,(HD_RES_BIT or BF_RES_BIT or IR_DMA_EN)
	MOV	DX,HD_PORT
	OUT	DX,AL
	RET
;-------------------------------------------------------
; ’…‘’ —’€…‘’ „‘€ (AH=10)				;
;-------------------------------------------------------
TST_RDY		proc	near
	CALL    DRIVE_SELECT
	DEC	DX			; WDC …ƒ‘’ ‘’€’“‘€
	XOR	AH,AH
	IN	AL,DX			; ‹“—…… ‘’€’“‘€
	TEST	AL,40H			; „‘ —’€… ?
	JNZ	TST_RDY_RET		; „€.
	MOV	AH,DRIVE_NOT_RDY	; …’,“‘’€‚€ 
TST_RDY_RET:
	RET
TST_RDY		EndP
;-------------------------------------------------------
; –€‹‡€– ’€‹–› „‘€  (AH=9)			;
;-------------------------------------------------------
INIT_DRV	proc	near
RAM_DIAG:
CHK_DRV:
	XOR	AH,AH			; O.K. ‘’€’“‘
	RET
INIT_DRV	EndP
;-------------------------------------------------------
;HDISK_READ	(AH=2)					;
;	’€ –…„“€ ‚›‹…’ —’…… ‘ „‘€ ‚
;	€’ „ 80H ‘…’‚				;
;-------------------------------------------------------
HDISK_READ	proc	near
	MOV	AX,256*READ_CMD+DMA_WRITE_CMD+3	; €€‹ †.„‘€
	JMP	short RWVF_OPN
HDISK_READ	EndP
;-------------------------------------------------------
; HDISK_WRITE	(AH=3)					;
;-------------------------------------------------------
HDISK_WRITE	proc	near
	MOV	AX,256*WRITE_CMD+DMA_READ_CMD+3	; €€‹ †.„‘€
	JMP	short RWVF_OPN
HDISK_WRITE	EndP
;-------------------------------------------------------
; HDISK_VERF	(AH=4)					;
;-------------------------------------------------------
HDISK_VERF	proc	near
	MOV	AX,256*READ_CMD+DMA_READ_CMD+3	; €€‹ †.„‘€
	JMP	short RWVF_OPN
HDISK_VERF	EndP
;-------------------------------------------------------
; FMT_TRK	(AH=5)					;
;-------------------------------------------------------
FMT_TRK		proc	near
	MOV	AX,256*WR_FORMAT_CMD+DMA_READ_CMD+3	; €€‹ †.„‘€
	MOV	DI,1
	JMP	short RWVF_FMT_POINT
FMT_TRK		EndP
;-------------------------------------------------------
; RD_LONG	(AH=0A)					;
;-------------------------------------------------------
RD_LONG		proc	near
	MOV	AX,256*RD_LONG_CMD+DMA_WRITE_CMD+3	; €€‹ †.„‘€
	JMP	short RWVF_OPN
RD_LONG		EndP
;-------------------------------------------------------
; WR_LONG	(AH=0B)					;
;-------------------------------------------------------
WR_LONG		proc	near
	MOV	AX,256*WR_LONG_CMD+DMA_READ_CMD+3	; €€‹ †.„‘€
WR_LONG		EndP
;-------------------------------------------------------
; RWVF_OPN						;
;	’€ –…„“€ ‚›‹…’ —’…/‡€‘/‚…”.
;	‚›€ƒ -‚€ ‘…’‚ ‚ „‹‰  €‹‰
;	„…‹
; INPUT							;
;	AH = €‰’ €„› „‹ Intel' 82064		;
;	CL = … ‘…’€ + ‘’€… ’› ’…€		;
;	CH = ’› ’…€        				;
;	DL = … „‘€ (0..1)				;
;	DH = ƒ‹‚€					;
;	DI = ‘—…’— ‹€(0..80)			;
; ‚›•„ 						;
;-------------------------------------------------------
RWVF_OPN         proc	near
	DEC	CX			; …€ ‘…’‚ €—€’‘ ‘ 0
RWVF_FMT_POINT:
	CALL	HDMA_SETUP		; “‘’€‚€ €€…’‚ ……„€—
	JNC	RWVF_CONTINUE
	MOV	AX,DMA_BOUNDARY*256	; ……„€—€ 0 ‹€
	RET				; DMA €
RWVF_CONTINUE:
	PUSH	DI			; ‡€‘ ‘—…’—€ ‹€
	CALL	SET_PARAM_PTR		; DS:SI “€‡€’…‹ € ’€‹–“ €€…’‚
	XCHG	CL,CH
	MOV	BX,CX
	MOV	CL,6
	SHR	BH,CL			; “‘’€‚€ ‘’€• 2 ’
	XCHG	BX,DI			; DI = … –‹„€
					; BL = ‘—…’— ‹€
	AND	CH,3FH			; CH = … ‘…’€
	MOV	BH,DSEL_0_BIT		; DSEL_0 ’
	MOV	CL,DL
	SHL	BH,CL			; ‘„‚ƒ „‘€
	OR	BH,(HD_RES_BIT or BF_RES_BIT or IR_DMA_EN)
;
;------ „‹›‰ ’…‘’,‚‡†… ’‹ „‹ 82064
;
	TEST	AH,LONG_FLAG		; „‹… ?
	JZ	SHORT_RWVF		; …’, €‹…
	OR	BH,LONG_MODE_BIT	; !!!
SHORT_RWVF:
					; BH = HD_PORT €‰’
	MOV	CL,3
	SHL	DL,CL
	OR	DL,20H			; DL = SDH …ƒ‘’
					; (512 €‰’/‘…, CRC „…‹- „‹ 062)
					; CRC - OR   DL,20H
					; “‘’€€‚‹‚€… ECC „…‹
					; ECC - OR   DL,0A0H 
					; DH = ƒ‹‚€
					; AH = €„›‰ €‰’
;
;------ ƒ‹€‚›‰ ‘—…’—
;
RWVF_LOOP:
	MOV	CL,0EH[SI]		; ‹“—.—‘‹€ ‘…’/’…  (1..x)
	CMP	AH,WR_FORMAT_CMD	; ’…“™‰ CMD ’ FORMAT ?
	JNE	RWVF_A0			; …’
	MOV	CH,GAP_1		; „€,“‘’€‚€ GAP „‹›
	JMP	short RWVF_S
RWVF_A0:
	SUB	CL,CH			; €‘€‹›‰ ‘…’ ‚’…“™… ’……
					; (1..x)
	CMP	CL,BL			; ‘‹…„‰ ’… „‹ –…‘‘€ ?
	JB	RWVF_S			; …’
	MOV	CL,BL			; „€, “‘’€‚€ ‚…… ‚›‹…
RWVF_S:
;
;------ ‘›‹€ €€…’‚ ‚ ’‹‹…
;
	PUSH	DX			; ‘•€…… DX
	MOV	AL,DL			; SDH
	OR	AL,DH			; €‚‹…… ’ ƒ‹‚
	PUSH	AX			; ‘›‹€ €„›  SDH         (7,6)
;------ ‚›„…‹…… „‘€
	MOV	AL,BH			; SDH „€‚—›‰
	OR	AL,DH			; €‚‹…… ’ ƒ‹‚
	MOV	DX,HD_PORT
	OUT	DX,AL			; ‚’ ‚›„…‹…ƒ „‘€
;------ ‡€ƒ“‡€ ”€‰‹€ ‡€„€—  ‚ …ƒ‘’ €„
	CLI				; ‡€…’ …›‚€‰ € ‚… ‡€ƒ“‡
	MOV	DL,(WDC_PORT+1) and 0FFH; ’ ‡€‘
	MOV	AX,5[SI]		; ‹“—…… ‡ ’€‹–›
	SHR	AX,1
	SHR	AX,1			; „…‹ € 4
	OUT	DX,AL			; ‘›‹€… Precomp –…‹„ 		(1)
	PUSH	DI			; ‘›‹€… –‹„ (5,4)
	PUSH	CX			; ‘›‹€… … ‘…’€  ‘—…’— (3,2)
OUT_LOOP:
	POP	AX
	INC	DX
	OUT	DX,AL			; ‘›‹€ —…’›ƒ €‰’€
	MOV	AL,AH
	INC	DX
	OUT	DX,AL			; ‘›‹€ …—…’ƒ €‰’€
	CMP	DL,(WDC_PORT+7) AND 0FFH ; ‘‹…„‰ OUT ?
	JNE	OUT_LOOP		; …’
;------ €‡……… DMA
	MOV	AL,3
	OUT	DMA_MASK,AL		; €‡……… €€‹€ „‘€ DMA
	CALL	HWAIT_INT
	IN	AL,DX			; …ƒ‘’ ‘’€’“‘€
	POP	DX			; ‚‘‘’€ DX
	MOV	CH,TIME_OUT		; ‚… ‚›‹ ?
	JC	RWVF_EXIT		; „€, ‚… ‚›‹
	AND	AL,01100101B		; ‘‘ ’ BUSY,SC,RDQ,CIP
	XOR	AL,01000000B		; ‚…‘ ’ ‘‘€
	JNE	RWVF_ERROR		; WDC €
;------ ‚›—‘‹…… ‚›• €€…’‚
	XOR	CH,CH			; …‚›‰ ‘…’ € ’……
	INC	DH			; ‚›„…‹…… ‘‹…„“™…‰ ƒ‹‚
	CMP	DH,2[SI]		; €‘€‹€ ƒ‹‚€ ?
	JB      RWVF_A1			; …’
	XOR	DH,DH			; ‚›„…‹…… 0 ƒ‹‚
	INC	DI			; ‘‹…„“™‰ –‹„
RWVF_A1:
	SUB	BL,CL			; “……… ‘—…’—€
	JA	RWVF_LOOP		; €’€ ‘‹…„“™…ƒ ’…€
RWVF_EXIT:
	POP	AX			; ‚‘‘’€‚‹…… ‘—…’—€ ‹€
	SUB	AL,BL			; ‘…’€ €’€› O.K.
	MOV	AH,CH			; AH = „  (0 …‘‹ O.K.)
	RET
RWVF_ERROR:

	PUSH	BX
	XOR	BX,BX
	SHR	AL,1			; ‘‘ ”‹€ƒ€ 
	MOV	AH,AL
	MOV	DX,(WDC_PORT+1)		; …ƒ‘’ 
	IN	AL,DX			; ‹“—…… 
ERR_SCAN:
	INC	BX
	SHL	AX,1			; ’ ?
	JC	ERROR_FOUND
	JNZ	ERR_SCAN
ERROR_FOUND:
	MOV	CH,CS:(WDC_ERR_TBL-3)[BX] ; “‘’€‚€ „€ 
	POP	BX

	INC	DX			; 321+1
	IN	AL,DX			; ‹“—…… ‘—…’—€ ‘…’‚ WDC
	SUB	CL,AL			; —‘‹ “‘… €’€›• ‘…’‚
	SUB	BL,CL
	JMP	short RWVF_EXIT
RWVF_OPN         EndP

WDC_ERR_TBL	label	BYTE
	DB	DRIVE_NOT_RDY           ;0AAH
	DB	WRITE_FAULT             ;0CCH
	DB	UNDEF_ERR               ;0BBH
	DB	UNDEF_ERR               ;0BBH
	DB	DATA_CORRECTED		;011H
	DB	UNDEF_ERR               ;0BBH
	DB	BAD_TRACK               ;00BH
	DB	BAD_ECC                 ;010H
	DB	UNDEF_ERR               ;0BBH
	DB	RECORD_NOT_FND          ;004H
	DB	UNDEF_ERR               ;0BBH
	DB	BAD_CNTLR               ;020H
	DB	BAD_SEEK                ;040H
	DB	BAD_ADDR_MARK           ;002H

;-------------------------------------------------------
; SET_PARAM_PTR					           ;
;	’€ –…„“€ “‘’€€‚‹‚€…’ “€‡€’…‹ € ’€‹–“   ;
;	€€…’‚ ’…“™…ƒ „‘€                	   ;
;  ‚•„						           ;
;	DL = … „‘€ (0 ‹ 1,‡€—…… … ‚……’‘) ;
; OUTPUT					           ;
;    DS:SI = Pointer to parameter tbl			   ;
;-------------------------------------------------------
SET_PARAM_PTR	proc	near
	PUSH	AX
	XOR	AX,AX			; “‘’€‚€ ‘…ƒ…’€ ABS0
	MOV	DS,AX

	Assume	DS:ABS0
	MOV	SI,offset HF_TBL_VEC
	OR	DL,DL			; „‘‚„ 0 ?
	JZ	SPP_0			; „€.
	ADD	SI,(HF2_TBL_VEC - HF_TBL_VEC)
SPP_0:
	LDS	SI,[SI]
	POP	AX
	RET
SET_PARAM_PTR	EndP

;-------------------------------------------------------
; HWAIT_INT						;
;	’€ –…„“€ †„€…’ ‚›‹… …€–       ;
;	 ‘ƒ€‹‡“…’, …‘‹ ‡‹ …›‚€…      ;
;  ‚•„							;
;	AH = €‰’ €„› „‹ Intel' 82064		;
;    DS:SI = “€‡€’…‹ € ’€‹–“ €€…’‚
;  ‚›•„						;
;	CARRY = 0 - €‹ ‚›‹…€
;	      = 1 - ‚… ‚›‹		;
;-------------------------------------------------------
HWAIT_INT	proc	near
	MOV	AL,9[SI]		; ‘’€„€’… TIMEOUT
	CMP	AH,I64_FMT_CMD
	JNE	WAIT_START
	MOV	AL,0AH[SI]		; Time Out  ”€’‚€
WAIT_START:
;
;------ ‚ ’‰ …›‚€ ‡€…™…› !
;
	PUSH	DS
	CALL	DDS		        ; “‘’€‚€ ‘…ƒ…’€ BIOS

	Assume	DS:DATA

	PUSH	AX
;
;------ €‡……… …›‚€‰ ’‹‹…€
;
	IN	AL,INT_CTL_PORT+1	; ‹“—…… €‘ …›‚€‰
	AND	AL,not FD_INT_MASK
	OUT	INT_CTL_PORT+1,AL	; €‡……… …›‚€‰ „‘€
;
	MOV	AX,9000H		;  ‡€’
	MOV	[HF_EOI],AL		; ‘‘ EndOfInt ”‹€ƒ€
	STI				; €‡……… …›‚€‰
	INT	15H			; € … €“†…€
	POP	AX			; ‚‘‘’€‚‹…… €‰’€ CMD
	PUSH	CX
WAIT_LOOP:
	TEST	HF_EOI,80H		; †„€…’‘ …›‚€… ?
	JNZ	WAIT_DONE		; „€. OK.
	LOOP	WAIT_LOOP		; ‚“’…‰ –‹
	DEC	AL
	JNZ	WAIT_LOOP		; ‚…‰ –‹
	CALL	IR_DMA_DISABLE
	STC				; “‘’€‚€ ”‹€ƒ€ - TIMEOUT
WAIT_DONE:
	POP	CX
	POP	DS
	RET
HWAIT_INT	EndP
;
;------ ’—€ ‚•„€ ‚ …›‚€… †.„‘€
;
HD_INT	proc	FAR
	PUSH	AX			; ‘•€…… …ƒ‘’‚
	PUSH	DS
	MOV	AL,EOI			; …– …›‚€
	OUT	INT_CTL_PORT,AL
	CALL	DDS          		; “‘’€‚€ ‘…ƒ…’€ BIOS
	CALL	IR_DMA_DISABLE
	POP	DS
	POP	AX
	IRET
HD_INT	EndP
;
;------ ‡€…’ …›‚€‰  ’‹‹…€ DMA
;
IR_DMA_DISABLE:
	PUSH	AX
	IN	AL,INT_CTL_PORT+1	; ‹“—…… €‘ …›‚€‰
	OR	AL,FD_INT_MASK
	OUT	INT_CTL_PORT+1,AL	; ‡€…’ …›‚€‰ „‘€
	MOV	AL,7
	OUT	DMA_MASK,AL		; “‘’€‚€ DMA „‹ ‡€…’€
	MOV	HF_EOI,80H		; “‘’€‚€ ”‹€ƒ€ …›‚€‰ „‘€
	STI				; €‡……… …›‚€‰
	MOV	AX,9100H		; …›‚€ “‘’€‚‹…›
	INT	15H
	POP	AX
	RET				; …’ 

;-------------------------------------------------------
; HDMA_SETUP						;
;	’€ –…„“€ ƒ€“…’ DMA          	;
;  ‚•„							;
;	   DI = ‘—…’— ‹€ (0..80h, ‡€— ‚….)	;
;	   AL = €‰’ „‹ DMA				;
;	   AH = LONG ”‹€ƒ (cmd „‹ WDC)			;
;	ES:BX = €„…‘ —’€…›•/‡€‘›‚ „€›• 		;
;  ‚›•„						;
;	   BX : €‡“… 				;
;	   CARRY = 0 - €‹… —€…
;		 = 1 - € ƒ€–›    		;
;-------------------------------------------------------
HDMA_SETUP	proc	near
	PUSH	DX
	PUSH	AX
	PUSH	CX
;
;------ “‘’€‚€ …†€ DMA
;
	OUT	DMA_F_F,AL		; ‘‘ ‘’…€ f/f
	MOV	CH,AH			; ‡€‘ LONG ”‹€ƒ€  €“‡€e
	OUT	DMA_MODE,AL		; ‚›‚„ €‰’€ …†€
;
;------ ‚›—‘‹…… DMA  …€ …ƒ‘’€ ‘’€–
;
	AND	AX,3			; … €€‹€
	MOV	DX,AX
	SHL	DX,1			; DMA €‡‚›‰ …ƒ‘’ (4 ‹ 6)
	PUSH	DX			; ‡€‘ …ƒ
	ADD	AL,7FH			; …ƒ‘’ ‘’€– (81 ‹ 82)
	PUSH	AX			; ‡€‘ …ƒ
;
;------ …„…‹…… €‡‚ƒ €„…‘€  ‡€—…… ‘’€–›
;
	MOV	AX,ES			; ‹“—…… ES ‡€—…
	MOV	CL,4			; ‘„‚ƒ ‘—…’—€
	ROL	AX,CL			; ‚€™…… ‚‹…‚
	PUSH	AX			; ‡€‘ ‘’€• 4 ’
	AND	AL,0F0H			; “‹…… ‹€„…ƒ ‹€
	ADD	AX,BX			; €‚‹…… ‘…™…
	OUT	DX,AL			; ‚›‚„ ‹€„…ƒ €„…‘€
	PUSH	AX			; ‡€‘ ‘’€’‚ƒ €„…‘€ ‚ BX
	POP	BX
	MOV	AL,AH
	OUT	DX,AL			; ‚›‚„ ‘’€…ƒ €„…‘€
	POP	AX			; ‚‘‘’€‚‹…… ‘’€• 4 ’
	ADC	AL,0			;  ……‘… €„ INC
	AND	AL,0FH			; ‘‘ ‘’€…ƒ ‹€ („‹ PC AT)
	POP	DX			; ‚‘‘’€‚‹…… …ƒ‘’€ ‘’€–
	OUT     DX,AL			; ‚›‚„ ‘’€• 4 ’ …ƒ‘’€ ‘’€–
;
;------ …„…‹…… ‘—…’—€
;
	MOV	AX,512D			; €‡… ‘…’€
	TEST	CH,LONG_FLAG		; „‹›‰ ?
	JZ	SHORT_DMA		; …’ €‹›‰
	MOV	AL,4			; 512 + 4 €‰’ ECC
SHORT_DMA:
	MUL	DI			; ‘—…’— ……„€— ‹€
	POP	DX			; ‚‘‘’€‚‹…… DMA €‡‚ƒ …ƒ‘’€
	INC	DX			; DX = DMA CNT …ƒ‘’
	JNC	ADJUST_DMA		; OK, ‘—…’— €‚‹›‰
	NEG	AX			; AX = 0 ?    ( = 64K )
	JC	BOUNDARY_OUT		; …’, € ( > 64K )
ADJUST_DMA:
	DEC	AX			; …ƒ“‹‚€
	ADD	BX,AX			; ’…‘’ „‹ 64K ……‹
	OUT     DX,AL			; ‹€„‰ €‰’ ‘—…’—€
	MOV	AL,AH
	OUT     DX,AL			; ‘’€‰ €‰’ ‘—…’—€
BOUNDARY_OUT:
	POP	CX			; ‚‘‘’€‚‹…… …ƒ‘’‚
	POP	AX
	POP	DX
	RET				; CARRY = 1 …‘‹ ‚›•„ ‡€ ƒ€–›
HDMA_SETUP	EndP
;----------------------------------------------------------------
H_COM	label	Word			; ’€‹–€ ”“–‰ ……‘›‹
	DW	HDISK_RESET		; 000H
	DW	HREAD_STATUS		; 001H
	DW	HDISK_READ		; 002H
	DW	HDISK_WRITE		; 003H
	DW	HDISK_VERF		; 004H
	DW	FMT_TRK			; 005H
	DW	FMT_BAD			; 006H
	DW	FMT_DRV			; 007H
	DW	READ_PARMS		; 008H
	DW	INIT_DRV		; 009H
	DW	RD_LONG			; 00AH
	DW	WR_LONG			; 00BH
	DW	HDISK_SEEK		; 00CH
	DW	HDISK_RESET		; 00DH
	DW	RD_BUFF			; 00EH
	DW	WR_BUFF			; 00FH
	DW	TST_RDY			; 010H
	DW	HDISK_RECAL		; 011H
	DW	RAM_DIAG		; 012H
	DW	CHK_DRV			; 013H
	DW	DISK_RESET		; 014H
	DW	RD_DASD_TYPE		; 015H
	DW	BAD_COMMAND		; 016H
	DW	BAD_COMMAND		; 017H
	DW	BAD_COMMAND		; 018H
	DW	PARK_HEAD		; 019H
H1L	EQU	$-H_COM


