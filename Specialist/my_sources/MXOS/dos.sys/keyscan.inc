;+---------------------------------------------------------------------------
; MXOS
; Получить код нажатой клавиши
;
; На выходе
;  a - код
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

setKeybMode83:	mvi	a, 83h
		sta	IO_KEYB_MODE
		ret

; ---------------------------------------------------------------------------

keyScan2:	; Режим чтения ряда
		call	setKeybMode82

		; Одним чтением првоеряем все клавиши
		lda	IO_KEYB_B	

		; Эти биты не используются в сканировании
		ori	3

		; Ни одна клавиша не нажата
		cpi	0FFh
		rz

		; Сохраняем регистры
		push	h
		push	b
		push	d
		
		; Перебираем 12 столбцов кнопок
		lxi	h, 0FFEh
		lxi	d, v_keybTbl + 11
		mvi	b, 0FFh
loc_C1DD:	mov	a, h
		sta	IO_KEYB_C
		mov	a, l
		sta	IO_KEYB_A
		rrc
		cma
		ani	4
		mov	c, a
		lda	IO_KEYB_B
		ora	c

		; Перебираем 6 кнопок в столбце
		mvi	c, 6
		rrc
		rrc
loc_C1F2:	rrc
		cnc	keybScan3
		dcr	c
		jnz	loc_C1F2

		; Цикл
		dcx	d
		dad	h
		inx	h
		mov	a, h
		adi	0F0h
		mov	h, a
		jc	loc_C1DD

		; Режим ВВ55 по уполчанию
		call	setKeybMode82

		; Результат
		mov	a, b

		; Восстаналвиаем регистры
		pop	d
		pop	b
		pop	h
		ret

;----------------------------------------------------------------------------

keybScan3:	push	d
		push	psw
		mvi	a, 6		; e += (6 - c) * 16
		sub	c
		add	a
		add	a
		add	a
		add	a
		add	e
		mov	e, a
		ldax	d		; b = *de;
		mov	b, a
		pop	psw
		pop	d
		ret