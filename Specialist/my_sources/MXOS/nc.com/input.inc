;----------------------------------------------------------------------------
; MXOS NC.COM
; Ввод строки
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

input:		; Вывод строки
		push	h
		lxi	h, v_input
		call	printStringInv
		pop	h

		; Включаем инверсию
		mvi	a, 1
		sta	v_inverse

input_loop:	; Ввод символа
		call	getch

		; Enter или ESC
		cpi	0Dh
		jz	input_exit
		cpi	1Bh
		jz	input_exit

		; Если служебная клавиша или пробел, то пропускаем
		cpi	21h
		jc	input_loop

		; Сохраняем для вывода
		mov	c, a

		; Помещаем символ в буфер
		stax	d

		; Удаление
		cpi	7Fh
		jz	input_bkspc

		; Если переполнение
		mvi	a, (v_input+23) & 0FFh
		cmp	e
		jz	input_loop

		; Вывод символа на экран		
		call	printChar

		; Увеличение длины строки
		inx	d

		jmp	input_loop

; ---------------------------------------------------------------------------

input_bkspc:	; Если это начало строки, выходим
		mvi	a, v_input & 0FFh
		cmp	e
		jz	input_loop

		; Уменьшаем длину строки
		dcr	e

		; Стираем символ с экрана
		push	h
		lxi	h, asc_DC17
		call	printString
		pop	h

		jmp	input_loop

; ---------------------------------------------------------------------------

input_exit:	; Сохраняем ESC или Enter для выхода 
		mov	c, a

		; Записываем в конец строки 0Dh, 0
		xchg
		mvi	m, 0Dh
		inx	h
		xra	a
		mov	m, a

		; Восстанавливаем инверсию
		sta	v_inverse

		; Выход		
		mov	a, c
		ret