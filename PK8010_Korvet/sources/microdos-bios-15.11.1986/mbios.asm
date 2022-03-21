;
	PAGE	0
;
; CBIOS for MICRODOS
;
CDISK	EQU	0004H
IOBYTE	EQU	0003H
BUFF	EQU	80H
;
OSYSREG	EQU	0FF7FH
OSCONF	EQU	5CH
GRAPCONF EQU	3CH
DRSYSREG EQU	0FA7FH
DRCONF	EQU	14H
NCREG	EQU	0FFBFH
COLORMD	EQU	80H
;
DRCONST	EQU	0046H
DRCONIN	EQU	0049H
DRCONOUT EQU	004CH
;
DRVREG	EQU	0FE39H	; Drive register addresss
FDC	EQU	0FE18H	; FDC base address
;
LSTDATA	EQU	0FE30H
LSTCONT	EQU	0FE33H
LSTST	EQU	0FE38H
LSTRDY	EQU	00000100B
STBSET	EQU	00001011B
STBRST	EQU	00001010B
;
;		    FDC parameters and commands
MAXRET	EQU	04H	; Max number of retries
DRNUM	EQU	02H	; Number of drives
;
RESTOCMD	EQU	08H
STEPICMD	EQU	48H
STEPOCMD	EQU	68H
STEPCMD 	EQU	28H
RDSECCMD	EQU	84H
WRSECCMD	EQU	0A4H
FORCECMD	EQU	0D0H
;
;
	ORG	0E600H	;origin of this program
;
;	     jump vector for individual subroutines
;
	JMP	BOOT
	JMP	WBOOT
	JMP	CHRSTAT
	JMP	CHRIN
	JMP	CHROUT
	JMP	SELDSK
	JMP	DISKIO
	JMP	RETMSG
	JMP	RESCOM
;
;	fixed data tables for two-drive standard
;	IBM-compatible 5" disks
;       disk parameter header for disk 00
DPBASE:
DPH0	DW	0000H,0000H
	DW	0000H,0000H
	DW	DIRBUF,DPBLK00+16
	DW	CHK00,ALL00
;	disk parameter header for disk 01
DPH1	DW	0000H,0000H
	DW	0000H,0000H
	DW	DIRBUF,DPBLK01+16
	DW	CHK01,ALL01
;
;   This disk parameter block is written 
;   for 5" 80 track DS/DD
;         Tot. cap = 784 Kbytes
;         128 : 32 bytes dir entries
;         2048 bytes/block
;         5 sect/track, 1024 bytes/sect
;
DPBLK00	DB	0,0	; Flag for presence of info 
			;  ( Load address )
	DW	0	; Starting sector to load
	DW	0	; Number of physical sectors to load
	DB	00H	; 8"/5"
	DB	01H	; Double density 
			;  ( 00 - single density
			;    01 - double density )
	DB	01H	; 96 tpi    ( 00 - 48 tpi
			;             01 - 96 tpi
			;             02 - 135 tpi )
	DB	01H	; Sector skew factor
			;( 00 - use translation table in
			;	bytes 32 -127
			;  01 - no skew
			;  nn - use translation table in 
			;	bytes 32-127 )
	DB	03H	; 1024 bytes/sector 
			;( 00 - 128 bytes/sector
			;  01 - 256 bytes/sector
			;  02 - 512 bytes/sector
			;  03 - 1024 bytes/sector )
	DB	01H	; Sector placement info
			;( 00 - single sided disk
			;  01 -sector numbered from 
			;      1 to n on each side
			;  02 -sector numbers 
			;      continued on next side)
	DW	05H	; Sectors/track
	DW	80	; Tracks/side
