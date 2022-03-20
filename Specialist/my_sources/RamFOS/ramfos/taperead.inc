;----------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа C806
; Чтение байта с лента
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

tapeRead:	push	h
		push	d
		push	b

		; Промежуточный адрес возврата
		lxi	h, popa_ret
		push	h

		lhld	v_tape
		xchg
		lxi	h, 0FFE1h

		mvi	b, 8
tapeRead_0:	 call	tapeWaitC3
		 mov	a, c
		 cmp	d
		 jc	tapeRead_0
		 call	tapeWaitC3
		 mov	a, c
		 cmp	d
		jc	tapeRead_0

tapeRead_1:	 call	tapeWaitC3
		 lda	v_tape+1
		 cmp	c
		 cmc
		 mov	a, d
		 rar
		 mov	d, a
		 call	tapeWaitC3
		 dcr	b
		jnz	tapeRead_1

		call	tapeWaitC3
		mov	a, e
		xri	1
		sta	v_tape
		lda	v_tape+1
		cmp	c
		cmc
		ral
		mov	c, a
		mov	a, d
		ora	a
		push	psw
		pop	d
		mov	a, e
		rar
		rar
		xra	c
		rar
		mov	a, d
		rnc

tapeError:	mvi	a, 3Fh
		stc
		ret
