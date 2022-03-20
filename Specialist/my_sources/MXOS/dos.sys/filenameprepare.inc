;+---------------------------------------------------------------------------
; MXOS
; Подготовить имя файла для функций ОС
;
; На входе 
;  hl - исходное имя
;  de - буфер для результата (9 байт)
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileNamePrepare:; Сохраняем регистры
		push	b
		push	d

		; Если второй символ исходной строки ':', то меняем диск
		inx	h		
		mov	a, m
		cpi	':'
		dcx	h
		jnz	fileNamePr_1

		; Меняем диск
		mov	a, m		
		sui	'A'
		call	fileSelectDrive

		; Диск не входит в имя файла
		inx	h		
		inx	h		
		
fileNamePr_1:	; 6 символов имени, 3 расширения
		lxi	b, 603h

		; Копируем текст до точки, пробела или конца строки, не более 6 символов. 
fileNamePr_2:	mov	a, m
		ana	a
		jp	fileNamePr_3
		sui	40h
fileNamePr_3:	cpi	' '+1
		jc	fileNamePr_5
		inx	h
		cpi	'.'
		jz	fileNamePr_5		
		stax	d
		inx	d
		dcr	b
		jnz	fileNamePr_2

		; Пропускаем текст до точки, пробела или конца строки
fileNamePr_4:	mov	a, m
		cpi	' '+1
		jc	fileNamePr_6
		inx	h
		cpi	'.'
		jnz	fileNamePr_4
		jmp	fileNamePr_6

; ---------------------------------------------------------------------------

fileNamePr_5:	; Имя короче 6 символов
		; Заполняем недостающие символы имени пробелами
		call	memset_de_20_b

		; Копируем текст до пробела или конца строки, не более 3 символов. 
fileNamePr_6:	mov	a, m                         
		ana	a
		jp	fileNamePr_7
		sui	40h		
fileNamePr_7:	cpi	' '+1
		jc	fileNamePr_11
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	fileNamePr_6

fileNamePr_8:	; Пропускаем текст до пробела или конца строки
		mov	a, m
		cpi	' '
		jc	fileNamePr_10
		inx	h
		jnz	fileNamePr_8
		
fileNamePr_9:	; Пропускаем текст до пробела или конца строки
		; Почему то дублируется код
		mov	a, m
		cpi	' '
		jc	fileNamePr_10
		inx	h
		jz	fileNamePr_9
		dcx	h

fileNamePr_10:	; Восстанавливаем регистры и выходим
		pop	d
		pop	b
		ret

; ---------------------------------------------------------------------------

fileNamePr_11:	; Заполняем недостающие символы расширения пробелами
		mov	b, c
		call	memset_de_20_b

		; Восстанавливаем регистры и выходим
		pop	d
		pop	b
		ret		