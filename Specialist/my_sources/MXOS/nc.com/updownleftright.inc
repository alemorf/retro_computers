;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиши перемещения курсора
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

Down:		; Если curFile+1 < filesCnt, то curFile = curFile+1
		lxi	h, panelA_filesCnt
		call	readBytePanel
		mov	c, a
		lxi	h, panelA_curFile
		call	readBytePanel
		inr	a
		cmp	c
		jz	mainDriveChanged
		call	writeBytePanel
		jmp	mainDriveChanged

; ---------------------------------------------------------------------------

Up:		; Если curFile > 0, то curFile = curFile-1
		lxi	h, panelA_curFile
		call	readBytePanel
		dcr	a
		jm	mainDriveChanged
		call	writeBytePanel
		jmp	mainDriveChanged

; ---------------------------------------------------------------------------

Left:		; Если curFile > 18, то curFile = curFile-18, иначе curFile = 0
		lxi	h, panelA_curFile
		call	readBytePanel
		sui	18
		jp	Left_1
		xra	a		
Left_1:		call	writeBytePanel
		jmp	mainDriveChanged

; ---------------------------------------------------------------------------

Right:		lxi	h, panelA_filesCnt
		call	readBytePanel
		mov	c, a
		dcr	c
		jz	mainDriveChanged
		lxi	h, panelA_curFile
		call	readBytePanel
		adi	18
		cmp	c
		jc	Right_1
		mov	a, c
Right_1:	call	writeBytePanel
		jmp	mainDriveChanged