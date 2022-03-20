;----------------------------------------------------------------------------
; MXOS NC.COM
; Убрать их имени пробелы
;
; hl - откуда
; de - куда
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

compactName:	; Сохраняем регистры
		push	h
		push	b

		; Копируем до пробела, но не более 6 букв
		lxi	b, 6		
compactName_1:	mov	a, m
		cpi	' '
		jz	compactName_2		
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	compactName_1

compactName_2:	; Пропущенные символы исходной строки
		dad	b

		; Точка
		mvi	a, '.'
		stax	d
		inx	d

		; Копируем 3 буквы
		mvi	c, 3
compactName_3:	mov	a, m
		cpi	' '
		jz	compactName_4
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	compactName_3

compactName_4:	xchg
		push	psw

		; Если последний символ '.', то удаляем его
		dcx	h
		mov	a, m
		cpi	'.'
		jz	compactName_5
		inx	h
compactName_5:	

		; Добавляем пробел и конец строки
		mvi	m, ' '
		inx	h
		mvi	m, 0Dh
		inx	h
		mvi	m, 0

		; Результат в DE
		xchg

		; Восстаналиваем регистры и выходим
		pop	psw
		pop	b
		pop	h
		ret