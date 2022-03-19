;--------------------------------------------------------------------------
;               EQUATES
;-----------------------------------------------------------------------------

PORT_A          EQU        60H         ;8255 PORT A ADDR
PORT_B          EQU        61H         ;8255 PORT B ADDR
PORT_C          EQU        62H         ;8255 PORT C ADDR
CMD_PORT        EQU        63H
INTA00          EQU        20H         ;8259 PORT
INTA01          EQU        21H         ;8259 PORT
EOI             EQU        20H
TIMER           EQU        40H
TIM_CTL         EQU        43H         ;8253 TIMER CONTROL PORT ADDR
TIMER0          EQU        40H         ;8253 TIMER/CNTER 0 PORT ADDR
TIMER2          EQU        3FCH
TIM2_CTL        EQU        3FFH        ;8253 TIMER2 CONTROL PORT ADDR
TIMER20         EQU        3FCH        ;8253 TIMER/CNTER2 0 PORT ADDR
TMINT           EQU        01          ;TIMER 0 INTR RECVD MASK
DMA             EQU        00          ;DMA CH.0 ADDR. REG PORT ADDR
DMA_3_ADDR	EQU	DMA+6	; DMA channel 3 base addres
DMA_3_CNT	EQU	DMA+7	; DMA channel 3 word count
DMA08           EQU        08          ;DMA STATUS REG PORT ADDR
DMA_MASK	EQU	DMA+10	; DMA mask register
DMA_MODE	EQU	DMA+11D	; DMA mode register
DMA_F_F		EQU	DMA+12D	; DMA flip/flop
DMA_3_HIGH	EQU	082H	; Port for high 4 bits of DMA

DMA_READ_CMD	EQU	01001000B ; MEM  --> Port
DMA_WRITE_CMD	EQU	01000100B ; Port --> MEM
MAX_PERIOD      EQU        540H
MIN_PERIOD      EQU        410H
KBD_IN          EQU        60H         ;KEYBOARD DATA IN ADDR PORT
KBDINT          EQU        02          ;KEYBOARD INTR MASK
KB_DATA         EQU        60H         ;KEYBOARD SCAN CODE PORT
KB_CTL          EQU        61H         ;CONTROL BITS FOR KEYBOARD SENSE DATA
SENSE_FAIL	EQU	0FFH	; Sense oparation failed
STATUS_ERR	EQU	0E0H	; Stattus Error/Error REG=0
WRITE_FAULT	EQU	0CCH	; Write Fault on selected drive
UNDEF_ERR	EQU	0BBH	; Undefined error occurred
DRIVE_NOT_RDY	EQU	0AAH	; Drive Not Ready
BAD_CNTLR	EQU	020H	; Controller has failed
DATA_CORRECTED	EQU	011H	; ECC corrected data error
BAD_ECC		EQU	010H	; Bad ECC on disk read
BAD_TRACK	EQU	00BH	; Bad tracek flag detected
INIT_FAIL	EQU	007H	; Drive parameter activity failed
BAD_RESET	EQU	005H	; Reset failed

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


;WDC_PORT		EQU	320H
;HD_PORT			EQU	328H
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


