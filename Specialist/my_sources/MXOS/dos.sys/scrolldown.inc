;+---------------------------------------------------------------------------
; MXOS
; Прокрутка экрана вниз
;
; На выходе
;   af, bc - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

		; Сохраняем регистры
		push	b
		push	psw
		lxi	h, 0
		dad	sp
		shld	v_oldSP

		; Подготовка переменных
		lxi	sp, 0C000h ; Куда
		mvi	h, 0BFh	   ; Откуда
		mvi	b, 48      ; Столбцов
loc_C741:	mvi	c, 246 / 6 ; 246 строк
		mvi	l, 245	   ; Начинаем с 245 строки

loc_C745:	; Копируем 6 байт из HL в SP
		mov	d, m
		dcx	h
		mov	e, m
		dcx	h
		push	d		
		mov	d, m
		dcx	h
		mov	e, m
		dcx	h
		push	d
		mov	d, m
		dcx	h
		mov	e, m
		dcx	h
		push	d

		; Цикл
		dcr	c
		jnz	loc_C745

		; Сохраняем H
		mov	a, h
		
		; Очищаем верхние 10 строк
		lhld	v_inverse
		push	h
		push	h
		push	h
		push	h
		push	h

		; Восстанавливаем H
		mov	h, a

		; Следующий столбец
		dcr	b
		jnz	loc_C741

		; Восстанавлиаем регистры и выходим
		lhld	v_oldSP
		sphl
		pop	psw
		pop	b
		ret