;		        CP/M parameters
	DW	40  ; 128 bytes sectors per track; SPT
	DB	4   ; block shift factor         ; BSH
	DB	15  ; block mask                 ; BLM
	DB	00H ; extent mask                ; EXM
	DW	391 ; disk size -1               ; DSM
	DW	127 ; directory max -1           ; DRM
	DB	0C0H; alloc 0                    ; AL0
	DB	00H ; alloc 1                    ; AL1
	DW	32  ; check size                 ; CKS
	DW	3   ; track offset               ; OFS
	DB	2FH ; Checksum
;
DPBLK01	DB	0,0	; Flag for presence of info
	DW	0	; Starting sector to load
	DW	0	; Number of physical sectors to load
	DB	00H	; 8"/5"
	DB	01H	; Double density  
			;	( 00 - single density
			;  	  01 - double density )
	DB	01H	; 96 tpi  ( 00 - 48 tpi
			;           01 - 96 tpi
			;           02 - 135 tpi )
	DB	01H	; Sector skew factor 
			;( 00 - use translation table 
			;	in bytes 32 -127
			;  01 - no skew
			;  nn - use translation table 
			;	in bytes 32-127 )
	DB	03H	; 1024 bytes/sector   
			;( 00 - 128 bytes/sector
			;  01 - 256 bytes/sector
			;  02 - 512 bytes/sector
	                ;  03 - 1024 bytes/sector )
	DB	01H	; Sector placement info
			;( 00 - single sided disk
			;  01 -sector numbered from 1 
			;      to n on each side
			;  02 - sector numbers continued 
			;	on next side )
	DW	05H	; Sector/track
	DW	80	; Tracks/side
;		        CP/M parameters
	DW	40 ; 128 bytes sectors per track  ; SPT
	DB	4  ; block shift factor          ; BSH
	DB	15 ; block mask                   ; BLM
	DB	00H; extent mask                  ; EXM
	DW	391; disk size -1                 ; DSM
	DW	127; directory max -1             ; DRM
	DB	0C0H; alloc 0                     ; AL0
	DB	0  ; alloc 1                      ; AL1
	DW	32 ; check size                   ; CKS
	DW	3  ; track offset                 ; OFS
	DB	2FH; Checksum
;
BOOT	DI
	MVI	A,OSCONF
	STA	DRSYSREG
	XRA	A
	STA	DPBLK00	; Set " Wrong Info " Flag
	STA	DPBLK01	;        Too
	STA	UNALLO	;Clear "Write to unallocated block"
	STA	IOBYTE	; clear the iobyte
	STA	CDISK	; select disk zero
	STA	ERRFL 	; Clear error flag
	LXI	H,0FFFFH
	SHLD	SECRDB
	SHLD	SECWRB
	EI
	RET
;
WBOOT	MVI	A,GRAPCONF
	STA	OSYSREG
	MVI	A,COLORMD
	STA	NCREG
	LXI	H,0
	DAD	SP
	LXI	SP,8000H
	LXI	B,0-400H
	LXI	D,0FFFFH
CLRGR	PUSH	D
	PUSH	D
	PUSH	D
	PUSH	D
	PUSH	D
	PUSH	D
	PUSH	D
	PUSH	D
	INR	C
	JNZ	CLRGR
	INR	B
	JNZ	CLRGR
	SPHL
	CALL	FLUSH
	LXI	H,0FFFFH
	SHLD	SECRDB	; by making wrong buffer info
	SHLD	SECWRB	; for write buffer too
	XRA	A      	; Say " There is no info ### "
	STA	DPBLK00	; For drive 0
	STA	DPBLK01	; FOR DRIVE 1
	STA	BUFFAC   ; Make Write buffer inactive
	STA	ERRFL    ; Clear error flag
	MVI	A,STBRST
	STA	LSTCONT
	RET
;
CHRSTAT	MOV	A,D
	ORA	A
	JZ	CONST
	DCR	A
	JZ	LISTST
	SUB	A
	RET
;
CONST	LXI	D,DRCONST
	JMP	DRCALL
;
LISTST	LDA	LSTST
	ANI	LSTRDY
	RZ
	CMA
	RET
