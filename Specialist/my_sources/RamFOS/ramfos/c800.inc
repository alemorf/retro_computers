;+---------------------------------------------------------------------------
; RAMFOS
; Точки входа
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

j_biosInit:		jmp	biosInit
j_keyWait:		jmp	keyWait
j_tapeRead:		jmp	tapeRead
j_printChar:		jmp     printChar
j_tapeWrite:		jmp	tapeWrite
j_printCharA:		jmp	printCharA
j_keyCheck:		jmp	keyCheck
j_printHex:		jmp	printHex
j_printString:		jmp	printString
j_keyScan:		jmp	keyScan
j_getCursorPos:		jmp	getCursorPos
j_getCharFromScr:	jmp	getCharFromScreen
j_tapeReadPilot:	jmp	tapeReadPilot
j_tapeWritePilot:	jmp     tapeWritePilot
j_calcCrc:		jmp     calcCrc
j_setBottomLine:	jmp     setBottomLine
j_getMemTop:		jmp	getMemTop
j_setMemTop:		jmp     setMemTop
j_input:		jmp     input
j_strToHex:		jmp	strToHex
j_setCursorPos:		jmp	setCursorPos
			jmp	printer
			jmp	printerHex
j_inputFileName:	jmp     inputFileName
			jmp	beep
			jmp	setColor
			jmp	fullClearScreen
			jmp	oldBeep
j_cmp_hl_de:		jmp     cmp_hl_de
j_printerEchoMode:	jmp	printerEchoMode
j_tapeMode:		jmp	tapeMode
