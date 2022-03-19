;--------------------------------------------------------------------------
;               EQUATES
;-----------------------------------------------------------------------------

TIM		EQU	   HF_NUM
PORT_A          EQU        60H         ;8255 ÄÑêÖë èéêíÄ A
PORT_B          EQU        61H         ;8255 ÄÑêÖë èéêíÄ B
PORT_C          EQU        62H         ;8255 ÄÑêÖë èéêíÄ C
CMD_PORT        EQU        63H
INTA00          EQU        20H         ;8259 èéêí
INTA01          EQU        21H         ;8259 èéêí
EOI             EQU        20H
TIMER           EQU        40H
TIM_CTL         EQU        43H         ;ÄÑêÖë èéêíÄ ìèêÄÇãÖçàü íÄâåÖêÄ 8253
TIMER0          EQU        40H         ;8253 TIMER/CNTER 0 PORT ADDR
TIMER2          EQU        3FCH
TIM2_CTL        EQU        3FFH        ;8253 TIMER2 CONTROL PORT ADDR
TIMER20         EQU        3FCH        ;8253 TIMER/CNTER2 0 PORT ADDR
TMINT           EQU        01          ;TIMER 0 INTR RECVD MASK
DMA             EQU        00          ;ÄÑêÖë èéêíÄ êÖÉàëíêÄ äÄçÄãÄ 0 DMA
DMA_3_ADDR	EQU	   DMA+6       ; ÅÄáéÇõâ ÄÑêÖë äÄçÄãÄ 3 DMA
DMA_3_CNT	EQU	   DMA+7       ; ëóÖíóàä ëãéÇ äÄçÄãÄ 3 DMA
DMA08           EQU        08          ; ÄÑêÖë èéêíÄ êÖÉàëíêÄ ëíÄíìëÄ DMA
DMA_MASK	EQU	   DMA+10      ; êÖÉàëíê åÄëäà DMA
DMA_MODE	EQU	   DMA+11D     ; êÖÉàëíê êÖÜàåÄ DMA
DMA_F_F		EQU	   DMA+12D     ; DMA flip/flop
DMA_3_HIGH	EQU	   082H	       ; èéêí Ñãü 4 ëíÄêòàï ÅàíéÇ DMA

DMA_READ_CMD	EQU	   01001000B   ; MEM  --> Port
DMA_WRITE_CMD	EQU	   01000100B   ; Port --> MEM
MAX_PERIOD      EQU        540H
MIN_PERIOD      EQU        410H
KBD_IN          EQU        60H         ;ÄÑêÖë èéêíÄ ÇÇéÑÄ ÑÄççõï ë äãÄÇàÄíìêõ
KBDINT          EQU        02          ;åÄëäÄ èêÖêõÇÄçàâ äãÄÇàÄíìêõ
KB_DATA         EQU        60H         ;èéêí ëäÄç-äéÑéÇ äãÄÇàÄíìêõ
KB_CTL          EQU        61H         ;CONTROL BITS FOR KEYBOARD SENSE DATA

SENSE_FAIL	EQU	   0FFH	       ; Sense oparation failed
STATUS_ERR	EQU	   0E0H	       ; Stattus Error/Error REG=0
WRITE_FAULT	EQU	   0CCH	       ; Write Fault on selected drive
UNDEF_ERR	EQU	   0BBH	       ; Undefined error occurred
DRIVE_NOT_RDY	EQU	   0AAH	       ; Drive Not Ready
BAD_CNTLR	EQU	   020H	       ; Controller has failed
DATA_CORRECTED	EQU	   011H	       ; ECC corrected data error
BAD_ECC		EQU	   010H	       ; Bad ECC on disk read
BAD_TRACK	EQU	   00BH	       ; Bad tracek flag detected
INIT_FAIL	EQU	   007H	       ; Drive parameter activity failed
BAD_RESET	EQU	   005H	       ; Reset failed

LONG_FLAG	EQU	   0010B	; LONG opn active
MULT_TRANS	EQU	   0100B	; Multiple Sector flag
RESTORE_CMD	EQU	   10H+WDC_RATE
SEEK_CMD	EQU	   70H+WDC_RATE
READ_CMD	EQU	   28H+MULT_TRANS	; Retries Enable
WRITE_CMD	EQU	30H+MULT_TRANS	; Retries Enable
RD_LONG_CMD	EQU	READ_CMD+LONG_FLAG  ;
WR_LONG_CMD	EQU	WRITE_CMD+LONG_FLAG ;
SCAN_ID_CMD	EQU	40H		; Retries Enable
WR_FORMAT_CMD	EQU	50H
	GAP_1	EQU	30D		; GAP length for format
