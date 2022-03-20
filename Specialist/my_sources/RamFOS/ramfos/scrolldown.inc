;----------------------------------------------------------------------------
; RAMFOS
; Сдвиг экрана вниз
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

scrollDownX0:	; x = 0
		mvi	h, 0	; Влияет на расчет C, смотри ниже

scrollDown:	push	h
		; c = cursorY - 8
		mov	a, l
		sui	8
		; if(v_cursorX != 0) c += 10
		dcr	h
		inr	h
		jz	scrollDown_0
		  adi	10		  
scrollDown_0:	mov	c, a

		; l = v_screenHeight, e = h = v_screenHeight-10
		lhld	v_screenHeight
		mov	e, h

		; if(v_screenHeight < c) goto CDF9
		mov	a, e
		sub	c
		jc	scrollDown_1

		; с = (v_screenHeight - c) / 2
		rar
		mov	c, a

		; Адрес на экране. Для DE, HL идентичный, поскольку будет отличаться E, L
		mvi	h, 90h
		mov	d, h

		; 48 столбцов
		mvi	b, 48
scrollDown_2:	 push	h
		 push	d
		 push	b
		  ; Копируем C линий
		  inr	c
		  dcr	c
		  cnz	memcpyb_hl_de_c2
		  ; Верхние 10 линий очищаем
		  lda	v_inverse
		  mvi	c, 10		
scrollDown_3:	   dcr	l
		   mov	m, a
		   dcr	c
		  jnz	scrollDown_3
		 pop	b
		 pop	d
		 pop	h
		 ; Следующий столбец
		 inr	h
		 inr	d
		 dcr	b
		jnz	scrollDown_2

scrollDown_1:	; Восстанавливам L, он же cursorY
		; cursorX, он же H будет заменен 0 в функции saveCursorPosX0
		pop	h
		jmp	saveCursorPosX0
