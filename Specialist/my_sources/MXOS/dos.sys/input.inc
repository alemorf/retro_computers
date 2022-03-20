;+---------------------------------------------------------------------------
; MXOS
; Ввод строки
;
; На входе
;  hl - начало буфера
;  de - конец буфера
;
; На выходе
;  bc, de, hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

input:		; Сохраняем регистры
		push	h
		push	b
		push	psw

		; Сохраняем значения
		shld	v_input_start
		xchg
		shld	v_input_end

		; Помещаем в конец буфера 0
		mov	h, d
		mov	l, e
		mvi	m, 0

input_loop:	; Ждем клавиашу
		call	j_getch
		mov	c, a

		; Нажата служебная клавиша
		cpi	20h
		jc	input_spec

		; Нажата клавиша Back space
		cpi	7Fh
		jz	input_bkspc

		; ...
		nop
		nop
		nop

		; Это конец буфера
		push	h
		lhld	v_input_end
		call	cmp_hl_de_2
		pop	h
		jnz	loc_C8DE		
		call	cmp_hl_de_2
		jz	input_loop
		ldax	d
		dcx	d
		stax	d
loc_C8DE:	push	b
		mov	b, h
		mov	c, l
		inx	b
		call	memmove_bc_hl
		pop	b
		mov	m, c		; *hl++	= c;
		call	j_printChar	; Вывод	символа	на экран
		inx	h
		inx	d		
loc_C8EC:	push	h
		lhld	v_cursorY
		xthl
		push	h
		call	j_printString
		mvi	c, ' '
		call	j_printChar
		pop	h
		xthl
		shld	v_cursorY
		pop	h

		; Продолжение
		jmp	input_loop

; ---------------------------------------------------------------------------

input_bkspc:	; Если курсор в начале строки ничего не удаляем
		call	cmp_hl_de_2
		jz	input_loop

		; Сдвигаем строку
		mov	b, h
		mov	c, l
		inx	h
		call	memmove_bc_hl

		; Уменьшаем положение курсора
		dcx	h

		dcx	d
		jmp	loc_C8EC

; ---------------------------------------------------------------------------

input_spec:	; Нажато влево
		cpi	8
		jz	input_left

		; Нажато вправо
		cpi	18h
		jz	input_right

		; Нажат не ввод
		cpi	0Dh
		jnz	input_loop

		; Нажат ввод

		; Сохраняем в конец стрки 0D
		stax	d

		; Восстанавливаем регистры и выходим
		pop	psw
		pop	b
		pop	h
		ret

; ---------------------------------------------------------------------------

input_left:	; Если курсор в начале строки (hl==v_input_start) не перемещаем курсор
		xchg
		push	h		
		lhld	v_input_start
		call	cmp_hl_de_2
		pop	h
		xchg
		jz	input_loop

		; Уменьшаем положение курсора
		dcx	h

input_lr:	; Перемещаем курсор вправо/влево
		call	j_printChar

		; Продолжаем ввод
		jmp	input_loop

; ---------------------------------------------------------------------------

input_right:	; Если курсор в конце строк (hl==de) не перемещаем курсор
		call	cmp_hl_de_2
		jz	input_loop

		; Увеличиваем положение курсора
		inx	h

		; Общее продолжение
		jmp	input_lr