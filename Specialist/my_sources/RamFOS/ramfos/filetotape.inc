;+---------------------------------------------------------------------------
; RAMFOS
; Сохранить файл на магнитофон
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileToTape:	; Сначала записываем только 15 байт.
		push	h
		 push	d
		  lxi	d, 15
		  call	fileToTape_0
		 pop	d
		pop	h

		; Потом тот же блок данных, но целиком

fileToTape_0:	; Пилот тон
		call	j_tapeWritePilot

		; Запись длины
		mov	c, e
		xra	a
		call	j_tapeWrite
		mov	c, d
		xra	a
		call	j_tapeWrite

		; Укорочение первого импульса магниофона *15 тактов
		mvi	b, 8		
fileToTape_1:	 ; Если записывать нечего, выходим
		 mov	a, e
		 ora	d
		 rz
		 ; Читаем байт с диска
		 call	pageRead
		 inx	h
		 ; Уменьшаем счетчик
		 dcx	d
		 ; Записываем на магнитофон
		 mov	a, b
		 call	j_tapeWrite
		jmp	fileToTape_1