;----------------------------------------------------------------------------
; RAMFOS
; Очистить экран
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

clearScreen:	
#if COLOR_SUPPORT
		; Цвет по умолчанию
		mvi	a, INIT_SCREEN_COLOR
		call	setColor
#endif
clearScreen2:
		; Сохраняем SP
		lxi	h, 0
		dad	sp
		shld	v_oldSP

		; Колонки
		mvi	b, 48

		; Байт для заливки экрана
		lda	v_inverse
		mov	d, a
		mov	e, a

		; Заливаем экран. Начинаем с 383,240.
		lxi	h, 0BFF0h
loc_CE1B:	 sphl
		 mvi	c, 17h		; 230 строк
loc_CE1E:	  push	d
		  push	d
		  push	d
		  push	d
		  push	d
		  dcr	c
		 jnz	loc_CE1E
		dcr	h
		dcr	b
		jnz	loc_CE1B

		; Восстаналиваем SP
		lhld	v_oldSP
		sphl

		; Дальше магия с переменными и строками состояния

		; При печати двойного символа 1F скрываем нижнюю строку
		lxi	h, v_dblClear
		mvi	a, 1Fh
		cmp	m
		cz	bottomLineHide	; Если вызвана, то на выходе A=0		
		sta	v_dblClear

		lda	v_topLineHeight
		ora	a
		cz	clearTopLine2

		lda	v_screenHeight
		cpi	250
		cz	sub_CE57

loc_CE4B:	; cursorX = 0
		mvi	h, 0

		; cursorY = byte_D231 - 2
		lda	v_topLineHeight+1
		dcr	a
		dcr	a
		mov	l, a
		
saveCursorPos:	; Сохранить положение курсора
		shld	v_cursorPos
		ret

; ---------------------------------------------------------------------------

sub_CE57:	lxi	d, 10h
		jmp	clearLine	; d - строка, e	- высота

; ---------------------------------------------------------------------------
