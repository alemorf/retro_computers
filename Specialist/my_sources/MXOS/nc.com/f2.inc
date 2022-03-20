;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиши F1, F2. Выбор накопителя для панели
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

F2:		; Временно устанавливаем activePanel=1
		lda	activePanel
		push	psw
		mvi	a, 1
		sta	activePanel

		; Диалог
		call	chooseDrive

		; Если выбрали устройство, то сохраняем его.
		cpi	0FFh
		jz	loc_D5C3		
		sta	panelB_drive

		; А так же делаем панель видимой и переиещаем курсор в начало
		xra	a
		sta	panelB_info
		sta	panelB_curFile

loc_D5C3:	; Восстанавливаем activePanel
		pop	psw
		sta	activePanel

		; Перезагружаем и перерисовываем вторую панель
		call	loadAndPrintB

		; Перезагружаем и перерисовываем первую панель, только если она отображается
		lda	panelA_info
		ana	a
		jz	loc_D603
		call	loadAndPrintA

		; Сохраняем состояние и выходим
		jmp	loc_D603

; ---------------------------------------------------------------------------

F1:		; Временно устанавливаем activePanel=02
		lda	activePanel
		push	psw
		mvi	a, 0
		sta	activePanel

		; Диалог
		call	chooseDrive

		; Если выбрали устройство, то сохраняем его.
		cpi	0FFh
		jz	loc_D5F2
		sta	panelA_drive

		; А так же делаем панель видимой и переиещаем курсор в начало
		xra	a
		sta	panelA_info
		sta	panelA_curFile

loc_D5F2:	; Восстанавливаем activePanel
		pop	psw
		sta	activePanel

		; Перезагружаем и перерисовываем первую панель
		call	loadAndPrintA

		; Перезагружаем и перерисовываем вторую панель, только если она отображается
		lda	panelB_info
		ana	a
		jz	loc_D603
		call	loadAndPrintB
		
loc_D603:	; Сохраняем состояние и выходим
		call	saveState
		jmp	mainDriveChanged

; ---------------------------------------------------------------------------

chooseDrive:	COLOR(COLOR_DIALOG)

		lxi	h, g_chooseDrive
		call	draw

		; Выводим текст "CHOOSE DRIVE:"
		lxi	h, 1E63h
		call	setCursorPosPanel
		lxi	h, aChooseDrive
		call	printString

		; Выводим текст "A   B   C   D"
		lxi	h, 1C74h
		call	setCursorPosPanel
		lxi	h, aABCD
		call	printString

		; Выводим текст "E   F   G   H"
		lxi	h, 1C7Fh
		call	setCursorPosPanel
		lxi	h, aEFGH	
		call	printString

		; Меняем вид курсора
		lda	v_cursorCfg
		push	psw
		xra	a
		sta	v_cursorCfg

		; Сохраняем текущее устройство
		lxi	h, panelA_drive
		call	readBytePanel
		sta	v_chooseDrive

loc_D644:	; Рисуем курсор
		call	chooseDrive_draw

		; Ждем нажатия клавиши
		call	getch

		; Стираем курсор
		push	psw
		call	chooseDrive_draw
		pop	psw

		mvi	c, 1
		cpi	18h
		jz	loc_D690
		mvi	c, 7
		cpi	8
		jz	loc_D690
		mvi	c, 4
		cpi	1Ah
		jz	loc_D690
		cpi	19h
		jz	loc_D690
		cpi	0Dh
		jz	loc_D688
		cpi	1Bh
		jz	loc_D681

		; Выбор диска нажатием на A-H
		sui	41h
		cpi	8
		jnc	loc_D644
		mov	c, a

		; Восстанавливаем вид курсора
		pop	psw
		sta	v_cursorCfg
		mov	a, c
		ret

; ---------------------------------------------------------------------------

loc_D681:	; Восстанавливаем вид курсора
		pop	psw
		sta	v_cursorCfg

		; Ничего не выбрано
		mvi	a, 0FFh
		ret

; ---------------------------------------------------------------------------

loc_D688:	; Восстанавливаем вид курсора
		pop	psw
		sta	v_cursorCfg
		; Выбрали
		lda	v_chooseDrive
		ret

; ---------------------------------------------------------------------------

loc_D690:	lda	v_chooseDrive
		add	c
		ani	7
		sta	v_chooseDrive
		jmp	loc_D644

; ---------------------------------------------------------------------------

chooseDrive_draw:
		; Выбранное устройство
		lda	v_chooseDrive

		; Координаты курсора
		lxi	h, 976Ch

		; Вторая строка
		cpi	4
		jc	chooseDrive_draw2
		 sui	4
		 mov	c, a
		 mov	a, l
		 adi	0Bh
		 mov	l, a
		 mov	a, c
chooseDrive_draw2:	
                ; Рисуем
		mov	c, a
		add	a
		add	c
		add	h
		mov	h, a
		call	activePanelPos
		mvi	b, 1		; ширина 8 пикселей
		jmp	inverseRect	; hl - адрес
		