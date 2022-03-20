;+---------------------------------------------------------------------------
; RAMFOS
; Стандартная точка входа C815
; Вывод 16-ричного числа на экране
;
; На входе
;  A - число
;
; 2013-11-01 Дизассемблировано vinxru
;----------------------------------------------------------------------------

printHex:	push	psw
		rrc
		rrc
		rrc
		rrc
		call	printHex_1
		pop	psw
printHex_1:	push	psw
		ani	0Fh
		cpi	10
		jm	printHex_2
		 adi	7
printHex_2:	adi	'0'
printCharA_popret:
		call	printCharA
pop_psw_ret:	pop	psw
		ret
