;----------------------------------------------------------------------------
; MXOS
; Ожидание ввода с клавиатуры (продолжение)
;
; На выходе
;  ? - код
;
; 2013-12-12 Дизассемблировано vinxru
;----------------------------------------------------------------------------

loc_C55C:	; Если нажат лишь РУС/LAT - то обрабатываем его как CAPS/LOCK
		call	setKeybMode91
		mvi	a, 0F8h
		sta	IO_KEYB_B
		lda	IO_KEYB_A		
		push	psw
		call	setKeybMode82
		pop	psw
		ani	8
		jnz	getch_capsLock

		; Меняем KOI-7 / KOI-8
		lda	v_koi8
		cma
		sta	v_koi8

		; Звуковой сигнал
		call	beep

		mvi	a, 3Ah
		sta	v_keyLocks

		; Меняем частоту
		mvi	a, 5Fh
		sta	v_beep

		jmp	getch_retry

; ---------------------------------------------------------------------------
; CAPS LOCK для KOI-7

getch_capsLock:	; Переключаем capsLock
		lda	v_keyLocks
		xri	80h
		sta	v_keyLocks

		; Изменяем высоту звуковго сигнала		
		lda	v_beep
		xri	10h
		sta	v_beep

		; Ждем следующую клавишу
		jmp	getch_retry

; ---------------------------------------------------------------------------
; CAPS LOCK для KOI-7 или РУС/LAT для KOI-8

getch_rc:	; В режиме KOI-8 мы переключаем кодировку
		lda	v_koi8
		inr	a

		lda	v_keyLocks	; Требуется в getch_rusLat
		jnz	getch_rusLat

		; В режиме KOI-7 мы перключаем регистр
		jmp	getch_capsLock	

; ---------------------------------------------------------------------------

loc_C5A8:	; Включен KOI-7
		mov	b, a

		lda	IO_KEYB_B
		ani	2
		jnz	loc_C311

		mvi	a, 0A0h
		xra	b
		mov	b, a

		jmp	loc_C311