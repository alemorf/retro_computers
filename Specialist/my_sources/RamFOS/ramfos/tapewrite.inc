;+---------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа C80С
; Запись байта на магнитофон
;
; На входе
;  С - байт
;  A - укорочение первого импульса *15 тактов
;
; Сохраняет регистры BC,DE,HL
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

tapeWrite:	push	h
		push	b
		 lhld	v_tapePulseB
		 adi	3
		 cma
		 add	l
		 mov	l, a
		 call	tapePulse
		 ora	a
		 ora	a
		 mvi	b, 8				
tapeWrite_0:	  call	tapePulseBit
		  dcr	b
		 jnz	tapeWrite_0
		 call	tapeWriteEnd
		 push	h
		 push	h
		  call	tapePulseA
		 pop	h
		 pop	h
		pop	b
		pop	h
		ret

; ---------------------------------------------------------------------------

tapePulseBit:	mov	a, c
		rrc
		mov	c, a
		jc	tapePulseA
tapePulseB:	lhld	v_tapePulseB
		jmp	tapePulse

; ---------------------------------------------------------------------------

tapeWriteEnd:	mov	a, c
		ora	a
		mov	c, a
		jpo	tapePulseB
		lhld	v_tapePulseA
		dcr	l
		call	tapePulse
tapePulseA:	lhld	v_tapePulseA
		jmp	tapePulse
