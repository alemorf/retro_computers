	Assume	CS:CODE,DS:CODE

IVK_TITLE:
        INT	19H			; Boot from DISK
CMOS_SET        PROC    NEAR
        ;---‚ AH … ‹•‰ —…‰
        PUSH    CX
        PUSH    AX
        PUSH    DX
        PUSH	BX
        MOV     AL,AH   ; „“‹‚€…
        MOV     CL,3
        SHR     AL,CL
        ADD     AL,19H
        MOV     BL,AL
        OUT     CMOS_PORT,AL
        SUB	AL,19H
        SHL     AL,CL
        SUB     AH,AL
        MOV     CL,AH
        MOV     DL,1
        SHL     DL,CL
        IN      AL,CMOS_PORT+1
        OR      AL,DL
        XCHG    AL,BL
        OUT     CMOS_PORT,AL
        XCHG    BL,AL
        OUT     CMOS_PORT+1,AL
        POP	BX
        POP     DX
        POP     AX
        POP     CX
        RET
CMOS_SET        ENDP
       

TEST_1SEG       PROC    NEAR
        PUSH    CX
        PUSH    AX
        PUSH	BX
        push	es
        push	di
TST_ESC_PRESSED:
	MOV	AH,1
	INT	16H			; €†€’€ ‹€ ‹€‚€ ?
	JZ	TST_CONT		; …’
	XOR	AX,AX
	INT	16H
	CMP	AL,1BH			; ESC ?
	JNE	TST_esc_PRESSED         ; …’
	MOV	DL,11			; “‘’€‚€ ›‘’ƒ ’…‘’€
TST_CONT:
        MOV     CX,1FFFH
        XOR	BX,BX
        CMP     DL,11
        JNE     GOD_1
        MOV     CX,24
GOD_1:
	;----’…‘’ €„…‘‚
	IN	AL,0F0H
	CMP	AL,DS:[BX]
	JNE	BAD_1
GOOD_1N:
        MOV     AX,DS:[BX]
	NOT	AX
        NOT     WORD PTR  DS:[BX]
	CMP	AX,DS:[BX]
        JNE     BAD_1
        NOT     WORD PTR DS:[BX]
	NOT	AX
        CMP     AX,DS:[BX]
        JNE     BAD_1
        ADD     BX,2
        LOOP    GOOD_1N
	cmp	dl,11
	jne	continue_p
	jmp	god_ex
continue_p:	
	cld        
;----―¥ΰ¥­®α ¨ αΰ Ά­¥­¨¥ α BIOS
	push	ds
	push	si
	mov	di,0fc00h
	mov	ds,di
	mov	di,0d000h
	mov	es,di
	xor	si,si
	xor	di,di
	mov	cx,1fffh
rep	movsw
	xor	di,di
	xor	si,si
	mov	cx,1fffh
skan:	
	mov	ax,ds:[si]
	add	si,2
	scasw
	loope	skan
	pop	si
	pop	ds
	or	cx,0			
	je	skan0
	;---
BAD_1:	pop	di
        pop	es
	POP	BX
	POP	AX
        POP     CX
        STC             ; “‘’€‚€ ”‹€ƒ€ ERROR!
        RET
skan0:	
god_ex:
	pop	di	
        pop	es
        POP	BX
        POP	AX
        POP     CX
        CLC             ; ‘‘ ”‹€ƒ€ O.K!
        RET

TEST_1SEG       ENDP
	
;--–…„“€ ’€’ €“‡›  „‹’…‹‘’ ‚ CX
pauza	proc	near
pauz_1:	push	cx
	mov	cx,0ffffh
pauz:	loop	pauz
	pop	cx
	loop	pauz_1
	ret
pauza	endp


CMOS_ZAP PROC  NEAR
	OUT	70H,AL
	MOV	AL,BL
	OUT	71H,AL
	RET
CMOS_ZAP	ENDP

STR_PRINT       PROC    NEAR
        MOV	AH,0Eh
        SUB BX,BX
        SUB DX,DX
