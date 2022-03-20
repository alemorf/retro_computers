;----------------------------------------------------------------------------
; RAMFOS
; Расчет ареса символа в видеопамяти памяти и знакогенераторе
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

calcCharAddr2:	; Какая то хрень
		mov	b, c
calcCharAddr3:	sta	v_dblClear

		; hl = charGen + c * 8
		push	d
		 lhld	v_charGenPtr
		 xchg
		 mov	l, c
		 mvi	h, 0
		 dad	h
		 dad	h
		 dad	h
		 dad	d
		pop	d

; Получить адрес и смещение символа на экране по координатам
; Вход: de - координаты
; Выход: de - адрес, c - смещение
		
calcCharAddr:	; c = (d & 3)
		mov	a, d		
		ani	3
		mov	c, a
		mvi	a, 5
		sub	c
		mov	c, a
	
		; d = d / 4 + 0x90		
		mov	a, d		
		ani	0FCh
		rrc
		rrc
		adi	90h
		mov	d, a
		ret
