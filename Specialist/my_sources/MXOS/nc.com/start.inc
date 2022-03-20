;----------------------------------------------------------------------------
; MXOS NC.COM
; Запуск
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

Start:		; Отключаем инверсию
		lxi	h, 0
		shld	v_inverse

		; *** Однократно вызываем FORMAT ***

		; Устанавливаем свой драйвер
		call	swapDriver
		lxi	h, 0FF00h

		; Если в памяти есть специальная метка, значит уже запускали
		call	0FFC0h
		cpi	5Ah
		jz	formatCalled

		; Восстанавливаем драйвер
		call	swapDriver

		; Сохраняем состояние
		call	saveState

		; Запуск A:FORMAT.COM B:
		lxi	h, aFormatB
		jmp	fileExec

; ---------------------------------------------------------------------------

formatCalled:	; Копируем состояние из ДОЗУ в ОЗУ
		inx	h
		lxi	d, activePanel
		mvi	c, 9
loc_D026:	 call	0FFC0h
		 stax	d
		 inx	h
		 inx	d
		 dcr	c
		jnz	loc_D026

		; Восстанавливаем драйвер
		call	swapDriver
		mvi	c, 1Fh		; Очистка экрана

		; Вывод	подсказки
		COLOR(COLOR_HELP_F)
		call	printChar
		lxi	h, 1FFh
		shld	v_cursorY
		lxi	h, aF1LeftF2RighF3		
		call	printString

		; Раскрашиваем подсказку
		COLOR(COLOR_HELP_TEXT)
		lxi	h, 92F7h
		mvi	d, 8		
loc_D049:	 mvi	b, 4
		 call	inverseRect	; hl - адрес, b	- ширина, высота 9
		 inr	h
		 inr	h
		 dcr	d
		jnz	loc_D049

		; Очищаем ком строку
		call	clearCmdLine