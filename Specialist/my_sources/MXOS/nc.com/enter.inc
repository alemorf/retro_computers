;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша ENTER
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

Enter:		; Если ком строка не пустая
		lhld	v_cmdLineEnd
		mvi	a, v_cmdLine & 0FFh
		cmp	l
		jnz	EnterCmdLine

		; Загрузка файла NC.EXT по адресу 0
		lxi	d, 0
		lxi	h, aNcExt
		call	fileLoad2
		jc	Enter_stdExec

		; Получить имя выбранного файла
		call	getSelectedFile
		mov	a, m
		inr	a
		jz	mainLoop ; Ничего не выбрано

		; hl - расширение файла
		lxi	d, 6
		dad	d

		; hl - расширение файла
		lxi	d, 0

		; Сравниваем расширение из файла
Enter_extLoop:	mvi	c, 3
		push	h
Enter_1:	ldax	d
		cmp	m
		jnz	Enter_nextExt
		inx	h
		inx	d
		dcr	c
		jnz	Enter_1
		pop	h
		inx	d

		; Найдено расширение

		; Копирование имени выбранного файла в ком строку
Enter_5:	lxi	h, v_cmdLine
Enter_4:	ldax	d
		mov	m, a
		cpi	0Dh
		jz	Enter_3
		inr	a
		jz	Enter_3
		inx	h
		inx	d
		jmp	Enter_4

; ---------------------------------------------------------------------------

Enter_3:	mvi	m, ' '
		inx	h
		mvi	m, 0
		shld	v_cmdLineEnd

		; Вывод ком строки на экран
		lxi	h, v_cmdLine
		call	printString

Enter_stdExec:	; Получить выбранный файл
		call	getSelectedFile

		; Ничего не выбрано
		mov	a, m
		inr	a
		jz	mainLoop

		; ?
		call	selFileToCmdLine

EnterCmdLine:	; Очистка экрана
		mvi	c, 1Fh
		call	printChar

		; Помещаем в конец ком строки 0Dh
		lhld	v_cmdLineEnd
		mvi	m, 0Dh

		; Сохраняем состояние
		call	saveState

		; Запускаем файл
		lxi	h, v_cmdLine
		jmp	fileExec