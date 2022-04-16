;+---------------------------------------------------------------------------
; MXOS
; Драйвер внешнего ПЗУ
;
; Все регистры сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

IO_PAGE_RAM	= 0FFFCh
IO_PAGE_STD	= 0FFFFh

start:		; Режим стандартного Специалиста	

		lxi	h, driver
		lxi	d, 0EF00h 
copy:		mov	a, m
		inx	h
		stax	d
		inx	d
		mvi	a, 0E0h
		cmp	e
		jnz	copy

		lxi	h, data
		lxi	d, 0
		jmp	0EF00h

		; Копирование
driver:		mov	a, m
		inx	h
		sta	IO_PAGE_RAM-800h
		stax	d
		inx	d
		mvi	a, 80h
		cmp	h
		jz	0
		sta	IO_PAGE_STD
		jmp	0EF00h 

data:

.end