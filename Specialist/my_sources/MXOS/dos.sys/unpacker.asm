TMP		= 07FFFh
IO_RAM		= 0FFFCh

.org 0E000h

start:		; Включаем ОЗУ
		sta	IO_RAM

		; Стек
		lxi	sp, TMP

		; Распаковываем ОС
		lxi	d, packedData
		lxi	b, 0C000h
		push	b
		jmp	unmlz

; Разархиватор MegaLZ
; (с) b2m, vinxru, группа mayhem...


unmlz:		mvi	a, 80h

loc_2:		sta	TMP		
		ldax	d
		inx	d
		jmp	loc_13
; ---------------------------------------------------------------------------

loc_A:		mov	a, m
		inx	h
		stax	b
		inx	b

loc_E:
		mov	a, m
		inx	h
		stax	b
		inx	b

loc_12:
		mov	a, m

loc_13:
		stax	b
		inx	b

loc_15:
		lda	TMP
		add	a
		jnz	loc_1F
		ldax	d
		inx	d
		ral

loc_1F:
		jc	loc_2
		add	a
		jnz	loc_29
		ldax	d
		inx	d
		ral

loc_29:
		jc	loc_4F
		add	a
		jnz	loc_33
		ldax	d
		inx	d
		ral

loc_33:
		jc	loc_43
		lxi	h, 3FFFh
		call	sub_A2
		sta	TMP
		dad	b
		jmp	loc_12
; ---------------------------------------------------------------------------

loc_43:
		sta	TMP
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		dad	b
		jmp	loc_E
; ---------------------------------------------------------------------------

loc_4F:
		add	a
		jnz	loc_56
		ldax	d
		inx	d
		ral

loc_56:
		jc	loc_60
		call	sub_B7
		dad	b
		jmp	loc_A
; ---------------------------------------------------------------------------

loc_60:
		mvi	h, 0

loc_62:
		inr	h
		add	a
		jnz	loc_6A
		ldax	d
		inx	d
		ral

loc_6A:
		jnc	loc_62
		push	psw
		mov	a, h
		cpi	8
		jnc	loc_98
		mvi	a, 0

loc_76:
		rar
		dcr	h
		jnz	loc_76
		mov	h, a
		mvi	l, 1
		pop	psw
		call	sub_A2
		inx	h
		inx	h
		push	h
		call	sub_B7
		xchg
		xthl
		xchg
		dad	b

loc_8C:		mov	a, m
		inx	h
		stax	b
		inx	b
		dcr	e
		jnz	loc_8C
		pop	d
		jmp	loc_15

; ---------------------------------------------------------------------------

loc_98:
		pop	psw
		; Конец
		ret

; ---------------------------------------------------------------------------

sub_A2:		add	a
		jnz	loc_A9
		ldax	d
		inx	d
		ral

loc_A9:		jc	loc_B1
		dad	h
		rc
		jmp	sub_A2

; ---------------------------------------------------------------------------

loc_B1:		dad	h
		inr	l
		rc
		jmp	sub_A2

; ---------------------------------------------------------------------------

sub_B7:		add	a
		jnz	loc_BE
		ldax	d
		inx	d
		ral

loc_BE:		jc	loc_CA
		sta	TMP
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		ret
; ---------------------------------------------------------------------------

loc_CA:		lxi	h, 1FFFh
		call	sub_A2
		sta	TMP
		mov	h, l
		dcr	h
		ldax	d
		inx	d
		mov	l, a
		ret

packedData:

.end