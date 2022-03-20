;+---------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа F81E	
; Получить координаты курсора в символах
;
; На выходе
;  h - строка (Y)
;  l - столбец (X)
;  Сохраняет остальные регистры
;
; 2013-11-01 vinxru
;----------------------------------------------------------------------------                   

getCursorPos:	push	psw
		lxi	h, -1

		; h = v_cursorPosY / 10
		lda	v_cursorPos	
getCursorPos_0:	 inr	h
		 sui	0Ah
		jnc	getCursorPos_0

		; l = v_cursorPosX / 3
		lda	v_cursorPos+1			
getCursorPos_1:  inr	l
		 sui	3
		jnc	getCursorPos_1

		pop	psw
		ret