COMPUTE_CMD	EQU	08H
SET_PARM_CMD	EQU	00H		; 5-bit Span

;-----------------DISKETTE EQUATES
MEDIA_CHANGE            EQU     06H                     ; MEDIA REMOVED ON DUAL ATTACH CARD
MAX_DRV                 EQU     002H                    ; MAX NUMBER OF DRIVES
HOME                    EQU     010H                    ; TRACK 0 MASK
SENSE_DRV_ST            EQU     004H                    ; SENSE DRIVE STATUS COMMAND
TRK_SLAP                EQU     030H                    ; CRASH STOP (48 TPI DRIVES)
QUIET_SEEK              EQU     00AH                    ; SEEK TO TRACK 10
HD12_SETTLE             EQU     015D                    ; 1.2 M HEAD SETTLE TIME
HD320_SETTLE            EQU     020D                    ; 320 K HEAD SETTLE TIME
;---------DISK CHANGE LINE EQUATES
NOCHGLN                 EQU     001H                    ; NO DISK CHANGE LINE AVAILABLE
CHGLN                   EQU     002H                    ; DISK CHANGE LINE AVAILABLE

WDC_RATE	EQU	0000B 	; 35 mkS
LONG_FLAG	EQU	0010B	; LONG opn active
MULT_TRANS	EQU	0100B	; Multiple Sector flag
RESTORE_CMD	EQU	10H+WDC_RATE
SEEK_CMD	EQU	70H+WDC_RATE
READ_CMD	EQU	28H+MULT_TRANS	; Retries Enable
WRITE_CMD	EQU	30H+MULT_TRANS	; Retries Enable
RD_LONG_CMD	EQU	READ_CMD+LONG_FLAG  ;
WR_LONG_CMD	EQU	WRITE_CMD+LONG_FLAG ;
SCAN_ID_CMD	EQU	40H		; Retries Enable
WR_FORMAT_CMD	EQU	50H
	GAP_1	EQU	30D		; GAP length for format
COMPUTE_CMD	EQU	08H
SET_PARM_CMD	EQU	00H		; 5-bit Span



WDC_PORT		EQU	1F0H       ;320H
HD_PORT			EQU	1F8H       ;328H
DSEL_0_BIT              EQU	00001000B
HD_RES_BIT	        EQU	00100000B
IR_DMA_EN	        EQU	01000000B
BF_RES_BIT	        EQU	10000000B
LONG_MODE_BIT	        EQU	40H		; !!!
I64_FMT_CMD	        EQU	01010000B ; Format command

FD_INT_NO		EQU	0DH	; Hardware INT vector
INT_CTL_PORT		EQU	20H	; 8259 Control port
EOI			EQU	20H	; END OF INTERRUPT command
FD_INT_MASK		EQU	(1 SHL (FD_INT_NO-8))	;


;----------------------------------------------------------------------------
;         8088 INTERRUPT LOCATIONS
;----------------------------------------------------------------------------
ABS0		segment	at	0
STG_LOC0        LABEL     BYTE
       ORG      2*4
NMI_PTR         LABEL     WORD
       ORG      5*4
INT5_PTR        LABEL     WORD
       ORG      8*4
INT_ADDR        LABEL     WORD
INT_PTR         LABEL     DWORD
	ORG	0aH*4
RTC_INT_1	LABEL	  WORD
       ORG      FD_INT_NO * 4
HDISK_VEC       LABEL     DWORD
       ORG      10H*4
VIDEO_INT       LABEL     WORD        ;video_int
       ORG      13H*4                  ; DISK INTERRUPT VECTOR
ORG_VECTOR      LABEL     DWORD
       ORG      15H*4                  ; FOR DEBUG ONLY
H15_VEC         LABEL     DWORD
       ORG      19H*4
BOOT_VEC       LABEL     DWORD
       ORG      1DH*4
PARM_PTR        LABEL     DWORD        ;POINTER TO VIDEO PARMS
       ORG      1CH*4
TIM_PTR         LABEL     WORD
       ORG      1EH*4
DISK_POINTER    LABEL     DWORD        ;INTERRUPT 1EH
       ORG      1FH*4
EXT_PTR LABEL   DWORD                  ;POINTER TO EXTENSION
       ORG      40H*4
DISK_VECTOR     LABEL     WORD
       ORG      41H*4
HF_TBL_VEC      LABEL     DWORD
       ORG      42H*4
VEC_42          LABEL     WORD
       	ORG	46H*4			; Fixed Disk 2 parameter vector
HF2_TBL_VEC	label	  DWORD
	ORG	4AH*4
