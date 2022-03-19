	ASSUME CS:CODE,DS:CODE
SET_UP  PROC	NEAR
	PUSH	CS
	POP	DS
	mov	cx,1000
	xor	bx,bx
sd_9:	mov	byte ptr es:[bx],0
	inc	bx
	inc	bx
	loop	sd_9

;----ВЫВОД ОБЩЕЙ ТАБЛИЦЫ

;ВЫВОД РАМКИ
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
;вывод сообщений
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
;ВЫВОД ЯЧЕЕК
	CALL VVVV

;УСТАНОВКА ПРЕРЫВАНИЙ ТАЙМЕРА
	PUSH	DS
	xor	ax,ax
	mov	ds,ax
	mov	ax,offset TIMER_1
	mov	word ptr ds:[1ch*4],ax
	mov	ax,cs
	mov	word ptr ds:[1ch*4+2],ax
	POP	DS

;ИНВЕРСИЯ ИЗОБРАЖЕНИЙ
    ;инверсия первой ячейки
	MOV	BX,160*2+13*2
	MOV	AL,70H
	CALL	INVER
    ;процедура передвижения курсора и инверсии
    	CALL	PEREDV
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


TIMER_1	PROC	near
	push	ax
	push	bx
	PUSH	cx
	push	dx
	push	si
	push	di
	push	es
	push	ds
	push	bp
	MOV	AL,0
	CALL	CMOS_READ
	MOV	BX,160*1+48*2
	MOV	byte ptr ES:[BX-2],58
	CALL	RASP
	MOV	AL,2
	CALL	CMOS_READ
	MOV	BX,160*1+45*2
	MOV	byte ptr ES:[BX-2],58
	CALL	RASP
	MOV	AL,4
	CALL	CMOS_READ
	MOV	BX,160*1+42*2
	CALL	RASP
	push	cs
	pop	ds
	pop	bp
	pop	ds
	pop	es
	POP	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	IRET
TIMER_1	ENDP

otsl_1  proc near
;отслеживание переполнения
	MOV	BX,160*2+19*2
	MOV	CX,3630H
	MOV	DX,3539H
	CALL	OTSL
	MOV	BX,160*2+16*2
	CALL	OTSL
	MOV	BX,160*4+19*2
	CALL	OTSL
	MOV	BX,160*4+16*2
	CALL	OTSL
	MOV	BX,160*2+13*2
	MOV	CX,3234H
	MOV	DX,3233H
	CALL	OTSL
	MOV	BX,160*4+13*2
	CALL	OTSL
	MOV	CX,3332H
	MOV	DX,3331H
	MOV	BX,160*3+13*2
	CALL	OTSL
	MOV	CX,3133H
	MOV	DX,3132H
	MOV	BX,160*3+16*2
	CALL	OTSL
	MOV	CX,3035H
	MOV	DX,3034H
	MOV	BX,160*6+13*2
	CALL	OTSL
	MOV	BX,160*7+13*2
	CALL	OTSL
;hard
	MOV	CX,3136H
	MOV	DX,3135H
	MOV	BX,160*8+13*2
OT_1:	CALL	OTSL
;adapter
	MOV	CX,3034H
	MOV	DX,3033H
	MOV	BX,160*9+13*2
	CALL	OTSL
	ret
otsl_1	endp

;отслеживание
;BX-адрес,CX-максимальное значение DX=CX-1, AX-минимальное значение
OTSL	PROC  NEAR
	MOV	AL,byte ptr ES:[BX+2]
	MOV	AH,byte ptr ES:[BX]
	CMP	AX,CX
	jb	rt_1
	MOV	byte ptr ES:[BX],30H
	MOV	byte ptr ES:[BX+2],30H
RT_1:   CMP	AX,3939H
	jb	rt_2
	MOV	byte ptr ES:[BX],DH
	MOV	byte ptr ES:[BX+2],DL
RT_2:   RET
OTSL	ENDP


;ВЫВОД HELP
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
; ПРОЦ. ОБРАБОТКИ PGUP
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
; ПРОЦ. ОБРАБОТКИ PGUP
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
; ПРОЦ. ОБРАБОТКИ PGDN
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
; ПРОЦ. ОБРАБОТКИ PGDN
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


