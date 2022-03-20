;+---------------------------------------------------------------------------
; RAMFOS
; Эхопечать на принтере
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_PRINTER==0

printerEcho_crLf:
		; В сумме код ниже заменяет 0A или 0D на пару 0A, 0D. 
		; Но в случае "0A любые символы 0D", послений не дублируется

		; Вместо 0A, то печатаем пару символов 0A, 0D.
		lxi	h, v_printerCrLf
		cpi	0Ah
		jz	printerEcho_0

		; Вместо 0D, то печатаем пару символов 0A, 0D, только если прошлый перенос был 0D.
		; Иначе выводим 0D как есть, без второго сивола.
		cpi	0Dh
		jnz	printerEcho_spc
		cmp	m

printerEcho_0:	mvi	c, 0Ah
		cz	printer
		mvi	c, 0Dh
		mov	m, a
		jmp	printer

; ---------------------------------------------------------------------------

loc_D0B1:	; Если символ >= 0x87
		cpi	87h ; 'З'
		jnc	printerEcho_1

printerEcho_spc:; Заменяем символ на пробел
		mvi	c, ' '

doPrinterEcho:	; Если это удаление, выходим
		mov	a, c
		cpi	8
		rz
		; Перевод курсора в начало экрана - выходим
		cpi	0Ch
		rz
		; Если <= 0x18
		cpi	18h
		jc	printerEcho_crLf
		; Если <= 0x1C выходим
		cpi	1Ch
		rc
		; Если очистка экрана - выходим
		cpi	1Fh
		rz
		; Остальные служебные коды заменяем на пробел
		jc	printerEcho_spc
		; Если <= 0x60, печатаем
		cpi	60h
		jc	printer
		; ?
		lhld	v_koi8
		cpi	7Fh
		jnc	 loc_D0B1 ;+
		inr	l
		jnz	printer
		ori	80h
		mov	c, a

printerEcho_1:  ; Если символ меньше 0xC0, выходим
		cpi	0C0h
		rc

		; Если v_tapeMode = '0', выводим символ без изменений
		lda	v_tapeMode
		sui	'0'
		jz	printer

		; Если v_tapeMode = '1', выводим с преобразованим
		dcr	a
		jnz	printerXlat

		; Иначе перед выводом каждого симовола выводим 27, 82, 1
		; Из документациии к принтерам Epson
		; Select International character set France
		lxi	h, 1B52h
		mvi	a, 1
		call	printerEsc

		; Вывод C на принтер
		call	printer		; Вывод	байта на принтер

		; Выводим 27, 82, 0
		; Select International character set USA
		xra	a

printerEsc:	push	b
		 mov	c, h
		 call	printer		; Вывод	байта на принтер
		 mov	c, l
		 call	printer		; Вывод	байта на принтер
		 mov	c, a
		 call	printer		; Вывод	байта на принтер
		pop	b
		ret

#endif