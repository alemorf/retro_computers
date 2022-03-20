;+---------------------------------------------------------------------------
; RAMFOS
; Установить активную страницу
;
; На входе
;  b - диск
;
; На выходе
;  v_pageStart = v_curFile = f_nextFile = начало страницы, заголовок первого файла
;  hl - начало страницы
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileSetPage:	; Начало RAM-диска
		lhld	v_aramPageStart

		; Диск
		mov	a, b
		sta	v_page

		; У ROM-диска другое начало
		; Обновляем надпись RAM/ROM в заголовке файловой панели
		ora	a
		mvi	a, 'A'
		jp	fileSetPage_1
		 mvi	a, 'O'
		 ; Начало ROM-диска
		 lxi	h, ROM_PAGE_START
fileSetPage_1:	sta	a_panelOA

                ; Параметры диска
		shld	v_pageStart
		shld	v_curFile
		shld	f_nextFile
		ret		