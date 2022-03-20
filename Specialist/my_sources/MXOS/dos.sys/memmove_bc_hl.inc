;+---------------------------------------------------------------------------
; MXOS
; Копирование накладывающихся блоков памяти (с ошибкой)
;
; На входе
;  hl - откуда
;  de - откуда, конечный адрес не включая
;  bc - куда BC с увеличением адресов
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

memmove_bc_hl:	; Сохраняем регистры
		push	h
		push	b
		push	d

		; Если b<h или c<l, то
		mov	a, b
		cmp	h
		jc	memcpy_bc_hl2
		; Тут не хватает jnz
		mov	a, c
		cmp	l
		jc	memcpy_bc_hl2

		; bc = bc + de - hl
		push	h		
		call	sbb_de_hl_to_hl
		dad	b
		mov	b, h
		mov	c, l
		pop	h

memcpyb_bc_de:	; Копируем из DE в BC с уменьшением адресов, пока HL не равно DE
		ldax	d
		stax	b
		call	cmp_hl_de_2
		dcx	d
		dcx	b
		jnz	memcpyb_bc_de

		; Восстановление регистров и выход
		jmp	pop_dbh_ret2

; ---------------------------------------------------------------------------

memcpy_bc_hl2:	; Копируем из HL в BC с увеличением адресов, пока HL не равно DE
		mov	a, m
		stax	b
		call	cmp_hl_de_2
		inx	h
		inx	b
		jnz	memcpy_bc_hl2

pop_dbh_ret2:	; Восстановление регистров и выход
		pop	d
		pop	b
		pop	h
		ret