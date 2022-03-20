;+---------------------------------------------------------------------------
; RAMFOS
; Точки входа
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

			jmp	init
			jmp	j_keyWait
			jmp	j_tapeRead
			jmp	j_printChar
			jmp	j_tapeWrite
			jmp	j_printCharA
			jmp	j_keyCheck
			jmp	j_printHex
			jmp	j_printString
			jmp	j_keyScan
			jmp	j_getCursorPos
			jmp	j_getCharFromScr
			jmp	dlg_loadFile
			jmp	fileSaveDlg
			jmp	j_calcCrc
			jmp	fileSetType
			jmp	j_getMemTop
			jmp	j_setMemTop
j_pageReadAny:		jmp	pageReadAny
j_pageWriteAny:		jmp	pageWriteAny
			jmp	j_setCursorPos
			jmp	fileSave
			jmp	fileSetAddr
			jmp	fileGetName
			jmp	fileSetName
			jmp	fileFind
			jmp	fileLoad
			jmp	fileDelete
#if NO_ROM_ENTRY | RKS_LOADER
#if NO_MXDOS
			jmp	init
#else
			jmp	loadMxDos
#endif
			jmp	exec
#endif