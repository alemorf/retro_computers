;----------------------------------------------------------------------------
; RAMFOS
; Сдвиг экрана вверх
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

scrollUp:	push	h
		mov	a, l		; c =  (l + 2 -	word_D231)/2

		lhld	v_topLineHeight
		mov	e, h		; e = word_D231
		inr	a
		inr	a
c_scrolUpEx:	sub	e
		rar
		mov	c, a
		; Адрес видео
		mvi	h, 90h
		mov	d, h
		; Колонки		
		mvi	b, 48
loc_CD5A:	 push	h
		 push	d
		 push	b
		  ; Копируем C байт
		  inr	c
		  dcr	c
		  cnz	memcpy_hl_de_c2
		  ; Очищаем последние 10 байт
		  lda	v_inverse
		  mvi	c, 10
loc_CD67:	   mov	m, a
		   inr	l
		   dcr	c
		  jnz	loc_CD67
		 pop	b
		 pop	d
		 pop	h
		 ; Следующая колонка
		 inr	h
		 inr	d
		 dcr	b
		jnz	loc_CD5A
		pop	h
		; Установка положения курсора	
saveCursorPosX0:mvi	h, 0
		jmp	saveCursorPos