LOOPMSG:
        PUSH AX
        MOV	AL,CS:SI
        INC	SI
        INT 10H
        POP	AX
        LOOP	LOOPMSG
        RET
STR_PRINT       ENDP

ROM_SHOW  PROC  NEAR
	PUSH	AX
	PUSH	CX
        PUSH    DX    
        PUSH	BX
	MOV	DX,ES
	MOV	AH,2
	XOR	BX,BX
	INT	10H
       	MOV	AX,DI
        ADD     AX,16D
	MOV	DI,AX
        MOV     CX,4
LO:
        XOR     DX,DX
        DIV     SI
        OR      DL,30H
        MOV     DH,14
        PUSH    DX
        LOOP    LO
        MOV     CX,4
LO1:
        POP     AX
        INT     10H
        LOOP    LO1
        POP	BX
        POP     DX
	POP	CX
	POP	AX
        RET
ROM_SHOW ENDP

MAP_PROG PROC   NEAR
	MOV	AL,MAP_BEGIN
	MOV	CX,10H
	MOV	SI,0
MAJOR_C:	
	MOV	BH,1
	MOV	DL,0
	OUT	CMOS_PORT,AL
	XCHG	AH,AL
	IN	AL,CMOS_PORT+1
	XCHG	AH,AL
REPID_1:	
	TEST	AH,BH
	JNZ	BAD_CELL
;-------•€ —…‰€
	;---‚›—‘‹… …… …
	PUSH	AX
	PUSH	BX
	MOV	BX,SI
	SUB	AL,MAP_BEGIN
	SHL	AL,1
	SHL	AL,1
	SHL	AL,1
	ADD	AL,DL
	XCHG	AH,AL
	XCHG	AL,BL
	OUT	MEMORY_PROC,AL
	XCHG	AH,AL
	OUT	MEMORY_CHIP,AL
	INC	SI
	POP	BX
	POP	AX	
BAD_CELL:	
	SHL	BH,1
	INC	DL	
	CMP	BH,0
	JNE	REPID_1
	INC	AL
	LOOP	MAJOR_C
        RET
MAP_PROG        ENDP

CMOP_0SEG       PROC NEAR
	MOV	AH,AL
	MOV	CX,3
	MOV	DH,19H
	SHR	AL,CL
	CMP	AL,0
	JE	POIN_1	; ‚ AH —‘‹ „‹ ‚’ƒ –‹€
	MOV	CL,AL
	MOV	BX,AX	; ‘•€…… AX
	MOV	AL,MAP_BEGIN
POIN_2:
	OUT	CMOS_PORT,AL
	XCHG	AH,AL
	MOV	AL,0FFH
	OUT	CMOS_PORT+1,AL
	XCHG	AH,AL
	INC	AL
	LOOP	POIN_2
	MOV	DH,AL	; ‚ DH “€‡€’…‹ € ‘‹…„“™“ —…‰“ MAP
	MOV	AX,BX	; BOCC’€‚‹…… AX
	MOV	CL,3
	SHL	AL,CL
	SUB	AH,AL	; ‹“—…… ‘’€’€
POIN_1:
	CMP	AH,0
	JE	POIN_3
	XOR	BX,BX
	MOV	DL,1
	MOV	CL,AH	; ‘—…’— –‹‚
	MOV	AL,DH	; AL - “€‡€’…‹ € ‘‹…„“™“ —…‰“
	OUT	CMOS_PORT,AL
POIN_4:
	OR	BH,DL
	SHL	DL,1
	LOOP	POIN_4
	XCHG	AL,BH
	OUT	CMOS_PORT+1,AL
POIN_3:
        RET
CMOP_0SEG       ENDP
	
POISK_BIOS PROC NEAR
	nop
	assume ds:data,es:abs0
	PUSH	DS
ROM_SCAN:
        MOV     DX,0C400H
