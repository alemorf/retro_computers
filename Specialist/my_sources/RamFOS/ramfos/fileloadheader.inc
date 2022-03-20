;----------------------------------------------------------------------------
; RAMFOS
; Загрузить заголовок файла
;
; На входе
;   v_page          - Номер текущей страницы
;   hl              - Адрес текущего файла в ДОЗУ
;
; На выходе, если файл найден
;   b               - Текущая страница ДОЗУ
;   v_curFile       - Адрес текущего файла в ДОЗУ
;   v_header        - Заголовок файла
;   f_fileBodySize  - Длина файла без заголовка - 1
;   f_fileSize      - Длина файла с заголовком
;   f_nextFile      - Адрес следующего файла в ДОЗУ
;
;   Если не включено в ДОЗУ по адресу v_curFile + f_fileSize 
;   записывается v_curFile
;
; На выходе, если файл не найден
;   v_pageFreePtr, v_curFile - Адрес первого свободного байта
;   v_pageFreeTotal      - Свободно байт
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileLoadHeader:	; Сохраняем смещение текущего файла в v_curFile
		shld	v_curFile

		; Читаем заголовок файла с диска в v_header
		lxi	d, v_header
		push	d
		 lxi	b, FILE_HEADER_SIZE-1
		 call	pageReadBlock
		pop	d

		; Помещаем в В текущую страницу
		lda	v_page
		mov	b, a

		; В начале файла должно быть D3,D3,D3
		lxi	h, a_defHeader
		call	memcmp_hl_de_3	; b не изменяет

		; Если маркер найден, то переходим к fileLoadHeader2
		jz	fileLoadHeader2

		; Не найден маркер начала файла!

		; Восстаналиваем заголовок в памяти
		lxi	h, a_defHeader
		lxi	d, v_header
		call	memcpy_de_hl_15

		; Устаналиваем конец страницы
		lhld	f_nextFile	
		shld	v_pageFreePtr
		xchg

		; Получаем в HL размер страницы
		lhld	v_aramPageEnd
		lda	a_panelOA
		cpi	'O'
		jnz	fileLoadHeader_0
		 lxi	h, ROM_PAGE_END
fileLoadHeader_0:	
                ; Рассчитываем свободное место на диске
		call	sub_hl_de
		shld	v_pageFreeTotal

		; ?
		dcr	c
		ret