;
CHRIN	MOV	A,D
	ORA	A
	JZ	CONIN
	MVI	A,1AH
	RET
;
CONIN	LXI	DRCONIN
	JMP	DRCALL
;
CHROUT	MOV	A,D
	ORA	A
	JZ	CONOUT
	DCR	A
	JZ	LISTOUT
	RET
;
CONOUT	LXI	D,DRCONOUT
DRCALL	DI
	LXI	H,0
	DAD	SP
	SHLD	SAVESTC
	LXI	SP,CSTACK
	EI
	LXI	H,OSYSREG
	MVI	M,DRCONF
	LXI	H,DRET
	PUSH	H
	XCHG
	PCHL
DRET	LXI	H,DRSYSREG
	MVI	M,OSCONF
	LHLD	SAVESTC
	SPHL
	RET
;
SAVESTC	DW	0
	DS	10H
CSTACK
;
LISTOUT	LDA	LSTST
	ANI	LSTRDY
	JZ	LISTOUT
	MOV	A,C
	CMA
	STA	LSTDATA
	LXI	H,LSTCONT
	MVI	M,STBSET
	MVI	M,STBRST
	RET
;
SELDSK	MOV	A,C
	LXI	H,DPH0
	ORA	A
	RZ
	LXI	H,DPH1
	DCR	A
	RZ
	LXI	H,0
	RET
;
DISKIO	MOV	A,C
	STA	WRTYPE
	CALL	GETINFO
	ORA	A
	RNZ
	CALL	LTOF
	INX	H
	INX	H
	MOV	A,M	; λοδ οπεςαγιι
	INX	H
	INX	H
	INX	H
	INX	H
	MOV	E,M
	INX	H
	MOV	D,M
	CPI	RDOP
	JZ	DISKRD
	CPI	WROP
	JZ	DISKWR
	MVI	A,0FFH
	RET
;
DISKRD	PUSH	D	; αδςεσ πδπ
	LXI	D,SEEKPARM
	LXI	H,WRPARM
	CALL	CMPARM
	LXI	D,WRBUF
	JZ	RDMOV
	LXI	D,SEEKPARM
	LXI	H,RDPARM
	CALL	CMPARM
	LXI	D,RDBUF
	JZ	RDMOV
	MVI	C,LENPARM
	LXI	D,SEEKPARM
	LXI	H,RDPARM
	CALL	MOVHD
	LXI	H,RDPARM
	CALL	SETDSK
	LXI	H,RDBUF
	CALL	DTOM
	LXI	D,RDBUF
	ORA	A
	JZ	RDMOV
	POP	H
	LXI	H,RDPARM
	MVI	M,0FFH
	RET
RDMOV	LHLD	SEEKPARM+LENPARM
	DAD	D
	XCHG
	POP	H
	MVI	C,LENS
	CALL	MOVHD
	SUB	A
	RET
;
;		perform a write operation
;
WRITE	MOV	A,C
	STA	WRTYPE 	; Save hint from BDOS
	CALL	GETINFO	; Get info about disk
	ORA	A
	RNZ		; Exit to BDOS if error
	CALL	LTOF 	; Convert to actual disk parameters
	LDA	WRTYPE 	; Get write type info
	CPI	01H 	; Directory write ?
	JNZ	WR1
;		   Directory write
;	Flush buffer if it was active. Then read buffer, 
;	transfer bytes and write back
	XRA	A
	STA	UNALLO 	; Mark write buffer as unallocated !
	LXI	H,DSKSEK
	LXI	D,DSKWRB
	LXI	B,6
	CALL	HLSUBDE
	JZ	WRD1 	; If there is sector in buffer - you 
;			  needn't read it again
	CALL	FLUSH 	; If buffer was active - flush it
	ORA	A
	RNZ		; Exit if error
	LXI	D,SECSEK
	LXI	H,SECWRB
	LXI	B,6
	CALL	DETOHL 	; Make a new buffer
	CALL	PREREAD	; Read buffer from disk
			; ( May be get from read buffer )