ROM_SCAN_1:
        MOV     DS,DX
        SUB     BX,BX
        MOV	AX,[BX]
        CMP     AX,0AA55H
        JNZ	NEXT_ROM
	MOV	WORD PTR [BX],55AAH
	CMP	WORD PTR [BX],0AA55H 
	JNZ     NEXT_ROM
        CALL    ROM_CHECK
        JMP	SHORT ARE_WE_DONE
NEXT_ROM:
        ADD     DX,0080H
ARE_WE_DONE:
        CMP     DX,0F600H
        JL      ROM_SCAN_1
	POP	DS
        RET
POISK_BIOS ENDP
        NOP
DEFINE_MEM PROC NEAR
	XOR	DI,DI
	MOV	DX,400H
	XOR	BX,BX
TST_16K:
	MOV     DS,DX
	MOV     AX,0AAAAH
	MOV	SI,[DI]
	MOV     [DI],AX
TST_55AA:
	CMP     AX,[DI]
	JNZ     END_MEM_TST
	SHR	word ptr [DI],1
	SHR	AX,1
	JNC	TST_55AA
	MOV	[DI],SI
	ADD     DH,4H
	ADD     BX,16D
	CMP     DH,(0A0H)
	JNZ     TST_16K
END_MEM_TST:
        ADD     BX,16D
        MOV     AX,DATA
        MOV     DS,AX
	MOV     MEMORY_SIZE,BX    	;SAVE MEMORY SIZE
        MOV     EDGE_CNT,BX             ;‘•€… ‘’›‰ €‡… „‹ SETUP
        RET
DEFINE_MEM ENDP

;SEG_1_REST PROC NEAR
;	MOV	AL,0
;	OUT	MEMORY_PROC,AL
;	XCHG	AH,AL
;	IN	AL,MEMORY_CHIP
;	INC	AL
;	INC	AH
;	XCHG	AH,AL
;	MOV	CX,80H
;	SUB	CL,AH
;MAPSET:	
;	OUT	MEMORY_PROC,AL
;	XCHG	AH,AL
;	OUT	MEMORY_CHIP,AL
;	INC	AL
;	INC	AH
;	XCHG	AH,AL
;	LOOP	MAPSET
;      RET
;SEG_1_REST ENDP

MSG1 	DB	0DH,0AH,'BIOS POISK 2.1 (C)1991 Soft M.P.',0dh,0ah
LLC	EQU	$ - OFFSET MSG1
ZAPROS1	DB	0DH,0AH,'Monochrome or Cga , Ega',0DH,0AH
LLC1    EQU     $ - OFFSET ZAPROS1
MEM_TES DB	0DH,0AH,'TEST MEMORY ...'
LLC2	EQU	$ - OFFSET MEM_TES
HARD_TITL DB    0DH,0AH,0DH,0AH,'HARD BIOS 1.0 (C)1991 Installed',0DH,0AH
LLC3    EQU     $ - OFFSET HARD_TITL

TIME_SAVE PROC NEAR
	PUSH	BX
	CALL	RAZR
	MOV	BX,160*2+13*2
	CALL	TERM_RED
	MOV	AL,4
	CALL	CMOS_ZAP
	MOV	BX,160*2+16*2
	CALL	TERM_RED
	MOV	AL,2
	CALL	CMOS_ZAP
	MOV	BX,160*2+19*2
	CALL	TERM_RED
	MOV	AL,0
	CALL	CMOS_ZAP
	CALL	ZAPR
	POP	BX
	RET
TIME_SAVE ENDP




;------------------------------------
;‚›‚„ ‘’
;‚ SI offset    ‚ BX-…‘’ “‘’€‚
;------------------------------------
STR_SHOW PROC	NEAR
SCHIT:	MOV	AL,byte ptr DS:[SI]
	CMP	AL,0
	JE	RET_1
	MOV	byte ptr ES:[BX],AL
	INC	SI
	INC	BX
	INC	BX
	JMP	SHORT SCHIT
RET_1:	RET
STR_SHOW ENDP

