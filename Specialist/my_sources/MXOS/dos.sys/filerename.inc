;+---------------------------------------------------------------------------
; MXOS
; Переименовать файл
;
; На входе 
;  hl - исходное имя
;  de - новое имя
;
; На выходе
;  cf - ошибка
;  bc,de,hl - сохраняются
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

fileRename:	; Найти файл с именем из HL
		call	fileFind
		rc

		; Сохранить регистры
		push	h
		push	b
		push	d
		
		;
		lhld	v_foundedFile

		; Попытаться найти файл с новым именем
		xchg
		call	fileFind2		

		; Если такой файл есть, то удалить
		cnc	deleteFileInt
		
		; Заменяем имя
		mvi	c, 9		
loc_CD2C:	mov	a, m
		stax	d
		inx	h
		inx	d
		dcr	c
		jnz	loc_CD2C

		; Сохраняем изменения
		call	saveFatDir

		; Выход
		ora	a
		jmp	pop_dbh_ret