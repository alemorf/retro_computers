;+---------------------------------------------------------------------------
; RAMFOS
; Вывод идникаторов в верхнюю строку
; Эта функция вызывается только из printIndicators и clearTopLine
;
; 2013-11-01 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

#if FAST_PRINT
INDCATORS_SEP = ' '
#else
INDCATORS_SEP = 11h
#endif

printIndicatorsInt:	
		; Если дата хранится в ОЗУ, проверяется, введена ли дата
#if DATE_IN_RAM
		lda	v_header2_saved
		cpi	8Bh
		cnz	inputDate
#endif
		; Установка положения курсора (0 стока 45 столбец)
		lxi	h, 8708h	
		shld	v_cursorPos

		; Если дата хранится в ДОЗУ, проверяется, введена ли дата
#if DATE_IN_RAM==0
		; Читаем из нулевой страницы байт по адресу v_aramPageEnd+1
		lhld	v_aramPageEnd
		inx	h
		xra	a
		call	j_pageReadAny
		
		; Если там записан не 8B, то переходим к вводу даты
		mov	a, c
		cpi	8Bh
		push	h		
		jnz	inputDate
#endif

		; Разделитель
		mvi	a, INDCATORS_SEP
		call	printCharA

		; Выводим скорость записи на ленту
		lda	v_tapeMode
		call	printCharA

		; Выводим режим эхопечати
		lda	v_printerEcho
		call	printCharA

		; Выводим CAPS LOCK
		lhld	v_rusLat
		dcr	h
		mvi	a, 0Bh
		jm	loc_C9D5
		 mvi	a, 0Fh		 
loc_C9D5:	call	printCharA

		; Выводим РУС/LAT
		inr	l
		lxi	h, a_lat
		jnz	loc_C9E2
		  lxi	h, a_rus
loc_C9E2:	call	printString

		; Выводим KOI8/7
		lda	v_koi8
		ora	a
		mvi	a, '8'
		jz	loc_C9EF
		  dcr	a		  
loc_C9EF:	call	printCharA

#if FAST_PRINT
		mvi	a, ' '
		call	printCharA
#else
		call	printChar6
#endif

#if DATE_IN_RAM
		; Разделитель
		mvi	a, INDCATORS_SEP
		call	printCharA

		; Вывод на экран даты
		lda v_header2_date
		call	printHex

#if NICE
		mvi	a, '-'
		call	printCharA
#endif
		; Вывод на экран даты
		lda	v_header2_date+1
		call	printHex
#if NICE
		mvi	a, '-'
		call	printCharA
#endif
		; Вывод на экран даты
		lda v_header2_date+2
		call	printHex
#else
		pop	h

		; Адрес для сохранения даты
		lxi	d, v_header2_saved

		; Сохраняем C в v_header2_saved <--- ????
		mov	a, c
		stax	d

		; Разделитель
		mvi	a, INDCATORS_SEP
		call	printCharA

		; Вывод на экран даты
		mvi	b, 3		; 3 байта
loc_CA02:	 inx	h
		 inx	d
		 ; Читаем байт из нулевой страницы
		 xra	a
		 call	j_pageReadAny
		 ; Запись в памяти
		 mov	a, c
		 stax	d
		 ; Вывод на экран
		 call	printHex
		 ; Цикл 3-1
		 dcr	b
		jnz	loc_CA02
#endif

#if FAST_PRINT
		ret
#else
		jmp	printChar6
#endif

;----------------------------------------------------------------------------
; RAMFOS
; Лишний код
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_PRINT_STATUS_BUG==0
printIndicatorsEnd:
		pop	psw
		cnz	changeInverse
#endif

;----------------------------------------------------------------------------
; RAMFOS
; Очистка верхней строки и перемещение туда курсора
; Вызывается при печати символа 08Fh
;
; 2013-11-01 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

clearTopLine:	
#if COLOR_SUPPORT
		; Цвет по умолчанию
		mvi	a, INIT_SCREEN_COLOR
		call	setColor
#endif

		; Реальная очистка верхней строки
		call	clearTopLine2

		; Устанавливаем курсор в верхнюю строку
		lxi	h, 8
		shld	v_cursorPos

		; ?
		lxi	h, 140Ah
		shld	v_topLineHeight

;----------------------------------------------------------------------------
; RAMFOS
; Вывод идникаторов в верхнюю строку с сохранением курсора, цвета и инверсии
; Эта функция вызывается только из keyScan
;
; 2013-11-01 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

printIndicators:
		; Не рисовать индикаторы
		lda	v_topLineHeight
		ora	a
		rz

		; Запоминаем положение курсора
		lhld	v_cursorPos

		; Запоминаем инверсию в стеке
		lda	v_inverse
		ora	a
		push	psw
#if FAST_PRINT
		; Если инверсия не была включена, включаем её.
		cz	changeInverse
#else
		; Если инверсия была включена, выключаем её.
		cnz	changeInverse
#endif	

		; Сохранение цвета и установка стандартного цвета
#if COLOR_SUPPORT
		lda	v_color
		push	psw
		mvi	a, 0F0h
		call	setColor
#endif

		; Вывод статусной строки
		push	h
		 call	printIndicatorsInt
		pop	h

		; Восстановление цвета
#if COLOR_SUPPORT
		pop	psw
		call	setColor
#endif
	
		;  Восстановление положения курсора
		shld	v_cursorPos
		 
#if NO_PRINT_STATUS_BUG==0
		jnz	printIndicatorsEnd
#endif

		;  Восстановление инверсии
		pop	psw
#if FAST_PRINT
		rnz
#else
		rz
#endif	
		; продолжается в changeInverse