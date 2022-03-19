
HARD_HELP PROC NEAR
	MOV	SI,offset HARD_1
	CMP	AX,3031H
	JE	AD_5
	MOV	SI,offset HARD_2
	CMP	AX,3032H
	JE	AD_5
	MOV	SI,offset HARD_3
	CMP	AX,3033H
	JE	AD_5
	MOV	SI,offset HARD_4
	CMP	AX,3034H
	JE	AD_5
	MOV	SI,offset HARD_5
	CMP	AX,3035H
	JE	AD_5
	MOV	SI,offset HARD_6
	CMP	AX,3036H
	JE	AD_5
	MOV	SI,offset HARD_7
	CMP	AX,3037H
	JE	AD_5
	MOV	SI,offset HARD_8
	CMP	AX,3038H
	JE	AD_5
	MOV	SI,offset HARD_9
	CMP	AX,3039H
	JE	AD_5
	MOV	SI,offset HARD_10
	CMP	AX,3130H
	JE	AD_5
	MOV	SI,offset HARD_11
	CMP	AX,3131H
	JE	AD_5
	MOV	SI,offset HARD_12
	CMP	AX,3132H
	JE	AD_5
	MOV	SI,offset HARD_13
	CMP	AX,3133H
	JE	AD_5
	MOV	SI,offset HARD_14
	CMP	AX,3134H
	JE	AD_5
        MOV	SI,offset REZ_1
AD_5:   MOV	BX,160*13+2*2
	CALL	PROC_1
	MOV	BX,160*13+10*2
	CALL	PROC_1
	MOV	BX,160*13+20*2
	CALL	PROC_1
	MOV	BX,160*13+34*2
	CALL	PROC_1
	MOV	BX,160*8+27*2
	CALL	PROC_1
	RET
HARD_HELP ENDP

FLOP_HELP PROC NEAR
	MOV	SI,offset DISK_2
	CMP	AL,31H
	JE	AD_3
	MOV	SI,offset DISK_3
	CMP	AL,32H
	JE	AD_3
	MOV	SI,offset DISK_4
	CMP	AL,33H
	JE	AD_3
	MOV	SI,offset DISK_5
	CMP	AL,34H
	JE	AD_3
	MOV	SI,offset DISK_0
AD_3:	CALL	STR_SHOW
	RET
FLOP_HELP ENDP

ADAP_HELP PROC NEAR
	CMP	AL,30H
	MOV	SI,offset ADAPT1
	JE	AD_1
	MOV	SI,offset ADAPT2
	CMP	AL,31H
	JE	AD_1
	MOV	SI,offset ADAPT3
	CMP	AL,32H
	JE	AD_1
	MOV	SI,offset ADAPT4
AD_1:
	MOV	BX,160*9+28*2
	CALL	STR_SHOW
	RET
ADAP_HELP ENDP

;--------------------------------------
; Ž–. Ž€Ž’Šˆ PGUP
;--------------------------------------
PG_UP  PROC  NEAR
	SUB	BX,4
	MOV	AL,70H
	CALL	INVER
	MOV	AH,byte ptr ES:[BX-4]
	MOV	AL,byte ptr ES:[BX-2]
	CMP	AL,30H+9
	JE	gPEREN
	INC	AL
gPEREN1:
	MOV	byte ptr ES:[BX-4],AH
	MOV	byte ptr ES:[BX-2],AL
	RET
gPEREN:
	CMP	AH,30H+9
	JE	gPEREN5
        MOV	AL,30H
	INC	AH
	JMP	SHORT gPEREN1
gPEREN5:
	MOV	AX,3030H
	JMP	SHORT gPEREN1
PG_UP ENDP


;--------------------------------------
; Ž–. Ž€Ž’Šˆ PGUP
;--------------------------------------
PG_UP_1  PROC  NEAR
	SUB	BX,4
	MOV	AL,70H
	CALL	INVER
	MOV	AH,byte ptr ES:[BX-4]
	MOV	AL,byte ptr ES:[BX-2]
	CMP	AL,30H+9H
	JNE	PEREN
	mov	al,40h
PEREN:  INC	AL
	CMP	AL,47H
	JNE	PEREN_2
	MOV	AL,30H
	CMP	AH,30H+9H
	JNE	PEREN_1
	mov	ah,40h
PEREN_1:
	INC	AH
PEREN_2:
	CMP	AX,4730H
	JNE	PEREN_3
	MOV	AX,3030H
PEREN_3:
	MOV	byte ptr ES:[BX-4],AH
	MOV	byte ptr ES:[BX-2],AL
	RET
PG_UP_1 ENDP


