;----------------------------------------------------------------------------
; MXOS NC.COM
; Вывод инфомарции о файле внизу окна
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printInfoLine:	; Если файлов нет, выходим
		lxi	h, panelA_filesCnt
		call	readBytePanel
		ana	a
		rz

		COLOR(COLOR_INFOLINE)		

		lxi	h, 12DEh
		call	setCursorPosPanel

		call	getSelectedFile
		call	printFileName
		mvi	b, 3
		call	printSpaces	; b - кол-во пробелов

		dcx	h
		dcx	h
		dcx	h
		mov	d, m
		dcx	h
		mov	e, m

		push	d

		dcx	h
		mov	a, m
		call	printHexByte
		dcx	h
		mov	a, m
		call	printHexByte

		mvi	c, ' '
		call	printChar

		pop	d

		jmp	printDec
