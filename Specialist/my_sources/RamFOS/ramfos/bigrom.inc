;+---------------------------------------------------------------------------
; RAMFOS
; Чтение ПЗУ Специалиста MX
;
; 2013-11-01 Разработано vinxru
;----------------------------------------------------------------------------

#if BIG_ROM
bigRom:		push	psw

		; Если в HL было число < 8000h, то переходим к чтению ПЗУ MX
		mov	a, h
		xri	80h
		jm	bigRom_0

		; Сохраняем HL и вычитаем из него 8000h
		push	h
		 mov	h, a		 
		 ; Первые 4 байта в ПЗУ СТД это программа инициаизации
		 inx	h
		 inx	h
		 inx	h
		 inx	h
		 ; Включаем ПЗУ СТД
		 sta	IO_PAGE_STD
		 xra	a
		 sta	IO_COLOR-800h
		 ; Чтение байта
		 mov	c, m
		 ; Включение ОЗУ MX и восстановление цвета
		 sta	IO_PAGE_RAM-800h
		 lda	v_color
		 sta	IO_COLOR
		pop	h
		; Восстанавливаем в A значение
		pop	psw
		ret
		
bigRom_0:	; Включение ПЗУ MX
		sta	IO_PAGE_ROM
		; Чтение байта
		mov	c, m
		; Включение ОЗУ MX
		sta	IO_PAGE_RAM
		; Восстанавливаем в A значение
		pop	psw
		ret      
#endif