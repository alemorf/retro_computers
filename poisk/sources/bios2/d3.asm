WAITF	proc	near
	PUSH	AX
	PUSH	BX
	CLI
	OUT 	0CH,AL
	IN	AL,0
	MOV	BL,AL
	IN	AL,0
	MOV	BH,AL                     ;BX=BEGIN COUNT
LLLFF1:   CLI
	OUT 	0CH,AL
	IN	AL,0
	MOV	AH,AL
	IN	AL,0
	STI
	XCHG	AL,AH
	SUB	AX,BX
	JNS	LLLFF2
	NEG	AX
LLLFF2:	CMP	AX,CX
	JC	LLLFF1		
	POP	BX
	POP	AX
RET
WAITF	ENDP



; ----------------------------------------------------------------
;  DMA_SETUP                                                     :
;       THIS ROUTINE SETS UP THE DMA FOR READ/WRITE/VERIFY       :
;       OPERATIONS.                                              :
;  ON ENTRY:    AL = DMA COMMAND                                 :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
DMA_SETUP        PROC    NEAR
        CLI                             ; DISABLE INTERRUPTS DURING DMA SET-UP
        OUT     DMA+12,AL               ; SET THE FIRST/LAST F/F
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        OUT     DMA+11,AL               ; OUTPUT THE MODE BYTE
        CMP     AL,42H                  ; DMA VERIFY COMMAND
        JNE     NOT_VERF                ; NO
        XOR     AX,AX                   ; START ADDRESS
        JMP     SHORT J33
NOT_VERF:
        MOV     AX,ES                   ; GET THE ES VALUE
        PUSH	CX
        MOV	CL,4
        ROL     AX,CL                   ; ROTATE LEFT
        POP	CX
        MOV     CH,AL                   ; GET HIGHEST NIBBLE OF ES TO CH
        AND     AL,11110000B            ; ZERO THE LOW NIBBLE FROM SEGMENT
        ADD     AX,[BP+2]               ; TEST FOR CARRY FROM ADDITION
        JNC     J33
        INC     CH                      ; CARRY MEANS HIGH 4 BITS MUST BE INC
J33:
        PUSH    AX                      ; SAVE START ADDRESS
        OUT     DMA+4,AL                ; OUTPUT LOW ADDRESS
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        MOV     AL,AH
        OUT     DMA+4,AL                ; OUTPUT HIGH ADDRESS
        MOV     AL,CH                   ; GET HIGH 4 BITS
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; I/O WAIT STATE
        AND     AL,00001111B
        OUT     81H,AL                  ; OUTPUT HIGH 4 BITS TO PAGE REGISTER

;--------DETERMINE COUNT

        MOV     AX,SI                   ; AL = # OF SECTORS
        XCHG    AL,AH                   ; AH = # OF SECTORS
        SUB     AL,AL                   ; AL = 0,AX = #OF SECTORS* 256
        SHR     AX,1                    ; AX = # SECTORS * 128
        PUSH    AX                      ; SAVE # OF SECTORS * 128
        MOV     DL,3                    ; GET BYTES/SECTOR PARAMETER
        CALL    GET_PARM
        MOV     CL,AH                   ; SHIFT COUNT (0=128,1=256 ETC)
        POP     AX                      ; AX = # SECTORS * 128
        SHL     AX,CL                   ; SHIFT BY PARAMETER VALUE
        DEC     AX                      ; -1 FOR DMA VALUE
        PUSH    AX                      ; SAVE COUNT VALUE
        OUT     DMA+5,AL                ; LOW BYTE OF COUNT
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        MOV     AL,AH
        OUT     DMA+5,AL                ; HIGH BYTE OF COUNT
        STI                             ; RE-ENABLE INTERRUPTS
        POP     CX                      ; RECOVER COUNT VALUE
        POP     AX                      ; RECOVER ADDRESS VALUE
        ADD     AX,CX                   ; ADD, TEST FOR 64K OVERFLOW
        MOV     AL,2                    ; MODE FOR 8237
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        OUT     DMA+10,AL               ; INITIALIZE THE DISKETTE CHANNEL
        JNC     NO_BAD                  ; CHECK FOR ERROR
        MOV     DISKETTE_STATUS,DMA_BOUNDARY    ; SET ERROR
NO_BAD:
        RET                             ; CY SET BY ABOVE IF ERROR
DMA_SETUP        ENDP

; ----------------------------------------------------------------
;  FMTDMA_SETUP                                                  :
;       THIS ROUTINE SETS UP THE DMA CONTROLLER FOR A FORMAT     :
;       OPERATIONS.                                              :
;  ON ENTRY:    NOTHING REQUIRED                                 :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
FMTDMA_SET          PROC    NEAR
        MOV     AL,04AH                 ; WILL WRITE TO THE DISKETTE
        CLI                             ; DISABLE INTERRUPTS DURING DMA SET-UP
        OUT     DMA+12,AL               ; SET THE FIRST/LAST F/F
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        OUT     DMA+11,AL               ; OUTPUT THE MODE BYTE

        MOV     AX,ES                   ; GET THE ES VALUE
        PUSH	CX
        MOV	CL,4
        ROL     AX,CL                   ; ROTATE LEFT
        POP	CX
        MOV     CH,AL                   ; GET HIGHEST NIBBLE OF ES TO CH
        AND     AL,11110000B            ; ZERO THE LOW NIBBLE FROM SEGMENT
        ADD     AX,[BP+2]               ; TEST FOR CARRY FROM ADDITION
        JNC     J33A
        INC     CH                      ; CARRY MEANS HIGH 4 BITS MUST BE INC
J33A:
        PUSH    AX                      ; SAVE START ADDRESS
        OUT     DMA+4,AL                ; OUTPUT LOW ADDRESS
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        MOV     AL,AH
        OUT     DMA+4,AL                ; OUTPUT HIGH ADDRESS
        MOV     AL,CH                   ; GET HIGH 4 BITS
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; I/O WAIT STATE
        AND     AL,00001111B
        OUT     81H,AL                  ; OUTPUT HIGH 4 BITS TO PAGE REGISTER

;--------DETERMINE COUNT

        MOV     DL,4                    ; SECTORS/TRACK VALUE IN PARM TABLE
        CALL    GET_PARM
        XCHG    AL,AH                   ; AL = SECTORS/TRACK VALUE
        SUB     AH,AH                   ; AX = SECTORS/TRACK VALUE
        SHL     AX,1                    ; AX = SEC/TRK * 4(OFFSET FOR C,H,R,N)
        SHL	AX,1
        DEC     AX                      ; -1 FOR DMA VALUE
        PUSH    AX                      ; SAVE # OF BYTES TO BE TRANSFERED
        OUT     DMA+5,AL                ; LOW BYTE OF COUNT
        JMP     $+2                     ; WAIT FOR I/O
        JMP     $+2                     ; WAIT FOR I/O
        MOV     AL,AH
        OUT     DMA+5,AL                ; HIGH BYTE OF COUNT
        STI                             ; RE-ENABLE INTERRUPTS
        POP     CX                      ; RECOVER COUNT VALUE
        POP     AX                      ; RECOVER ADDRESS VALUE
        ADD     AX,CX                   ; ADD, TEST FOR 64K OVERFLOW
        MOV     AL,2                    ; MODE FOR 8237
        JMP     $+2                     ; WAIT FOR I/O
        OUT     DMA+10,AL               ; INITIALIZE THE DISKETTE CHANNEL
        JNC     FMTDMA_OK               ; CHECK FOR ERROR
        MOV     DISKETTE_STATUS,DMA_BOUNDARY    ; SET ERROR
FMTDMA_OK:
        RET                             ; CY SET BY ABOVE IF ERROR
