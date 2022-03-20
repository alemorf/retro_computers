;----------------------------------------------------------------------------
; RAMFOS
; Получить код символа на экране
;
; 2013-11-01 vinxru
;----------------------------------------------------------------------------                   

getCharFromScreen:
		push	h
		push	d
		push	b

		; Адрес возврата
		lxi	h, popa_ret
		push	h

		; Положение курсора в пикселях
		lhld	v_cursorPos	

		; Расчет адреса
		xchg
		call	calcCharAddr
		xchg
		
		; с - смещение в битах
		; hl - адрес с видеопамяти

		mvi	b, 8 ; Высота символа
		lxi	d, unk_D21A ; Сюда будет скопирован символ с экрана
		push	d		
loc_CAF9:	 push	h
		  ; Загрузить в HL из памяти по адресу HL
		  mov	a, m		
		  inr	h
		  mov	l, m
		  mov	h, a
		  ; Сдвигаем HL на c*2 бит
		  mov	a, c
loc_CAFF:	   push	psw
		    call	hl_div_2
		    call	hl_div_2
		   pop 	psw
		   dcr	a
		  jnz	loc_CAFF
		  ; Сохраняем только нижние 6 бит по адресу de
		  mov	a, l
		  ani	3Fh
		  stax	d
		  dcx	d
		 pop	h
		 dcr	l
		 dcr	b
		jnz	loc_CAF9

		; Если v_inverse не ноль
		lda	v_inverse
		ora	a
		jz	loc_CB29
		 ; Инвертируем байт по адресу de
		 mvi	b, 8
loc_CB1F:	  ; de++
		  inx	d
		  ; *de = (*de ^ 0xFF) & 0x3F;
		  ldax	d
		  cma
		  ani	3Fh
		  stax	d
		  ; Цикл
		  dcr	b
		 jnz	loc_CB1F
loc_CB29:	pop	d

		; de - адрес на экране

		; Сравниваем каждый символ из знакогенератора с экраном

		mvi	a, -1
		lhld	v_charGenPtr	; Знакогенератор
		lxi	b, 8		; высота символа
loc_CB32:	 ; Следующий символ
		 dad	b		
		 push	b
		 push	d
		 push	h
		  mov	b, a
		  call	compareChar
		  mov	a, b
		 pop	h
		 pop	d
		 pop	b
		jnz	loc_CB32

		; Знакогенератор не содержит символов 80-BF
		cpi	80h
		rc
		adi	40h		
		ret

; ---------------------------------------------------------------------------

compareChar:	; if(a == 0xBF) return true;
		cpi	0BFh
		rz
		; Увеличивае номер символа
		inr	b
		; Далее memcmp_hl1_de_c