;		Make transfer and then write buffer
WRD1	CALL	CPTOBUF	; Transfer bytes to write buffer
	JMP	FLUSH 	; And write buffer
WR1	ORA	A 	; Is A = 0 ?
	JNZ	WR2 	; If not - there will be
			;" WRITE TO UNALLOC. " type
;	Writing to ordinary sector ( may be to unallocated )
	LXI	D,DSKWRB
	LXI	H,DSKSEK
	LXI	B,6
	CALL	HLSUBDE	; Is desired record in buffer ?
	JZ	CPTOBUF	; If so - transfer and exit
;	There is no record in buffer - flush old buffer
	CALL	FLUSH
	ORA	A
	RNZ			; If error - exit
;	If unalloc. flag   and   we are in unalloc. block -
;		make buffer and write into it
	LDA	UNALLO
	ORA	A 	; Unallocated block ?
	JZ	WRU1 	; No - make an ordinary pre-read
	LXI	D,DSKCPM
	LXI	H,DSKBLS
	LXI	B,5 	; Compare five bytes
	CALL	DESUBHL	; Is current track and sector lower 
;			  than start of unallocated ?
	JC	WRU1 	; Not in bounds - 
			; make an ordinary read-modify cycle
	LXI	D,DSKCPM
	LXI	H,DSKBLE
	LXI	B,5
	CALL	HLSUBDE	; Is end of unallocated block
			; lower than current ?
	JC	WRU1 	; Not in bounds - go
; Next sector is unallocated one - the pre-read is unnesessary
	LXI	D,SECSEK
	LXI	H,SECWRB
	LXI	B,6
	CALL	DETOHL 	; Make a new buffer
	JMP	CPTOBUF	; and write into it
WRU1	XRA	A
	STA	UNALLO 	; Mark - no unallocated block
	LXI	D,SECSEK
	LXI	H,SECWRB
	LXI	B,6
	CALL	DETOHL	; Make a new buffer
	CALL	PREREAD	; Fill write buffer
;	Make transfer and exit
	JMP	CPTOBUF	; Transfer bytes to write buffer
;	BDOS has signalled - unallocated block begins
;	Calculate start and end of such block
WR2	CALL	FLUSH 	; Write old buffer,
			; if there was any writing in it
	ORA	A
	RNZ
	MVI	A,0FFH
	STA	UNALLO 	; We now work with unallocated block
	LXI	H,SECCPM
	LXI	D,SECBLS
	LXI	B,5
	CALL	HLTODE 	; Start of unalloc. block
	LXI	H,SECCPM
	LXI	D,SECBLE
	LXI	B,5
	CALL	HLTODE 	; Prepare ending block info
	LDA	DSKSEK
	CALL	GETDPB 	; HL <- DPBLKXX
;		              HL points to correct DPBLKXX
	LXI	B,10H  	; Offset for Sect. Per Track CP/M Info
	DAD	B
	MOV	C,M
	INX	H
	MOV	B,M ; BC has Number of 128 byte sectors on track
	PUSH	H 	; HL points number of records per track
	INX	H
	INX	H
;	HL points to BLM byte of CP/M info
	MOV	E,M
	MVI	D,0
	LHLD	SECCPM
; BC - Number of records (sectors) per track ( CP/M info )
;	DE - Number of last record (sector) in block
;       HL - Starting sector of block
	DAD	D 	; Calculate last sector in block
	SHLD	SECBLE
;	Now ajust sector number if it is greater than allowed
	MVI	A,00
	SUB	C
	MOV	C,A
	MVI	A,0
	SBB	B
	MOV	B,A 	; BC = - BC
	POP	H
	PUSH	B
	PUSH	H
WRSU1	POP	H 		; .(HL ) = Sect. per track + 1
	PUSH	H 		; Save HL
	LXI	D,SECBLE+1	; Point to end of word !!!
	LXI	B,2
	CALL	HLSUBDE		; Compare two bytes, which
				; are forming sector number
	JNC	WRSUE1 		; If in range - exit
