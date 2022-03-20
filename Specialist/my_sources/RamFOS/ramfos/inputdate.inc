;+---------------------------------------------------------------------------
; RAMFOS
; Ввод текущей даты
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

inputDate:	; Вывод приглашения "V3.1/дата:" или "дата:"
		lxi	h, a_inputDate
		call	printString
	
		; Ввод даты
		lxi	h, buffer
		lxi	d, 9FFh ; Максимум 9 символов
		call	input

		; Если была ошибка
		jnc	inputDate
		mov	m, a

		; Преобразование введенной строки и числа
		cm	parseDate

		; Если преобразование не удалось вводим повторно
		jz	inputDate

#if DATE_IN_RAM
		; Сохраняем признак того, что дата введена
		mvi	a, 8Bh 
		sta	v_header2_saved

		ret
#else
		; Извлекаем из стека адрес на диске
		pop	h

		; Сохраняем 08Bh
		mvi	c, 8Bh 
		call	inputDate_1
		
		; Сохраняем день на диск
parseDate_r1:	mvi	c, 22h
		call	inputDate_1

		; Сохраняем месяц на диск
parseDate_r2:	mvi	c, 09h
		call	inputDate_1

		; Сохраняем год на диск
parseDate_r3:	mvi	c, 92h
inputDate_1:	xra	a
		call	j_pageWriteAny
		inx	h
		inr	a
		ret
#endif

#if NICE
#define A_INPUTDATE a_inputDate: .db 0Dh, 0C4h, 0C1h, 0D4h, 0C1h, ':', 0 ; "дата:"
#else
#define A_INPUTDATE a_inputDate: .db 0Dh, 'V', '3', '.', '1', '/', 0C4h, 0C1h, 0D4h, 0C1h, ':', 0 ; "V3.1/дата:"
#endif