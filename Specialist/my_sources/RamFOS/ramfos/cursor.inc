;+---------------------------------------------------------------------------
; RAMFOS
; Функции перемещения курсора
;
; На входе в каждую функцию HL должен содержать v_cursorPos
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

cursorRight:	; Если v_cursorX >= 190, то перейти на новую строку
		mov	a, h
		cpi	190
		jnc	cursorCrLf

		; v_cursorX += 3
		adi	3
		mov	h, a

		; Сохранить новое положение курсора (shld v_cursorPos, ret)
		jmp	saveCursorPos

; ---------------------------------------------------------------------------

cursorCrLf:	; v_cursorX = 0
		mvi	h, 0

cursorDown:	; Если v_cursorY > screenHeight+10, сдвинуть экран вверх
		lda	v_screenHeight+1
		cmp	l
		jc	scrollUp

		; cursorY += 10
		mov	a, l
		adi	10
		mov	l, a

		; Сохранить новое положение курсора (shld v_cursorPos, ret)
		jmp	saveCursorPos

; ---------------------------------------------------------------------------

cursorLeft:	; Если курсор у левого края экрана, ничего не делать
		mov	a, h
		cpi	2
		jc	saveCursorPos

		; v_cursorX -= 3
		sui	3
		mov	h, a

		; Сохранить новое положение курсора (shld v_cursorPos, ret)
		jmp	saveCursorPos

; ---------------------------------------------------------------------------

cursorUp:	; Если курсор не на верхней служебной строке, то сдвинуть экран вверх
		lda	v_topLineHeight+1
		cmp	l
		jnc	scrollDownX0

		; v_cursorY -= 10
		mov	a, l
		sui	10
		mov	l, a

		; Сохранить новое положение курсора (shld v_cursorPos, ret)
		jmp	saveCursorPos