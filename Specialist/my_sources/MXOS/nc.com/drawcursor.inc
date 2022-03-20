;----------------------------------------------------------------------------
; MXOS NC.COM
; Рисование курсора
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

drawCursor:	; Цвет устаналвиается перед выводом

		; Если файлов нет, выходим
		lxi	h, panelA_filesCnt
		call	readBytePanel
		ana	a
#if ENABLE_COLOR
		rz
#else
		jz	drawCursor_0
#endif
		; Номер выбранного файла
		lxi	h, panelA_curFile
		call	readBytePanel

		; Рассчиытваем координату X (h = a < 18 ? 0x91 : 0x9D)
		mvi	h, 91h
		cpi	18
		jc	drawCursor_1
		sui	18
		mvi	h, 9Dh

drawCursor_1:	; Рассчиытваем координату Y (l = a * 10 + 18h)
		add	a
		mov	c, a
		add	a
		add	a
		add	c
		adi	24
		mov	l, a

		; Ширина
		mvi	b, 10

		; Если правая панель, сдвигаем курсор на пол экрана
drawCursor_2:	lda	activePanel
		ana	a
		jz	drawCursor_3
		mvi	a, 18h
drawCursor_3:	add	h
		mov	h, a

		; Рисуем курсор (hl - адрес, b - ширина, высота 9)
		call	inverseRect
		ret

; ---------------------------------------------------------------------------

#if ENABLE_COLOR==0
drawCursor_0:	lxi	h, 92D6h
		mvi	b, 2
		jmp	drawCursor_2
#endif