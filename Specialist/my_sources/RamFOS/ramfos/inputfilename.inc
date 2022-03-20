;+---------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа C845
; Ввовод имени файла с клавиатуры в v_header2_name
;
; 2013-11-01 vinxru
;----------------------------------------------------------------------------

inputFileName:	push	h
		push	d
		push	b

		; Промежуточный адрес возврата
		lxi	h, popa_ret
		push	h

 		; Выводим сообщение на экран и сохраним курсор строки
		lxi	h, a_inputFileName
		call	printString

		; Удалим из имени файла все левые символы
		call	printFileName2

loc_C873:	; Восстановить курсор строки
		call	popCursorLine

		; Ввод имени файла
		lxi	h, v_header2_name
		lxi	d, 0CFFh
		call	input

		; Нажат ESC
		rz

		; Нажата левая клавиша, вывести знак вопроса и вернуться к вводу
		lxi	h, loc_C873
		push	h
		jnc	xra_a_stc_ret

		; Сдвинуть курсор
		lhld	v_pushCursorLn
		mov	a, h
		adi	3*8
		mov	h, a
		shld	v_cursorPos

		; Разделитель между именем и расширением должен быть пробелом
		lxi	h, v_header2_ext-1
		mvi	b, 4
		mov	a, m
		cpi	20h
		jnz	xra_a_stc_ret		

		; Расширение
loc_C89C:	 dcr	b
		 call	printCharA
		 jz	loc_CE8A	; Переход на pop h, ora a, ret
		 inx	h
		 mov	a, m
		 cpi	20h
		jnz	loc_C89C
		
xra_a_stc_ret:	; Вывод знака вопроса
		mvi	a, '?'
		call	printCharA
		xra	a

ora_a_stc_ret:	ora	a
		stc
		ret
