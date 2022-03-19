; ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
; Разархиватор MegaLZ
; (с) b2m, vinxru, группа mayhem...
; Используется компилятор sjasm

		device zxspectrum48
		include "unmlz_org.inc"

begin:
	ADD A
	JP NC, XX
	  LD HL, V_BANKH1+1
	  LD (HL), 1  ; BANK
XX:     
	LD (V_BANKL1+1), A  ; BANK
	INC A
	LD (V_BANKL2+1), A  ; BANK

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

READBYTE:	LD A, D
		LD (0EE02h), A 
		LD A, E
V_BANKL1:	CP 0                  ; тут находятся 7 бит банка (*2)
		JP Z, IGNOREBYTE      ; Пропускаем диагональные байты
NOIGNOREBYTE:	LD (0EE01h), A 
V_BANKH1:	LD A, 0               ; тут находится старший бит банка
		LD (0EE02h), A 
V_BANKL2:	LD A, 1               ; тут находится 7 бит банка (*2+1)
		LD (0EE01h), A
		LD A, (0EE00h) 		
		SCF
		INC E
		INC E
		RET NZ                  

;----------------------------------------------------------------------------
; Пересекли границу 128 байт

INCBANK:        INC D
		RET NZ

		; Пересекли границу 2048 байт

		PUSH AF
		PUSH BC
		PUSH DE
		PUSH HL
		LD C, '.'
		CALL 0F809h
		POP HL
		POP DE
		POP BC
		POP AF

		; Увеличиваем счетчики банков

		PUSH AF

		LD A, (V_BANKL2+1)
		INC A
		JP Z, INCBANK1
INCBANK2:       LD (V_BANKL1+1), A
		INC A
		LD (V_BANKL2+1), A
		POP AF

		; Адрес чтения
		LD DE, 0F000h
		SCF
		RET

;----------------------------------------------------------------------------
; Пересекли границу 256 Кб

INCBANK1:       PUSH HL
	        LD HL, V_BANKH1+1
 	        INC (HL)
	        POP HL
		JP INCBANK2

;----------------------------------------------------------------------------
; Пропускаем диагональные байты

IGNOREBYTE:     LD A, D          ; Пропускаем только адреса 0-128
		AND 0Fh		 
		LD A, E
		JP NZ, NOIGNOREBYTE		
                INC E
		INC E
		CALL Z, INCBANK
		JP READBYTE

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