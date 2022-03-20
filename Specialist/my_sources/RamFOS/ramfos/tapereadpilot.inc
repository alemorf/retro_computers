;----------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа C824
; Чтение пилот тона с ленты
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

tapeReadPilot:	push	h
		push	d
		push	b

		; Промежуточный адрес возврата
		lxi	h, popa_ret
		push	h

		; Порт магнитофона
		lxi	h, IO_KEYB_B

		mvi	e, 1		
loc_C678:	 mvi	d, 0
loc_C67A:	 mov	b, c
		 call	tapeWaitC3
		 mov	a, c
		 sub	b
		 jnc	loc_C684
		  cma
loc_C684:	 cpi	3
		jnc	loc_C678
		dcr	d
		jnz	loc_C67A

		call	tapeWaitC3

		; Повторить D раз
		lxi	b, 100h		
loc_C693:	 call	tapeWait
		 inx	b
		 inx	b
		 dcr	d
		jnz	loc_C693

		mov	l, c
		mov	h, b
		ora	a

		; bc >>= 1
		mov	a, b
		rar
		mov	b, a
		mov	a, c
		rar
		mov	c, a

		dad	b
		mov	l, e
		shld	v_tape
		ret
