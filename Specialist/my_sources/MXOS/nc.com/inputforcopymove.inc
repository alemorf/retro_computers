;----------------------------------------------------------------------------
; MXOS NC.COM
; Ввод строки в которой изначально содержится имя выбранного файла
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

inputForCopyMove:
		; Положение курсора
		lxi	h, 3D6Eh
		shld	v_cursorY

		; Строка для редактирования	
		lxi	d, v_input

		; Отображается ли панель?
		lxi	h, panelA_info
		lda	activePanel
		ana	a
		jnz	loc_D255
		inx	h
loc_D255:	mov	a, m

		; Если не отображается, то накопитель в стркоу не помещать
		ana	a
		jnz	loc_D265

		; Записываем букву накопителя
		inx	h
		inx	h
		mov	a, m
		adi	'A'
		stax	d
		inx	d

		; Записываем ':'
		mvi	a, ':'
		stax	d
		inx	d

loc_D265:	; Записать выбранный файл
		call	getSelectedFile
		call	compactName

		; Записать 0
		dcx	d
		dcx	d
		xra	a
		stax	d

		; Перейти к редакированию
		jmp	input