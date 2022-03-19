; ROM-диск Апогей БК01 на основе стандартных ПЗУ
; Разархиватор MegaLZ
; (с) b2m, vinxru, группа mayhem...
; Используется компилятор sjasm

	device zxspectrum48
	include "unmlz_org.inc"

begin:
	; Выбор банка ПЗУ
	ld hl, 0EE01h
	ld (hl), a
	ld (BANK+1), a
	inc hl
	xor a
	ld (hl), a
	ld (hl), 80h
	ld (hl), a
	
	LD A,80h
UNLD:	LD (BITS), A
	CALL READBYTE
	JP UNSTA

UNST3:	LD A,(HL)
	INC HL
	LD (BC), A
	INC BC
UNST2:  LD A,(HL)
	INC HL
	LD (BC), A
	INC BC
UNST1:	LD A,(HL)
UNSTA:	LD (BC), A
	INC BC
ULOOP:	LD A, (BITS)
	ADD A
	JP NZ,  L1
	CALL READBYTE
	RLA
L1:	JP C,  UNLD
	ADD A
	JP NZ,  L3
	CALL READBYTE
	RLA ; RAL
L3:	JP C,  UN2
	ADD A
	JP NZ,  L2
	CALL READBYTE
	RLA
L2:	JP C,  UN1
	LD HL,3FFFh
	CALL GETBITS
	LD (BITS), A
	ADD HL, BC
	JP UNST1
UN1:    LD (BITS), A
	CALL READBYTE
	LD L,A
	LD H,0FFh
	ADD HL, BC
	JP UNST2
UN2:	ADD A
	JP NZ,  L4
	CALL READBYTE
	RLA
L4:	JP C,  UN3
	CALL GETBIGD
	ADD HL, BC
	JP UNST3
UN3:	LD H,0
UN3A:	INC H
	ADD A
	JP NZ,  L5
	CALL READBYTE
	RLA
L5:	JP NC,  UN3A
	PUSH AF
	LD A,H
	CP 8
	JP NC,  UNEXIT
	LD A,0
	RRA
	DEC H
	JP NZ,  $-2
	LD H,A
	LD L,1
	POP AF
	CALL GETBITS
	INC HL
	INC HL
	PUSH HL
	CALL GETBIGD
	EX DE, HL ; XCHG
	EX (SP), HL ; XTHL
	EX DE, HL ; XCHG
	ADD HL, BC
LDIR:	LD A, (HL)
	INC HL
	LD (BC), A
	INC BC
	DEC E
	JP NZ,  LDIR
	POP DE
	JP ULOOP
UNEXIT:	POP AF
	CALL 0FACEh
	LD C, 1Fh
	CALL 0F809h
	RET

GETBITS:ADD A
	JP NZ,  L7
	CALL READBYTE
	RLA ; RAL
L7:	JP C,  GETB1
	ADD HL, HL
	RET C
	JP GETBITS
GETB1:	ADD HL, HL
	INC L
	RET C
	JP GETBITS

GETBIGD:ADD A
	JP NZ,  L8
	CALL READBYTE
	RLA
L8:	JP C,  GETBD1
	LD (BITS), A
	CALL READBYTE
	LD L,A
	LD H,0FFh
	RET

GETBD1:	LD HL,1FFFh
	CALL GETBITS
	LD (BITS), A
	LD H,L
	DEC H
	CALL READBYTE
	LD L,A
	RET

BITS DB 80h

;----------------------------------------------------------------------------
; Чтение байта из ПЗУ
; Вызывающая программа хранит и не изменяет DE.
; DE - это смещение от F000 до FFFF c шагом 2.

READBYTE:	LD A, E
		LD (0EE01h), A
		LD A, D
		LD (0EE02h), A
		LD A, (0EE00h)
		INC E
		RET NZ
		INC D
		
		PUSH AF
		LD A, D
		AND 7
		CALL Z, PRINTDOT
		POP AF

		RET NS

		PUSH AF
		
BANK:		  LD A, 1
		  INC A		
		  ld (BANK+1), a
		  ld (0EE01h), a
		  xor a
		  ld (0EE02h), a
		  ld a, 80h
		  ld (0EE02h), a
		  xor a
		  ld (0EE02h), a
		POP AF
		LD DE, loader0end-loader0 ; Размер нулевого загрузчика
		RET

;----------------------------------------------------------------------------

PRINTDOT:       PUSH BC
		PUSH DE
		PUSH HL
		LD C, '.'
		CALL 0F809h
		POP HL
		POP DE
		POP BC
		RET

;----------------------------------------------------------------------------

end:
CORRECT_ORG = 0E000H-(end-begin)
	db 9, "org "
	db (CORRECT_ORG/10000)%10 + '0'
	db (CORRECT_ORG/1000)%10 + '0'
	db (CORRECT_ORG/100)%10 + '0'
	db (CORRECT_ORG/10)%10 + '0'
	db (CORRECT_ORG/1)%10 + '0'

orgFileEnd:	
	savebin "unmlz_org.inc",end,orgFileEnd-end
	DUP 0E000H-end+1
	EDUP REPT
	DUP end+0E000H+1
	EDUP REPT
	DISPLAY 0E000H-end, ' ', end-0E000H, ' ', 0E000H-(end-begin)
	
	savebin "unmlz.bin",begin,end-begin

loader0:	incbin "loader0.bin"
loader0end:
