
PEREDV PROC NEAR
;----àçÇÖêëàü àáéÅêÄÜÖçàâ
SAV1:   push	ds
	call	dds
	assume	ds:data
	MOV	RIG_1,2
        MOV	UPPP,0
        MOV	DOWW,2
        MOV	LEF_1,0
RE_1:   push	bx
	push	ds
	push	cs
	pop	ds
	call	otsl_1
	CALL	VVV_1
	pop	ds
	pop	bx
	MOV	AH,0
        INT	16H
RE_12:  XCHG	AH,DL
        MOV	AL,7
        SUB	BX,4
        CALL	INVER
	CMP	DL,4DH
        JE	RIGH1
        CMP	DL,4BH
        JE	LEFT_1
        CMP	DL,48H
        JE	UP_1G
        CMP	DL,50H
        JE	DN_DN
        CMP	DL,49H
        JE	PGUP1
        CMP	DL,51H
        JE	PGDN1
        CMP	DL,15H
        JE	SAVE_1
	CMP	DL,31H
	JE	RETT
	mov	al,70h
	SUB	BX,4
	CALL	INVER
	JMP	SHORT RE_1
RETT:	pop	ds
	RET
SAVE_1: pop	ds
	CALL	SAVE_PRO
	RET
PGUP1:  JMP     PGUP
PGDN1:	JMP	PGDN
DN_DN:	JMP	DN_1
UP_1G:	JMP	UP_1
RIGH1:  JMP     short RIGHT_1

LEFT_1:
	MOV	AL,LEF_1
	CMP	AL,0
	JE	RE_RE
	cmp	bx,160*9+20*2
	jb	mem_ob1
	INC	BX
	INC	BX
MEM_OB1:
	SUB	BX,10
	DEC	AL
	MOV	LEF_1,AL
	MOV	AL,RIG_1
	INC	AL
	MOV	RIG_1,AL
	MOV	AL,70H
	CALL	INVER
	JMP	RE_1
RE_11:
        CMP	BX,160*7
	JA	RE_RE1
	MOV	BX,160*4+15*2
	MOV	UPPP,2
	MOV	LEF_1,0
	MOV	RIG_1,2
	MOV	DOWW,0
	JMP	SHORT RE_RE
RE_RE1:
	mov	bx,160*9+15*2
	mov	uppp,3
	mov	rig_1,0
	mov	lef_1,0
	mov	al,70h
re_re:
	SUB	BX,4
	MOV	AL,70H
	CALL	INVER
re_re5:	JMP	RE_1

RIGHT_1:
	MOV	AL,RIG_1
	CMP	AL,0
	JE	RE_RE
	cmp	bx,160*9+19*2
	ja	mem_ob
	ADD	BX,2
mem_ob:	DEC	AL
	MOV	RIG_1,AL
	MOV	AL,LEF_1
	INC	AL
	MOV	LEF_1,AL
	MOV	AL,70H
	CALL	INVER
	JMP	RE_1

UP_1:   MOV	AL,UPPP
	CMP	AL,0
	JE	RE_11
	DEC	AL
	MOV	UPPP,AL
	MOV	AL,DOWW
	INC	AL
	MOV	DOWW,AL
	SUB	BX,160+4
	MOV	AL,70H
	CALL	INVER
	JMP	RE_1

DN_1:   CMP	BX,160*2+22*2
	JA	D_NN
	CALL	TIME_SAVE
D_NN:   MOV	AL,DOWW
	CMP	AL,0
	JE	RE_113
	DEC	AL
	MOV	DOWW,AL
	MOV	AL,UPPP
	INC	AL
	MOV	UPPP,AL
	ADD	BX,160-4
	MOV	AL,70H
	CALL	INVER
        JMP	RE_1

PGDN:   cmp	bx,160*10
	jb	sddd
	call	pg_dn_1
	jmp	re_1
sddd:	CALL	PG_DN
	JMP	RE_1
PGUP:	cmp	bx,160*10
	jb	sddd1
	call	pg_up_1
	jmp	re_1
sddd1:	CALL	PG_UP
	JMP	RE_1

RE_113:
	CMP	BX,160*9+13*2
	JA	MEMOR_1
	MOV	BX,160*6+13*2
	MOV	AL,70H
	CALL	INVER
	MOV	RIG_1,0
	MOV	LEF_1,0
	MOV	UPPP,0
	MOV	DOWW,3
	JMP     RE_1
MEMOR_1:
	MOV	BX,160*10+13*2
	MOV	AL,70H
	CALL	INVER
	MOV	RIG_1,1
	MOV	LEF_1,0
	MOV	UPPP,0
	MOV	DOWW,1
	JMP	RE_1
PEREDV  ENDP

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

