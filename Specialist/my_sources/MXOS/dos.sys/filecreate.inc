;----------------------------------------------------------------------------
; MXOS
; Создать файл
;
; На входе
;  hl - имя файла и информация (всё в формате записи каталога)
;
; На выходе
;  сf - ошибка
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileCreate:	; Сохраняем регистры
		push	h
		push	b
		push	d

		; Если файл существует, то удаляем его
		call	fileFind
		cnc	deleteFileInt

		; Сохраняем готовую запись каталога
		push	h

		; Ищем свободную запись в каталоге
		lxi	h, diskDirectory	; Адрес каталога
		lxi	d, 16			; Размер записи в каталоге
		mvi	b, 48			; Максимум файлов
fileCreate_0:	mov	a, m
		inr	a
		jz	fileCreate_1		; Свободная запись найдена
		dad	d
		dcr	b
		jnz	fileCreate_0

		; Свободных записей нет

		; Освобождаем стек
		pop	h

		; Установка A=0, ZF=1
		xra	a		

stc_pop_dbh_ret:; Установка флага CF=1
		stc

pop_dbh_ret:	; Восстановление регистров и выход
		pop	d
		pop	b
		pop	h
		ret

; ---------------------------------------------------------------------------
; Свободная запись найдена

fileCreate_1:	; Адрес свободной записи в DE
		xchg

		; Готовая запись каталога в HL
		pop	h

		; Копируем готовую запись в каталог 
		mvi	c, 14
fileCreate_2:	mov	a, m
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	fileCreate_2

		; Сохраняем адрес созданного файла
		xchg
		shld	v_createdFile
			
		; Ищем свободный кластер
		call	fileFindClusterFirst
		jc	stc_pop_dbh_ret

		push	psw

		; Сохраняем в каталог адрес первого кластера
		inx	h
		mov	m, a ; [15]

		; Читаем длину
		dcx	h
		dcx	h
		mov	d, m ; [13]
		dcx	h
		mov	e, m ; [12]

		; Читаем адрес
		dcx	h
		mov	b, m ; [11]
		dcx	h
		mov	l, m ; [10]

		; Сохраняем адрес
		mov	h, b
		shld	v_input_start

		; Сохраняем длину
		xchg
		shld	v_input_end

		; ?
		mov	b, h
		inr	b
		mvi	h, 0FBh

		; Первый кластер файла
		pop	psw
		mov	c, a
		mov	l, a

		jmp	loc_CC24

; ---------------------------------------------------------------------------

allocClusters:	call	fileFindClusterNext
		jc	stc_pop_dbh_ret		
loc_CC24:	mov	m, a
		mov	l, a
		dcr	b
		jnz	allocClusters
		mov	m, l		
		mvi	b, 0FBh
		xchg
		mvi	e, 1		
loc_CC30:	mov	d, c
		call	j_diskDriver
		inr	h
		ldax	b
		cmp	c
		mov	c, a
		jnz	loc_CC30		
		lhld	v_input_end
		inx	h
		xchg
		lhld	v_input_start
		mvi	b, 0		
loc_CC45:	mov	a, d
		ora	e
		jz	loc_CC52
		mov	a, m
		add	b
		mov	b, a
		inx	h
		dcx	d
		jmp	loc_CC45

; ---------------------------------------------------------------------------

loc_CC52:	mov	a, b
		lhld	v_createdFile
		mov	m, a
		call	saveFatDir
		ora	a
		jmp	pop_dbh_ret