; ……„‚€  ‚›‚„
PRO	PROC			;……„‚€ 00-0F ‚ ASCII ‘‚‹›
  ADD	 AL,90H 		;„€‚’ …‚›‰ „‚—›‰ ””–…’
  DAA				;……‚„ ‚ €‹”€‚’ –”‚‰ „€€‡
  ADC	 AL,40H 		;ADD CONVERSION AND ADJUST LOW NIBBLE
  DAA				;ADJUST HIGH NIBBLE TO ASCII RANGE
  MOV	 byte ptr ES:[BX],AL    ;‡€‘€’ ‚  “”…
  INC	 BX			;“€‡€’…‹ € ‘‹…„“™“ ‡–
  INC	 BX
  RET
PRO	ENDP




RASP	PROC	NEAR
	mov	ah,al
	sar	al,1
	sar	al,1
	sar	al,1
	sar	al,1
	and	al,0fh
	call	pro
	mov	al,ah
	and	al,0fh
	call	pro
	RET
RASP	ENDP


RAZR	PROC	NEAR
;---ΰ §ΰ¥θ¥­¨¥ § ―¨α¨
	push	ax
	mov	al,0bh
	out	70h,al
	in	al,71h
	or	al,10000000b
	mov	ah,al
	mov	al,0bh
	out	70h,al
	mov	al,ah
	out	71h,al
	pop	ax
	RET
RAZR	ENDP


;error_S	proc	near
;	mov	cx,ax
;err_1:	push	cx
;	mov	bx,100fh
;	call	beeper
;	mov	cx,1
;	call	pauza
;	pop	cx
;	loop	err_1
;	RET
;error_S	endp






SAVE_PRO PROC	NEAR
	call	razr
;DATA
	MOV	BX,160*3+13*2
	CALL	TERM_RED
	MOV	AL,7
	CALL	CMOS_ZAP
	MOV	BX,160*3+16*2
	CALL	TERM_RED
	MOV	AL,8
	CALL	CMOS_ZAP
	MOV	BX,160*3+19*2
	CALL	TERM_RED
	MOV	AL,9
	CALL	CMOS_ZAP
;ALARM
	MOV	BX,160*4+13*2
	CALL	TERM_RED
	MOV	AL,5
	CALL	CMOS_ZAP
	MOV	BX,160*4+16*2
	CALL	TERM_RED
	MOV	AL,3
	CALL	CMOS_ZAP
	MOV	BX,160*4+19*2
	CALL	TERM_RED
	MOV	AL,1
	CALL	CMOS_ZAP
	call	zapr
;FLOP A
	MOV	BX,160*6+13*2
	CALL	TERM_RED
	XCHG	BL,DL
	MOV	BX,160*7+13*2
;FLOP B
	CALL	TERM_RED
	AND	BL,01111B
	ROL	BL,1
	ROL	BL,1
	ROL	BL,1
	ROL	BL,1
	AND	DL,01111B
	OR	BL,DL
	MOV	AL,10H
	CALL	CMOS_ZAP
;HARD
	MOV	BX,160*8+13*2
	CALL	TERM_RED
;------------------------
	MOV	AL,12H
	CALL	CMOS_ZAP
;MEMORY HIG
	MOV	BX,160*10+13*2
	CALL	TERM_RED
	MOV	AL,16H
	CALL	CMOS_ZAP
;MEMORY LOW
	MOV	BX,160*10+15*2
	CALL	TERM_RED
	MOV	AL,15h
	CALL	CMOS_ZAP
;EMS
	MOV	BX,160*11+13*2
	CALL	TERM_RED
	MOV	AL,18h
	CALL	CMOS_ZAP
	MOV	BX,160*11+15*2
	CALL	TERM_RED
	MOV	AL,17H
	CALL	CMOS_ZAP