FMTDMA_SET          ENDP
; ----------------------------------------------------------------
;  NEC_INIT                                                      :
;       THIS ROUTINE SEEKS TO THE REQUESTED TRACK AND            :
;       INITIALIZES THE NEC FOR THE READ/WRITE/VERIFY/FORMAT     :
;       OPERATION.                                               :
;  ON ENTRY:    AH : NEC COMMAND TO BE PERFORMED                 :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
NEC_INIT          PROC    NEAR
        PUSH    AX                      ; SAVE NEC COMMAND
        CALL    MOTOR_ON                ; TURN MOTOR ON FOR SPECIFIC DRIVE

;-------- DO THE SEEK OPERATION

        MOV     CH,[BP+1]               ; CH = TRACK #
        CALL    SEEK                    ; MOVE TO CORRECT TRACK
        POP     AX                      ; RECOVER COMMAND
        JC      ER_1                    ; ERROR ON SEEK
        MOV     BX,OFFSET ER_1          ; LOAD ERROR ADDRESS
        PUSH    BX                      ; PUSH NEC_OUT ERROR RETURN

;-------- SEND OUT THE PARAMETERS TO THE CONTROLLER

        CALL    NEC_OUTPUT              ; OUTPUT THE OPERATION COMMAND
        MOV     AX,SI                   ; AH = HEAD #
        MOV     BX,DI                   ; BL = DRIVE #
        SHL     AH,1
        SHL	AH,1                    ; MOVE IT TO BIT 2
        AND     AH,00000100B            ; ISOLATE THAT BIT
        OR      AH,BL                   ; OR IN THE DRIVE NUMBER
        CALL    NEC_OUTPUT              ; FALL THRU CY SET IF ERROR
        POP     BX                      ; THROW AWAY ERROR RETURN
ER_1:
        RET
NEC_INIT          ENDP
; ----------------------------------------------------------------
; RWV_COM                                                        :
;       THIS ROUTINE SENDS PARAMETERS TO THE NEC SPECIFIC        :
;       TO THE READ/WRITE/VARIFY OPERATIONS.                     :
;  ON ENTRY:    CS:BX = ADDRESS OF MEDIA/DRIVE PARAMETER TABLE   :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
RWV_COM          PROC    NEAR
        MOV     AX,OFFSET ER_2          ; LOAD ERROR ADDRESS
        PUSH    AX                      ; PUSH NEC_OUT ERROR RETURN
        MOV     AH,[BP+1]               ; OUTPUT TRACK #
        CALL    NEC_OUTPUT
        MOV     AX,SI                   ; OUTPUT HEAD #
        CALL    NEC_OUTPUT
        MOV     AH,[BP]                 ; OUTPUT SECTOR #
        CALL    NEC_OUTPUT
        MOV     DL,3                    ; BYTES/SECTORS PARAMETER FROM BLOCK
        CALL    GET_PARM                ; . TO THE NEC
        CALL    NEC_OUTPUT              ; OUTPUT TO CONTROLLER
        MOV     DL,4                    ; EOT PARAMETER FROM BLOCK
        CALL    GET_PARM                ; . TO THE NEC
        CALL    NEC_OUTPUT              ; OUTPUT TO CONTROLLER

        MOV     AH,CS:[BX].MD_GAP       ; GET GAP LENGTH
        CALL    NEC_OUTPUT
        MOV     DL,6                    ; DTL PARAMETER FROM BLOCK
        CALL    GET_PARM                ; . TO THE NEC
        CALL    NEC_OUTPUT              ; OUTPUT TO CONTROLLER
        POP     AX                      ; THROW AWAY ERROR EXIT
ER_2:
        RET
RWV_COM          ENDP
; ----------------------------------------------------------------
;  NEC_TERM                                                      :
;       THIS ROUTINE WAITS FOR OPERATION THEN ACCEPTS            :
;       THE STATUS FROM THE NEC FOR THE READ/WRITE/VERIFY/       :
;       FORMAT OPERATION.                                        :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
NEC_TERM          PROC    NEAR

;-------- LET THE OPERATION HAPPEN

        PUSH    SI                      ; SAVE HEAD #, # OF SECTORS
        CALL    WAIT_INT                ; WAIT FOR INTERRUPT
        PUSHF
        CALL    RESULTS                 ; GET THE NEC STATUS
        JC      SET_END_POP
        POPF
        JC      SET_END                 ; LOOK FOR ERROR

;-------  CHECK THE RESULTS RETURNED BY THE CONTROLLER

        CLD                             ; SET THE CORRECT DIRECTION
        MOV     SI,OFFSET NEC_STATUS    ; POUNT TO STATUS FIELD
        LODS    NEC_STATUS              ; GET ST0
        AND     AL,11000000B            ; TEST FOR NORMAL TERMINATION
        JZ      SET_END                 ;
        CMP     AL,01000000B            ; TEST FOR ABNORMAL TERMINATION
        JNZ     J18                     ; NOT ABNORMAL,BAD NEC

;------- ABNORMAL TERMINATION , FIND OUT WHY

        LODS    NEC_STATUS              ; GET ST1
        SAL     AL,1                    ; TEST FOR EOT FOUND
        MOV     AH,RECORD_NOT_FND
        JC      J19
        SAL     AL,1
        SAL	AL,1
        MOV     AH,BAD_CRC
        JC      J19
        SAL     AL,1                    ; TEST FOR DMA OVERRUN
        MOV     AH,BAD_DMA
        JC      J19
        SAL     AL,1
        SAL	AL,1                    ; TEST FOR RECORD NOT FOUND
        MOV     AH,RECORD_NOT_FND
        JC      J19
        SAL     AL,1
        MOV     AH,WRITE_PROTECT        ; TEST FOR WRITE_PROTECT
        JC      J19
        SAL     AL,1                    ; TEST MISSING ADDRES MARK
        MOV     AH,BAD_ADDR_MARK
        JC      J19

;------- NEC MUST HAVE FAILED

J18:
        MOV     AH,BAD_NEC
J19:
        OR      DISKETTE_STATUS,AH
SET_END:
        CMP     DISKETTE_STATUS,1       ; SET ERROR CONDITION
        CMC
        POP     SI                      ; RESTORE HEAD #, # OF SECTORS
        RET
SET_END_POP:
        POPF
        JMP     SHORT SET_END
NEC_TERM          ENDP
;-----------------------------------------------------------------
;  DSTATE:      ESTABLISH STATE UPON SUCCESSFUL OPERATION.       :
;-----------------------------------------------------------------
DSTATE          PROC    NEAR
        CMP     DISKETTE_STATUS,0       ; CHECK FOR ERROR
        JNZ     SETBAC                  ; IF ERROR JUMP
        OR      DSK_STATE[DI],MED_DET   ; NO ERROR, MARK MEDIA AS DETERMINED
        TEST    DSK_STATE[DI],DRV_DET   ; DRIVE DETERMINED
        JNZ     SETBAC                  ; IF DETERMINED NO TRY TO DETERMINE
        MOV     AL,DSK_STATE[DI]        ; LOAD STATE
        AND     AL,RATE_MSK             ; KEEP ONLY RATE
        CMP     AL,RATE_250             ; RATE 250 ?
        JNE     M_12                    ; NO,MUST BE 1.2M OR 1.44M DRV

;--------- CHECK IF IT IS 1.44M

        CALL    CMOS_TYPE               ; RETURN DRIVE TYPE IN (AL)
        JC      M_12                    ; CMOS BAD
        CMP     AL,04                   ; 1.44MB DRIVE ?
        JE      M_12                    ; YES
M_720:
        AND     DSK_STATE[DI],NOT FMT_CAPA      ; TURN OFF FORMAT CAPA
        OR      DSK_STATE[DI],DRV_DET   ; MARK DRIVE DETERMINED
        JMP     SHORT SETBAC            ; BACK
M_12:
        OR      DSK_STATE[DI],DRV_DET+FMT_CAPA  ; TURN ON DETERMINED & FMT CAPA
SETBAC:
        RET
