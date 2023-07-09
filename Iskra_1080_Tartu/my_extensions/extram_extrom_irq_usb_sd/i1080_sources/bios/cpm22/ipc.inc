BOOT:   JP BIOS_BOOT
WBOOT:  JP BIOS_WBOOT
CONST:  JP BIOS_CONST
CONIN:  JP BIOS_CONIN
CONOUT: JP BIOS_CONOUT
LIST:   JP BIOS_LIST
PUNCH:  JP BIOS_PUNCH
READER: JP BIOS_READER
HOME:   JP BIOS_HOME
SELDSK: JP BIOS_SELDSK
SETTRK: JP BIOS_SETTRK
SETSEC: JP BIOS_SETSEC
SETDMA: JP BIOS_SETDMA
READ:   JP BIOS_READ
WRITE:  JP BIOS_WRITE
PRSTAT: JP BIOS_PRSTAT
SECTRN: JP BIOS_SECTRN

;----------------------------------------------------------------------------

MAX_FILES_COUNT = 128
MAX_BLOCKS_COUNT = 2048
MAX_DEVICES = 2

OPCODE_JP = 0xC3

PORT_WINDOW_0 = 0
PORT_WINDOW_1 = 1
PORT_WINDOW_2 = 2

PAGE_RAM_0 = 4 * 2
PAGE_RAM_1 = 5 * 2
PAGE_RAM_2 = 6 * 2

;----------------------------------------------------------------------------

SYSCALL_STACK = 100h

SYSCALL_INTERRUPT = 0  * 3 + 5
SYSCALL_WBOOT     = 1  * 3 + 5
SYSCALL_CONST     = 2  * 3 + 5
SYSCALL_CONIN     = 3  * 3 + 5
SYSCALL_CONOUT    = 4  * 3 + 5
SYSCALL_LIST      = 5  * 3 + 5
SYSCALL_PUNCH     = 6  * 3 + 5
SYSCALL_READER    = 7  * 3 + 5
SYSCALL_SELDSK    = 8  * 3 + 5
SYSCALL_SETTRK    = 9  * 3 + 5
SYSCALL_SETSEC    = 10 * 3 + 5
SYSCALL_READ      = 11 * 3 + 5
SYSCALL_WRITE     = 12 * 3 + 5
SYSCALL_PRSTAT    = 13 * 3 + 5

;----------------------------------------------------------------------------

RUN:
        ; Выбрать сраницы ОЗУ для CP/M
        DI
        LD A, PAGE_RAM_0
	OUT (PORT_WINDOW_0), a
	LD A, PAGE_RAM_1
	OUT (PORT_WINDOW_1), a
	LD A, PAGE_RAM_2
	OUT (PORT_WINDOW_2), a
        ; Окно 3 уже выбрано

        ; Установка обработчика прерываний
	LD A, OPCODE_JP
	LD (38h), A
	LD HL, INTERRUPT
	LD (39h), HL
        LD SP, CCPSTACK
        EI
	
        ; Настройка переменных CP/M
	LD (0), A
        LD HL, WBOOT
	LD (1), HL
	LD (5), A
	LD HL, FBASE
	LD (6), HL
        LD A, C
        LD (TDRIVE), A
        LD HL, TBUFF
        LD (BIOS_DMA), HL
        LD A, 81h
        LD (IOBYTE), A

        ; Запуск CP/M
	JP CBASE

;----------------------------------------------------------------------------

BIOS_DMA DW 0

;----------------------------------------------------------------------------

INTERRUPT:
    ; Save CPU state, switch stack and memory page
    PUSH AF
    PUSH HL
    LD HL, 0
    ADD HL, SP
    LD (INTERRUPT_SAVED_SP), HL
    LD SP, SYSCALL_STACK
    XOR A
    OUT (PORT_WINDOW_0), A
    LD A, 2
    OUT (PORT_WINDOW_1), A
    PUSH BC
    PUSH DE

    ; System call
    CALL SYSCALL_INTERRUPT

    ; Restore CPU state
    POP DE
    POP BC
    LD A, PAGE_RAM_0
    OUT (PORT_WINDOW_0), A
    LD A, PAGE_RAM_1
    OUT (PORT_WINDOW_1), A
INTERRUPT_SAVED_SP = $ + 1
    LD SP, 0
    POP HL
    POP AF

    ; End of interrupt handler
    EI
    RET

;----------------------------------------------------------------------------
        
BIOS_BOOT:
	DI
	LD A, 0FFh
	OUT (PORT_WINDOW_0), A
	JP 0

;----------------------------------------------------------------------------

BIOS_WBOOT:
	LD DE, SYSCALL_WBOOT
	JP SYSCALL

;----------------------------------------------------------------------------

BIOS_CONST:
    PUSH DE
	LD DE, SYSCALL_CONST
	JP SYSCALL

;----------------------------------------------------------------------------

BIOS_CONIN:
    PUSH DE
	LD DE, SYSCALL_CONIN
	JP SYSCALL

;----------------------------------------------------------------------------
	
BIOS_CONOUT:
        PUSH DE
        LD DE, SYSCALL_CONOUT
        JP SYSCALL

;----------------------------------------------------------------------------

BIOS_LIST:
    PUSH DE
	LD DE, SYSCALL_LIST
	JP SYSCALL
	