ALARM1		label	  WORD
       ORG      472H
ABS_RESET_FLAG	label	Word		; RESET_FLAG relative ABS0
       ORG      475H
FD_NUM          LABEL     BYTE
       ORG      400H
DATA_AREA       LABEL     BYTE         ;ABSOLUTE LOCATION OF DATA SEGMENT
DATA_WORD       LABEL     WORD
       ORG      0500H
MFG_TEST_RTN    LABEL     FAR
       ORG      7C00H
BOOT_LOCN       LABEL     FAR
       ORG      7DFDH
BOOT_DRIVE_NO   LABEL     BYTE
ABS0	EndS

;-----------------------------------------------------------------------------
;          STACK -- USED DURING INITIALIZATION ONLY
;------------------------------------------------------------------------------

STACK	segment	at  30H

	DW	128 DUP(?)
TOS	label	WORD

STACK	EndS

;-----------------------------------------------------------------------------
;          ROM BIOS DATA AREAS
;------------------------------------------------------------------------------

DATA   SEGMENT    AT  40H
RS232_BASE        DW       4 DUP(?)      ;ADDRESSES OF R5232 ADAPTERS
PRINTER_BASE      DW       4 DUP(?)      ;ADDRESSES OF PRINTERS
EQUIP_FLAG        DW       ?             ;INSTALLED HARDWARE
MFG_TST           DB       ?             ;INITIALIZATION FLAG
MEMORY_SIZE       DW       ?             ;MEMORY SIZE IN K BYTES
MFG_ERR_FLAG      DB       ?             ;SCRATCHPAD FOR MANUFACTURING
                  DB       ?             ;ERROR CODES

;-----------------------------------------------------------------------------
;         KEYBOARD DATA AREAS
;------------------------------------------------------------------------------

KB_FLAG           DB       ?

;------SHIFT FLAG EQUATES WITHIN KB_FLAG

INS_STATE         EQU      80H          ;INSERT STATE IS ACTIVE
CAPS_STATE        EQU      40H          ;CAPS LOCK STATE HAS BEEN TOGGLED
NUM_STATE         EQU      20H          ;NUM LOCK STATE HAS BEEN TOGGLED
SCROLL_STATE      EQU      10H          ;SCROLL LOCK STATE HAS BEEN TOGGLED
ALT_SHIFT         EQU      08H          ;ALTERNATE SHIFT KEY DEPRESSED
CTL_SHIFT         EQU      04H          ;CONTROL SHIFT KEY DEPRESSED
LEFT_SHIFT        EQU      02H          ;LEFT SHIFT KEY DEPRESSED
RIGHT_SHIFT       EQU      01H          ;RIGHT SHIFT KEY DEPRESSED

KB_FLAG_1         DB       ?            ;SECOND BYTE OF KEYBOARD STATUS
INS_SHIFT         EQU      80H          ;INSERT KEY IS DEPRESSED
CAPS_SHIFT        EQU      40H          ;CAPS LOCK KEY IS DEPRESSED
NUM_SHIFT         EQU      20H          ;NUM LOCK KEY IS DEPRESSED
SCROLL_SHIFT      EQU      10H          ;SCKROLL LOCK KEY IS DEPRESSED
HOLD_STATE        EQU      08H          ;SUSPEND KEY HAS BEEN TOGGLED

ALT_INPUT         DB       ?            ;STORAGE FOR ALTERNATE KEYPAD ENTRY
BUFFER_HEAD       DW       ?            ;POINTER TO HEAD OF KEYBOARD BUFFER
BUFFER_TAIL       DW       ?            ;POINTER TO TAIL OF KEYBOARD BUFFER
KB_BUFFER         DW       16 DUP(?)    ; ROOM FOR IS ENTRIES
KB_BUFFER_END     LABEL    WORD

;-----HEAD = TAIL INDICATES THAT THE BUFFER IS EMPTY

NUM_KEY           EQU      69           ;SCAN CODE FOR NUMBER LOCK
SCROLL_KEY        EQU      70           ;SCROLL LOCK KEY
ALT_KEY           EQU      56           ;ALTERNATE SHIFT KEY SCAN CODE
CTL_KEY           EQU      29           ;SCAN CODE FOR CONTROL KEY
CAPS_KEY          EQU      58           ;SCAN CODE FOR SHIFT LOCK
LEFT_KEY          EQU      42           ;SCAN CODE FOR LEFT SHIFT
RIGHT_KEY         EQU      54           ;SCAN CODE FOR RIGHT SHIFT
INS_KEY           EQU      82           ;SCAN CODE FOR INSERT KEY
DEL_KEY           EQU      83           ;SCAN CODE FOR DELETE KEY