DSTATE          ENDP
; ----------------------------------------------------------------
;  RETRYERM                                                      :
;       DETERMINES WHETHER A RETRY IS NECESSARY. IF RETRY IS     :
;       REQUIRED THEN STATE INFORMATION IS UPDATED FOR RETRY.    :
;                                                                :
;  ON EXIT:     CY = 1 FOR RETRY, CY = 0 FOR NO RETRY            :
;-----------------------------------------------------------------
RETRY          PROC    NEAR
        CMP     DISKETTE_STATUS,0       ; GET STATUS OF OPERATION
        JZ      NO_RETRY                ; SUCCESSFUL OPERATION
        CMP     DISKETTE_STATUS,TIME_OUT        ; IF TIME OUT NO RETRY
        JZ      NO_RETRY
        MOV     AH,DSK_STATE[DI]        ; GET MEDIA STATE OF DRIVE
        TEST    AH,MED_DET              ; ESTABLISHED/DETERMINED ?
        JNZ     NO_RETRY                ; IF ESTABLISHED STATE THEN TRUE ERROR
        AND     AH,RATE_MSK             ; ISOLATE RATE
        MOV     CH,LASTRATE             ; GET START OPERATION STATE
        ROL     CH,1                    ; ROTATE LEFT
        ROL     CH,1                    ; ROTATE LEFT
        ROL     CH,1                    ; ROTATE LEFT
        ROL     CH,1                    ; TO CORRESPONDING BITS
        AND     CH,RATE_MSK             ; ISOLATE RATE BITS
        CMP     CH,AH                   ; ALL RATES TRIED
        JE      NO_RETRY                ; IF YES, THEN TRUE ERROR

;       SETUP STATE INDICATOR FOR RETRY ATTEMP TO NEXT RATE
;         00000000B (500) -> 10000000B (250)
;         10000000B (250) -> 01000000B (300)
;         01000000B (300) -> 00000000B (500)

        CMP     AH,RATE_500+1           ; SET CY FOR RATE 500
        RCR     AH,1                    ; TO NEXT STATE
        AND     AH,RATE_MSK             ; KEEP ONLY RATE BITS
        AND     DSK_STATE[DI],NOT RATE_MSK+DBL_STEP     ; RATE, DBL STEP OFF
        OR      DSK_STATE[DI],AH        ; TURN ON NEW RATE
        MOV     DISKETTE_STATUS,0       ; RESET STATUS FOR RETRY
        STC                             ; SET CARRY FOR RETRY
        RET                             ; RETRY RETURN
NO_RETRY:
        CLC                             ; CLEAR CARRY NO RETRY
        RET                             ; NO RETRY RETORN
RETRY          ENDP
; ----------------------------------------------------------------
;  NUM_TRANS                                                     :
;       THIS ROUTINE CALCULATES THE NUMBER OF SECTORS THAT       :
;       WERE ACTUALLY TRANSFERRED TO/FROM THE DISKETTE.          :
;  ON ENTRY:    [BP+1] = TRACK                                   :
;               SI-HI  = HEAD                                    :
;               [BP]   = START SECTOR                            :
;  ON EXIT:     AL = NUMBER ACTUALLY TRANSFERED                  :
;-----------------------------------------------------------------
NUM_TRANS          PROC    NEAR
        XOR     AL,AL                   ; CLEAR FOR ERROR
        CMP     DISKETTE_STATUS,0       ; CHECK FOR ERROR
        JNE     NT_OUT                  ; IF ERROR 0 TRANSFERED
        MOV     DL,4                    ; SECTOR/TRACK OFFSET TO DL
        CALL    GET_PARM                ; AH = SECTOR/TRACK
        MOV     BL,NEC_STATUS+5         ; GET ENDING SECTOR
        MOV     CX,SI                   ; CH = HEAD # STARTED
        CMP     CH,NEC_STATUS+4         ; GET HEAD ENDED UP ON
        JNZ     DIF_HD                  ; IF ON SAME HEAD, THEN NO ADJUST
        MOV     CH,NEC_STATUS+3         ; GET TRACK ENDED UP ON
        CMP     CH,[BP+1]               ; IS IT ASKED FOR TRACK
        JZ      SAME_TRK                ; IF SAME TRACK NO INCREASE
        ADD     BL,AH                   ; ADD SECTORS/TRACK
DIF_HD:
        ADD     BL,AH                   ; ADD SECTORS/TRACK
SAME_TRK:
        SUB     BL,[BP]                 ; SUBTRACT START FROM END
        MOV     AL,BL                   ; TO AL
NT_OUT:
        RET
NUM_TRANS          ENDP
; ----------------------------------------------------------------
;  SETUP_END                                                     :
;       RESTORES MOTOR_COUNT TO PARAMETER PROVIDED IN TABLE      :
;       AND LOADS DSKETTE_STATUS TO AH, AND SETS CY.             :
;  ON EXIT:                                                      :
;           AH, DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
SETUP_END          PROC    NEAR
        MOV     DL,2                    ; GET THE MOTOR WAIT PARAMETER
        PUSH    AX                      ; SAVE NUMBER TRANSFERED
        CALL    GET_PARM
        MOV     MOTOR_COUNT,AH          ; STORE UPON RETURN
        POP     AX                      ; RESTORE NUMBER TRANSFERED
        MOV     AH,DISKETTE_STATUS      ; GET STATUS OF OPERATION
        OR      AH,AH                   ; CHECK FOR ERROR
        JZ      NUN_ERR                 ; NO ERROR
        XOR     AL,AL                   ; CLEAR NUMBER RETURNED
NUN_ERR:
        CMP     AH,1                    ; SETB THE CARRY FLAG TO INDICATE
        CMC                             ; SUCCES OR FAILURE
        RET
SETUP_END          ENDP
; ----------------------------------------------------------------
;  SETUP_DBL                                                     :
;       CHECK DOUBLE STEP.                                       :
;  ON ENTRY:                                                     :
;               DI = DRIVE                                       :
;  ON EXIT:     CY = 1 MEANS ERROR                               :
;-----------------------------------------------------------------
SETUP_DBL          PROC    NEAR
        MOV     AH,DSK_STATE[DI]        ; ACCES STATE
        TEST    AH,MED_DET              ; ESTABLISHED STATE ?
        JNZ     NO_DBL                  ; IF ESTABLISHED THEN DOUBLE DONE

;------- SHECK FOR TRACK 0 TO SPEED UP ACKNOWLEDGE OF UNFORMATTED DISKETTE

        MOV     SEEK_STATUS,0           ; SET RECALIBRATE REQUIRED ON ALL
                                        ; DRIVES
        CALL    MOTOR_ON                ; ENSURE MOTOR STAY ON
        MOV     CH,0                    ; LOAD TRACK 0
        CALL    SEEK                    ; SEEK TO TRACK 0
        CALL    READ_ID                 ; READ ID FUNCTION
        JC      SD_ERR                  ; IF ERROR NO TRACK 0

;------- INITIALIZE START AND MAX TRACK (TIMES 2 FOR BOTH HEADS)

        MOV     CX,0450H                ; START, MAX TRACKS
        TEST    DSK_STATE[DI],TRK_CAPA  ; TEST FOR 80 TRACK CAPABILITE
        JZ      SNT_OK                  ; IF NOT COUNT IS SETUP
        MOV     CL,0A0H                 ; MAXIMUM TRACK 1.2MB

;       ATTEMP READ ID OFF ALL TRACKS, ALL HEADS UNTIL SUCCES; UPON SUCCES,
;       MUST SEE IF ASKED FOR TRACK IN SINGLE STEP MODE = TRACK ID READ; IF NOT
;       THEN SET DOUBLE STEP ON.

