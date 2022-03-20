;+---------------------------------------------------------------------------
; MXOS
; Загрузить файл
;
; На входе
;  hl - имя
;  de - адрес загрузки
;
; На выходе
;  bc,de,hl - сохраняются
;  v_foundedFile - найденный файл
;  cf - ошибка
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileLoad2:	; Ищем файл с именем в HL
		call	fileFind2
		rc

		; Сохранить регистры
		push	h
		push	b
		push	d

		; Указатель на длину найденного файла
		lhld	v_foundedFile
		lxi	b, 13
		dad	b

		jmp	loc_CCBA

;----------------------------------------------------------------------------
; Загрузить файл по адресу указанному в заголовке
;
; На входе
;  hl - имя
;
; На выходе
;  bc,de,hl - сохраняются
;  v_foundedFile - найденный файл
;  cf - ошибка
;----------------------------------------------------------------------------

fileLoad:	; Ищем файл с именем в HL
		call	fileFind
		rc

		; Сохраняем регистры
		push	h
		push	b
		push	d

		; DE = адрес загрузки
		lhld	v_foundedFile
		lxi	d, 10
		dad	d
		mov	e, m ; +10
		inx	h
		mov	d, m ; +11

		inx	h
		inx	h

loc_CCBA:	; Длина файла в кластерах
		mov	b, m ; +13
		inr	b
		
		; Первый кластер
		inx	h
		inx	h
		mov	a, m ; +15

		xchg

loc_CCC0:	; Читаем кластер в память
		mvi	e, 2		; Чтение
		mov	d, a		; Кластер
		call	j_diskDriver

		; Следующий кластер
		inr	h
		mov	e, d
		mvi	d, 0FBh
		ldax	d

		; Цикл
		dcr	b
		jnz	loc_CCC0

		; Восстанавливаем регистры
		pop	d
		pop	b
		pop	h

		jmp	loc_CCD9

; ---------------------------------------------------------------------------

fileLoadInfo:	; Ищем файл с именем в HL
		call	fileFind
		rc

loc_CCD9:	; Сохраняем регистры
		push	h
		push	b
		push	d

		; Что то в DE
		lxi	b, 9
		dad	b
		xchg

		; Информация о файле исключая имя
		lhld	v_foundedFile
		dad	b

		; Копируем 7 байт из HL в DE
		mvi	b, 7
loc_CCE7:	mov	a, m
		stax	d
		inx	h
		inx	d
		dcr	b
		jnz	loc_CCE7

		; Выход CF=0
		ora	a
		jmp	pop_dbh_ret
