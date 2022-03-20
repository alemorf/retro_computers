;----------------------------------------------------------------------------
; RAMFOS + Специалист MX2
; Загрузчик
;
; 2013-11-01 Разработано vinxru
;----------------------------------------------------------------------------

.include "config.inc"

.org loader1Offset
		; Глушим таймер
		LXI H, 0FFEFh
		MVI M, 03Eh
		MVI M, 07Eh
		MVI M, 0BEh
		
		; Очищаем экран
		mvi	a, 0F0h
		sta	0FFF8h
		lxi	sp, 0BFFFh
		lxi	h, 0	
		lxi	d, 600h
clearLoop:	  push h
		  push h
		  push h
		  push h
		  dcr e
		 jnz clearLoop
		 dad h
		 dcr d
		jnz clearLoop

		; Выводим логотип		
		mvi	a, 0F0h ; Белый		
		lxi     d, logo
		mvi     h, 091h
		mvi	c, 44
		call	logoLine		
		mvi	a, 0C0h	; Красный
		mvi	c, 2
		call	logoLine
		 		
		; Попытка загрузится с SD
.include "sdloader.inc"

		; Копируем RAMFOS
		lxi     b, 0C000h
		lxi     d, ramfosOffset
		call	unmlzOffset

		; Запускаем программу сдвига и RAMFOS
		lxi	d, 0D2A0h
		lxi	h, 0F800h
                lxi	b, 0FFE0h - 0F800h                
moveLoop:	 ldax d
		 inx d
		 mov m, a
		 inx h
		 dcx b
		 mov a, b
		 ora c
		jnz moveLoop

		jmp 0F800h

; ---------------------------------------------------------------------------

logoLine:	sta 0FFF8h
logoLine_0:      mvi	b, 39
		 mvi	l, 108
drawChar_1:       ldax	d
		  inx	d
		  mov	m, a
		  inx	h
		  dcr	b
		 jnz	drawChar_1
		 inr	h
		 dcr	c
		jnz	logoLine_0
		ret

; ---------------------------------------------------------------------------

logo:
.include "logo.inc"

; ---------------------------------------------------------------------------

.end