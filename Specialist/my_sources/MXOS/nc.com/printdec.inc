;----------------------------------------------------------------------------
; MXOS NC.COM
; Вывод десятичного числа из HL
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printDec:	push	d
		push	b
		push	h
		xchg
		mvi	b, 20h
		lxi	d, -10000
		call	printDec1
		lxi	d, -1000
		call	printDec1
		lxi	d, -100
		call	printDec1
		lxi	d, -10
		call	printDec1
		mov	a, l
		adi	'0'
		mov	c, a
		call	printChar
		pop	h
		pop	b
		pop	d
		ret

; ---------------------------------------------------------------------------


printDec1:	; c = '0' + (hl / de), hl /= de;
		mvi	c, '0'-1

loc_DB11:	inr	c
		dad	d
		jc	loc_DB11

		mov	a, d		; hl -=	de;
		cma
		mov	d, a
		mov	a, e
		cma
		mov	e, a
		inx	d
		dad	d
		mov	a, c

		; if(c!='0') b=0xFF; c&=b;		
		cpi	'0'
		jz	loc_DB26
		mvi	b, 0FFh		
loc_DB26:	ana	b
		mov	c, a

		jmp	printChar
