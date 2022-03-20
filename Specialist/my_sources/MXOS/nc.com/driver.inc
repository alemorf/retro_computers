;----------------------------------------------------------------------------
; MXOS NC.COM
; Драйвер для доступа к ДОЗУ
;
; 2013-12-18 Дизассемблировано и доработано vinxru
;----------------------------------------------------------------------------

swapDriver:	lxi	h, 0FFC0h
		lxi	d, Driver
		mvi	b, DriverEnd-Driver
swapDriver_1:	 mov	c, m
		 ldax	d
		 mov	m, a
		 mov	a, c
		 stax	d
		 inx	h
		 inx	d
		 dcr	b
		jnz	swapDriver_1
		ret

; ---------------------------------------------------------------------------

Driver:		
#if BIG_MEM
		xra	a
#endif
		sta     IO_PAGE_ARAM
		mov     a, m
		sta     IO_PAGE_RAM
		ret
DriverW:	
#if BIG_MEM
		push	b
		mov	b, a
		xra	a
		sta     IO_PAGE_ARAM
		mov     m, b
		sta     IO_PAGE_RAM
		pop	b
#else
		sta     IO_PAGE_ARAM
		mov     m, a
		sta     IO_PAGE_RAM
#endif
		ret
DriverEnd: