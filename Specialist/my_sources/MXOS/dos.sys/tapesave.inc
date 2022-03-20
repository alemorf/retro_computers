;+---------------------------------------------------------------------------
; MXOS
; Запись программы на ленту
;
; На входе
;  hl - начальный адрес
;  de - конечный адрес
;
; На выходе
;  bc - контрольная сумма
;  de,hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

tapeSave:	; Расчитываем CRC
		push	h
		call	calcCS
		pop	h

		push	h
		push	b

		; Пилот-тон (256 нулей)
		mvi	b, 0
loc_C9A4:	xra	a
		call	j_tapeWrite
		dcr	b
		jnz	loc_C9A4

		; Стартовый байт 0E6h
		mvi	a, 0E6h
		call	j_tapeWrite

		; Запись адреса первого байта
		call	tapeWriteWord
		xchg

		; Запись адреса последнего байта
		call	tapeWriteWord
		xchg
		
loc_C9B9:	; Запись блока памяти от HL до DE
		mov	a, m
		call	j_tapeWrite
		call	cmp_hl_de_2
		inx	h
		jnz	loc_C9B9

		; Запись CRC
		pop	h
		call	tapeWriteWord

		; Возвращаем CRC в регистре BC
		mov	b, h
		mov	c, l

		; Восстанавливаем регистры и выходим
		pop	h
		ret