unmlz:		;push	b
		mvi	a, 80h
UNLD:
		sta	unmlz_1
		ldax	d
		inx	d
		jmp	UNSTA
; ---------------------------------------------------------------------------
UNST3:		mov	a, m
		inx	h
		stax	b
		inx	b
		
UNST2:		mov	a, m
		inx	h
		stax	b
		inx	b

UNST1:		mov	a, m

UNSTA:		stax	b
		inx	b

ULOOP:		lda	unmlz_1
		add	a
		jnz	L1
		ldax	d
		inx	d
		ral

L1:		jc	UNLD
		add	a
		jnz	L3
		ldax	d
		inx	d
		ral

L3:		jc	UN2
		add	a
		jnz	L2
		ldax	d
		inx	d
		ral

L2:		jc	UN1
		lxi	h, 3FFFh
		call	GETBITS
		sta	unmlz_1
		dad	b
		jmp	UNST1

; ---------------------------------------------------------------------------

UN1:		sta	unmlz_1
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		dad	b
		jmp	UNST2

; ---------------------------------------------------------------------------

UN2:		add	a
		jnz	L4
		ldax	d
		inx	d
		ral

L4:		jc	UN3
		call	GETBIGD
		dad	b
		jmp	UNST3

; ---------------------------------------------------------------------------

UN3:		mvi	h, 0

UN3A:		inr	h
		add	a
		jnz	L5
		ldax	d
		inx	d
		ral

L5:		jnc	UN3A
		push	psw
		mov	a, h
		cpi	8
		jnc	UNEXIT
		mvi	a, 0

L5B:		rar
		dcr	h
		jnz	L5B
		mov	h, a
		mvi	l, 1
		pop	psw
		call	GETBITS
		inx	h
		inx	h
		push	h
		call	GETBIGD
		xchg
		xthl
		xchg
		dad	b

LDIR:		mov	a, m
		inx	h
		stax	b
		inx	b
		dcr	e
		jnz	LDIR
		pop	d
		jmp	ULOOP

; ---------------------------------------------------------------------------

UNEXIT:		pop	psw
		;pop	b
		ret

; ===========================================================================

GETBITS:	add	a
		jnz	L7
		ldax	d
		inx	d
		ral		
L7:		jc	GETB1
		dad	h
		rc
		jmp	GETBITS

; ---------------------------------------------------------------------------

GETB1:		dad	h
		inr	l
		rc
		jmp	GETBITS

; ===========================================================================

GETBIGD:	add	a
		jnz	L8
		ldax	d
		inx	d
		ral

L8:		jc	GETBD1
		sta	unmlz_1
		ldax	d
		inx	d
		mov	l, a
		mvi	h, 0FFh
		ret

; ---------------------------------------------------------------------------

GETBD1:		lxi	h, 1FFFh
		call	GETBITS
		sta	unmlz_1
		mov	h, l
		dcr	h
		ldax	d
		inx	d
		mov	l, a
		ret

unmlz_1: .db 0