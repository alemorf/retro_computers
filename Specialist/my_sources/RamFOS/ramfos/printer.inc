;+---------------------------------------------------------------------------
; RAMFOS
; Печать на принтере
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_PRINTER==0

printerXlat:	; c = v_printerXlat[c % 64];
		mov	a, c		
		ani	63
		lxi	h, v_printerXlat
		mov	c, a
		mvi	b, 0
		dad	b
		mov	c, m

printer:	push	psw

		; Режим КР580ВВ55
		mvi	a, 90h
		sta	IO_EXT_MODE

		; Инвертируем и записываем данные
		mov	a, c
		cma
		sta	IO_EXT_B

printer_0:	 ; Пользователь может прервать ожидание
		 lda	IO_KEYB_B		
		 ani	2
		 jz	printer_break

		 ; Ждем пока 6-ой бит не нулевой
		 lda	IO_EXT_A
		 ani	40h
		jnz	printer_0

		; Строб
		mvi	a, 3
		sta	IO_EXT_C

		; Пауза
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		; Строб
		xra	a
		sta	IO_EXT_C

printer_break:	pop	psw
		ret

		.db    0
#else

printer:
printerHex:
printerEchoMode: 
doPrinterEcho:
		ret
#endif