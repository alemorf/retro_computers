;+---------------------------------------------------------------------------
; MXOS
; Получить список файлов
;
; На входе 
;  hl - адрес буфера (769 байт)
;
; На выходе
;  bc,de,hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileList:	; Загрузка FAT и каталога
		call	loadFatDir

		; Сохранение регистров
		push	h
		push	b
		push	d

		; Максимум файлов
		mvi	b, 48

		; Адрес первого файла
		lxi	d, diskDirectory
		
fileList_loop:	; Если первый символ не FFh, копируем описатель
		ldax	d
		inr	a
		jnz	fileList_copy

		; Вычисляем адрес следующего файла
		push	h
		lxi	h, 10h
		dad	d
		xchg
		pop	h

fileList_next:	; Цикл
		dcr	b
		jnz	fileList_loop

		; В конце символ 0FFh
		mvi	m, 0FFh
		jmp	pop_dbh_ret

; ---------------------------------------------------------------------------

fileList_copy:	; Копируем 16 байт из DE в HL
		mvi	c, 16
fileList_copyl:	ldax	d
		mov	m, a
		inx	h
		inx	d
		dcr	c
		jnz	fileList_copyl
		jmp	fileList_next