;----------------------------------------------------------------------------
;              DISKETTE DATA AREAS
;---------------------------------------------------------------------------
SEEK_STATUS        DB      ?             ;DRIVE RECALIBRATION STATUS
                                         ;BIT 3-0 = DRIVE 3-0 NEEDS RECAL
                                         ;BEFORE NEXT SEEK IF BIT IS=0

INT_FLAG           EQU     080H          ;INTERRUPT OCCURRENCE FLAG
MOTOR_STATUS       DB      ?             ;MOTOR STATUS
                                         ;BIT 3-0 = DRIVE 3-0 IS CURRENTLY
                                         ;RUNNING
                                         ;BIT 7 = CURRENT OPERATION IS A WRITE,
                                         ;REQUIRES DELAY

MOTOR_COUNT        DB      ?             ;TIME OUT COUNTER FOR DRIVE TURN OFF
MOTOR_WAIT         EQU     37            ;2 SECS OF COUNTS FOR
                                         ;MOTOR TURN OFF
DISKETTE_STATUS    DB      ?             ;RETURN CODE STATUS BYTE
TIME_OUT           EQU     80H           ;ATTACHMENT FAILED TO RESPOND
BAD_SEEK           EQU     40H           ;SEEK OPERATION FAILED
BAD_NEC            EQU     20H           ;NEC CONTROLLER HAS FAILED
BAD_CRC            EQU     10H           ;BAD CRC ON DISKETTE READ
DMA_BOUNDARY       EQU     09H           ;ATTEMPT TO DMA ACROSS 64K BOUNDARY
BAD_DMA            EQU     08H           ;DMA OVERRUN ON OPERATION
RECORD_NOT_FND     EQU     04H           ;REQUESTED SECTOR NOT FOUND
WRITE_PROTECT      EQU     03H           ;WRITE ATTEMPTED ON WRITE PROT DISK
BAD_ADDR_MARK      EQU     02H           ;ADDRESS MARK NOT FOUND
BAD_CMD            EQU     01H           ;BAD COMMAND PASSED TO
CMD_BLOCK          LABEL   BYTE          ;DISKETTE I/O
NEC_STATUS         DB      7 DUP(?)      ;STATUS BYTES FROM NEC

;---------------------------------------------------------------------------
;              VIDEO DISPLAY DATA AREA
;--------------------------------------------------------------------------
CRT_MODE           DB      ?             ;CURRENT CRT MODE
CRT_COLS           DW      ?             ;NUMBER OF COLUMNS ON SCREEN
CRT_LEN            DW      ?             ;LENGTH OF REGEN IN BYTES
CRT_START          DW      ?             ;STARTING ADDRESS IN REGEN BUFFER
CURSOR_POSN        DW      8 DUP(?)      ;CURSOR FOR EACH OF UP TO 8 PAGES
CURSOR_MODE        DW      ?             ;CURRENT CURSOR MODE SETTING
ACTIVE_PAGE        DB      ?             ;CURRENT PAGE BEING DISPLAYED
ADDR_6845          DW      ?             ;BASE ADDRESS FOR ACTIVE DISPLAY CARD
CRT_MODE_SET       DB      ?             ;CURRENT SETTING OF THE 3*8 REGISTER
CRT_PALETTE        DB      ?             ;CURRENT PALETTE SETTING COLOR CARD
;----------------------------------------------------------------------------
;  é°´†·‚Ï §†≠≠ÎÂ ™†··•‚≠Æ£Æ ¨†£≠®‚Æ‰Æ≠†  & POST DATA AREA
;----------------------------------------------------------------------------
IO_ROM_INIT	label	Word		;PNTR to optional I/O ROM INIT
					;ROUTINE
EDGE_CNT	DW	 ?		;TIME COUNT AT DATA EDGE
IO_ROM_SEG	label	Word		;POINTER to IO ROM SEGMENT
CRC_REG 	DW	 ?		;CRC REGISTER
INTR_FLAG	label	Byte		;FLAG to indicate an INTERRUPT
					;HAPPEND
LAST_VAL	DB	 ?		;LAST INPUT VALUE
;----------------------------------------------------------------------------
;            TIMER DATA AREA
;----------------------------------------------------------------------------
TIMER_LOW          DW       ?            ;LOW WORD OF TIMER COUNT
TIMER_HIGH         DW       ?            ;HIGH WORD OF TIMER COUNT
TIMER_OFL          DB       ?            ;TIMER HAS ROLLED OVER
                                         ;SINCE LAST READ
;COUNTS_SEC        EQU      18
;COUNTS_MIN        EQU      1092
;COUNTS_HOUR       EQU      65543
;COUNTS_DAY        EQU      1573040 = 1800B0H