SNT_OK: MOV     MOTOR_COUNT,0FFH        ; ENSURE MOTOR STAYS ON FOR OPERATION
        PUSH    CX                      ; SAVE TRACK, COUNT
        MOV     DISKETTE_STATUS,0       ; CLEAR STATUS, EXPECT ERRORS
        XOR     AX,AX                   ; CLEAR AX
        SHR     CH,1                    ; HALVE TRACK, CY = HEAD
        RCL     AL,1
        RCL	AL,1
        RCL	AL,1                    ; AX = HEAD IN CORRECT BIT
        PUSH    AX                      ; SAVE HEAD
        CALL    SEEK                    ; SEEK TO TRACK
        POP     AX                      ; RESTORE HEAD
        OR      DI,AX                   ; DI = HEAD OR'ED DRIVE
        CALL    READ_ID                 ; READ ID HEAD 0
        PUSHF                           ; SET RETURN FROM READ_ID
        AND     DI,11111011B            ; TURN OFF HEAD 1 BIT
        POPF                            ; RESTORE ERROR RETURN
        POP     CX                      ; RESTORE COUNT
        JNC     DO_CHK                  ; IF OK, ASKED = RETURNED TRACK ?
        INC     CH                      ; INC FOR NEXT TRACK
        CMP     CH,CL                   ; REACHED MAXIMUM YET
        JNZ     SNT_OK                  ; CONTINUE TILL ALL TRIED

;-------- FALL THRU, READ ID FAILED FOR ALL TRACK

SD_ERR:
        STC                             ; SET CARRY FOR ERROR
        RET                             ; SETUP_DBL ERROR EXIT
DO_CHK:
        MOV     CL,NEC_STATUS+3         ; LOAD RETURNED TRACK
        MOV     DSK_TRK[DI],CL          ; STORE TRACK NUMBER
        SHR     CH,1                    ; HALVE TRACK
        CMP     CH,CL                   ; IS IT THE SAME AS ASKED FOR TRACK
        JZ      NO_DBL                  ; IF SAME THEN NO DOUBLE STEP
        OR      DSK_STATE[DI],DBL_STEP  ; TURN ON DOUBLE STEP REQUIRED
NO_DBL:
        CLC                             ; CLEAR ERROR FLAG
        RET
SETUP_DBL          ENDP
; ----------------------------------------------------------------
;  READ_ID                                                       :
;       READ ID FUNCTION.                                        :
;  ON ENTRY:    DI = BIT 2 = HEAD; BITS 1,0 = DRIVE              :
;  ON EXIT:     DI = BIT 2 IS RESET , BITS 1,0 = DRIVE           :
;               DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;-----------------------------------------------------------------
READ_ID          PROC    NEAR
        MOV     AX,OFFSET ER_3          ; MOVE NEC OUTPUT ERROR ADDRESS
        PUSH    AX
        MOV     AH,4AH                  ; READ ID COMMAND
        CALL    NEC_OUTPUT              ; TO CONTROLLER
        MOV     AX,DI                   ; DRIVE # TO AH, HEAD 0
        MOV     AH,AL
        CALL    NEC_OUTPUT              ; TO CONTROLLER
        CALL    NEC_TERM                ; WAIT FOR OPERATION, GET STATUS
        POP     AX                      ; THROW AWAY ERROR ADDRESS
ER_3:
        RET
READ_ID          ENDP
; ----------------------------------------------------------------
;  CMOS_TYPE                                                     :
;       RETURNS DISKETTE TYPE FROM CMOS                          :
;  ON ENTRY:    DI = DRIVE #                                     :
;                                                                :
;  ON EXIT:     AL = TYPE; CY REFLECTS STATUS                    :
;-----------------------------------------------------------------
CMOS_TYPE          PROC    NEAR
  ;      MOV     AL,CMOS_DIAG            ; CMOS DIAGNOSTIC STATYS BYTE ADDRESS
  ;      CALL    CMOS_READ               ; GET CMOS STATUS
  ;      TEST    AL,BAD_BAT+BAD_CKSUM    ; BATTERY GOOD AND CHECKSUM VALID ?
  ;      STC                             ; SET CY = 1 INDICATING ERROR FOR
                                        ;   RETURN
  ;      JNZ     BAD_CM                  ; ERROR IF EITHER BIT ON
  ;      MOV     AL,CMOS_DISKETTE        ; ADDRESS OF DISKETTE BYTE IN CMOS
  ;      CALL    CMOS_READ               ; GET DISKETTE BYTE
  ;      MOV	AL,TYPEDSK       ; TEMPORARY                      ! ! ! ! !
        mov	al,10h
        out	70h,al
        jmp	short $+2
        jmp	short $+2
        in	al,71h
        OR      DI,DI                   ; SEE WHICH DRIVE IN QUESTION
        JZ      TB                      ; IF DRIVE 1, DATA IN LOW NIBBLE
        PUSH	CX
        MOV	CL,4
        ROR     AL,CL                   ; ROTATE RIGHT
        POP	CX                      ; EXCHANGE NIBBLES IF SECOND DRIVE
TB:
        AND     AL,00FH                 ; KEEP ONLY DRIVE DATA, RESET CY = 0
BAD_CM:
        RET
CMOS_TYPE          ENDP
; ----------------------------------------------------------------
;  GET_PARM                                                      :
;       THIS ROUTINE FETCHES THE INDEXED POINTER FROM THE        :
;       DISK BASE BLOCK POINTED TO BY THE DATA VARIABLE          :
;       DISK_POINTER.A BYTE FROM THAT TABLE IS THEN MOVED        :
;       INTO AH, THE INDEX OF THAT BYTE BAING THE PARAMETER      :
;       IN DL.                                                   :
;  ON ENTRY:    DL = INDEX OF BYTE TO BE FETCHED                 :
;                                                                :
;  ON EXIT:     AH = THAT BYTE FROM BLOCK                        :
;               AL,DH RESTOROYED                                 :
;-----------------------------------------------------------------
GET_PARM          PROC    NEAR
        PUSH    DS
        PUSH    SI
        SUB     AX,AX                   ; DS = 0 ,BIOS DATA AREA
        MOV     DS,AX
        XCHG    DX,BX                   ; BL = INDEX
        SUB     BH,BH                   ; BX = INDEX
        ASSUME  DS:ABS0
        LDS     SI,DISK_POINTER         ; POINT TO BLOCK
        MOV     AH,[SI+BX]              ; GET THE WORD
        XCHG    DX,BX                   ; RESTORE BX
        POP     SI
        POP     DS
        RET
        ASSUME  DS:DATA
GET_PARM          ENDP
; -------------------------------------------------------------------------
;  MOTOR_ON                                                                :
;       TURN MOTOR ON AND WAIT FOR MOTOR START UP TIME, THE MOTOR_COUNT    :
;       IS REPLACED WITH A SUFFICIENTLY HIGH NUMBER (0FFH) TO ENSURE       :
;       THAT THE MOTOR DOES NOT GO OFF DURING THE OPERATION. IF THE        :
;       MOTOR NEEDED TO BE TURNED ON, THE MULTITASKING HOOK FUNCTION       :
;       (AX=90FDH, INT 15H) IS CALLED TELLING THE OPERATING SYSTEM         :
;       THAT THE BIOS IS ABOUT TO WAIT FOR MOTOR START UP. IF THIS         :
;       FUNCTION RETURNS WITH CY = 1 , IT MEANS THAT THE MINIMUM WAIT      :
;       HAS BEEN COMPLETED. AT THIS POINT A CHECK IS MADE TO ENSURE        :
;       THAT THE MOTOR WASN'T TURNED OFF BY THE TIMER. IF THE HOOK DID     :
;       NO WAIT, THE WAIT FUNCTION (AH=086H) IS CALLED TO WAIT THE         :
;       PRESCRIBED AMOUNT OF TIME. IF THE CARRY FLAG IS SET NOT RETURN,    :
;       IT MEANS THAT THE FUNCTION IS IN USE AND DID NOT PERFORM THE       :
;       WAIT. A TIMER 1 WAIT LOOP WILL THEN DO THE WAIT.                   :
;                                                                          :
;  ON ENTRY:    DI = DRIVE #                                               :
;                                                                          :
;  ON EXIT:     AX,CX,DX RESTOROYED                                        :
;---------------------------------------------------------------------------
MOTOR_ON          PROC    NEAR
        PUSH    BX                      ; SAVE REG.
        CALL    TURN_ON                 ; TURN ON MOTOR
        JC      MOT_IS_ON               ; IF CY = 1 NO WAIT
        CALL    XLAT_OLD                ; TRANSLATE STATE TO COMPATIBLE MODE
        MOV     AX,090FDH               ; LOAD WAIT CODE $ TYPE
        INT     15H                     ; TELL OPERATING SYSTEM ABOUT TO DO
                                        ; WAIT
        PUSHF                           ; SEVE CY FOR TEST
        CALL    XLAT_NEW                ; TRANSLATE STATE TO PRESENT ARCH.
        POPF                            ; RESTORE CY FOR TEST
        JNC     M_WAIT                  ; BYPPAS LOOP IF OP SYSTEM HANDLED WAIT
        CALL    TURN_ON                 ; CHECK AGAIN IF MOTOR ON
        JC      MOT_IS_ON               ; IF NO WAIT MEANS IT IS ON