;	Not in range - bump track counter
	LHLD	TRKBLE
	INX	H 	; Bump track number
	SHLD	TRKBLE
	LHLD	SECBLE
	POP	D
	POP	B
	PUSH	B
	PUSH	D
	DAD	B 	; Subtract maximum sector number
	SHLD	SECBLE
	JMP	WRSU1
WRSUE1	POP	H
	POP	H 	; Align stack pointer
;	Now	make buffer and transfer
	LXI	D,SECSEK
	LXI	H,SECWRB
	LXI	B,6
	CALL	DETOHL 	; Make a new buffer
;	and	write into it
	JMP	CPTOBUF
;
; PREREAD - If there is info in read buffer -
;		   move it to write buffer,
;	    else - read sector to write buffer from disk.
;
;	Before to make reading from disk ask for info in RDBUFF
;
PREREAD	LXI	H,DSKRDB
	LXI	D,DSKWRB
	LXI	B,0006
	CALL	HLSUBDE	; Are read and write buffer the same ?
	JNZ	PREREZ 	; No - Make Pre-read
; There is info in read buffer - transfere it into write buffer
	LXI	B,0400H	; Setup counter
	LXI	H,RDBUFF
	LXI	D,WRBUFF
	JMP	HLTODE 	; Move read buffer into write buffer
;
PREREZ	LXI	H,DSKWRB
	CALL	DSETUP 	; Setup FDC and DRVREG
	LXI	H,WRBUFF
	CALL	DTOM 	; Read sector into buffer
	ORA	A
	RET
; CPTOBUF - procedute to transfer bytes from .(DMACPM)
; to write buffer
CPTOBUF	LXI	H,DSKRDB
	LXI	D,DSKWRB
	LXI	B,6
	CALL	DESUBHL	; Are write and read buffers the same ?
	JNZ	CPT1 	; If not -
			; transfer bytes to write buffer only
;	Transfer to read buffer
	LHLD	OFSSEK
	LXI	D,RDBUFF
	DAD	D 	; Calculate place for record in buffer
	XCHG
	LHLD	DMACPM 	; Get DMA address
	LXI	B,128 	; Load counter
	XCHG
	CALL	DETOHL 	; Fill part of read buffer
CPT1	LHLD	OFSSEK
	LXI	D,WRBUFF
	DAD	D 	; Calculate place for record in buffer
	XCHG
	LHLD	DMACPM 	; Get DMA address
	LXI	B,128 	; Load counter
	XCHG
	MVI 	A,0FFH
	STA	BUFFAC	; Mark : there were info
			; written in buffer
	JMP	DETOHL	; Fill part of buffer and return 
			; with success flag
;
;   FLUSH - write buffer to disk
;
;      Before do that - be sure that something was written
FLUSH	LDA	BUFFAC
	ORA	A
	RZ		; Do nothing if buffer was inactive
	XRA	A
	STA	BUFFAC 	; If you write buffer to disk -
			; mark it as unactive
	LXI	H,DSKWRB
	CALL	DSETUP 		; Setup FDC and DRVREG
	LXI	H,WRBUFF	; HL points to buffer
	JMP	MTOD 	; Write sector from buffer to disk
;
WRTYPE	DB	0 	;Storage for write type :
			;	0 - ordinary write
			;       1 - directory write
			;       2 - first sector of 
			;	      unallocated block
BUFFAC	DB	0 	; Active write buffer
UNALLO	DB	0 	; <>0 - Write to unallocated block
ERRFL	DB	0
;
;
GETINFO	MOV	A,M	; ξονες δισλα
	LXI	D,DPB0
	ORA	A
	JZ	L1GI
	LXI	D,DPB1