;ADAPTER
	MOV	BX,160*9+13*2
	CALL	TERM_RED
	AND	BL,011b           ;00001111B
	MOV	AL,14h
	OUT	70H,AL
	IN	AL,71H
	AND	AL,11001111B
	mov	cl,4
	shl	bl,cl
	OR	BL,AL
	MOV	AL,14H
	CALL	CMOS_ZAP
	mov	al,cmos_alarm
	out	cmos_port,al
	in	al,cmos_port+1
	or	al,00100000b
	xchg	al,dl
	mov	al,cmos_alarm
	out	cmos_port,al
	xchg	al,dl
	out	cmos_port+1,al
	RET
SAVE_PRO ENDP


PROC_1  PROC NEAR
	MOV	CX,4
AD_6:	MOV	AL,byte ptr DS:[SI]
	MOV	byte ptr ES:[BX],AL
	INC	SI
	INC	BX
	INC	BX
	LOOP	AD_6
	RET
PROC_1	ENDP



;--------------------------------
;―ΰ®ζ¥¤γΰ  ΆλΆ®¤  αβΰ®ª¨
;--------------------------------
STROK   PROC	NEAR
        MOV	byte ptr ES:[BX],DL        ;205
        INC	BX
        MOV	byte ptr ES:[BX],7H
        INC	BX
        LOOP	STROK
        RET
STROK	ENDP



TERM_RED PROC NEAR
	MOV	AH,byte ptr ES:[BX]
	MOV	AL,byte ptr ES:[BX+2]
	cmp	ah,39h
	ja	star
	sub	ah,30h
	jmp	short star1
star:	sub	ah,37h
star1:
	cmp	al,39h
	ja	star2
	sub	al,30h
	jmp	short star3
star2:	sub	al,37h
star3:

	mov	cl,4
	shl	ah,cl
	AND	AH,11110000B
	AND	AL,00001111B
	OR	AL,AH
	XCHG	AL,BL
	RET
TERM_RED ENDP


ZAPR	PROC	NEAR
	PUSH	AX
	mov	al,0bh
	out	70h,al
	in	al,71h
	and	al,01111111b
	xchg	al,ah
	mov	al,0bh
	out	70h,al
	xchg	al,ah
	out	71h,al
	POP	AX
	RET
ZAPR	ENDP








CMOS_READ	PROC	NEAR
	CALL	RAZR
	OUT	70H,AL
	JMP	SHORT $+2
	IN	AL,71H
	CMP	BX,160*10
	JA	NOT_ERROR
	MOV	AH,AL
	AND	AH,01111B
	CMP	AH,9H
	JA	ERROR_CMOS
	MOV	AH,AL
	AND	AH,11110000B
	CMP	AH,90H
	JA	ERROR_CMOS
	JMP	SHORT NOT_ERROR
ERROR_CMOS:
	MOV	AL,0
NOT_ERROR:
	CALL	ZAPR
	RET
CMOS_READ	ENDP

SET_UP  PROC	NEAR
	PUSH	CS
	POP	DS
	mov	cx,1000
	xor	bx,bx
sd_9:	mov	byte ptr es:[bx],0
	inc	bx
	inc	bx
	loop	sd_9

;----‚›‚„ ™…‰ ’€‹–›

;‚›‚„ €
        XOR	BX,BX
        MOV	CX,50
        MOV	DL,205
        CALL	STROK
        MOV	BX,160*15
        MOV	CX,50
        CALL	STROK
        MOV	CX,50
        MOV	DL,177
        MOV	BX,160*16+2
        CALL	STROK
        MOV	BX,160
        MOV	CX,14
        MOV	DL,186
        CALL	STOLB
        MOV	BX,160+50*2
        MOV	CX,14
        CALL	STOLB
        MOV	BX,160+51*2
        MOV	CX,16
        MOV	DL,177
        CALL	STOLB
        MOV	BX,160+52*2
        MOV	CX,16
        MOV	DL,177
        CALL	STOLB
        MOV	byte ptr ES:[0],201
        MOV	byte ptr ES:[100],187
        MOV	byte ptr ES:[160*15],200
        MOV	byte ptr ES:[160*15+100],188
        MOV	SI,offset SOOB_1
        MOV	BX,160*15+30*2
        CALL	STR_SHOW
        MOV	SI,offset SOOB_2
        MOV	BX,4*2
        CALL	STR_SHOW
