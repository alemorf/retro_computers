;----------------------------------------------------------------------------
; MXOS NC.COM
; Клавиша ENTER (продолжение)
;
; 2013-12-18 Дизассемблировано vinxru
;----------------------------------------------------------------------------

Enter_nextExt:	pop	h
Enter_2:	ldax	d
		inx	d
		cpi	0Dh
		jz	Enter_extLoop
		inr	a
		jnz	Enter_2
		jmp	Enter_stdExec