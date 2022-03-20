;----------------------------------------------------------------------------
; MXOS NC.COM
; Реализация индексной адресации
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

; [hl + activePanel] = a

writeBytePanel:	push	b
		push	h
		push	psw
		mov	c, a
		lda	activePanel
		ana	a
		jz	loc_D97E
		inx	h
loc_D97E:	mov	m, c
		pop	psw
		pop	h
		pop	b
		ret

; a = [hl + activePanel]

readBytePanel:	push	h
		lda	activePanel
		ana	a
		jz	loc_D98C
		inx	h
loc_D98C:	mov	a, m
		pop	h
		ret
