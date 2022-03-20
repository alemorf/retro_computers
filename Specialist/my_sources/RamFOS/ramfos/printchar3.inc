;----------------------------------------------------------------------------
; RAMFOS
; Вывод символа на экран. Продолжение printChar.inc
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printChar2:	sui	21h

printChar_esc1:	; Обработка первого символа ESC-последовательности

		; Если символ Y, перейти к обработке второго символа
		mov	a, c
		cpi	'Y'
		mvi	a, 2
		jz	setEscMode

		; Доработка для вывода всех символов знакогенератора
#if ALL_CHARS
printCharAll:
		xra	a
		sta	v_escMode
		lhld	v_cursorPos
		jmp	printChar_0
#endif

; ---------------------------------------------------------------------------

setEscMode0:	xra	a
setEscMode:	sta	v_escMode
		ret

; ---------------------------------------------------------------------------

printChar_esc2:	sta	v_escRow
		mvi	a, 3
		jmp	setEscMode

; ---------------------------------------------------------------------------

setEscMode1:	mvi	a, 1
		jmp	setEscMode
		
; ---------------------------------------------------------------------------

printChar_esc:	; Обработка ESC последовательности

		; Если printChar_esc1Mode=1
		dcr	a
		jz	printChar_esc1
		mov	b, a

		; Вычесть из буквы 20h
		mov	a, c
		sui	20h

		; Если printChar_esc1Mode=2, сохранить 
		dcr	b
		jz	printChar_esc2

		mov	l, a
		lda	v_escRow
		mov	h, a
		call	setEscMode0

		; Продолжение setCursorPos