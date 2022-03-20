;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша F3 - отобразить информацию о накопителе
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

F3:		; Временный выбор противоположной панели
		lda	activePanel
		push	psw
		xri	1
		sta	activePanel

		; Меняем видимость панели
		lxi	h, panelA_info
		call	readBytePanel
		xri	1
		call	writeBytePanel

		; Восстанавлаием активную панель
		pop	psw
		sta	activePanel
		ana	a
		jz	loc_D701

		; Перерисовываем панель
		call	loadAndPrintA

		jmp	loc_D603

; ---------------------------------------------------------------------------

loc_D701:	call	loadAndPrintB
		jmp	loc_D603		        