;+---------------------------------------------------------------------------
; MXOS
; Драйвер диска в ДОЗУ, ПЗУ
;
; Запись 256-байтного блока
;   На входе
;     e - 1
;     d - номер блока 
;     hl - адрес буфера в памяти
;   На выходе
;     все регистры сохраняются
;
; Чтение 256-байтного блока
;   На входе
;     e - 2
;     d - номер блока 
;     hl - адрес буфера в памяти
;   На выходе
;     все регистры сохраняются
;
; Получение размера накопителя
;   На входе
;     e - 3
;   На выходе
;     a - кол-во секторов на диске (для функции e=0)
;     bc, de, hl - сохраняются
;
; 2013-12-12 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

#if ROM_64K
ROM_SIZE = 0
#else
ROM_SIZE = 0C0h
#endif

diskDriver:	; Сохраняем регистры
		push	h
#if BIG_MEM
		push	b		; +1
#endif
		push	d
		push	psw

		; Заранее загружаем в С активный диск
#if BIG_MEM
		lda	v_drive		; +4
		mov	c, a		; +5
		dcr	c		; +6
#endif
		; Функция 1 - Запись блока
		dcr	e
		jz	diskDriver_w

		; Функция 2 - Чтение блока
		dcr	e
		jz	diskDriver_r
		
		; Функция 3 - Получение размера диска
		pop	psw		
#if BIG_MEM==0
		lda	v_drive         ; +3
		ana	a
		mvi	a, ROM_SIZE
#else
		inr	c
		mvi	a, ROM_SIZE
#endif
		jz	diskDriver_1
		mvi	a, 0FFh		; Размер RAM-диска		
diskDriver_1:		
		; Восстановливаем регистры и выходим
#if BIG_MEM
		jmp	pop_dbh_ret
#else
		pop	d
		pop	h
		ret
#endif
		
; ---------------------------------------------------------------------------
; Функция 2 - Чтение блока

diskDriver_r:	
#if ROM_64K
		; Это ПЗУ
		inr	c
		jnz	rom_64k
		; Это старшая часть ПЗУ
		mvi	a, 80h
		xra	d
		jm	rom_64k
		; 
		mov	d, a
		; Первые 4 байта в ПЗУ СТД это программа инициаизации
		inx	d
		inx	d
		inx	d
		inx	d
		; Включаем ПЗУ СТД (да, надо регистр цвета сбросить для этого)
		xra	a
		sta	IO_COLOR
		; Включаем ПЗУ СТД
rom_64k_0:	sta	IO_PAGE_STD
		; Чтение
		ldax	d
		; Включение ОЗУ MX
		sta	IO_RAM-800h
		; Запись
		mov	m, a
		inx	h
		; Цикл
		inx	d
		mvi	a, 4
		cmp	e
		jnz	rom_64k_0
		; Восстаналиваем цвет
		mvi	a, INIT_COLOR
		sta	IO_COLOR
		; Выходим
		jmp	popa_adh_ret
		
rom_64k:	dcr	c
#endif
#if BIG_MEM==0
		; Не нужно, тут и так E=0
		mvi	e, 0		;+1
#endif
		call	0FFC0h

popa_adh_ret:	; Восстанавливаем регистры и выходим
		pop	psw
#if BIG_MEM
		jmp	pop_dbh_ret
#else
		pop	d
		pop	h
		ret
#endif

; ---------------------------------------------------------------------------
; Функция 1 - Запись блока

diskDriver_w:	
#if BIG_MEM==0
		; Не нужно, тут и так E=0
		mvi	e, 0		;-1 у нас лишний байт в драйвере
#endif
		call	0FFD0h

		; Восстановливаем регистры и выходим
		jmp	popa_adh_ret