M_WAIT:
        MOV     DL,10                   ; GET THE MOTOR WAIT PARAMETER
        CALL    GET_PARM
        MOV     AL,AH                   ; AL = MOTOR WAIT PARAMETER
        XOR     AH,AH                   ; AX = MOTOR WAIT PARAMETER
        CMP     AL,8                    ; SEE IF AT LEAST A SECOND IS SPECIFIED
        JAE     GP2                     ; IFYES, CONTINUE
        MOV     AL,8                    ; ONE SECOND WAIT FOR MOTOR START UP

;------ AX CONTAINS NUMBER OF 1/8 SECONDS (125000 MICROSECONDS) TO WAIT

GP2:
;        PUSH    AX                      ; SAVE WAIT PARAMETER
;        MOV     DX,62500                ; LOAD LARGEST POSSIBLE MULTIPLIER
;        MUL     DX                      ; MULTIPLY BY HALF OF THAT'S NECESSARY
;        MOV     CX,DX                   ; CX = HIGH WORD
;        MOV     DX,AX                   ; CX,DX = 1/2 * (# OF MICROSECONDS)
;        CLC                             ; CLEAR CARRY FOR ROTATE
;        RCL     DX,1                    ; DOUBLE LOW WORD, CY CONTAINS OVERFLOW
;        RCL     CX,1                    ; DOUBLE HI,INCLADING LOW WORD OVERFLOW
;        MOV     AH,86H                  ; LOAD WAIT CODE
;        INT     15H                     ; PERFORM WAIT
;        POP     AX                      ; RESTORE WAIT PARAMETER
;        JNC     MOT_IS_ON               ; CY MEANS WAIT COULD NOT BE DONE

;----- FOLLOWING LOOPS REQUIRED WHEN RTC WAIT FUNCTION IS ALREADY IN USE

J13:                                    ; WAIT FOR 1/8 SECOND PER (AL)
        MOV     CX,8286                 ; COUNT FOR 1/8 SECOND AT 15.085737 US
        CALL    WAITF                   ; GO TO FIXED WAIT ROUTINE
        DEC     AL                      ; DECREMENT TIME VALUE
        JNZ     J13                     ; ARE WE DONE YET
MOT_IS_ON:
        POP     BX                      ; RESTORE REG.
        RET
MOTOR_ON          ENDP
; ----------------------------------------------------------------
;  TURN_ON                                                       :
;       TURN MOTOR ON AND RETURN WAIT STATE.                     :
;  ON ENTRY:    DI = DRIVE #                                     :
;                                                                :
;  ON EXIT:     CY = 0 MEANS WAIT REQUIRED                       :
;               CY = 1 MEANS NOT WAIT REQUIRED                   :
;               AX,BX,CX,DX DESTROYED                            :
;-----------------------------------------------------------------
TURN_ON          PROC    NEAR
        MOV     BX,DI                   ; BX = DRIVE #
        MOV     CL,BL                   ; CL = DRIVE #
        PUSH	CX
        MOV	CL,4
        ROL     BL,CL                   ; ROTATE LEFT
        POP	CX                      ; BL = DRIVE DRIVE SELECT
        CLI                             ; NO INTERRUPTS WHILE DETERMINING
                                        ; STATUS
        MOV     MOTOR_COUNT,0FFH        ; ENSURE MOTOR STAYS ON FOR OPERATION
        MOV     AL,MOTOR_STATUS         ; GET DIGITAL OUTPUT REGISTER
                                        ; REFLECTION
        AND     AL,00110000B            ; KEEP ONLY DRIVE SELECT BITS
        MOV     AH,1                    ; MASK FOR DETERMINING MOTOR BIT
        SHL     AH,CL                   ; AH = MOTOR ON,A=00000001,B=00000010

;  AL = DRIVE SELECT FROM MOTOR_STATUS
;  BL = DRIVE SELECT DESIRED
;  AH = MOTOR ON MASK DESIRED

        CMP     AL,BL                   ; REQUESTED DRIVE ALREADY SELECTED ?
        JNZ     TURN_IT_ON              ; IF NOT SELECTED JUMP
        TEST    AH,MOTOR_STATUS         ; TEST MOTOR ON BIT
        JNZ     NO_MOT_WAIT             ; JUMP IF MOTOR ON AND SELECTED
TURN_IT_ON:
        OR      AH,BL                   ; AH = DRIVE SELECT AND MOTOR ON
        MOV     BH,MOTOR_STATUS         ; SAVE COPY OF MOTOR_STATUS BEFORE
        AND     BH,00001111B            ; KEEP ONLY MOTOR BITS
        AND     MOTOR_STATUS,11001111B  ; CLEAR OUT DRIVE SELECT
        OR      MOTOR_STATUS,AH         ; OR IN DRIVE SELECTED AND MOTOR ON
        MOV     AL,MOTOR_STATUS         ; GET DIGITAL OUTPUT REGISTER
                                        ; REFLECTIONS
        MOV     BL,AL                   ; BL = MOTOR_STATUS AFTER, BH=BEFORE
        AND     BL,00001111B            ; KEEP ONLY MOTOR BITS
        STI                             ; ENABLE INTERRUPTS AGAIN
        AND     AL,00111111B            ; STRIP AWAY UNWANTED BITS
        PUSH	CX
        MOV	CL,4
        ROL     AL,CL                   ; ROTATE LEFT
        POP	CX                      ; PUT BITS IN DESIRED POSITIONS
        OR      AL,00001100B            ; NO RESET, ENABLE DMA/INTERRUPT
        MOV     DX,03F2H                ; SELECT DRIVE AND TURN ON MOTOR
        OUT     DX,AL
        CMP     BL,BH                   ; NEW MOTOR TURNED ON ?
        JE      NO_MOT_WAIT             ; NO WAIT REQUIRED IF JUST SELECT
        CLC                             ; SET CARRY MEANING WAIT
        RET
NO_MOT_WAIT:
        STC                             ; SET NO WAIT  REQUIRED
        STI                             ; INTERRUPTS BACK ON
        RET
TURN_ON          ENDP
; ----------------------------------------------------------------
;  HD_WAIT                                                       :
;       WAIT FOR HEAD SETTLE TIME.                               :
;  ON ENTRY:    DI = DRIVE #                                     :
;                                                                :
;  ON EXIT:     AX,BX,CX,DX DESTROYED                            :
;-----------------------------------------------------------------
HD_WAIT          PROC    NEAR
        MOV     DL,9                    ; GET HEAD SETTLE PARAMETER
        CALL    GET_PARM
        TEST    MOTOR_STATUS,10000000B  ; SEE IF A WRITE OPERATION
        JZ      ISNT_WRITE              ; IF NOT, DO NOT ENFORCE ANY VALUES
        OR      AH,AH                   ; CCHECK FOR ANY WAIT
        JNZ     DO_WAT                  ; IF THERE DO NOT ENFORCE
        MOV     AH,HD12_SETTLE          ; LOAD 1.2M HEAD SETTLE MINIMUM
        MOV     AL,DSK_STATE[DI]        ; LOAD STATE
        AND     AL,RATE_MSK             ; KEEP ONLY RATE
        CMP     AL,RATE_250             ; 1.2M DRIVE ?
        JNE     DO_WAT                  ; DEFAULT HEAD SETTLE LOADED
GP3:
        MOV     AH,HD320_SETTLE         ; USE 320/360 HEAD SETTLE
        JMP     SHORT DO_WAT
ISNT_WRITE:
        OR      AH,AH                   ; CHECK FOR NO WAIT
        JZ      HW_DONE                 ; IF NOT WRITE AND 0 ITS OK

;----- AH CONTAINS NUMBER OF MILLISECONDS TO WAIT

DO_WAT:
        MOV     AL,AH                   ; AL = # MILLISECONDS
        XOR     AH,AH                   ; AX = # MILLISECONDS
        PUSH    AX                      ; SAVE HEAD SETTLE PARAMETER
        MOV     DX,1000                 ; SET UP FOR MULTIPLY TO MICROSECONDS
        MUL     DX                      ; DX,AX = # MICROSECONDS
        MOV     CX,DX                   ; CX,AX = # MICROSECONDS
        MOV     DX,AX                   ; CX,DX = # MICROSECONDS
        MOV     AH,86H                  ; LOAD WAIT CODE
        INT     15H                     ; PERFORM WAIT
        POP     AX                      ; RESTORE HEAD SETTLE PARAMETER
        JNC     HW_DONE                 ; CHECK FOR EVENT WAIT ACTIVE
J29:                                    ; 1 MILLISECONDS LOOP
        MOV     CX,66                   ; COUNT AT 15.085737 US PER COUNT
        CALL    WAITF                   ; DELAY FOR 1 MILLISECONDS
        DEC     AL                      ; DECREMENT THE COUNT
        JNZ     J29                     ; DO AL MILLISECONDS # OF TIMES
HW_DONE:
        RET
HD_WAIT          ENDP
; --------------------------------------------------------------------
;  NEC_OUTPUT                                                         :
;       THIS ROUTINE SENDS A BYTE TO THE NEC CONTROLLER AFTER         :
;       TESTING FOR CORRECT DIRECTION AND CONTROLLER READY THIS       :
;       ROUTINE WILL TIME OUT IF THE BYTE IS NOT ACCEPTED WITHIN      :
;       A REASONABLE AMOUNT OF TIME, SETTING THE DISKETTE STATUSTION  :
;       ON COMPLETION.                                                :
;                                                                     :
;  ON ENTRY:                                                          :
;       AH = BYTE TO BE OUTPUT                                        :
;  ON EXIT:                                                           :
;       CY = 0 SUCCES                                                 :
;       CY = 1 FAILURE -- DESKETTE STATUS UP DATED                    :
;              IF A FAILURE HAS OCCURRED, THE RETURN IS MADE          :
;              ONE LEVEL HIGNER THAN THE CALLER OF NEC_OUTPUT.        :
;              THIS REMOVES THE REQUIREMENT OF TESTING AFTER          :
;              EVERY CALL OF NEC_OUTPUT.                              :
;       AX,CX,DX DESTROYED                                            :
;----------------------------------------------------------------------
NEC_OUTPUT          PROC    NEAR
        PUSH    BX                      ; SAVE REG.
        MOV     DX,03F4H                ; STATUS PORT
        MOV     BL,2                    ; HIGH ORDER COUNTER
        XOR     CX,CX                   ; COUNT FOR TIME OUT

J23:
        IN      AL,DX                   ; GET STATUS
        AND     AL,11000000B            ; KEEP STATUS AND DIRECTION
        CMP     AL,10000000B            ; STATUS 1 AND DIRECTION 0 ?
        JZ      J27                     ; STATUS AND DIRECTION OK
        LOOP    J23                     ; CONTINUE TILL CX EXHAUSTED

        DEC     BL                      ; DECREMENT COUNTER
        JNZ     J23                     ; REPEAT TILL DELAY FINISHED, CX=0

;------- FALL THRU TO ERROR RETURN

        OR      DISKETTE_STATUS,TIME_OUT
        POP     BX                      ; RESTORE REG.
        POP     AX                      ; DISCARD THE RETURN ADDRESS
        STC                             ; INDICATE ERROR TO CALLER
        RET

;------- DIRECTION AND STATUS OK; OUTPUT BYTE

J27:
        MOV     AL,AH                   ; GET BYTE TO OUTPUT
        INC     DX                      ; DATA PORT = STATUS PORT + 1
        OUT     DX,AL                   ; OUTPUT THE BYTE
        PUSHF                           ; SAVE FLAG
        MOV     CX,3                    ; 30 TO 45 MICROSECOND WAIT FOR
        CALL    WAITF                   ; NEC FLAGS UPDATE CYCLE
        POPF                            ; RESTORE FLAG FOR EXIT
        POP     BX                      ; RESTORE REG.
        RET                             ; CY = 0 FROM TEST INSTRUCTION
NEC_OUTPUT          ENDP
; ----------------------------------------------------------------
;  SEEK                                                          :
;       THIS ROUTINE WILL MOVE THE HEAD ON THE NAMED DRIVE       :
;       TO THE NAMED TRACK. IF THE DRIVE HAS NOT BEEN ACCESSED   :
;       SINCE THE DRIVE RESET COMMAND WAS ISSUED, THE DRIVE      :
;       WILL BE RECALIBRATED.                                    :
;                                                                :
;  ON ENTRY:    DI = DRIVE #                                     :
;               CH = TRACK #                                     :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION   :
;                 AX,BX,CX,DX DESTROYED                          :
;-----------------------------------------------------------------
SEEK    PROC    NEAR
        MOV     BX,DI                   ; BX = DRIVE #
        MOV     AL,1                    ; ESTABLISH MASK FOR RECALIBRATE TEST
        XCHG    CL,BL                   ; GET DRIVE VALUE INTO CL
        ROL     AL,CL                   ; SHIFT MASK BY THE DRIVE VALUE
        XCHG    CL,BL                   ; RECOVER TRACK VALUE
        TEST    AL,SEEK_STATUS          ; TEST FOR RECALIBRATE REQUIRED
        JNZ     J28A                    ; JUMP IF RECALIBRATE NOT REQUIRED
        OR      SEEK_STATUS,AL          ; TURN ON THE NO RECALIBRATE BIT IN
                                        ; FLAG
        CALL    RECAL                   ; RECALIBRATE DRIVE
        JNC     AFT_RECAL               ; RECALIBRATE DONE

;----- ISSUE RECALIBRETE FOR 80 TRACK DISKETTES

        MOV     DISKETTE_STATUS,0       ; CLEAR OUT INVALID STATUS
        CALL    RECAL                   ; RECALIBRATE DRIVE
        JC      RB                      ; IF RECALIBRATE FAILS TWICE THEN ERROR
AFT_RECAL:
        MOV     DSK_TRK[DI],0           ; SAVE NEW CYLINDER AS PRESENT POSITION
        OR      CH,CH                   ; CHECK FOR SEEK TO TRACK 0
        JZ      DO_WAIT                 ; HEAD SETTLE, CY = 0 IF JUMP

;------- DRIVE IS IN SYNCHRONIZATION WITH CONTROLLER, SEEK TO TRACK

J28A:
        TEST    DSK_STATE[DI],DBL_STEP  ; CHECK FOR DOUBLE STEP REQUIRED
        JZ      R7_1                      ; SINGLE STEP REQUIRED BYPASS DOUBLE
        SHL     CH,1                    ; DOUBLE NUMBER OF STAP TO TAKE
R7_1:
        CMP     CH,DSK_TRK[DI]          ; SEE IF ALREADY AT THE DESIRED TRACK
        JE      RB                      ; IF YES, DO NOT NEED TO SEEK
        MOV     DX,OFFSET NEC_ERR       ; LOAD RETURN ADDRESS
        PUSH    DX                      ; ON STACK FOR NEC_OUTPUT ERROR
        MOV     DSK_TRK[DI],CH          ; SAVE NEW CYLINDER AS PRESENT POSITION
        MOV     AH,0FH                  ; SEEK COMMAND TO NEC
        CALL    NEC_OUTPUT
        MOV     BX,DI                   ; BX = DRIVE #
        MOV     AH,BL                   ; OUTPUT DRIVE NUMBER
        CALL    NEC_OUTPUT
        MOV     AH,DSK_TRK[DI]          ; GET CYLINDER NUMBER
        CALL    NEC_OUTPUT
        CALL    CHK_STAT_2              ; ENDING INTERRUPT AND SENSE STATUS

;--------- WAIT FOR HEAD SETTLE

DO_WAIT:
        PUSHF                           ; SAVE STATUS
        CALL    HD_WAIT                 ; WAIT FOR HEAD SETTLE TIME
        POPF                            ; RESTORE STATUS
RB:
NEC_ERR:
        RET                             ; RETURN TO CALLER
SEEK    ENDP
; ----------------------------------------------------------------
;  RECAL                                                         :
;       RECALIBRATE DRIVE                                        :
;                                                                :
;  ON ENTRY:    DI = DRIVE #                                     :
;                                                                :
;  ON EXIT:     CY REFLECTS STATUS OF OPERATION.                 :
;-----------------------------------------------------------------
RECAL          PROC    NEAR
        PUSH    CX
        MOV     AX,OFFSET RC_BACK       ; LOAD NEC_OUTPUT ERROR
        PUSH    AX
        MOV     AH,07                   ; RECALIBRATE COMMAND
        CALL    NEC_OUTPUT
        MOV     BX,DI                   ; BX = DRIVE #
        MOV     AH,BL
        CALL    NEC_OUTPUT              ; OUTPUT THE DRIVE NUMBER
        CALL    CHK_STAT_2              ; GET THE INTERRUPT AND SENSE INT
                                        ; STATUS
        POP     AX                      ; THROW AWAY ERROR
RC_BACK:
        POP     CX
        RET
RECAL          ENDP
; ----------------------------------------------------------------
;  SEEK                                                          :
;       THIS ROUTINE HANDLES THE INTERRUPT RECEIVED AFTERE       :
;       RECALIBRATE OR SEEK TO THE ADAPTER. THE                  :
;       INTERRUPT IS WAITED FOR, THE INTERRUPT STATUS SENSED,    :
;       AND THE RESULT RETURNED TO THE CALLER.                   :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION.  :
;-----------------------------------------------------------------
CHK_STAT_2          PROC    NEAR
        MOV     AX,OFFSET CS_BACK       ; LOAD NEC_OUTPUT ERROR ADDRESS
        PUSH    AX
        CALL    WAIT_INT                ; WAIT FOR THE INTERRUPT
        JC      J34                     ; IF ERROR, RETURN IT
        MOV     AH,08H                  ; SENSE INTERRUPT STATUS COMMAND
        CALL    NEC_OUTPUT
        CALL    RESULTS                 ; READ IN THE RESULTS
        JC      J34
        MOV     AL,NEC_STATUS           ; GET THE FIRST STATUS BYTE
        AND     AL,01100000B            ; ISOLATE THE BITS
        CMP     AL,01100000B            ; TEST FOR CORRECT VALUE
        JZ      J35                     ; IF ERROR, GO MARK IT
        CLC                             ; GOOD RETURN
J34:
        POP     AX                      ; THROW AWAY ERROR RETURN
CS_BACK:
        RET
J35:
        OR      DISKETTE_STATUS,BAD_SEEK
        STC                             ; ERROR RETURN CODE
        JMP     SHORT J34
CHK_STAT_2      ENDP
; ----------------------------------------------------------------
;  WAIT_INT                                                      :
;       THIS ROUTINE WAITS FOR AN INTERRUPT TO OCCUR A TIME OUT  :
;       ROUTINE TAKES PLACE DURING THE WAIT, SO THAT AN ERROR    :
;       MAY BE RETURNED IF THE DRIVE IS NOT READY.               :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION.  :
;-----------------------------------------------------------------
WAIT_INT          PROC    NEAR
        STI                             ; TURN ON INTERRUPTS, JUST IN CASE
        CLC                             ; CLEAR TIMEOUT INDICATOR
        MOV     AX,09001H               ; LOAD WAIT CODE AND TYPE
        INT     15H                     ; PERFORM OTHER FUNCTION
        JC      J36A                    ; BYPPAS TIMING LOOP IF TIMEOUT DONE
        MOV     BL,10                   ; CLEAR THE COUNTERS
        XOR     CX,CX                   ; FOR 2 SECONDS WAIT

J36:
        TEST    SEEK_STATUS,INT_FLAG    ; TEST FOR INTERRUPT OCCURRING
        JNZ     J37
        LOOP    J36                     ; COUNT DOWN WHILE WAITING
        DEC     BL                      ; SECONDS LEVEL COUNTER
        JNZ     J36
J36A:
        OR      DISKETTE_STATUS,TIME_OUT        ; NOTHING HAPPEND
        STC                             ; ERROR RETURN
J37:
        PUSHF                           ; SAVE CURRENT CARRY
        AND     SEEK_STATUS,NOT INT_FLAG        ; TURN OFF INTERRUPT FLAG
        POPF                            ; RECOVER CARRY
        RET                             ; GOOD RETURN  CODE
WAIT_INT          ENDP
; ----------------------------------------------------------------
;  RESULTS                                                       :
;       THIS ROUTINE WILL READ ANYTHING THAT THE NEC CONTROLLER  :
;       RETURNS FOLLOWING AN INTERRUPT.                          :
;                                                                :
;  ON EXIT:     DSKETTE_STATUS, CY REFLECT STATUS OF OPERATION.  :
;                 AX,BX,CX,DX DESTROYED                          :
;-----------------------------------------------------------------
RESULTS          PROC    NEAR
        PUSH    DI
        MOV     DI,OFFSET NEC_STATUS    ; POINTER TO DATA AREA
        MOV     BL,7                    ; MAX STATUS BYTES
        MOV     DX,03F4H                ; STATUS PORT

;----- WAIT FOR REQUEST FOR MASTER

R10_1:
        MOV     BH,2                    ; HIGH ORDER COUNTER
        XOR     CX,CX                   ; COUNTER

J39:                                    ; WAIT FOR MASTER
        IN      AL,DX                   ; GET STATUS
        AND     AL,11000000B            ; KEEP ONLY STATUS AND DIRECTION
        CMP     AL,11000000B            ; STATUS 1 AND DIRECTION 1 ?
        JZ      J42                     ; STATUS AND DIRECTION OK
        LOOP    J39                     ; LOOP TILL TIMEOUT

        DEC     BH                      ; DECREMENT HIGH ORDER COUNTER
        JNZ     J39                     ; REPEAT TILL DELAY DONE
        OR      DISKETTE_STATUS,TIME_OUT
        STC                             ; SET ERROR RETURN
        JMP     SHORT POPRES            ; POP REGISTRS AND RETURN

;------ READ IN THE STATUS

J42:
        JMP     $+2                     ; WAIT FOR I/O
        INC     DX                      ; POINT AT DATA PORT
        IN      AL,DX                   ; GET THE DATA
        MOV     [DI],AL                 ; STORE THE BYTE
        INC     DI                      ; INCREMENT THE POINTER
        MOV     CX,3                    ; MINIMUM 24 MICROSECONDS FOR NEC
        CALL    WAITF                   ; WAIT 30 TO 45 MICROSECONDS
        DEC     DX                      ; POINT THE STATUS PORT
        IN      AL,DX                   ; GET STATUS
        TEST    AL,00010000B            ; TEST FOR NEC STILL BASY
        JZ      POPRES                  ; RESULTS DONE ?
        DEC     BL                      ; DECREMENT THE STATYS COUNTER
        JNZ     R10_1                     ; GO BACK FOR MORE
        OR      DISKETTE_STATUS,BAD_NEC ; TOO MANY STATUS BYTES
        STC                             ; SET ERROR FLAG

;------RESULT OPERATION IS DONE

POPRES:
        POP     DI
        RET                             ; RETURN WITH CARRY SET
RESULTS          ENDP
; ----------------------------------------------------------------
;  READ_DSKCHNG                                                  :
;       READS THE STATE OF THE DISK CHANGE LINE.                 :
;  ON ENTRY:    DI = DRIVE #                                     :
;                                                                :
;  ON EXIT:     DI = DRIVE #                                     :
;               ZF = 0 :DISK CHANGE LINE INACTIVE                :
;               ZF = 1 :DISK CHANGE LINE ACTIVE                  :
;               AX,BX,CX,DX DESTROYED                            :
;-----------------------------------------------------------------
READ_DSKCHNG          PROC    NEAR
        CALL    MOTOR_ON                ; TURN ON MOTOR IF NOT ALREADY ON
        JC	RET_MED_CHNG
        push	ds
        call	dds
	and     DSK_STATE[DI],not MED_DET
        pop	ds
        INC	AL                      ; RESET ZF
        RET
;        MOV     DX,03F7H                ; ADDRESS DIGITAL INPUT REGISTER
;        IN      AL,DX                   ; INPUT DIGITAL INPUT REGISTER
RET_MED_CHNG:
	SUB	AL,AL                   ; NO MEDIA CHANGE
;        TEST    AL,DSK_CHG              ; CHECK FOR DISK CHANGE LINE ACTIVE
        RET                             ; RETURN TO CALLER WITH ZERO FLAG SET
READ_DSKCHNG          ENDP
; ----------------------------------------------------------------
;  DRIVE_DET                                                     :
;       DETERMINES WHETHER DRIVE IS 80 OR 40 TRACKS AND          :
;       UPDATES STATE INFORMATION ACCORDINGLY.                   :
;                                                                :
;  ON ENTRY:    DI = DRIVE #                                     :
;-----------------------------------------------------------------
DRIVE_DET          PROC    NEAR
        CALL    MOTOR_ON                ; TURN ON MOTOR IF NOT ALREADY ON
        CALL    RECAL                   ; RECALIBRATE DRIVE
        JC      DD_BAC                  ; ASSUME NO DRIVE PRESENT
        MOV     CH,TRK_SLAP             ; SEEK TO TRACK 48
        CALL    SEEK
        JC      DD_BAC                  ; ERROR NO DRIVE
        MOV     CH,QUIET_SEEK+1         ; SEEK TO TRACK 10
SK_GIN:
        DEC     CH                      ; DECREMENT TO NEX TRACK
        PUSH    CX                      ; SAVE TRACK
        CALL    SEEK
        JC      POP_BAC                 ; POP AND RETURN
        MOV     AX,OFFSET POP_BAC       ; LOAD NEC OUTPUT ERROR ADDRESS
        PUSH    AX
        MOV     AH,SENSE_DRV_ST         ; SENSE DRIVE STATUS COMMAND BYTE
        CALL    NEC_OUTPUT              ; OUTPUT TO NEC
        MOV     AX,DI                   ; AL = DRIVE
        MOV     AH,AL                   ; AH = DRIVE
        CALL    NEC_OUTPUT              ; OUTPUT TO NEC
        CALL    RESULTS                 ; GO GET STATUS
        POP     AX                      ; THROW AWAY ERROR ADDRESS
        POP     CX                      ; RESTORE TRACK
        TEST    NEC_STATUS,HOME         ; TRACK O ?
        JZ      SK_GIN                  ; GO TILL TRACK 0
        OR      CH,CH                   ; IS HOME AT TRACK 0 ?
        JZ      IS_80                   ; MUST BE 80 TRACK DRIVE

;       DRIVE IS A 360 ; SET DRIVE TO DETERMINED;
;       SET MEDIA TO DETERMINED AT RATE 250.

        OR      DSK_STATE[DI],DRV_DET+MED_DET+RATE_250
        RET                             ; ALL INFORMATION SET
IS_80:
        OR      DSK_STATE[DI],TRK_CAPA  ; SETUP 80 TRACK CAPABILITY
DD_BAC:
        RET
POP_BAC:
        POP     CX                      ; THROW AWAY
        RET
DRIVE_DET          ENDP
; ----------------------------------------------------------------
;  DISK_INT                                                      :
;       THIS ROUTINE HANDLES THE DISKETTE INTERRUPT.             :
;                                                                :
;  ON EXIT:     THE INTERRUPT FLAG IS SET IN SEEK_STATUS         :
;-----------------------------------------------------------------
DISK_INT        PROC    FAR             ; ENTRY POINT FOR ORG OEF57H
        PUSH    AX                      ; SAVE WORK REGISTER
        PUSH    DS                      ; SAVE REGISTERS
        CALL    DDS                     ; SETUP DATA ADDRESSING
        OR      SEEK_STATUS,INT_FLAG    ; TURN ON INTERRUPT OCCURRED
        POP     DS                      ; RESTORE USER DS)
        MOV     AL,EOI                  ; END OF INTERRUPT MARKER
        OUT     INTA00,AL               ; INTERRUPT CONTROL PORT
        STI                             ; RE-ENABLE INTERRUPTS
        MOV     AX,09101H               ; INTERRUPT POST CODE AND TYPE
        INT     15H                     ; GO PERFORM OTHER TASK
        POP     AX                      ; RECOVER REGISTER
        IRET                            ; RETURN FROM INTERRUPT
