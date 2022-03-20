;+---------------------------------------------------------------------------
; RAMFOS
; Звуковой сигнал при нажатии клавиши
;
; 2013-11-01 vinxru
;----------------------------------------------------------------------------

keySound:	push	b
		 ; Частота
		 xchg
		 lhld	v_beepConfig
		 xchg

		 ; Понижаем частоту в два раза, если нажата РУС/LAT
		 lda	v_rusLat
		 ani	1
		 mov	a, d
		 jnz	keySound_0
		  rrc			; Интересно, а вдруг CF?
keySound_0:	 mov	d, a

		 ; Устаналиваем таймер (звук)
		 mov	b, e
		 mov	c, e
		 ora	a
		 call	setTimer
		pop	b

		; Для функции keyScan
		mvi	a, 0FFh
		ret
