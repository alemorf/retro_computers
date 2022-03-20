;+---------------------------------------------------------------------------
; RAMFOS
; Ожидание нажатия клавиши с курсором
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

keyCursor:	; Рисуем курсор XOR-ом
		call	keyCursor1
		; Стираем курсор XOR-ом
		call	keyCursor1
		; Если была нажата клавиаша, выходим
		rnz
		; Бесконечное ожидание
		jmp	keyCursor

;----------------------------------------------------------------------------

keyCursor1:	
#if FAST_PRINT != 1
		; Код символа курсора
		mvi	c, 17h

		; Положение курсора в пикселях 		
		lhld	v_cursorPos
		xchg

		; Получение изображения символа hl и адреса в видеопамяти de
		call	calcCharAddr2

		; Корректировка адреса
		mov	a, e
		sui	7
		mov	e, a

		; Рисование курсора
		call	drawChar
#else ;----------------------------------------------------------------------
		; Положение курсора в пикселях 		
		lhld	v_cursorPos
		xchg

		; Получение адреса в видеопамяти de
		call calcCharAddr

		; Исходный символ
		lxi	h, 3Fh		 

		; Сдвигаем
		mov	a, c		
drawCursor_0:	 dad	h
		 dad	h
		 dcr	a
		jnz	drawCursor_0

		; Цикл b
		mvi	b, 8
drawCursor_1:	 ; *de++ ^= hl
		 ldax	d
		 xra	h
		 stax	d		 
		 inr	d		 
		 ldax	d
		 xra	l
		 stax	d
		 dcr	d
		 dcr	e		
		 ; Цикл
		 dcr	b
		jnz	drawCursor_1
#endif ;---------------------------------------------------------------------
		; Ждем нажатия клавиши
		lxi	h, CURSOR_BLINK_SPEED
keyCursor1_0:	 call	keyCheck
		 rnz
		 dcx	h
		 mov	a, h
		 ora	l
		jnz	keyCursor1_0
		ret