L1GI	LDAX	D	; ζμαη ποδλμΰώεξιρ δισλα
	CMA
	RZ		; χοϊχςατ πςι ποδλμΰώεξξον δισλε
	MOV	A,M	; ξονες δισλα
	PUSH	H
	ORA	A
	MVI	A,DISKA
	JZ	L2GI
	MVI	A,DISKB
L2GI	STA	DRVREG
	MVI	A,2
	STA	RETRY
	CALL	RESTORE
	MVI	A,1
	STA	DSKSEC
	LXI	H,RDBUF
	CALL	DTOM
	JZ	L3GI
	LXI	H,DRVREG
	MOV	A,M
	ORI	DENSITY
	MOV	M,A
	LXI	H,RDBUF
	CALL	DTOM
L3GI	MVI	A,4
	STA	RETRY
	JNZ	L9GI	; οϋιβλα ώτεξιρ ιξζ-σελτοςα
	LXI	H,RDBUFF
	MVI	A,66H
	MVI	C,31
L4GI	ADD	M
	INX	H
	DCR	C
	JNZ	L4GI
	CMP	M
	JNZ	L10GI
	LXI	H,RDBUF
	MVI	M,0FFH
	INX	H
	INX	H
	MVI	M,00H
	LDA	DRVREG
	LXI	H,DPB0
	ANI	01H
	JNZ	L5GI
	LXI	H,DPB1
L5GI	LXI	D,RDBUF
	MVI	C,32
	CALL	MOVHD
	LDA	DRVREG
	LXI	H,DPH0
	LXI	B,XLT0
	ANI	01H
	JNZ	L6GI
	LXI	H,DPH1
	LXI	B,XLT1
L6GI	LDA	RDBUF+9
	DCR	A
	JZ	L7GI
	LXI	B,0000H
L7GI	MOV	M,C
	INX	H
	MOV	M,B
	JNZ	L8GI
	MOV	L,C
	MOV	M,B
	MVI	C,LENXLT
	CALL	MOVHD
L8GI	POP	H
	SUB	A
	RET
L9GI
L10GI
;
LTOF	MOV	A,M	; ξονες δισλα
	PUSH	H
	LXI	D,SEEKPARM
	STAX	D
	INX	D
	INX	D
	LXI	B,4
	DAD	B
	MOV	A,M
	ORA	A
	RAR
	STAX	D
	DCX	D
	MVI	A,01H
	JC	L1LTOF
	SUB	A
L1LTOF	STAX	D
	INX	D
	INX	D
	INX	H
	MOV	H,M
	MVI	L,0
	LDA	SEEKPARM
	ORA	A
	LDA	DPB0+10
	JZ	L2LTOF
	LDA	DPB1+10
L2LTOF	MOV	B,A
	MOV	C,A
	ORA	AGETDPB	; and calculate DPB address
	JZ	L4LTOF
L3LTOF	MOV	A,H
	ORA	A
	RAR
	MOV	H,A
	MOV	A,L
	RAR
	MOV	L,A
	DCR	C
	JNZ	L3LTOF
L4LTOF	MOV	A,H
	STAX	D
	INX	D
	MVI	H,0
	MOV	A,B
	ORA	A
	JZ	L6LTOF
L5LTOF	DAD	H
	DCR	B
	JNZ	L5LTOF
L6LTOF	XCHG
	MOV	M,E
	INX	H
	MOV	M,D
	POP	H
	RET
;
SETDSK	MOV	A,M	; ξονες δισλα
	ORA	A
	MVI	B,DISKA
	LDA	DPB0+7
	JZ	L1SD
	MVI	B,DISKB
	LDA	DPB1+7
L1SD	ORA	A
	JNZ	L2SD
	MVI	A,DENSITY
	ORA	B
	MOV	B,A
L2SD	INX	H
	MOV	A,M
	ORA	A
	JZ	L3SD
	MVI	A,SIDE
	ORA	B
	MOV	B,A
L3SD	STA	DRVREG
	INX	H
	MOV	B,M
	PUSH	H
	ANI	01H
	LXI	H,DPB0+2
	JNZ	L4SD
	LXI	H,DPB1+2
