;----------------------------------------------------------------------------
; MXOS NC.COM
; Поместить выбранный файл в ком строку
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

selFileToCmdLine:
		xchg

		; Получаем текущий накопитель
		lxi	h, panelA_drive
		call	readBytePanel
		adi	'A'

		; Выводим его в ком строку
		lhld	v_cmdLineEnd
		mov	m, a
		inx	h

		; Выводим двоеточние
		mvi	m, ':'
		inx	h

		; Выводим имя файла
		xchg
		call	compactName

		; Ограничение длины
		dcx	d
		mvi	a, (v_cmdLine+59 & 0FFh)
		cmp	e
		jnc	loc_D146
		 mov	e, a		 
loc_D146:	
		; Терминатор
		xra	a
		stax	d

		; Вывод
		COLOR(COLOR_CMDLINE)
		lhld	v_cmdLineEnd
		call	printString

		; Дописываем имя файла
		xchg
		shld	v_cmdLineEnd

		; Сохраняем новое положение
		lhld	v_cursorY
		shld	v_cmdLinePos
		ret