;ΆλΆ®¤ α®®΅ι¥­¨©
	MOV	SI,offset T_IME
	MOV	BX,160*2+3*2
	CALL	STR_SHOW
	MOV	SI,offset D_ATA
	MOV	BX,160*3+3*2
	CALL	STR_SHOW
	MOV	SI,offset A_LARM
	MOV	BX,160*4+3*2
	CALL	STR_SHOW
	MOV	SI,offset A_FLOP
	MOV	BX,160*6+3*2
	CALL	STR_SHOW
	MOV	SI,offset B_FLOP
	MOV	BX,160*7+3*2
	CALL	STR_SHOW
	MOV	SI,offset H_ARD
	MOV	BX,160*8+3*2
	CALL	STR_SHOW
	MOV	SI,offset A_DAP
	MOV	BX,160*9+3*2
	CALL	STR_SHOW
	MOV	SI,offset ROM_S
	MOV	BX,160*10+3*2
	CALL	STR_SHOW
	MOV	SI,offset EMS_S
	MOV	BX,160*11+3*2
	CALL	STR_SHOW
	MOV	SI,offset  HARD_1N
	MOV	BX,160*13+7*2
	CALL	STR_SHOW
	MOV	SI,offset SA_V
	MOV	BX,160*14+5*2
	CALL	STR_SHOW
	MOV	CX,10
	MOV	BX,160*2+11*2
D2:	MOV	byte ptr ES:[BX],58
	ADD	BX,160
	LOOP	D2
	MOV	byte ptr ES:[160*5+11*2],0
;‚›‚„ —……
	CALL VVVV

;“‘’€‚€ …›‚€‰ ’€‰…€
	PUSH	DS
	xor	ax,ax
	mov	ds,ax
	mov	ax,offset TIMER_1
	mov	word ptr ds:[1ch*4],ax
	mov	ax,cs
	mov	word ptr ds:[1ch*4+2],ax
	POP	DS

;‚…‘ ‡€†…‰
    ;¨­Ά¥ΰα¨ο ―¥ΰΆ®© οη¥©ª¨
	MOV	BX,160*2+13*2
	MOV	AL,70H
	CALL	INVER
    ;―ΰ®ζ¥¤γΰ  ―¥ΰ¥¤Ά¨¦¥­¨ο ªγΰα®ΰ  ¨ ¨­Ά¥ΰα¨¨
    	CALL	PEREDV
    	CALL	SUMMM
	RET
SET_UP  ENDP

TERM_SHOW PROC NEAR
	MOV	AH,AL
	AND	AL,01111B
	AND	AH,11110000B
	ADD	AL,30H
	cmp	al,39h
	jbe	dec_11
	add	al,7h
dec_11:	MOV	byte ptr ES:[BX+2],AL
	SHR	AH,1
	SHR	AH,1
	SHR	AH,1
	SHR	AH,1
	ADD	AH,30H
	cmp	ah,39h
	jbe	dec_2
	add	ah,7h
dec_2:	MOV	byte ptr ES:[BX],AH
	RET
TERM_SHOW ENDP


;-------------------------------------
;CX-ª®«¨η¥αβΆ® ¨­Ά¥ΰβ¨ΰγ¥¬λε α¨¬Ά®«®Ά
;al- βΰ¨΅γβ
;bx-­ η «μ­ ο ―®§¨ζ¨ο
;-------------------------------------
INVER	PROC  NEAR
	MOV	CX,2
INV:	MOV	byte ptr ES:[BX+1],AL
	ADD	BX,2
	LOOP	INV
	RET
INVER	ENDP



;‚›‚„ HELP
VVV_1	PROC NEAR
;adapter
	MOV	AL,byte ptr ES:[160*9+14*2]
	CALL	ADAP_HELP
