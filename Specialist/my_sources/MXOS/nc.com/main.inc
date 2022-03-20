;----------------------------------------------------------------------------
; MXOS NC.COM
; Основной цикл
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

mainReload:	; Перерисовываем обе панели
		lda	activePanel
		ana	a
		jnz	mainReload_0
		call	loadAndPrintA
		call	loadAndPrintB
		jmp	mainDriveChanged
mainReload_0:	call	loadAndPrintB
		call	loadAndPrintA
		
mainDriveChanged:
		; Вывод накопителя в ком строку
		COLOR(COLOR_CMDLINE)
		lxi	h, 1F3h
		shld	v_cursorY
		lxi	h, panelA_drive
		call	readBytePanel
		call	printDrive

		; Вывод информации о файле
		call	printInfoLine

mainLoop:	; Рисуем курсор выбранного файла
		COLOR(COLOR_CURSOR)
		call	drawCursor

		; Положение курсора в ком строке
		lhld	v_cmdLinePos
		shld	v_cursorY

		; Ждем нажатия клавиши
		COLOR(COLOR_CMDLINE)
		call	getch

		; Стираем курсор выбранного файла
		push	psw
		COLOR(COLOR_FILE)
		call	drawCursor
		pop	psw

		; Анализ нажатий клавиши
		mov	c, a
		jc	mainLoop_ctrl
		ana	a
		jz	F1
		dcr	a
		jz	F2
		dcr	a
		jz	F3
		dcr	a
		jz	F4
		dcr	a
		jz	F5
		dcr	a
		jz	F6
		dcr	a
		jz	F7
		dcr	a
		jz	F8
		dcr	a
		jz	Left
		dcr	a
		jz	Tab
		sui	4
		jz	Enter
		sui	0Bh
		jz	Right
		dcr	a
		jz	Up
		dcr	a
		jz	Down
		dcr	a
		jz	Esc
		adi	1Bh
		cpi	7Fh
		jz	Bkspc
		cpi	8Ah
		jz	f9
mainLoop_e:	cpi	' '
		jc	mainLoop

		; Вывод символов в ком строку
		lhld	v_cmdLineEnd
		mov	c, a
		mov	m, a

		; Если ком строка переполнена, выходим
		mvi	a, (v_cmdLine+59 & 0FFh)
		cmp	l
		jz	mainLoop

		; Увеличиваем длину
		inx	h
		shld	v_cmdLineEnd

		; Выводим символ на экран
		COLOR(070h)
		call	printChar

mainLoop_savePos:	; ?
		lhld	v_cursorY
		shld	v_cmdLinePos

		jmp	mainLoop

; ---------------------------------------------------------------------------

Bkspc:		; Если ком строка пустая, выходим
		lhld	v_cmdLineEnd
		mvi	a, v_cmdLine & 0FFh
		cmp	l
		jz	mainLoop

		; Удаляем один символ
		dcx	h
		shld	v_cmdLineEnd
		
		; Стираем символ на экране
		COLOR(070h)
		lxi	h, asc_DC17
		call	printString

		jmp	mainLoop_savePos

; ---------------------------------------------------------------------------

Esc:		call	clearCmdLine
		jmp	mainLoop

; ---------------------------------------------------------------------------

ctrlEnter:	; Если файл не выбран, выход
		call	getSelectedFile
		mov	a, m
		cpi	0FFh
		jz	mainLoop

		call	selFileToCmdLine
		jmp	mainLoop
