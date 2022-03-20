;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша F6 - переименование
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

F6:		; Рисуем окно
		call	drawWindowIfSel

		; Выводим текст "REMOVE FROM DISK A: TO"
		lxi	h, 3E5Eh
		shld	v_cursorY
		lxi	h, aRemoveFromDisk
		call	printString
		call	printSelDrive

		call	inputForCopyMove
		cpi	1Bh
		jz	mainReload

		lxi	h, v_input
		lxi	d, files2
		call	fileNamePrepare

		mvi	e, 2
		call	fileGetSetDrive
		mov	c, a
		lxi	h, panelA_drive
		call	readBytePanel
		cmp	c
		jnz	loc_D47B
		call	getSelectedFile
		lxi	d, files2
		call	fileRename
		jmp	mainReload
; ---------------------------------------------------------------------------

loc_D47B:	mvi	e, 1
		call	fileGetSetDrive
		call	getSelectedFile
		lxi	d, files2
		mvi	c, 9

loc_D488:	mov	a, m
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	loc_D488
		call	copyFileInt
		lxi	h, panelA_drive
		call	readBytePanel
		mvi	e, 1
		call	fileGetSetDrive
		lxi	h, files2
		call	fileDelete
		jmp	mainReload