;-----------------------------------------------------------------------------
;           SYSTEM DATA AREA
;-----------------------------------------------------------------------------
BIOS_BREAK         DB        ?           ;BIT 7=1 IF BREAK KEY HAS
                                         ;BEEN HIT
RESET_FLAG         DW        ?           ;WORD=1234H IF KEYBOARD
                                         ;RESET UNDERWAY
;------------------------------------%---------------------------------------
;           FIXED DISK DATA AREAS
;----------------------------------------------------------------------------
HDISK_STATUS       DB        ?
HF_NUM             DB        ?
CONTROL_BYTE       DB        ?
PORT_OFF           DB        ?
;-----------------------------------------------------------------------------
;          PRINTER AND R5232 TIME-OUT VARIABLES
;-----------------------------------------------------------------------------
PRINT_TIM_OUT      DB        4 DUP(?)
RS232_TIM_OUT      DB        4 DUP(?)
;-----------------------------------------------------------------------------
;           ADDITIONAL KEYBOARD DATA AREA
;-----------------------------------------------------------------------------
BUFFER_START       DW        ?
BUFFER_END         DW        ?
       ORG         8EH
HF_EOI             DB        ?       ;FIXED DISK INTERRUPT CONTROL
;-----------------------------------------------
;           ADDITIONAL FLOPPY DATA AREA
;-----------------------------------------------
                   ORG      8Bh
LASTRATE	   DB       1 DUP (?)

;-----------------------------------------------
;           ADDITIONAL HARD FILE DATA
;-----------------------------------------------

HF_STATUS	   DB	    1 DUP (?)  ;STATUS REGISTER
HF_ERROR	   DB	    1 DUP (?)  ;ERROR REGISTER
HF_INT_FLAG	   DB	    1 DUP (?)  ;HARD FILE INERRUPT FLAG
HF_CNTRL	   DB       1 DUP (?)  ;COMBO HARD FILE/FLOPPY CARD BIT 0-1

;-----------------------------------------------
;           ADDITIONAL DISKETTE AREA
;-----------------------------------------------
DSK_STATE		LABEL BYTE
		  DB        1 DUP (?)  ; DRIVE 0 MEDIA STATE
		  DB        1 DUP (?)  ; DRIVE 1 MEDIA STATE
		  DB        1 DUP (?)  ; DRIVE 0 OPERATION START STATE
		  DB        1 DUP (?)  ; DRIVE 1 OPERATION START STATE
DSK_TRK        	  DB        1 DUP (?)  ; DRIVE 0 PRESENT CYLINDER
                  DB        1 DUP (?)  ; DRIVE 1 PRESENT CYLINDER

;----------------------------------------------------------------------------
;  é°´†·‚Ï §†≠≠ÎÂ ™†··•‚≠Æ£Æ ¨†£≠®‚Æ‰Æ≠†
;----------------------------------------------------------------------------
	ORG	0ACH
LowLim          DW	?		;MIN Ñãàí. èÖêàéÑÄ "1"
LOAD_ADDR	DW	?
BUFFERM		DB	4 DUP (?)	; ®¨Ô ‰†©´† §´Ô ™†··•‚≠Æ£Æ ¨†£≠®‚Æ‰Æ≠†
UPPP		DB	?
RIG_1		DB	?
doww		db	?
lef_1		db	?
;--------------------------
; REAL TIME CLOCK DATA AREA
;--------------------------
	ORG 98H
USER_FLAG	 DW	1 DUP(?)	;OFFSET ADDR OF USERS WAIT FLAG
USER_FLAG_SEG	 DW	1 DUP(?)	;SEG ADDR OF USER WAIT FLAG
RTC_LOW 	 DW	1 DUP(?)	;LOW WORD OF USER WAIT FLAG
RTC_HIGH	 DW	1 DUP(?)	;HIGH WORD OF USER WAIT FLAG
RTC_WAIT_FLAG	 DB	1 DUP(?)	;WAIT ACTIVE FLAG

DATA     EndS
;----------------------------------------------------------------------------
;           EXTRA DATA AREA
;----------------------------------------------------------------------------
XXDATA SEGMENT AT   50H
STATUS_BYTE         DB       ?
XXDATA ENDS
;-----------------------------------------------------------------------------
;          VIDEO DISPLAY BUFFER
;-----------------------------------------------------------------------------
VIDEO_RAM          SEGMENT AT 0B800H
REGEN   LABEL      BYTE
REGENW  LABEL      WORD
        DB         16384 DUP(?)
VIDEO_RAM          ENDS
