;+---------------------------------------------------------------------------
; MXOS
; Рисование курсора на экране (продолжение)
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

drawCursor_1:	; Цикл
		dcr	a
		jnz	drawCursor_0

		; b = v_cursorCfg & 0xF
		mov	a, b
		ani	0Fh
		mov	b, a

		; Вывод курсора (b - высота, de - адрес на экране, hl - курсор)

drawCursor_2:	; Повторить код ниже B раз
		dcr	b
		jm	popa_ret_2

		; *de--	^= hl;
		ldax	d
		xra	h
		stax	d
		inr	d
		ldax	d
		xra	l
		stax	d
		dcr	d
		dcr	e
		jmp	drawCursor_2		