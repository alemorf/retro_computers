;+---------------------------------------------------------------------------
; MXOS
; Прокрутка экрана вверх (продолжение)
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

scrollUp2:	; Копируем 246 байт из SP в H0 
		mvi	c, 246 / 6
		mvi	l, 0

scrollUp2_0:	; Копирование 6 байт из SP в HL
		pop	d
		mov	m, e
		inx	h
		mov	m, d
		inx	h
		pop	d
		mov	m, e
		inx	h
		mov	m, d
		inx	h
		pop	d
		mov	m, e
		inx	h
		mov	m, d
		inx	h

		; Цикл
		dcr	c
		jnz	scrollUp2_0

		; Сохраняем H
		mov	a, h
		
		; Заполняем 10 байт 
		lhld	v_inverse
		push	h
		push	h
		push	h
		push	h
		push	h

		; Следующий столбец (SP += 20)
		lxi	h, 14h
		dad	sp
		sphl

		; Восстанавливаем H
		mov	h, a

		; Следующий столбец
		inr	h

		; Цикл
		dcr	b
		jnz	scrollUp2

		; Восстановление регистров и выход
		lhld	v_oldSP
		sphl
		pop	psw
		pop	b
		ret