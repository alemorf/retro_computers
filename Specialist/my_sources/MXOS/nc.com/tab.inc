;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша TAB - Смена активной панели
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

Tab:		; Получаем видимость панели
		lxi	h, panelA_info
		lda	activePanel
		ana	a
		jnz	loc_D6C7
		inx	h
loc_D6C7:	mov	c, a
		mov	a, m

		; Панель не видима, выходим
		ana	a
		jnz	mainDriveChanged

		; Меняем активную панель на противоположную
		mov	a, c
		xri	1                   	
		sta	activePanel

		; Перезагружаем списк файлов
		lxi	h, panelA_drive
		call	readBytePanel
		call	loadFiles	; На входе нужен a=накопитель

		jmp	loc_D603