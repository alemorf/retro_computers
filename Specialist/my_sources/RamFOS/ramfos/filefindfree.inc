;+---------------------------------------------------------------------------
; RAMFOS
; Расчет контрольной суммы сохраняемого файла, поиск страницы
; с подходящим cвободным объемом, удаление файла с именем v_header2_name
;
; На входе
;  v_header2_name  - Имя файла для удаления
;  f_header2_start - Адрес начала файла
;  f_header2_stop  - Адрес конца файла
;
; На выходе
;  jnc             - Страница найдена
;  f_header2_crc   - Контрольная сумма
;  v_page, b       - Страница
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileFindFree:	; Расчитываем контрольную сумму в v_header2_crc
		shld	v_header2_start	
		xchg
		shld	v_header2_end		
		xchg
		call	j_calcCrc
		mov	h, b
		mov	l, c
		shld	v_header2_crc

		; Поиск по всем страницам и удаление файла
		mvi	b, 20h
		call	fileFindEx

		; Поиск файла начиная с нулевой страницы
		mvi	b, 20h
fileFindFree_0:	 ; Определяем свободное место на странице
		 call	fileFind1
		 
		 ; de = расчитываем требуемый размер файла, почему то в цикле.
		 call	fileGetStartAndSize2
		 lxi	d, FILE_HEADER_SIZE + 3
		 dad	d
		 xchg		

		 ; Выходим с флагом NC, если места достаточно
		 lhld	v_pageFreeTotal
		 cnc	j_cmp_hl_de
		 rnc		

		 ; Следующая страница
		 call	pageNext
		jnc	fileFindFree_0
		ret