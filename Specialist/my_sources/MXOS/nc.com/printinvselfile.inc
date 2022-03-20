;----------------------------------------------------------------------------
; MXOS NC.COM
; Инверсный вывод имени выбранного файла
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printInvSelFile:
		call	getSelectedFile
		xchg
printInvFile:	lxi	h, 506Eh
		shld	v_cursorY
		xchg
		lxi	d, v_input
		call	compactName
		lxi	h, v_input
		jmp	printStringInv
