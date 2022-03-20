;+---------------------------------------------------------------------------
; MXOS
; Драйвер диска в ДОЗУ, ПЗУ. Вызывается при смене диска.
;
; 2013-12-12 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

		; Cохраняем A в E
		mov	e, a

		; Корректируем стандартный драйвер.
		; Если это диск 0 - то работаем с ПЗУ, иначе с ДОЗУ.
		ana	a
		mvi	a, IO_ROM & 0FFh	; STA IO_ROM
		mvi	l, 0C9h			; RET

		jz	disableRom_2
#if BIG_MEM
		 mvi	l, 46h			; MOV B, M
#else
		 mvi	l, 7Eh			; MOV A, M
#endif
		 mvi	a, IO_ARAM & 0FFh	; STA IO_ARAM
disableRom_2:	sta	0FFC0h + (driverR - driverStart) + 1
		mov	a, l
		sta	0FFC0h + (driverW - driverStart)

		; Восстанавливаем A из E
		mov	a, e