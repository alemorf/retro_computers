;----------------------------------------------------------------------------
; MXOS NC.COM
; Загрузить файлы и нарисовать
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

loadAndPrintB:	; Времено меняем активную панель на правую
		lda	activePanel
		push	psw
		mvi	a, 1
		sta	activePanel

		; Переходим к общему коду
		lda	panelB_info
		jmp	loadAndPrint

; ---------------------------------------------------------------------------

loadAndPrintA:	; Времено меняем активную панель на левую
		lda	activePanel
		push	psw
		mvi	a, 0
		sta	activePanel

		; Панель видима?
		lda	panelA_info
loadAndPrint:	ana	a
		jnz	loadAndPrint_2

		; Загружаем список файлов
		lxi	h, panelA_drive
		call	readBytePanel
		call	loadFiles	; На входе a должен содержать номер накопителя

		; Выводим список файлов
		call	printFilePanel

		jmp	loadAndPrint_3

; ---------------------------------------------------------------------------

loadAndPrint_2:	; Рисуем панельинформации
		call	printInfoPanel

loadAndPrint_3:	; Восстанавливаем активную панель
		pop	psw
		sta	activePanel

		; Загружаем список файлов
		lxi	h, panelA_drive
		call	readBytePanel
		call	loadFiles	; На входе a должен содержать номер накопителя
		ret

