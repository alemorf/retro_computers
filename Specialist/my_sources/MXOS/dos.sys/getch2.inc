;----------------------------------------------------------------------------
; MXOS
; Ожидание ввода с клавиатуры
;
; На выходе
;  ? - код
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

getch2:		; Сохраняем регистры
		push	h
		push	b
		push	d

		; Получаем код нажатой клавиши и сохраняем его в v_lastKey
		call	keyScan2
		sta	v_lastKey

getch_retry:	; Тут будет признак, нарисован курсор или нет
		mvi	c, 1

loc_C227:	; Рисуем курсор
		call	drawCursor2

		; Задержка
		lda	v_cursorDelay
loc_C22D:	mvi	b, 40h
		call	delay_l_0
		dcr	a
		jnz	loc_C22D

loc_C236:	; Рисуем/стираем курсор
		call	drawCursor
		
		; Задержка мерцания курсора
		lxi	d, 500h

loc_C23C:	; Получаем код нажатой клавиши
		call	keyScan2
		cpi	80h		; х.з.
		cpi	0FFh
		jnz	getch2_pressed

		; Записываем v_lastKey=0FFh
		sta	v_lastKey

		; Повторяем 500h раз
		dcx	d
		mov	a, d
		ora	e
		jnz	loc_C23C

		; Повтор всего
		jmp	loc_C236

; ---------------------------------------------------------------------------

.db 0FFh, 0FFh

; ---------------------------------------------------------------------------

setKeybMode82:	mvi	a, 82h
		sta	IO_KEYB_MODE
		ret

; ---------------------------------------------------------------------------

setKeybMode91:	mvi	a, 91h
		sta	IO_KEYB_MODE
		ret

; ---------------------------------------------------------------------------
; Была нажата клавиша

getch2_pressed:	; Сохраняем код
		mov	b, a

		; Если нарисован курсор, стираем его
		mov	a, c
		rrc
		jc	loc_C269
		call	drawCursor2
loc_C269:	
		lhld	unk_8FEF	; h = v_lastKey
		mov	a, b		; a = b = код нажатой клавиши
		cmp	h
		jnz	loc_C28D	; Код нажатой клавиши изменился
		cmp	l
		jz	loc_C295

		; Рисуем курсор
		call	drawCursor

		; Ждем, пока отпустят клавишу
		lda	byte_8FF5
		mov	d, a
loc_C27C:	call	keyScan2
		cmp	h
		jnz	loc_C227	; Быстро нажали другую клавишу
		dcr	d
		jnz	loc_C27C

		; Долго держали

		; Стираем курсор
		call	drawCursor

		jmp	loc_C290
; ---------------------------------------------------------------------------

loc_C28D:	; Звуковой сигнал
		call	beep

loc_C290:	;
		mov	l, h
		mov	h, b	; код нажатой клавиши сохраняем в v_lastKey
		shld	unk_8FEF

loc_C295:	; Не служеюбные клавиши CAPS LOCK, SHIFT и РУС/LAT не влияют
		mov	a, b
		cpi	21h
		jc	getch_noShift   
                ; На клавиши c кодами 21h-3Fh влияет SHIFT
		cpi	40h
		jc	getch_shift 
                ; На символьные клавиши (40h-7Eh) влияют CAPS LOCK, SHIFT и РУС/LAT
		cpi	7Fh
		jc	getch_chars
                ; Не служеюбные клавиши (7Fh+) CAPS LOCK, SHIFT и РУС/LAT не влияют
		jz	getch_noShift

		; ...
		nop
		nop

                ; Переходим, если код клавиши не 81h
		cpi	81h
		jnz	getch_noShift

                ; Код клавиши 81h

		; Если шифт не нажат
		lda	IO_KEYB_B
		ani	2
		jnz	loc_C55C

                ; Код клавиши 81h с шифтом

		; Звуковой сигнал
		call	beep

		; CAPS LOCK для KOI-7 или РУС/LAT для KOI-8
		jmp	getch_rc

; ---------------------------------------------------------------------------
; Нажата комбинация РУС/LAT

getch_rusLat:	; на входе a = v_keyLocks
		xri	81h
		sta	v_keyLocks

		; Особый звуковой сигнал
		lda	v_beep
		push	psw
		mvi	a, 4Fh
		sta	v_beep
		call	beep
		mvi	a, 5Fh
		sta	v_beep
		call	beep
		pop	psw
		sta	v_beep

		; ...
		nop

		jmp	getch_retry

; ---------------------------------------------------------------------------
; Включаем кирилицу или строчные буквы

getch_chars:	; Если не нажат CAPS LOCK, пропускаем код ниже
		lda	v_keyLocks
		mov	c, a
		ana	a
		jm	loc_C2EA	; CAPS LOCK

		; Превращаем заглавные в строчные
		mov	a, b
		xri	20h
		mov	b, a

loc_C2EA:	; Если зафиксирвоан ли РУС/ЛАТ, помещаем в C=1
		mov	a, c
		ani	1
		mov	c, a

		; Если шифт нажат, помещаем в A=0
		lda	IO_KEYB_B
		ani	2
		rrc				;! Как на счет флага C ?

		; Превращаем английские символы в русские если A^C==0
		xra	c
		mov	a, b
		jnz	loc_C5A8
		adi	80h
		jmp	loc_C5A8

; ---------------------------------------------------------------------------
; Меняем цифры на символы

getch_shift:	; Если не нажат шифт, пропускаем код ниже
		lda	IO_KEYB_B
		ani	2
		mov	a, b
		jnz	loc_C5A8

		; Меняем цифры на символы
		xri	10h

		; Одно исключение 30h должен меняться на 5Fh
		cpi	20h
		jnz	getch_noShift
		mvi	a, 5Fh

		; Прододжение getch_noShift

; ---------------------------------------------------------------------------
; Символы без изменений

getch_noShift:  ; Сохраняем код нажатой клавиши в B     
		mov	b, a

loc_C311:	call	setKeybMode83
		mvi	a, 0F7h
		sta	IO_KEYB_A
		lda	IO_KEYB_B
		cma
		rrc
		rrc
		rrc
		call	setKeybMode82
		nop

		; Восстаналиваем код нажатой клавиши
		mov	a, b

popa_ret_2:	; Восстаналиваем регистры и выходим
		pop	d
		pop	b
		pop	h
		ret