;----------------------------------------------------------------------------

BIOS_PUNCH:
    PUSH DE
	LD DE, SYSCALL_PUNCH
	JP SYSCALL
	
;----------------------------------------------------------------------------

BIOS_READER:
    PUSH DE
	LD DE, SYSCALL_READER
	JP SYSCALL

;----------------------------------------------------------------------------

BIOS_SELDSK2:
    PUSH DE
	LD DE, SYSCALL_SELDSK
	JP SYSCALL

;----------------------------------------------------------------------------

BIOS_SELDSK:
    ; Check device number
    LD A, C
    CP MAX_DEVICES
    LD HL, 0
    RET NC
    
    ; System call
    CALL BIOS_SELDSK2
    
    ; Check error
    OR A
    RET NZ
	
    ; Save current device number
    LD A, C
    LD (TDRIVE), A
	
    ; Return DPH address
    OR A
    LD HL, BIOS_DPH_A
    RET Z
    LD HL, BIOS_DPH_B    
    RET

;----------------------------------------------------------------------------

BIOS_SETTRK:
    PUSH DE
	LD DE, SYSCALL_SETTRK
	JP SYSCALL
	
;----------------------------------------------------------------------------

BIOS_HOME:
    PUSH BC
	LD BC, 0
	CALL BIOS_SETTRK
	POP BC
	RET
	
;----------------------------------------------------------------------------

BIOS_SETSEC:
    PUSH DE
	LD DE, SYSCALL_SETSEC
	JP SYSCALL

;----------------------------------------------------------------------------

BIOS_READ2:        
    PUSH DE
    LD DE, SYSCALL_READ
    JP SYSCALL
	
;----------------------------------------------------------------------------

BIOS_SETDMA:
    PUSH HL
    LD HL, BC
	LD (BIOS_DMA), HL
	POP HL
	RET
	
;----------------------------------------------------------------------------

BIOS_SECTRN:
	LD HL, BC
	RET

;----------------------------------------------------------------------------

BIOS_READ:
    CALL BIOS_READ2
    
	; Check error
	OR A
	RET NZ
	
    ; Copy data from the system call buffer	
    PUSH DE
    PUSH HL
	LD DE, BIOS_DMA_BUFFER
	LD HL, (BIOS_DMA)
BIOS_READ_1:	
	LD A, (DE)
	LD (HL), A
	INC HL
	INC E
	JP NZ, BIOS_READ_1
	POP HL
	POP DE
	
	; No error
	XOR A
	RET

;----------------------------------------------------------------------------

BIOS_WRITE:
    PUSH DE

    ; Copy data to the system call buffer
    PUSH HL
    LD DE, BIOS_DMA_BUFFER
    LD HL, (BIOS_DMA)
BIOS_WRITE_1:	
    LD A, (HL)
    LD (DE), A
    INC HL
    INC E
    JP NZ, BIOS_WRITE_1
    POP HL
	
    ; System call
    LD DE, SYSCALL_WRITE
    JP SYSCALL

;----------------------------------------------------------------------------

BIOS_PRSTAT:
        PUSH DE
        LD DE, SYSCALL_PRSTAT

SYSCALL:
        PUSH HL

        ; Save stack pointer
        LD HL, 0
        ADD HL, SP
        LD (BIOS_SAVED_SP), HL

        ; Switch RAM and stack pointer
        XOR A
        DI
        LD SP, SYSCALL_STACK
        OUT (PORT_WINDOW_0), A
        LD A, 2
        OUT (PORT_WINDOW_1), A
        EI

        ; System call
        EX HL, DE
        PUSH BC
        CALL CALL_HL
        POP BC

        ; Switch RAM and stack pointer
        LD A, PAGE_RAM_0
        DI
        OUT (PORT_WINDOW_0), A
        LD A, PAGE_RAM_1
        OUT (PORT_WINDOW_1), A
BIOS_SAVED_SP = $ + 1
        LD SP, 0
        EI

        ; Return
        LD A, D
        POP HL
        POP DE
        RET

;----------------------------------------------------------------------------
        
CALL_HL:
	JP HL

;----------------------------------------------------------------------------

BIOS_DPB_A DB 28h, 0, 4, 0Fh, 0, 8Ah, 1, 3Fh, 0, 080h, 0, 10h, 0, 2, 0
BIOS_DPB_B DB 28h, 0, 4, 0Fh, 0, 8Ah, 1, 3Fh, 0, 080h, 0, 10h, 0, 2, 0
BIOS_DIRBUF DS 128
BIOS_CSV_A DS MAX_FILES_COUNT / 4
BIOS_CSV_B DS MAX_FILES_COUNT / 4
BIOS_ALV_A DS MAX_BLOCKS_COUNT / 8
BIOS_ALV_B DS MAX_BLOCKS_COUNT / 8

; CP/M BIOS buffers

		DS 0x10000 - 128 - 16 * MAX_DEVICES - $
	
BIOS_DPH_A DS 8
           DW BIOS_DIRBUF
           DW BIOS_DPB_A
           DW BIOS_CSV_A
           DW BIOS_ALV_A
           
BIOS_DPH_B DS 8
           DW BIOS_DIRBUF
           DW BIOS_DPB_B
           DW BIOS_CSV_B
           DW BIOS_ALV_B

BIOS_DMA_BUFFER DS 128