DISK_INT        ENDP
; ----------------------------------------------------------------
;  DSKETTE_SETUP                                                 :
;       THIS ROUTINE DOES A PRELIMINARY CHECK TO SEE WHAT TYPE   :
;       OF DISKETTE DRIVES ARE ATTACH TI THE SYSTEM.             :
;-----------------------------------------------------------------
DSKETTE_SETUP   PROC    NEAR
        PUSH    AX                      ; SAVE REGISTERS
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    DS
        CALL    DDS                     ; POINT DATA SEGMENT TO BIOS DATA AREA
        OR      RTC_WAIT_FLAG,01        ; NO RTC WAIT , FORCE USE OF LOOP
        XOR     DI,DI                   ; INITIALIZE DRIVE POINTER
        MOV     WORD PTR DSK_STATE,0    ; INITIALIZE STATES
        AND     LASTRATE,NOT STRT_MSK+SEND_MSK  ; CLEAR START & SEND
        OR      LASTRATE,SEND_MSK       ; INITIALIZE SENT TO IMPOSSIBLE
        MOV     SEEK_STATUS,0           ; INDICATE RECALIBRATE NEEDED
        MOV     MOTOR_COUNT,0           ; INITIALIZE MOTOR COUNT
        MOV     MOTOR_STATUS,0          ; INITIALIZE DRIVES TO OFF STATE
        MOV     DISKETTE_STATUS,0       ; NO ERRORS
SUPO:
        CALL    DRIVE_DET               ; DETERMINE DRIVE
        CALL    XLAT_OLD                ; TRANSLATE STATE TO COMPATIBLE MODE
        INC     DI                      ; POINT TO NEXT DRIVE
        CMP     DI,MAX_DRV              ; SEE IF DONE
        JNZ     SUPO                    ; REPEAT FOR EACH DRIVE
        MOV     SEEK_STATUS,0           ; FORCE RECALIBRATE
        AND     RTC_WAIT_FLAG,0FEH      ; ALLOW FOR RTC WAIT
        CALL    SETUP_END               ; VARIOUS CLEANUPS
        POP     DS                      ; RESTORE CALLERS REGISTERS
        POP     DI
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
DSKETTE_SETUP   ENDP
