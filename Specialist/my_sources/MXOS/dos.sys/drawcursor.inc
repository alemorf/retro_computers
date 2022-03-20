;+---------------------------------------------------------------------------
; MXOS
; Рисование курсора на экране
;
; На выходе
;  bc,de,hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

drawCursor:	; Если установлен 7-ой бит v_cursorCfg & 0x80, выходим
		lda	v_cursorCfg
		ana	a
		rm

drawCursor2:	; Курсор нарисован/стерт
		inr	c
		
drawCursor3:	; Сохраняем регистры
		push	h
		push	b
		push	d

		; Рассчитываем адрес на экране
		call	calcCursorAddr
		mov	d, a

		; Положение курсора от +2 до -5 (при битах 654 от 0 до 7)
		; b = v_cursorCfg
		; e = ~((v_cursorCfg / 16) % 8 - 3) + l
		lda	v_cursorCfg
		mov	b, a
		rrc
		rrc
		rrc
		rrc
		ani	7
		sui	3
		cma
		add	l
		mov	e, a

		; Рассчитыаем маску курсора
		;  hl = 011111100b << (((~h) % 4 +1)*2)
		mov	a, h
		cma
		ani	3
		lxi	h, 011111100b ; FCh
		inr	a
drawCursor_0:	dad	h
		dad	h
		jmp	drawCursor_1