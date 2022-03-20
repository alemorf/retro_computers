;+---------------------------------------------------------------------------
; MXOS
; Чтение байта с ленты
;
; На входе
;  a=255 загрузка первого байта 
;  a=8   загрузка
;
; На выходе
;  c - байт
;  de,hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

tapeRead:	; Сохраняем регистры
		push	b
		push	d

		; Тут будет принятый байт
		mvi	c, 0

		; d=8 если загрузка (счетчик бит) или 0FFh если ожидание
		mov	d, a

tapeRead_0:	; Получаем состояние
		lda	IO_KEYB_B
		ani	1
		mov	e, a

		; Сдвигаем C
		mov	a, c
		ani	7Fh
		rlc
		mov	c, a

tapeRead_1:	; Получаем состояние
		lda	IO_KEYB_B

		; Если нажата клавиша, выходим
		cpi	80h
		jc	tapeReadError

		; Ждем изменения сигнала
		ani	1
		cmp	e
		jz	tapeRead_1

		; Сохраняем бит
		ora	c
		mov	c, a

		; Задержка
		call	readDelay

		lda	IO_KEYB_B
		ani	1
		mov	e, a

		; Если происходит загрузка данных, переходим на tapeRead_4
		mov	a, d
		ora	a
		jp	tapeRead_4

		; Если происходит ожидание
		; Если не найден 0E6h, переходим tapeRead_2
		mov	a, c		
		cpi	0E6h
		jnz	tapeRead_2

		; Начинаем загрузку без инверсии
		xra	a
		sta	v_tapeInverse
		jmp	tapeRead_3

tapeRead_2:	; Если не найден 19h, переходим на tapeRead_0
		cpi	19h
		jnz	tapeRead_0

		; Начинаем загрузку с инверсией
		mvi	a, 0FFh
		sta	v_tapeInverse

		; Загружаем 8 бит
tapeRead_3:	mvi	d, 9

		; Повторяем 8 байт
tapeRead_4:	dcr	d
		jnz	tapeRead_0

		; Инверсия байта
		lda	v_tapeInverse
		xra	c

		; Восстаналиваем регистры
		pop	d
		pop	b
		ret
