;+---------------------------------------------------------------------------
; MXOS
; Очистить экран
;
; На выходе
;  bc, de, hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

clearScreen:	; bc, hl - сохраняем. de - не используется
		push	h
		push	b

		; Сохранение SP
		lxi	h, 0
		dad	sp
		shld	v_oldSP

		; Устанавливаем SP в конец видеопамяти
		lxi	sp, 0C000h

		; Байт (слово) для заполнения памяти
		lhld	v_inverse

		; Помещаем в стек 3000h байт
		lxi	b, 3000h / 16
clearScreen_0:	  push	h
		  push	h
		  push	h
		  push	h
		  push	h
		  push	h
		  push	h
		  push	h
		  dcx	b
		  mov	a, b
		  ora	c
		jnz	clearScreen_0

		; Восстанавливаем SP
		lhld	v_oldSP
		sphl

		; bc, hl были сохранены. de - не используется
		pop	b
		pop	h
		ret		