;----------------------------------------------------------------------------
; MXOS NC.COM
; Рисование информационной панели
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printInfoPanel:	COLOR(COLOR_BORDER)

		; Рисуем панель
		lxi	h, g_infoPanel
		call	draw

                COLOR(COLOR_INFOHEADER)

		; COMMANDER VERSION 1.4
		lxi	h, 1110h
		call	setCursorPosPanel
		lxi	h, aCommanderVersi
		call	printString

		; (C) OMSK 1992
		lxi	h, 1D1Ah
		call	setCursorPosPanel
		lxi	h, aCOmsk1992	
		call	printString

		; Положение курсора
		lxi	h, 1630h
		call	setCursorPosPanel

		; Получить размер диска
		mvi	e, 3		
		call	diskDriver
#if DISABLE_FREE_SPACE_BUG
		sbi	4
#endif
		mov	d, a
		mvi	e, 0
		push	d

		; ##### TOTAL BYTES
                COLOR(COLOR_INFONUMBERS)
		call	printDec
                COLOR(COLOR_INFOTEXT)
		lxi	h, aTotalBytes	
		call	printString

		; ON DRIVE A:
		lxi	h, 1F3Ch
		call	setCursorPosPanel
		lxi	h, aOnDrive	
		call	printString		
                COLOR(COLOR_INFONUMBERS)
		call	printCurDrive
                COLOR(COLOR_INFOTEXT)

		; Положение курсора
		lxi	h, 548h
		call	setCursorPosPanel
		
		; Подсчет свободного места на диске

		; Читаем FAT
		lxi	h, 0FE00h
		lxi	d, 2
		call	diskDriver

		; Считаем не занятые кластеры с 4-ого
		mov	e, l
		mvi	l, 4
#if DISABLE_FREE_SPACE_BUG
		xra	a
		mov	d, a
#else
		mov	d, l
#endif
loc_D8B8:	 mov	a, m
		 ana	a
		 jnz	loc_D8BE
		  inr	d
loc_D8BE:	 inr	l
		jnz	loc_D8B8

		push	d

		; ##### BYTES FREE ON DRIVE #:
                COLOR(COLOR_INFONUMBERS)
		call	printDec
                COLOR(COLOR_INFOTEXT)
		lxi	h, aBytesFreeOnDri
		call	printString
		call	printCurDrive

		; Положение курсора
		lxi	h, 0D54h
		call	setCursorPosPanel

		; DE = кол-во файлов		
		lxi	h, panelA_filesCnt
		lda	activePanel
		ana	a
		jnz	loc_D8E0
		inx	h
loc_D8E0:	mov	e, m
		mvi	d, 0

		; ##### FILES USE #####
                COLOR(COLOR_INFONUMBERS)
		call	printDec
                COLOR(COLOR_INFOTEXT)
		lxi	h, aFilesUse
		call	printString
		pop	h
		pop	d
		mov	a, d
		sub	h
		mov	d, a
		mvi	e, 0
                COLOR(COLOR_INFONUMBERS)
		call	printDec
                COLOR(COLOR_INFOTEXT)

		; BYTES IN A:
		lxi	h, 1F60h
		call	setCursorPosPanel
		lxi	h, aBytesIn
		call	printString		

                COLOR(COLOR_INFONUMBERS)
		jmp	printCurDrive
		