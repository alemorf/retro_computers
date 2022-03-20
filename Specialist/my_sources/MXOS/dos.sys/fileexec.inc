;+---------------------------------------------------------------------------
; MXOS
; Запустить файл
;
; На входе
;  hl - ком строка в формате [Диск:]файл[ аргументы]
;
; На выходе
;  сf - ошибка
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileExec:	; Сюда будем записывать результат
		lxi	d, v_cmdLine
		
		; Если первый символ меньше пробела, выходим c CF
		mov	a, m
		cpi	' '
		jc	stc_ret

		; Максимальный размер ком строки (+2 терминатора, итого 82h)
		mvi	c, 80h		

fileExec_0:	; Если символ меньше пробела, выходим
		mov	a, m
		cpi	20h
		jc	fileExec_1

		; Копируем симовол из HL в DE
		stax	d
		inx	h
		inx	d

		; Повторяем 80h раз
		dcr	c
		jnz	fileExec_0

fileExec_1:	; В конец имени помещаем 13,0
		mvi	a, 0Dh
		stax	d
		xra	a
		inx	d
		stax	d

		; Выводим на экран 0
		call	printCharA

		; Вывод имени файла на экран
		lxi	h, v_cmdLine
		call	j_printString

		; Подготовка имени файла
		lxi	h, v_cmdLine
		lxi	d, v_fileName
		call	fileNamePrepare

		push	h

		; Если это BAT-файл
		lxi	d, aBat		; "BAT"
		call	cmpFileExt
		jz	execBat

		; Если это COM или EXE файл
		call	cmpFileExt
		jz	loc_CAB6
		call	cmpFileExt
		jnz	loc_CAD3
loc_CAB6:	
		pop	d

		; Загрузить файл
		lxi	h, v_fileName
		call	fileLoad
		jc	badCommand

		push	d

		call	printCharA

		; Получаем адрес загрузки файла
		lxi	d, 10
		dad	d
		mov	e, m
		inx	h
		mov	d, m

		; Адрес возврата
		lxi	h, loc_CAD1
		xthl

		; Перейти на DE
		xchg
		pchl

; ---------------------------------------------------------------------------

loc_CAD1:	ora	a
		ret

; ---------------------------------------------------------------------------

loc_CAD3:	pop	d
badCommand:	lxi	h, aBadCommandOrFi ; "\nBAD COMMAND OR FILE NAME"
		call	j_printString		                     
stc_ret:	stc
		ret

; ---------------------------------------------------------------------------

printCharA:	mvi	c, 0Ah
		jmp	j_printChar		