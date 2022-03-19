; ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
; Начальный загрузчик.
; (с) 22-11-2011 titus, vinxru
; Используется компилятор sjasm

	device ZXSPECTRUM48
begin:
	org 0h
	NOP            ; 00 Первые три байта идентичны, но они могут не прочитаться.
	NOP            ; 00
	NOP            ; 00
	LD DE, 11h     ; 11 11 00
	NOP            ; 00
	LD H, D	       ; 62
	LD H, D	       ; 62
	LD L, D	       ; 6A
	LD L, D	       ; 6A
	LD BC, 0AE01h  ; 01 01 AE (AE - это размер блока данных 0C1h - 13h)
	XOR (HL)       ; AE  
	JP 0x00C3      ; C3 C3 00
	NOP            ; 00

;----------------------------------------------------------------------------

	org 013h
        MACRO IB N
	incbin "loader1.bin",N,1
	incbin "loader1.bin",N,1
	ENDM
        MACRO I8 N
	IB N+0
	IB N+1
	IB N+2
	IB N+3
	IB N+4
	IB N+5
	IB N+6
	IB N+7
	ENDM
	I8 0
	I8 8
	I8 16
	I8 24
	I8 32
	I8 40
	I8 48
	I8 56
	I8 64
	I8 72
	IB 80
	IB 81
	IB 82
	IB 83
	IB 84
	IB 85
	IB 86

;----------------------------------------------------------------------------

	org 0C1h
	DEC HL        ; 2B
C2:	DEC HL        ; 2B
C3:	INC DE        ; 13
	INC DE        ; 13
	LD A,(DE)     ; 1A
	LD A,(DE)     ; 1A
	LD (HL),A     ; 77
	LD (HL),A     ; 77
	INC HL        ; 23
	INC HL        ; 23
	DEC B         ; 05
	DEC B         ; 05
	JP NZ,0x00C2  ; C2 C2 00
	NOP           ; 00
	LD DE, 0xC311 ; 11 11 C3
	JP 0          ; C3 00 00

end:
	savebin "loader0.bin", begin, end