;--------------------------------------
; Ž–. Ž€Ž’Šˆ PGDN
;--------------------------------------
PG_DN_1  PROC  NEAR
	SUB	BX,4
	MOV	AL,70H
	CALL	INVER
	MOV	AH,byte ptr ES:[BX-4]
	MOV	AL,byte ptr ES:[BX-2]
	CMP	AL,41H
	JNE	PEREN6
	MOV	AL,39H
	JMP	SHORT PEREN2
PEREN6:	CMP	AL,30H
	JE	PEREN3
	DEC	AL
PEREN2:	MOV	byte ptr ES:[BX-4],AH
	MOV	byte ptr ES:[BX-2],AL
	RET
PEREN3: MOV	AL,46H
	CMP	AH,41H
	JNE	PEREN4
	MOV	AH,39H
	JMP	SHORT PEREN2
PEREN4: CMP	AH,30H
	JNE	PEREN5
	MOV	AX,4646H
	JMP	SHORT PEREN2
PEREN5:	DEC	AH
	JMP	SHORT PEREN2
PG_DN_1   ENDP



;--------------------------------------
; Ž–. Ž€Ž’Šˆ PGDN
;--------------------------------------
PG_DN  PROC  NEAR
	SUB	BX,4
	MOV	AL,70H
	CALL	INVER
	MOV	AH,byte ptr ES:[BX-4]
	MOV	AL,byte ptr ES:[BX-2]
	CMP	AL,30H
	JE	gPEREN3
	DEC	AL
gPEREN2:
	MOV	byte ptr ES:[BX-4],AH
	MOV	byte ptr ES:[BX-2],AL
	RET
gPEREN3:
	CMP	AH,30H
	JE	gPEREN4
	MOV	AL,30H+9
	DEC	AH
	JMP	SHORT gPEREN2
gPEREN4:
	MOV	AX,3939H
	JMP	SHORT	gPEREN2
PG_DN   ENDP


STOLB	PROC	NEAR
	MOV	byte ptr ES:[BX],DL      ;186
	INC	BX
	MOV	byte ptr ES:[BX],7
        ADD	BX,159
        LOOP	STOLB
        RET
STOLB	ENDP


SUMMM	PROC	NEAR

  xor	bx,bx
  MOV	 CL,CMOS_BEGIN		;“‘’€Ž‚ˆ’œ €—€‹Ž CMOS
  MOV	 CH,CMOS_END		;“‘’€Ž‚ˆ’œ ŠŽ…– CMOS
CMOS_2:
  MOV	 AL,CL
  OUT	 CMOS_PORT,AL		;€—€‹œ›‰ €„…‘
  JMP	 SHORT $+2		;‡€„…†Š€
  IN	 AL,CMOS_PORT+1
  SUB	 AH,AH			;ƒ€€’ˆŸ AH=0
  ADC	 BX,AX			;„Ž€‚ˆ’œ Š ’…Š“™…Œ“ ‡€—…ˆž
  INC	 CL			;“Š€‡€’…‹œ € ‘‹…„“ž™…… ‘‹Ž‚Ž
  CMP	 CH,CL			;‡€ŠŽ—ˆ’œ ?
  JNZ	 CMOS_2		;……•Ž„ …‘‹ˆ …’
  MOV	AL,2eh
  OUT	 CMOS_PORT,AL		;€—€‹œ›‰ €„…‘
  JMP	 SHORT $+2		;‡€„…†Š€
  MOV	AL,BH
  OUT	CMOS_PORT+1,AL
  MOV	AL,2fh
  OUT	 CMOS_PORT,AL		;€—€‹œ›‰ €„…‘
  MOV	AL,BL
  OUT	CMOS_PORT+1,AL
  RET
SUMMM	ENDP

ADAPTER	PROC	NEAR
;---------------------------------------------------------------------------
; Ž‚…Š€ ’ˆ€ ‚ˆ„…Ž €„€’…€
; CMOS Ÿ—…‰Š€ 14H BIT 5,4
; 0 0 …ˆ‡‚…‘’›‰ ˆ‹ˆ EGA
; 0 1 40 CLM  CGA
; 1 0 80 CLM  CGA
; 1 1 TTL MONOXROME
;RETURN	Bh=5 CGA,EGA
;       Bl=5 TTL
;---------------------------------------------------------------------------
	MOV	DX,3D4H
	MOV	AL,0EH
	OUT	DX,AL
	MOV	AL,07h
	MOV	DX,3D5H
	OUT	DX,AL
	MOV	DX,3D4H
	MOV	AL,0EH
	OUT	DX,AL
	MOV	DX,3D5H
	IN	AL,DX
	AND	AL,01111111B
	CMP	AL,07h
	JnE	hgfd_1
	MOV	Bh,5      ;CGA

hgfd_1:	MOV	DX,3b4H
	MOV	AL,0EH
	OUT	DX,AL
	MOV	AL,07h
	MOV	DX,3b5H
	OUT	DX,AL
	MOV	DX,3b4H
	MOV	AL,0EH
	OUT	DX,AL
	MOV	DX,3b5H
	IN	AL,DX
	AND	AL,01111111B
	CMP	AL,07h
	jne	cga_n
	mov	bl,5
