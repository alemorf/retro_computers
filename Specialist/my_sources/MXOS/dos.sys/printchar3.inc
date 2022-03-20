;+---------------------------------------------------------------------------
; MXOS
; Обработка служебных кодов при выводе символа
;
; На входе
;  a - символ
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printChar3:	; Код 7
		sui	7
		jz	beep
		; Код 8
		dcr	a
		jz	printChar_c08
		; Код 10
		sui	2
		jz	printChar_c0A
		; Код 12
		sui	2
		jz	printChar_c0C
		; Код 13
		dcr	a
		jz	printChar_c0D
		; Код 24
		sui	11
		jz	printChar_c18
		; Код 25
		dcr	a
		jz	printChar_c19
		; Код 26
		dcr	a
		jz	printChar_c1A
		; Продолжение, если код 31
		sui	5
		rnz
		; Код 31 очищает экран
		call	clearScreen

		; Продолжение в printChar_c0C

; ---------------------------------------------------------------------------
; Обработка кода 0Ch. Курсор в левый верхний угол экрана

printChar_c0C:	; v_cursorY = 8
		mvi	l, 8

		; Продолжение в printChar_c0D

; ---------------------------------------------------------------------------
; Обработка кода 0Dh. Курсор в начало строки

printChar_c0D:	; v_cursorX = 0
		xra	a
saveVCursorHA:	mov	h, a
saveVCursor:	shld	v_cursorY
		ret

; ---------------------------------------------------------------------------
; Обработка кода 8h. Влево

printChar_c08:	; cursorX -= 3
		mov	a, h
		sui	3

		; Если нет переноса, сохранить положение курсора и выйти
		jnc	saveVCursorHA

		; cursorX = 189
		mvi	h, 189
		shld	v_cursorY

		; Продолжение в printChar_c19

; ---------------------------------------------------------------------------
; Обработка кода 19h. Вверх

printChar_c19:	; Если cursorY<18, то выйти. Иначе cursorY -= 10
		mov	a, l
		sui	0Ah
		rc
		cpi	8
		rc

saveVCursorLA:	; Сохранить положение курсора и выйти
		mov	l, a
		jmp	saveVCursor

; ---------------------------------------------------------------------------
; Обработка кода 18h. Вправо

printChar_c18:	; Если cursorX+3 >= 192, то перейти на printChar_c0A
		; Иначе cursorX += 3
		mov	a, h
		adi	3
		cpi	0C0h
		jc	saveVCursorHA
		jmp	printChar_c0A