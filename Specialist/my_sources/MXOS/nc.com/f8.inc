;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша F8 - удаление файла
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

F8:		; Рисуем окно
		call	drawWindowIfSel

		; Выводим надпись "DELETE FROM DISK A:"
		lxi	h, 425Eh
		shld	v_cursorY
		lxi	h, aDeleteFromDisk
		call	printString
		call	printSelDrive

		call	printInvSelFile

loc_D54C:	; Ждем нажатия Enter или ESC
		call	keyScan
		cpi	1Bh
		jz	mainReload
		cpi	0Dh
		jnz	loc_D54C

		; Если файл только для чтения
		call	getSelectedFile		
		lxi	d, 9
		dad	d
		mov	a, m
		ani	1
		jz	loc_D595

		call	drawWindow2

		; Выводим текст "FILE IS PROTECTION"
		lxi	h, 4680h
		shld	v_cursorY
		lxi	h, aFileIsProtecti
		call	printString

		; Выводим v_input
		lxi	h, 5090h
		shld	v_cursorY		
		lxi	h, v_input
		call	printStringInv

loc_D581:				; CODE XREF: drawWindowIfSel+379j
		call	keyScan
		inr	a
		jnz	loc_D581

loc_D588:				; CODE XREF: drawWindowIfSel+386j
		call	keyScan
		cpi	1Bh
		jz	mainReload
		cpi	0Dh
		jnz	loc_D588

loc_D595:	; Удаляем текущий файл
		call	getSelectedFile
		call	fileDelete

		; Уменьшаем счетчик файлов
		lxi	h, panelA_filesCnt
		call	readBytePanel
		dcr	a
		call	writeBytePanel

		jmp	mainReload
