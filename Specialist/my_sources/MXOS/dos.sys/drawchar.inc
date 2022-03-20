;+---------------------------------------------------------------------------
; MXOS
; Рисование символа на экране
;
; На входе 
;  bc - адрес символа
;  de - адрес в видеопамяти
;  h  - координата X в пикселях / 2
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

		; Высота символа
		mvi	l, 8

		; Переходим в одной из функций вывода
		mov	a, h
		ani	3
		jz	drawChar0	; a==0
		dcr	a
		jz	drawChar1	; a==1
		dcr	a
		jz	drawChar2	; a==2
		dcr	a
		jz	drawChar3	; a==3
		; Продолжение на drawChar2

; ---------------------------------------------------------------------------

drawChar2:	ldax	b		
		ani	0FCh
		mov	h, a
		ldax	d		
		rrc
		rrc
		rrc
		rrc
drawChar2_cma:	cma
		push	psw
		ani	3
		xra	h
		stax	b
		inr	b
		ldax	b
		ani	0Fh
		mov	h, a
		pop	psw
		ani	0F0h
		xra	h
		stax	b
		dcr	b

		; Цикл
		inx	b
		inx	d
		dcr	l
		jnz	drawChar2
		ret

; ---------------------------------------------------------------------------

drawChar3:	ldax	b
		ani	3
		mov	h, a
		ldax	d
		rlc
		rlc
drawChar3_xri:	xri	0FCh
		xra	h
		stax	b

		; Цикл
		inx	d
		inx	b
		dcr	l
		jnz	drawChar3
		ret

; ---------------------------------------------------------------------------

drawChar0:	ldax	b
		ani	0C0h
		mov	h, a
		ldax	d
drawChar0_xri:	xri	3Fh
		xra	h
		stax	b

		; Цикл
		inx	d
		inx	b
		dcr	l
		jnz	drawChar0
		ret

; ---------------------------------------------------------------------------

drawChar1:	ldax	b
		ani	0F0h
		mov	h, a
		ldax	d
		rrc
		rrc
drawChar1_cma:	cma
		ani	0Fh
		xra	h
		stax	b
		inr	b
		ldax	b
		ani	3Fh
		mov	h, a
		ldax	d
		rrc
		rrc
drawChar1_cma2:	cma
		ani	0C0h
		xra	h
		stax	b
		dcr	b

		; Цикл
		inx	b
		inx	d
		dcr	l
		jnz	drawChar1
		ret

; ---------------------------------------------------------------------------
; Вызывается из printChar_real2

normalVideo:	; Меняем CZ normalVideo на CNZ inverseVideo
		lxi	h, inverseVideo
		shld	printChar_poly+1
		mvi	a, 0C4h
		sta	printChar_poly

		; Аргумент XRI
		xra	a
		sta	drawChar0_xri+1
		sta	drawChar3_xri+1
normalVideo_1:	; Меняем CMA на NOP
		sta	drawChar2_cma		
		sta	drawChar1_cma
		sta	drawChar1_cma2
		ret

; ---------------------------------------------------------------------------
; Вызывается из printChar_real2

inverseVideo:	; Меняем CNZ inverseVideo на CZ normalVideo
		lxi	h, normalVideo
		shld	printChar_poly+1
		mvi	a, 0CCh		
		sta	printChar_poly

		; Меняем аргумент XRI
		mvi	a, 0FCh
		sta	drawChar3_xri+1
		mvi	a, 3Fh
		sta	drawChar0_xri+1

		; Меняем NOP на CMA
		mvi	a, 2Fh
		jmp	normalVideo_1