L4SD	MOV	C,M
	MOV	A,B
	CMP	C
	JZ	L6SD
	MOV	M,A
	ORA	A
	JNZ	L5SD
	CALL	RESTORE
	JMP	L6SD
L5SD	LXI	D,6
	DAD	D
	MOV	A,M
	ORA	A
	JZ	L7SD
	LXI	H,DSKDATA
	MOV	M,B
	LXI	H,DSKTRK
	MOV	M,C
	CALL	SEEK
L6SD	POP	H
	INX	H
	MOV	A,M
	STA	DSKSEC
	RET
L7SD	MOV	A,B
	SUB	C
	JNC	L8SD
	MOV	A,C
	SUB	D
	MOV	C,A
	CALL	STEPOUT
	JMP	L9SD
L8SD	MOV	C,A
	CALL	STEPIN
L9SD	DCR	C
	JZ	L6SD
L10SD	CALL	STEP
	DCR	C
	JNZ	L10SD
	JMP	L6SD
;
DTOM	DI
	PUSH	H
	XCHG
	LXI	H,FDC
	LXI	B,FDC+3
	LDA	RETRY
	PUSH	PSW
LDTOM	CALL	MTRON
	MVI	M,RDSECCMD
	CALL	CMDELAY
	CALL	DTOM1
	MOV	A,M
	ANI	5DH
	JZ	ALLDONE
	POP	PSW
	DCR	A
	POP	D
	JZ	DSKERR
	PUSH	D
	PUSH	PSW
	CALL	SHAKE
	JMP	LDTOM
;
DTOM1	MOV	A,M
	RRC
	RNC
	RRC
	JNC	DTOM1
	LDAX	B
	STAX	D
	INX	D
	JMP	DTOM1
;
MTRON	PUSH	H
	LXI	H,DRVREG
	MOV	A,M
	ANI	0DFH
	MOV	M,A
	ORI	20H
	MOV	M,A
	POP	H
LMTRON	MOV	A,M
	RLC
	JC	LMTRON
	RET
;
CMDELAY	MVI	A,10
LCMDEL	DCR	A
	JNZ	LCMDEL
	RET
;
ALLDONE	POP	PSW
	POP	H
	SUB	A
	EI
	RET
;
DSKERR	MOV	A,M
	EI
	RET
;
MTOD	DI
	PUSH	H
	XCHG
	LXI	H,FDC
	LXI	B,FDC+3
	LDA	RETRY
	PUSH	PSW
LMTOD	CALL	MTRON
	MVI	M,WRSECCMD
	CALL	CMDELAY
	CALL	MTOD1
	MOV	A,M
	ANI	5DH
	JZ	ALLDONE
	POP	PSW
	DCR	A
	POP	D
	JZ	DSKERR
	PUSH	D
	PUSH	PSW
	CALL	SHAKE
	JMP	LMTOD
;
MTOD1	MOV	A,M
	RRC
	RNC
	RRC
	JNC	MTOD1
	LDAX	D
	STAX	B
	INX	D
L1MTOD1	SUB	A
L2MTOD1	INR	A
	XRA	M
	JZ	L2MTOD1
	RRC
	LDAX	D
	STAX	B
	RC
	INX	D
	JMP	L1MTOD1
;
RETRY	DB	0
;
;             Set of Floppy disk subprogrammes
;
;       RESTORE - Restores head at track 00 ( outermost one )
;       STEPIN  - Makes one step inward
;       STEPOUT - Makes one step outward
;       SHAKE   - Makes step-in and step-out
;       STEP    - Makes a step in previous direction
;
RESTORE	LDA	SPEED
	ANI	3
	ORI	RESTOCMD
	JMP	WAITB
;
STEPIN	LDA	SPEED
	ANI	3
	ORI	STEPICMD
	JMP	WAITB
;
STEPOUT	LDA	SPEED
	ANI	3
	ORI	STEPOCMD
