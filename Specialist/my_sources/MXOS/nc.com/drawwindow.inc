;----------------------------------------------------------------------------
; MXOS NC.COM
; Рисование окошек
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

drawWindowIfSel:; Получить кол-во файлов
		lxi	h, panelA_filesCnt
		call	readBytePanel

		; Если файлов нет, выходим
		ana	a
		pop	h ; Адрес возврата
		jz	mainDriveChanged
		push	h
		

; ---------------------------------------------------------------------------

drawWindow1:	COLOR(COLOR_DIALOG)

		; Рисуем окно
		lxi	h, g_window1
		call	draw
	
		; Рисуем прямоугольник
		lxi	h, 9F66h	; x=120 y=102
		mvi	b, 18		; w=144 h=9
		jmp	inverseRect

; ---------------------------------------------------------------------------

drawWindow2:	COLOR(COLOR_DIALOG)

		; Рисуем окно
		lxi	h, g_window2
		call	draw

		; Рисуем прямоугольник
		lxi	h, 9E88h	; x=112 y=136
		mvi	b, 20		; w=160 h=9
		jmp	inverseRect