;flop_A
	MOV	AL,byte ptr ES:[160*6+14*2]
	MOV	BX,160*6+28*2
	CALL	FLOP_HELP
;flop_B
	MOV	AL,byte ptr ES:[160*7+14*2]
	MOV	BX,160*7+28*2
	CALL	FLOP_HELP
;HARD
        MOV	AL,byte ptr ES:[160*8+14*2]
        MOV	AH,byte ptr ES:[160*8+13*2]
        CALL	HARD_HELP
	RET
VVV_1	ENDP


VVVV	PROC	NEAR
        sti
;‘…“„›
	MOV	AL,0
	MOV	BX,160*2+19*2
	MOV	CX,2
L_OP1:	PUSH	AX
	CALL	CMOS_READ
	CALL	TERM_SHOW
	MOV	byte ptr ES:[BX-2],58
	POP	AX
;“’›
	INC	AL
	INC	AL
	PUSH	AX
	SUB	BX,6
	CALL	CMOS_READ
	CALL	TERM_SHOW
	MOV	byte ptr ES:[BX-2],58
	POP	AX
;—€‘›
	INC	AL
	INC	AL
	SUB	BX,6
	CALL	CMOS_READ
	CALL	TERM_SHOW
	MOV	AL,1
	MOV	BX,160*4+19*2
	LOOP	L_OP1
;ƒ„
	MOV	AL,9
	MOV	BX,160*3+19*2
	MOV	byte ptr ES:[BX-2],58
	CALL	CMOS_READ
	CALL	TERM_SHOW
;…‘–
	MOV	AL,8
	MOV	BX,160*3+16*2
	MOV	byte ptr ES:[BX-2],58
	CALL	CMOS_READ
	CALL	TERM_SHOW
;—‘‹
	MOV	AL,7
	MOV	BX,160*3+13*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
;Flop_A
	MOV	AL,10H
	MOV	BX,160*6+13*2
	CALL	CMOS_READ
	MOV	DL,AL
	AND	AL,01111B
	CALL	TERM_SHOW
;Flop_B
	XCHG	AL,DL
	AND	AL,11110000B
	SHR	AL,1
	SHR	AL,1
	SHR	AL,1
	SHR	AL,1
	MOV	BX,160*7+13*2
	CALL	TERM_SHOW
;Hard
	MOV	AL,12H
	MOV	BX,160*8+13*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
;Adapter
	MOV	AL,14H
	out	70h,al
	in	al,71h
	MOV	BX,160*9+13*2
	AND	AL,0110000B
	mov	cl,4
	shr	al,cl
	CALL	TERM_SHOW
;ROM
	MOV	AL,16H
	MOV	BX,160*10+13*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
	MOV	AL,15H
	MOV	BX,160*10+15*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
;EMS
	MOV	AL,18H
	MOV	BX,160*11+13*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
	MOV	AL,17H
	MOV	BX,160*11+15*2
	CALL	CMOS_READ
	CALL	TERM_SHOW
        cli
	RET
VVVV	ENDP


HARD_1N DB	'Cyl     Hds       PreComp       Zone',0
HARD_1  DB	'0306  0401280305 10M'
HARD_2  DB	'0615  0403000615 21M'
HARD_3  DB	'0615  0603000615 32M'
HARD_4  DB	'0940  0805120940 65M'
HARD_5  DB	'0940  0605120940 49M'
HARD_6  DB	'1023  08ffff1023 70M'
HARD_7  DB	'0462  0802560511 32M'
HARD_8  DB	'0733  05ffff0733 31M'
HARD_9  DB	'0900  15ffff0901117M'
HARD_10 DB	'0820  03ffff0820 21M'
HARD_11 DB	'0855  05ffff0855 37M'
HARD_12 DB	'0855  07ffff0855 52M'
HARD_13 DB	'0306  0801280319 21M'
HARD_14 DB	'0820  0608200820 42M'
