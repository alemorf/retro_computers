;+---------------------------------------------------------------------------
; RAMFOS
; Загрузка и запуск MXDOS с дискеты
; Вызывается при нажатии на F6 из файловой панели
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

#if NO_MXDOS==0

MXDOS_ADDR = 0E400h

loadMxDos:	mov	b, a

		; Установка головки и сектора
		mvi	a, 1
		sta	IO_FLOPPY_HEAD
		sta	IO_FLOPPY_SECTOR

		; Пауза
		mvi	h, 13h
loadMxDos_0:	 dcx	h
		 mov	a, l
		 ora	h
		jnz	loadMxDos_0

		; Устанавливаем головку
		sta	IO_FLOPPY_HEAD

		; Адрес загрузки
		lxi	h, MXDOS_ADDR

		; Чтения сектора
		mvi	a, 90h
		sta	IO_FLOPPY_CMD

		; Ожидание готовности
loadMxDos_1:	 lda	IO_FLOPPY_CMD
		 ral
		 rc
		 rar
		 rar
		jnc	loadMxDos_1

		; Получение данных
		mvi	c, 13h 
loadMxDos_2:	  sta	IO_FLOPPY_TRIG
		  lda	IO_FLOPPY_DATA
		  mov	m, a
		  inr	l
		 jnz	loadMxDos_2
		 inr	h
		 dcr	c
		jp	loadMxDos_2

		; Проверка
		lda	IO_FLOPPY_CMD
		xri	1
		ora	a
		mvi	a, 0D0h
		sta	IO_FLOPPY_CMD
		jnz	dlg_error

		; Проверка
		dcx	h
		mov	a, m
		dcx	h
		inr	m
		cmp	m
		jnz	dlg_error

		; Запуск MXDOS
		.db 078h
		call	MXDOS_ADDR

		; При выходе из MXDOS выбираем ROM-диск
		mvi	b, 80h
		ret
#endif