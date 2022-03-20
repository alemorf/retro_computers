;+---------------------------------------------------------------------------
; RAMFOS
; Чтение первых 15 байт заголовка файла в v_header и вывод его на экран
; Потом чтение длины тела (первые 2 байта) в DE
;
; Это общее начало функций fileFromTape, fileVerify
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileFromTapeCom:; Ждем пилот тон
		; Читаем длину в DE, но игнорируем её.
		lxi	h, v_header
		call	fileFromT_1

		; Читаем 15 байт с магнитофона по адресу hl
		mvi	e, 15
fileFromT_0:	 call	j_tapeRead
		 mov	m, a
		 inx	h
		 dcr	e
		jnz	fileFromT_0

		; Игнорируем D3,D3,D3

		; Выводим имя на экран
		call	printFileHeaderName

fileFromT_1:	; Ждем пилот тон
		call	j_tapeReadPilot

		; Читаем слово в DE
		cnc	j_tapeRead
		mov	e, a
		cnc	j_tapeRead
		mov	d, a
		ret