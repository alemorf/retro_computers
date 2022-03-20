;+---------------------------------------------------------------------------
; RAMFOS
; Вывести имя файла на экран и удалить из него все недопустимые символы
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printFileName:	
		; Разделитель
#if NICE
		mvi	c, ' '
#else
		; Разделитель
		mvi	c, 11h
#endif
		call	printChar

printFileName2:lxi	h, v_header2_name	; Имя
		mvi	b, 12			; Длина имени
printFileNam_1:	 mov	a, m
		 ; Символы меньше 0x20 заменяем на пробел
		 cpi	20h
		 jc	printFileNam_2
		 ; Символы от 0x20 до 0x7E допускаются
		 cpi	7Fh
		 jc	printFileNam_3
		 ; Символы от 0xC0 до 0xFF допускаются
		 cpi	0C0h
		 jnc	printFileNam_3		 
printFileNam_2:	 ; Заменяем недопустимый символ на пробел
		 mvi	m, 20h
		 mov	a, m
printFileNam_3:	 ; Выводим символ на экран
		 call	printCharA
		 ; Следующий символ
		 inx	h
		 dcr	b
		jnz	printFileNam_1		

		; Разделитель
#if NICE
		mvi	c, ' '
		jmp	printChar
#endif
		; Переход на printChar6