WAITB	STA	FDC
	CALL	DELAY3
WAITB1	LDA	FDC	; Get status
	ANI	1	; Mask DONE bit
	JNZ	WAITB1	; If not DONE yet - wait
	RET
;
SHAKE	CALL	STEPIN
	JMP	STEPOUT
;
STEP	MVI	A,STEPCMD OR 3
	JMP	WAITB
;
FORCE	MVI	A,FORCECMD
	STA	FDC
DELAY3	MVI	A,255
DELAY0	DCR	A
	JNZ	DELAY0
	RET
;
RETMSG	LXI	H,MSGTAB
	RET
;
MSGTAB	DW	MERR	; 0
	DW	MBAD	; 1
	DW	MEMPTY	; 2
	DW	MSYSTEM	; 3
	DW	MSELECT	; 4
	DW	MBLANC	; 5
	DW	MIGNORE	; 6
	DW	MBLANC	; 7
	DW	MEXIST	; 8
	DW	MANAME	; 9
	DW	MNOFILE	; 10
	DW	MERASE	; 11
	DW	MBOOT	; 12
	DW	MRONLY	; 13
;
MERR	DB	'οϋιβλα βδοσ ξα $'
MBAD	DB	'  οϋιβλα δισλα$'
MEMPTY	DB	'$'
MSYSTEM	DB	'  σιστενξωκ ζακμ$'
MSELECT	DB	'οϋιβλα χωβοςα  $'
MBLANC	DB	'  $'
MIGNORE	DB	'ιηξοςιςοχατψ - Y/N ?  $'
MEXIST	DB	'  ζακμ συύεστχυετ$'
MANAME	DB	'ξερχξοε ινρ$'
MNOFILE	DB	0DH,0AH,'ξετ ζακμοχ',0DH,0AH,'$'
MERASE	DB	0DH,0AH,'υδαμιτψ - Y/N ?  $'
MBOOT	DB	1BH,'E','λοςχετ πλ8020',0DH,0AH
	DB	'ξιισώετναϋ 15.11.1986',0DH,0AH,'$'
MRONLY	DB	'  ζακμ R/O$'
;
RESCOM	RET
;
;         Block for storing parameters received from CP/M
;         they have to be recalculated to actual
;         physical track and sector numbers
;
SECCPM	DS	2	; Sector number from BDOS
TRKCPM	DS	2	; Track number from BDOS
DSKCPM	DS	1	; Disk number from BDOS
DMACPM	DS	2	; DMA Address

;       Block in which procedure LTOF is writing result to

SECSEK	DS	2
TRKSEK	DS	2
SIDSEK	DS	1
DSKSEK	DS	1
OFSSEK	DS	2	; Offset from buffer start

;           Block for attributes of read buffer

SECRDB	DS	2
TRKRDB	DS	2
SIDRDB	DS	1
DSKRDB	DS	1

;           Block for attributes of write buffer

SECWRB	DS	2
TRKWRB	DS	2
SIDWRB	DS	1
DSKWRB	DS	1

;          Logical parameters for start of unallocated block

SECBLS	DS	2
TRKBLS	DS	2
DSKBLS	DS	1

;          Logical parameters for end of unallocated block

SECBLE	DS	2
TRKBLE	DS	2
DSKBLE	DS	1
;
LENBUF	EQU	1024
LENDIRB	EQU	128
LENALV	EQU	64
LENCSV	EQU	32
LENXLT	EQU	40
;
RDBUF	DS	1024	; Read buffer
;
WRBUF	EQU	0F800H
DIRBUF	EQU	WRBUF+LENBUF
ALV0	EQU	DIRBUF+LENDIRB
ALV1	EQU	ALV0+LENALV
CSV0	EQU	ALV1+LENALV
CSV1	EQU	CSV0+LENCSV
XLT0	EQU	CSV1+LENCSV
XLT1	EQU	XLT0+LENXLT
;
	END
