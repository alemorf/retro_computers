;+---------------------------------------------------------------------------
; MXOS
; Запустить BAT файл. Вызывается функцией fileExec
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

execBat:	pop	d

		; Сбрасываем счетчик
		lxi	h, diskDirectory 
		shld	v_batPtr		
		xchg

		; Проверяем наличие BAT-файла
		lxi	h, v_fileName
		mvi	c, 1
		call	fileGetSetAddr
		jc	badCommand

		; Сохраняем имя BAT-файла
		lxi	h, v_fileName	
		lxi	d, v_fileName_end
		lxi	b, v_batFileName
		call	memmove_bc_hl

		; Сохраняем диск содержащий BAT-файл
		lda	v_drive
		sta	v_batDrive+1

execBat_loop:	; Этот цикл выполняется для каждой строки BAT-файла

		; Сохраняем текущий диск
		lda	v_drive
		mov	b, a

v_batDrive:	; Выбрать диск содержащий BAT файл
		mvi	a, 1		
		call	fileSelectDrive

		; Загрузить BAT-файл в память
		lxi	h, v_batFileName 
		call	fileLoad
		lhld	v_batPtr

		; Сохраняем начало строки
		mov	d, h
		mov	e, l

execBat_0:	; Ищем конец строки
		mov	a, m		
		inx	h

		; Найден конец строки, запускаем файл
		cpi	0Dh		
		jz	execBat_1

		; Конец	файла
		cpi	0FFh		
		jnz	execBat_0
		ret

; ---------------------------------------------------------------------------

execBat_1:	; Сохраняем указатель
		shld	v_batPtr	

		; Восстановление активного диска		
		mov	a, b		
		call	fileSelectDrive

		; Запустить файл
		xchg			
		call	fileExec

		jmp	execBat_loop