CGA_N:	RET
ADAPTER	ENDP

SET_UP_N PROC NEAR
	CALL	CMOS_DIAG1
	JZ	SUCCESS_SETUP
	MOV	CX,SETUP_BAD1
	MOV	SI,OFFSET SETUP_BAD
	CALL	STR_PRINT
	MOV	BX,810H
	CALL	BEEPER
	MOV	CX,10
	CALL	PAUZA
	JMP	SHORT ERROR_SETUP
SUCCESS_SETUP:	
	MOV     CX,SETUP_1
	MOV	SI,offset SETUP
	CALL	STR_PRINT
        MOV	CX,08
        CALL    PAUZA
        MOV     CX,NONE1
        MOV     SI,OFFSET NONE
        CALL    STR_PRINT
	MOV	AH,1
	INT	16H
	JZ	KONFIG2
	XOR	AX,AX
	INT	16H
	CMP	AH,53H
	JNE	KONFIG2
;-----“‘’€Ž‚Š€ —€‘Ž‚
ERROR_SETUP:
	MOV	AL,0AH
	OUT	CMOS_PORT,AL
	MOV	AL,00100000B
	OUT	CMOS_PORT+1,AL
	MOV	AL,0BH
	OUT	CMOS_PORT,AL
	MOV	AL,00100001B
	OUT	CMOS_PORT+1,AL
;------“‘’€Ž‚Š€ €‡Œ…€ €ŒŸ’ˆ ‚ ŠŒŽ
	CALL	DDS
        MOV     BX,EDGE_CNT
        MOV     AL,16H
        OUT     CMOS_PORT,AL
        XCHG    AL,BH
        OUT     CMOS_PORT+1,AL
        MOV     AL,15H
        OUT     CMOS_PORT,AL
        XCHG    AL,BL
        OUT     CMOS_PORT+1,AL
;-----Ž‚…Š€ €„€’…€
        MOV     BX,0B000H
	MOV	AX,EQUIP_FLAG
	AND	AX,0110000B
	CMP	AX,0110000B
	JE	TTL_AD
	MOV	BX,0B800H
TTL_AD:
        MOV	ES,BX
        CALL	SET_UP
        CALL    SET_BAYT_DEV
        CALL    SUMMM        
	JMP	START
KONFIG2:
        RET
SET_UP_N ENDP

;----------------------
;„ˆ€ƒŽ‘’ˆŠ€ ŠŒŽ
;ˆ Ž˜ˆŠ… “‘’€Ž‚‹… ZF
;----------------------
CMOS_DIAG1 PROC  NEAR
	MOV	AL,DIAG_STATUS
	OUT	CMOS_PORT,AL
	IN	AL,CMOS_PORT+1
	TEST	AL,0C0H
	RET
CMOS_DIAG1 ENDP

REZ_1	DB	'                 REZ'
T_IME	DB	'Time',0
D_ATA	DB	'Data',0
A_LARM	DB	'Alarm',0
A_FLOP	DB	'Flop A',0
B_FLOP	DB	'Flop B',0
SA_V    DB	'Save Y/N',0

SETUP   DB   0AH,0DH,0DH,0AH,'PRESS DEL FOR RUN SET_UP'
SETUP_1 EQU  $ - OFFSET SETUP
NONE    DB   0DH,'                              '
NONE1   EQU  $ - OFFSET NONE
SETUP_BAD DB  0AH,0AH,0DH,'CMOS CHEKSUM ERROR !'
SETUP_BAD1 EQU $ - OFFSET SETUP_BAD

K_ONFIG PROC NEAR
	CALL	CMOS_DIAG1                      ;Ž‚…Š€ ŠŒŽ
	JZ	M_OK
	JMP	SHORT BAD_MOS			;……•Ž„ € ŒˆˆŒ€‹œ“ž ŠŽ”ˆƒ“€–ˆž
M_OK:
       MOV	AL,14H
       OUT	CMOS_PORT,AL
       IN	AL,CMOS_PORT+1                  ; €‰’ ŽŽ“„Ž‚€ˆŸ
       MOV	BX,0100010000001110b
       OR	BL,AL
       MOV      word ptr EQUIP_FLAG,BX         ;“‘’€Ž‚Š€ EQUIP_FLAG
       JMP      SHORT G_MOS
;----------------------------------------------------------
; ‡€ƒ“‡Š€ Ž ŒˆˆŒ€‹œŽ‰ ŠŽ”ˆƒ“€–ˆˆ
;----------------------------------------------------------
BAD_MOS:
	MOV	EQUIP_FLAG,442FH
G_MOS:	
        RET
K_ONFIG  ENDP