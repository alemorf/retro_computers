;----------------------------------------------------------------------------
; MXOS NC.COM
; Вывод списка файлов на панель
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printFilePanel:	COLOR(COLOR_BORDER)

		lxi	h, g_filePanel
		call	draw

		COLOR(COLOR_PANELNAME)

		; Вывод NAME
		lxi	h, 1110h
		call	setCursorPosPanel
		lxi	h, aNameName
		call	printString

		COLOR(COLOR_INFOLINE)

		; Вывод буквы диска
		lxi	h, panelA_drive
		call	readBytePanel
		lxi	h, 9DEh
		call	setCursorPosPanel
		call	printDrive

		COLOR(COLOR_FILE)

		; Вывод всех файлов
		lxi	h, files
		lxi	d, 0A20h
		mvi	c, 0		

		
loc_D92E:	; Установка положения курсора
		xchg
		call	setCursorPosPanel
		xchg

		; Файл существует?
		mov	a, m
		inr	a
		jz	loc_D94E

		; Вывод имени
		call	printFileName

		; Счетчик
		inr	c

		; Положение курсора
		mov	a, e
		adi	10
		mov	e, a

		; Следующая колонка
		cpi	0D0h
		jc	loc_D92E
		mov	a, d
		lxi	d, 3920h
		cpi	14h
		jc	loc_D92E

loc_D94E:	; Сохранение кол-ва файлов
		lxi	h, panelA_filesCnt
		mov	a, c
		call	writeBytePanel

		; Если курсор больше максимума
		lxi	h, panelA_curFile
		call	readBytePanel
		cmp	c
		rc

		; То изменить на максимум
		dcr	a
		rm
		jmp	writeBytePanel
