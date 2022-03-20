;----------------------------------------------------------------------------
; MXOS NC.COM
; Общая функция для копирования и переноса файла
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

copyFileInt:	; Загрузка выбранного файла в память
		call	loadSelFileAt0
		push	d	; Тут реальный адрес

		; Подготавливаем имя	
		xchg
		lxi	h, v_input
		call	fileNamePrepare
		xchg

loc_D4E4:	; Сохраняем имя
		push	h

		; Устанавливаем адрес сохраняемого файла
		lxi	d, 10
		dad	d
		lxi	d, 0
		mov	m, e
		inx	h
		mov	m, d

		; Сохраняем файл
		pop	h
		call	fileCreate

		; Изменяем адрес загрузки файла
		pop	d
		mvi	c, 1
		call	fileGetSetAddr

		; Выходим, если нет ошибки
		rnc

		; Рисуем окно
		call	drawWindow2

		; Вывод "CAN'T CREATY FILE"
		lxi	h, 4580h
		shld	v_cursorY
		lxi	h, aCanTCreatyFile
		call	printString

		; Вывод имени
		lxi	h, 5090h
		shld	v_cursorY
		lxi	h, v_input
		call	printStringInv

anyKey:		; Ждем нажатия любой клавиши
		call	keyScan
		inr	a
		jz	anyKey

		; Выход
		pop	h
		jmp	mainReload