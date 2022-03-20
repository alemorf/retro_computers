;+---------------------------------------------------------------------------
; RAMFOS
; Включение/выключение эхопечати на принтер
; Вызывается при нажатии на соответствующую клавишу
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_PRINTER==0

printerEchoMode:lxi	h, v_printerEcho
		mvi	a, 0D2h
		cmp	m
		jnz	printerEchoMode_0
		 xra	a
printerEchoMode_0:
		mov	m, a
		jmp	specialKeysRet
#endif