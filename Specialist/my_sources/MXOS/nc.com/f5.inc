;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша F5 - копирование
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

F5:		; Рисуем окно
		call	drawWindowIfSel

		; Рисуем надпись "COPY FROM DISK A: TO"
		lxi	h, 405Eh
		shld	v_cursorY
		lxi	h, aCopyFromDiskTo 
		call	printString
		call	printSelDrive

		call	inputForCopyMove
		cpi	1Bh
		jz	mainReload

		call	copyFileInt
		jmp	mainReload
