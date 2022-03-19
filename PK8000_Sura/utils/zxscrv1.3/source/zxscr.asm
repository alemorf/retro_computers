;Просмотрщик спектрумовских картинок (копии экрана длиной 6912 байт) на ПК8000.
;Программа не оптимизировалась ни по скорости ни по размеру, но вполне работоспособна
;Иван Городецкий, г. Уфа, iig1 на mail.ru
;v1.3 - 12.09.2008
;Компилировать в TASM - A Table Driven Cross Assembler for the MSDOS* Environment (tasm 3.01 или 3.2)


Begin		.equ	0D000h-1D0h

		.ORG Begin-26h

		.DB 1Fh, 0A6h, 0DEh, 0BAh, 0CCh, 13h, 7Dh, 74h
		.DB 0D0h, 0D0h, 0D0h, 0D0h, 0D0h, 0D0h, 0D0h, 0D0h, 0D0h, 0D0h
		.DB "ZXSCR "
		.DB 1Fh, 0A6h, 0DEh, 0BAh, 0CCh, 13h, 7Dh, 74h
		.DW Begin,0EB00h,Begin

Start:
		push	psw
		push	b
		push	d
		push	h
		mvi	a,2
		call	006Ah		;установить режим 2

Restart:
;изображение
		lxi	h,zxscr
		lxi	d,0
		mvi	a,3
ZxScreen:	push	psw
		push	h
		mvi	b,8		;в трети 8 строк
ZxThird:	push	h
		mvi	c,32		;32 символа в строке
ZxLine:	push	h
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inr	h
		inx	d
		mov	a,m
		stax	d
		inx	d
		pop	h
		inx	h
		dcr	c
		jnz	ZxLine
		pop	h
		push	d
		lxi	d,32
		dad	d
		pop	d
		dcr	b
		jnz	ZxThird
		pop	h
		push	d
		lxi	d,2048
		dad	d
		pop	d
		pop	psw
		dcr	a
		jnz	ZxScreen

;цвет
;адрес спектрумовских атрибутов в HL
		lxi	d,2000h	;адрес CT на ПК8000 в режиме 2 (при установке из ПЗУ)
		lxi	b,300h
ATTRloop:	call	ClrTrans
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		stax	d
		inx	d
		inx	h
		dcx	b
		mov	a,b
		ora	c
		jnz	ATTRloop

KeyWait:	mvi	a,6
		call	0047h
		mov	c,a
		mvi	a,00100000b	;F1
		ana	c
		jz	Exit
		mvi	a,01000000b	;F2
		ana	c
		jnz	ChkF3
;с учетом яркости
		mvi	a,00010001b
		sta	Bright+1
		jmp	Restart		
ChkF3:
		mvi	a,10000000b	;F3
		ana	c
		jnz	ChkF4
		mvi	a,00000000b
		sta	Bright+1
		jmp	Restart		
ChkF4:
		mvi	a,7
		call	0047h
		ani	00000001b	;F4
		jnz	ChkRight
		mvi	a,0Fh
		lxi	h,2000h	;CT
		lxi	b,1800h
		call	0056h
		jmp	KeyWait
ChkRight:
		mvi	a,8
		call	0047h
		ani	10000000b	;->
		jnz	ChkLeft
		di
		mvi	a,11111111b
		out	80h
		lxi	h,1800h+30
		lxi	d,1800h+31
		mvi	c,24
MovLineR:	push	d
		ldax	d
		push	psw
		mvi	b,31
MovSymR:	mov	a,m
		stax	d
		dcx	h
		dcx	d
		dcr	b
		jnz	MovSymR
		pop	psw
		stax	d
		pop	d
		lxi	h,32
		dad	d
		mov	d,h
		mov	e,l
		dcx	h
		dcr	c
		jnz	MovLineR
		mvi	a,11111100b
		out	80h
		ei
		jmp	KeyWait
ChkLeft:
		mvi	a,8
		call	0047h
		ani	00010000b	;<-
		jnz	ChkCenter
		di
		mvi	a,11111111b
		out	80h
		lxi	h,1800h+1
		lxi	d,1800h
		mvi	c,24
MovLineL:	push	d
		ldax	d
		push	psw
		mvi	b,31
MovSymL:	mov	a,m
		stax	d
		inx	h
		inx	d
		dcr	b
		jnz	MovSymL
		pop	psw
		stax	d
		pop	d
		lxi	h,32
		dad	d
		mov	d,h
		mov	e,l
		inx	h
		dcr	c
		jnz	MovLineL
		mvi	a,11111100b
		out	80h
		ei
		jmp	KeyWait
ChkCenter:
		mvi	a,9
		call	0047h
		ani	00000100b	;5
		jnz	ChkF5
		lxi	h,1800h	;PNT
		lxi	b,300h
		mvi	e,0
PNTiniLoop:	mov	m,e
		inr	e
		inx	h
		dcx	b
		mov	a,b
		ora	c
		jnz	PNTiniLoop
		jmp	KeyWait
ChkF5:
		mvi	a,7
		call	0047h
		ani	00000010b	;F5
		jnz	KeyWait
		di
		mvi	a,11111111b
		out	80h
		lxi	h,17FFh
		mvi	c,0FFh
InvLoop:
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,m
		cma
		mov	m,a
		dcx	h
		mov	a,h
		cmp	c
		jnz	InvLoop
		mvi	a,11111100b
		out	80h
		ei
		jmp	KeyWait

Exit:
		pop	h
		pop	d
		pop	b
		pop	psw
		jmp	0

ClrTrans:
		push	b
		push	d
		xchg

		ldax	d
		ani	00000111b
		lxi	h,ClrTab
		add	l
		mov	l,a
		mov	a,h
		aci	0
		mov	h,a
		mov	c,m		;цвет изображения

		ldax	d
		rrc
		rrc
		rrc
		ani	00000111b
		lxi	h,ClrTab
		add	l
		mov	l,a
		mov	a,h
		aci	0
		mov	h,a
		mov	a,m		;цвет фона
		rlc
		rlc
		rlc
		rlc
		ora	c
		mov	c,a

		ldax	d
		ani	01000000b
		jz	NoBright
Bright:	mvi	a,00010001b
		ora	c
		mov	c,a
NoBright:	mov	a,c
		xchg
		pop	d
		pop	b
		ret
		

ClrTab:	.db 0		;0 на zx - черный (0) на ПК8000
		.db 4		;1 на zx - синий (4) на ПК8000
		.db 8		;2 на zx - красный (8) на ПК8000
		.db 4+8	;3
		.db 2		;4 на zx - зеленый (2) на ПК8000
		.db 4+2	;5
		.db 8+2	;6
		.db 4+8+2	;7

zxscr:
		.end
