;------------   INT 13      ---------------
;    **** ‚‚„-‚›‚„ € „‘…’“ ****

CONTROL_STAT   EQU    0C0H   ;’ ’‹  ‘‘’
;--------------------------------------------------
; €‡€—…… €‡„‚ …ƒ‘’€ (’€) CONTROL_STAT
;--------------------------------------------------
;       D0 - ‡€’
;       D1 - „…‘ “‹‘€, ‘’‚. DRQ
;       D2 - ƒ € 0 „†… ‹ ’€‰€“’  ‡  —’
;       D3 - € CRC ()
;       D4 - …’ ‡€‘, … €‰„… €‘‘‚
;       D5 - ƒ ‡€ƒ“†…€ ‹ ‘ ‘’€… €  —’
;            ‹ „†€ … €‰„…€  ‡
;       D6 - ‡€™’€ ‡€‘
;       D7 - … ƒ’‚
;---------------------------------------------------

TRACK          EQU    0C1H   ;’ …€ „†
SECTOR         EQU    0C2H   ;’ …€ ‘…’€
DATA_F         EQU    0C3H   ;’ „€›•
;    ========   „‹ —’… :  ===========
;
MOTOR_EN       EQU    0C6H   ;‘‘’… „‚ƒ€’…‹ <D0>
RD_INTRQ       EQU    0C4H   ;—’…… INTRQ ‹ DRQ, D0-INTRQ
;
;   =========   „‹ ‡€‘ :  ===========
RG_C           EQU    0C4H   ;DDEN,HDSEL,FDRES,
                             ;EN. MOTORS,DRIVES(SEL1,SEL2)
;-------------------------------------
; €‡€—…… €‡„‚ …ƒ‘’€ (’€) RG_C
;-------------------------------------
;       D0 - DRIVE SELECT 0      -‚› “‘’‰‘’‚€ 0
;       D1 - DRIVE SELECT 1      -‚› “‘’‰‘’‚€ 1
;       D2 - MOTOR ON 0          -‚‹. ’ 0
;       D3 - MOTOR ON 1          -‚‹. ’ 1
;       D4 - SIDE (HEAD) SELECT  -‚› ‘’› (ƒ‹‚)
;       D5 - DOUBLE DENSITY      -…† „‚‰‰ ‹’‘’
;       D6 - FDC RESET           -‘‘ „‚‰‰ ‹’‘’
;       D7 - NO USE              -… ‘‹‡“…’‘
;-------------------------------------
MOTOR_ON       EQU    0C6H   ;‚‹. ’€

; =========  €   ‚ •  „ …  =============
;       €L      -‹—…‘’‚ ‘…’‚ „‹ —’-‡
;       AH      -„ …€–
;            0    -‘‘
;            1    -—’…… ‘‘’
;            2    -—’…… „€›•
;            3    -‡€‘ „€›•
;            4    -‘, ‚…€
;            5    -”€’‚€…
;- - - - - - - - - - - - - - - - - - - -
;       DH      -… ƒ‹‚
;       DL      -… “‘’‰‘’‚€ (0-3)
;- - - - - - - - - - - - - - - - - - - -
;       CH      -… –‹„€ („†)
;       ‘L      -… ‘…’€ (1-17)
;- - - - - - - - - - - - - - - - - - - -
;       ES:BX   -€„…‘ “”…€
;
; ============== „› ‡€‚…… ==================
BAD_CMD         EQU    1        ;…‚…€ €„€ (€>5,DL>3)
BAD_ADDR_MARK   EQU    2        ;
WRITE_PROTECT   EQU    3        ;‡€™’€ ‡€‘
RECORD_NOT_FND  EQU    4        ;
BAD_DMA         EQU    8        ;
DMA_BOUNDARY    EQU    9        ;
BAD_CRC         EQU    10H      ;
BAD_FDC         EQU    20H      ;…’ ‘‘€
BAD_SEEK        EQU    40H      ;
TIME_OUT        EQU    80H      ;’€‰-€“’
;===================================================
;
SEEK_OK         EQU    0
READ_WRITE_OK   EQU    0
SEEK_COMMAND    EQU   1cH       ;V = 1,h = 1
SEEK_COMNOV     EQU   10H       ;V = 0
READ_COMMAND    EQU   80H
WRITE_COMMAND   EQU   0A0H
WR_TRACK        EQU   0F0H
STEP_COMMAND    EQU   48H
WORD_DDEN       EQU   0
;
data    segment at 40h
        ORG     3EH
;----------------------------------------------------------------------------
; DISKETTE DATA AREAS     - ‹€‘’ „€›•
;----------------------------------------------------------------------------
SEEK_STATUS            DB     ?             ;DRIVE RECALIBRATION STATUS
;                                           BIT 3-0= DRIVE 3-0 NEEDS RECAL
;                                           BEFORE NEXT SEEK IF BIT IS=0
INT_FLAG               EQU    080H          ;”‹€ƒ €‹— …›‚€
MOTOR_STATUS           DB     ?             ;‘‘’… „‚ƒ€’…‹
;                             BIT 3-0 = DRIVE 3-0 IS CURRENTLY RUNNING
;                             BIT 7 = CURRENT OPERATION IS A WRITE,
;                             REQUIRES DELAY
;                                           DISKETES
MOTOR_WAIT             EQU    37            ;TWO SECONDS OF COUNTS FOR
;                                           MOTOR TURN OFF
MOTOR_COUNT            DB      ?
;
DISKETTE_STATUS        DB     ?             ;€‰’ „€ ‚‡‚€’€
;
NEC_STATUS             LABEL BYTE              ;7 BYTE
TRACK_PTR              DB     2 DUP(?)



STEP_MULT              DB     ?             ;‡€ 1 -“‘’ 0,1
                                            ;        2 -“‘’ 2,3
DRIVER_N               DB     0             ;… €’‚ƒ “‘’-‚€
                       DB     3 DUP (?)       ;…‡…‚




;-----------------------------------------------------------------------
data ends

;
code    segment
        assume cs:code,ds:data

; €’„†€ ‘ƒ€’“€

        DW      0AA55H
        DB      03H

DISK_INIT    PROC   FAR

; / –€‹‡€– „‘‚ƒ €„€’…€

        MOV     AX,0H
        MOV     DS,AX
        MOV     BX,410H
        MOV     AX,DS:[BX]
        OR      AX,01H            ;„ΰ ©Ά¥ΰ ƒ„ ―ΰ¨αγβαβΆγ¥β
        MOV     DS:[BX],AX
        MOV     BX,4CH            ;“αβ ­®Ά¨βμ Ά¥ªβ®ΰ INT13H
        LEA     AX,DISKETTE_IO
        MOV     DS:[BX],AX
        PUSH    CS
        POP     AX
        MOV     DS:[BX+2],AX
        DB      0CBH           ;(RETF)
DISK_INIT    ENDP

DISKETTE_IO  PROC  FAR
        STI                     ;€‡……… …›‚€‰
        PUSH    BX              ;‘•€…… …ƒ‘’‚
        PUSH    CX
        PUSH    DS
        PUSH    SI
        PUSH    DI
        PUSH    BP
        PUSH    DX
        MOV     BP,SP           ;“€‡€’…‹ ‘’…€
        MOV     SI,DATA         ;DATA-‘…ƒ…’
        MOV     DS,SI           ;–€– DATA-‘…ƒ…’€
        PUSH    CX              ;‘•. ‘•
        MOV     CH,1
        TEST    DL,2            ;“‘’‰‘’‚ 2,3?
        JNZ     STM             ;„€
        MOV     STEP_MULT,1     ;“‘’0,“‘’1
        JMP     STM1
STM:    MOV     STEP_MULT,2     ;“‘’2(*),“‘’3(*)
        AND     DL,1            ;‘’‚. ‚ 0,1
STM1:   MOV     CL,DL           ;… “‘’‰‘’‚€
        ROL     CH,CL           ;‘„‚ƒ 1  …“ “‘’‰‘’‚€
        MOV     MOTOR_STATUS,CH ;€‰’ –€‹‡€– (… “‘’‰‘’‚€)
        POP     CX              ;‚‘‘’€‚‹…… ‘•
        CALL    J1              ;€ …„…‹…… „€ €„›
        MOV     AH,DISKETTE_STATUS ;„ ‡€‚……
        CMP     AH,1            ;…‘‹ €=0,TO CF=1, €—… CF=0
        CMC                     ;‚…‘ ’€ CF
        POP     DX              ;‚‘‘’€‚‹…… …ƒ‘’‚
        POP     BP
        POP     DI
        POP     SI
        POP     DS
        POP     CX
        POP     BX
        RET     2               ;‚‡‚€’ …†‘…ƒ…’›‰ ‘ ‘•. ”‹€ƒ‚
DISKETTE_IO ENDP

;========== …„…‹…… „€ €„›  AH ===========
J1:     AND     MOTOR_STATUS,7FH  ;„€– „‹ —’… (‚7=0)
        OR      AH,AH           ;AH = 0?
        JZ      DISK_RESET      ;„€, €„€ ‘‘€
        CMP     AH,6
        JNL     J3              ;…‚…€ €„€ (AH > 5)
        CMP     AH,1            ;—’…… ‘‘’?
        JZ      DISK_STATUS     ;„€, (AH = 1)
        MOV     DISKETTE_STATUS,0   ;„ ‡€‚…… €‹›‰ (0)
        CMP     DL,2            ;“‘’‰‘’‚ 0,1?
        JAE     J3              ;…’ (DL > 3)
        cmp     ah,5            ;€=5?
        jz      form            ;„€, ”€’‚€…
        CMP     AH,3            ;„ -– … ‹… 3?
        JBE     RW_OPN          ;„€, —’/‡ …€– (AH = 2,AH = 3)
        JMP     VERIFY_OPN      ;-– ‚… (AH = 4)
J3:     MOV     DISKETTE_STATUS,BAD_CMD   ;„ 
        RET                     ;‚‡‚€’
form:   jmp     form1           ;€ / ”€’‚€

;===============================================================
;       / —’… ‘‘’ (€=1)
;===============================================================
;
;
DISK_STATUS:
        MOV     AL,DISKETTE_STATUS
        RET
;
;
;===============================================================
;       / ‘‘€ ‚ ‘•„… ‘‘’… (€=0)
;===============================================================
DISK_RESET:
        PUSH    AX              ;‘•€…… …ƒ‘’‚
        PUSH    SI
        PUSH    CX
        PUSH    DX
        CLI                     ;‡€…’ …›‚€‰
        OUT     MOTOR_ON,AL     ;-‚ ‘…’‚-->C6 ?????????????
        MOV     SI,DX           ;… “‘’‰‘’‚€
        AND     SI,1            ;‚›„…‹…… …€ “‘’.
        MOV     TRACK_PTR [SI],0   ;0 ‚ €‰’  …“ “‘’.
        MOV     CL,DL           ;… “‘’‰‘’‚€
        MOV     AL,5            ;“‘’. 0, ’ 0
        SAL     AL,CL           ;‘„‚ƒ € ‹—…‘’‚  …“ “‘’.
        MOV     AH,DH           ;… ƒ‹‚ (‘’›)
        AND     AH,1            ;‚›„…‹…… ‹. ’€ (0 ‹ 1)
        MOV     CL,4            ;
        ROL     AH,CL           ;… ƒ‹‚ ‚ D4
        OR      AL,AH           ;(“‘’+’)+ƒ‹‚€
        OUT     RG_C,AL         ;‘‘ .... „‚‰‰ ‹’‘’
        OR      AL,40H          ;+ ‘‘ „‚‰‰ ‹’‘’
        MOV     SEEK_STATUS,0   ;‘’€’“‘ ›’ 0
        MOV     DISKETTE_STATUS,0  ;‘’€’“‘ ‘‘’ 0
        OUT     RG_C,AL;        ;‘ ‘‘ „‚‰‰ ‹’‘’
        STI                     ;€‡…’ …›‚€
        MOV     AH,2            ;2 €‡€
RETR:   XOR     CX,CX           ;‘•=0
RETR1:  PUSH    AX              ;‘•. €•
        IN      AL,CONTROL_STAT   ;—’…… ‘‘’
        AND     AL,5            ;‚›„…‹…… ’‚ 0  2
        CMP     AL,4            ;€‹? (ƒ € „ 0)
        POP     AX
        JZ      RESET_END       ;„€, …– ‘‘€
        LOOP    RETR1           ;…’, …‘’ …™… "‡€’"
        DEC     AH              ;
        JNZ     RETR            ;›’€’‘ 2 €‡€
        OR      DISKETTE_STATUS,BAD_FDC  ;…’ ‘‘€ „‚. ‹’‘’
                                         ;‚‘… ‚… "‡€’"
        MOV     TRACK_PTR [SI], 0FFH  ;FF ‚ €‰’  …“ “‘’.
RESET_END:
        POP     DX              ;‚‘‘’€‚‹…… …ƒ‘’‚
        POP     CX
        POP     SI
        POP     AX
        RET

;===============================================================
;       / —’…-‡€‘
;===============================================================
;
RW_OPN: OR      AH,AH           ;„ €=2 (—’……)?
        JNP     J9              ;„€       ????????????????
        OR      MOTOR_STATUS,80H   ;‡€ ‡€‘
J9:     CALL    SELECT_DRIVE    ;‚› “‘’.+’+ƒ‹‚€
        CALL    TEST_WAIT       ;‡€„…†€
        TEST    MOTOR_STATUS,80H   ;‡€‘?
        JNZ     WRITE_DISK      ;„€
READ_DISK:                      ;—’…… ‘ „‘€
        MOV     DL,0            ;‘—…’— —‘‹€ ‘…’‚
        PUSH    BX
        MOV     BL,SEEK_COMMAND ;‘ ‘ ‡€ƒ“‡‰ ƒ  ‚.
        CALL    SEEK            ;‘
        POP     BX
        JC      ERR_OUT         ;›‹€ € (CF=1)
READ_LENG:
        CALL    READ            ;€ / —’…
        JC      ERR_OUT         ;›‹€ €
        INC     DL              ;+1  ‘—…’—“ ‘…’‚
        CALL    GET_SECTOR      ;“‘’€‚€ € ‘‹…„. ‘…’
        CMP     AL,DL           ;‚‘… ‘…’€?
        JNZ     READ_LENG       ;…™… …’
        RET                     ;—’…… ‡€‚……
ERR_OUT:
        MOV     AL,DL           ;… ‘…’€ ‘ ‰
        RET
WRITE_DISK:
        MOV     DL,0            ;‘—…’— —‘‹€ ‘…’‚
        PUSH    BX
        MOV     BL,SEEK_COMMAND ;‘ ‘ ‡€ƒ“‡‰ ƒ  ‚.
        CALL    SEEK            ;‘
        POP     BX
        JC      ERR_OUT         ;›‹€ €
WRITE_LENG:
        CALL    WRITE           ;‡€‘
        JC      ERR_OUT         ;›‹€ €
        INC     DL              ;+1  ‘—…’—“ ‘…’‚
        CALL    GET_SECTOR      ;“‘’€‚€ € ‘‹…„. ‘…’
        CMP     AL,DL           ;‚‘… ‘…’€?
        JNZ     WRITE_LENG      ;… ™…
        RET                     ;‡€‘ ‡€‚……€


;==========================================================================
;       / ”€’‚€ „‘…’› „†
;==========================================================================
FORM1:  CALL    SELECT_DRIVE    ;“‘’+’+ƒ‹‚€
        CALL    TEST_WAIT       ;‚‹ ’€
        PUSH    BX
        MOV     BL,SEEK_COMNOV  ;„ 10 -‘
        CALL    SEEK            ;€ / ‘€
        POP     BX
        JC      ERR_FORM        ;…‘‹ ›‹€ , CF=1
        CALL    WRITE_TRACK
ERR_FORM:
        MOV     AL,9
        RET

;SUBROUTINE  WRITE TRACK FOR FORMAT-/ ”€’‚€
;SI-TRACK,SIDE                     -SI „†€,‘’€
;DI-END NUMB SEC ,SIZE SEC         -DI ..‘…’€,€‡…
;AH-SECTOR                         -AH ‘…’
;ES-SIZE SEC IN BYTE               -ES €‡… ‘…’€
;
WRITE_TRACK:
        PUSH ES
        MOV     AX,ES:[BX]      ;‘‹‚ ‘ “”…€ („., ‘’.)
        MOV     SI,512          ;€‡… ‘…’€
        MOV     ES,SI           ;
WR_TRACK5:
        MOV     SI,AX           ;„†€, ‘’€
        MOV     DI,10*256+2     ;…—›‰  ‘—…’— ‘…’‚
        MOV     AH,01           ;€—€‹›‰ ‘—…’— ‘…’‚
        CALL    WRITE_TR        ;‡€‘ € „†“
        POP     ES
        RET

       ;/ ‡€‘ ”€’€ € „†“
WRITE_TR:
        MOV     DX,DATA_F       ;’ „€›•
        MOV     AL,WR_TRACK     ;„ "‡€‘ „†"
        CLI                     ;‡€…’ …›‚€‰
        OUT     CONTROL_STAT,AL ;€„€ "‡ „†"
                        ;80 €‰’ 4… (…‹)
        MOV     CX,80
WLD01:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,4EH
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD01
                        ;12 €‰’ 00
        MOV     CX,12
WLD02:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        SUB     AL,AL
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD02
                        ;3 €‰’€ F6 (‡ ‘2)
        MOV     CX,3
WLD03:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0F6H
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD03
                        ;1 €‰’ FC ()
        IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0FCH
        OUT     DX,AL          ;WRITE DATA
                        ;50 €‰’ 4… (1-‰ …‹)
        MOV     CX,50
WLD05:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,4EH
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD05
                        ;11 €‰’ 00
        MOV     CX,11
WLD06:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        SUB     AL,AL
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD06
                        ;+1 €‰’ 00
WR_SEC:
        IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        SUB     AL,AL
        OUT     DX,AL          ;WRITE DATA
                        ;3 €‰’€ F5 (‡ €1)
        MOV     CX,3
WLD08:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0F5H
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD08
                        ;1 €‰’ FE (€„…‘€ …’€)
WLD09:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0FEH
        OUT     DX,AL          ;WRITE DATA
                               ;adress label
                        ;1 €‰’ (… „†)
        MOV     BX,SI
WLD0A:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,BL
        OUT     DX,AL          ;WRITE DATA
                               ;number track
                        ;1 €‰’ (… ‘’›)
WLD0B:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,BH
        OUT     DX,AL          ;WRITE DATA
                               ;number side
                        ;1 €‰’ (… ‘…’€)
WLD0C:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,AH
        OUT     DX,AL          ;WRITE DATA
                               ;number sector
        INC     AH             ;+1  …“ ‘…’€
                        ;1 €‰’ („‹€ ‘…’€)
        MOV     BX,DI          ; <0€02>
WLD0D:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,BL
        OUT     DX,AL          ;WRITE DATA
                                ;size sector
                        ;1 €‰’ F7 (2 €‰’€ )
WLD0E:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0F7H
        OUT     DX,AL          ;WRITE DATA
                                 ;byte crc
                        ;22 €‰’€ 4… (2-‰ …‹)
        MOV     CX,22
WLD0F:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,4EH
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD0F
                        ;12 €‰’ 00
        MOV     CX,12
WLD10:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        SUB     AL,AL
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD10
                        ;3 €‰’€ F5 (‡ €1)
        MOV     CX,3
WLD11:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0F5H
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD11
                        ;1 €‰’ FB (€„.…’€ „€›•)
                        ;…‡ ‘’€
WLD12:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0FBH
        OUT     DX,AL          ;WRITE DATA
                        ; €‡…“ ‘…’€ <512> €‰’ 4…
        MOV     CX,ES
WLD13:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,4EH
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD13
                        ;1 €‰’ F7 (2 €‰’€ )
WLD14:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,0F7H
        OUT     DX,AL          ;WRITE DATA
                        ;54 €‰’€ 4… (3-‰ …‹)
        MOV     CX,54
WLD15:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,4EH
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD15
                        ;11 €‰’ 00
        MOV     CX,11
WLD16:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        SUB     AL,AL
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD16
        CMP     AH,BH           ;‚‘… ‘…’€ ’ 1-9 (€=10)
        JNZ     WR_SEC          ;…’ …™…
                        ;598 €‰’ 4… (4-‰ …‹)
        MOV     CX,598
        MOV     BL,04EH
WLD17:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ
        MOV     AL,BL
        OUT     DX,AL          ;WRITE DATA
        LOOP    WLD17
        IN      AL,CONTROL_STAT ;—’…… ‘‘’
        AND     AL,47H          ;
        JZ      WRDSK_END       ;€‹ ‡€‘€
        TEST    AL,40H          ;‡€™’€ ‡€‘?
        MOV     AL,WRITE_PROTECT ;„  "‡€™’€"
        JNZ     ERR_EX          ;„€, €
        MOV     AL,BAD_FDC      ;„ ™…‰ 
ERR_EX:                         ;
        OR      DISKETTE_STATUS,AL ;„€‚‹…… „€ 
        STC                     ;CF=1 -- €
WRDSK_END:
        RET

;===============================================================
;       “‘’€‚€ € ‘‹…„“™‰ ‘…’
;===============================================================
GET_SECTOR:
        PUSH    AX
        INC     CL              ;“‚…‹—…… …€ ‘…’€
        MOV     AL,CL
        OUT     SECTOR,AL       ;‚›‚„ …€ ‘…’€
        POP     AX
        RET

;===============================================================
;       / ‚… „†
;===============================================================
VERIFY_OPN:
        CALL    SELECT_DRIVE    ;“‘’+’+ƒ‹‚€
        CALL    TEST_WAIT       ;‚‹. ’€
        MOV     DL,0            ;‘—. ‘—’€›• ‘…’‚
        PUSH    BX
        MOV     BL,SEEK_COMMAND ;‘ ‘ ‡€ƒ“‡‰ ƒ  ‚…‰
        CALL    SEEK
        POP     BX
        JC      ERR_OUTL        ;›‹€ € ‘€
VERIFY_LENG:
        CALL    VERIFY          ;/ ‚… —’……
        JC      ERR_OUTL        ;›‹€ €
        INC     DL              ;+1 ‘—’€›‰ ‘…’
        CALL    GET_SECTOR      ;“‘’€‚€ € ‘‹…„“™‰ ‘…’
        CMP     AL,DL           ;‚‘… ‘…’€ ?
        JNZ     VERIFY_LENG     ;…’ …™…
        RET                     ;‚…€ ‡€‚……€

VERIFY: PUSH    AX
        PUSH    DX
        MOV     DX,DATA_F       ;’ „€›•
        MOV     AL,READ_COMMAND ;„ "—’…… ‘…’€"
        CLI                     ;‡€…’ …›‚€‰"
        OUT     CONTROL_STAT,AL ;€„€
        NOP
VLOOP:  IN      AL,RD_INTRQ     ;—’…… DRQ ‹ INTRQ
        SHR     AL,1            ;‹. ’ ‚ ‘F
        IN      AL,DX           ;—’…… €‰’€
        JC      VLOOP           ;‘…’ …™… … ‚…‘
        STI
        CALL    ERR_TABL        ;”‚€… „€ ‡€‚……
        POP     DX
        POP     AX
        RET                     ;‚‡‚€’
ERR_OUTL:
        JMP     ERR_OUT

;===============================================================
;       / ‘€ „†
;===============================================================
SEEK:   PUSH    AX              ;‘•. AX,DX
        PUSH    DX              ;
        MOV     AH,0            ;
        MOV     AL,MOTOR_STATUS ;‘’€’“‘ ’€
        AND     AL,7FH          ;…‡ …€–
        SUB     AL,1            ;-1  ??????????????????????
        MOV     SI,AX           ;‘•.‘’€’“‘€
        CMP     TRACK_PTR [SI],0FFH  ;‘‘ ›‹ €‹›‰?
        JNZ     SEEK0           ;„€
SEEK00: PUSH    AX              ;›‹€ € ‘‘€
        CALL    SELECT_DRIVE    ;‚› “‘’+ƒ‹‚€
        PUSH    DX              ;C•. DX
        MOV     DX,SI           ;‘’€’“‘ “‘’‰‘’‚€ (…)
        CALL    DISK_RESET      ;‘‘
        POP     DX
        POP     AX
        CMP     DISKETTE_STATUS,0 ;‘’€’“‘ 0 (‘‘ €‹›‰)?
        JNZ     SEEK3           ;…’, €
        OR      TRACK_PTR [SI],AH ;AH=0   „‹ …‚ƒ ‚•„€ ‚ SEEK00
                                  ;AH=80H „‹ ‚’ƒ ‚•„€ ‚ SEEK00
SEEK0:  MOV     AL,TRACK_PTR [SI] ;‘‘ ›‹ €‹›‰
        MOV     AH,AL           ;0
        AND     AH,80H          ;‚›„…‹…… „7 (0)
        AND     AL,7FH          ;‚›„…‹…… „6-„0 (0)
        MOV     TRACK_PTR [SI],CH ;… „†
        OR      TRACK_PTR [SI],AH ;+ ????????????
        MOV     AH,20H
        SUB     AL,CH
        JZ      SEEK2           ;„‹ AL = CH,AH:=21H
        JNC     SEEK1           ;„‹ AL > CH,AH:=21H
        NEG     AL              ;„‹ AL < CH,AH:=1
        MOV     AH,0
SEEK1:  CMP     STEP_MULT,1     ;“‘’ 0,1
        JZ      STM3            ;„€
        SHL     AL,1            ;„‹ “‘’ 2(*),3(*) AL:=AL*2
STM3:   OR      AL,AL           ;„‹ “‘’ 0,1
        JZ      SEEK2
        CALL    STEP
        JMP     SEEK22
SEEK2:  MOV     AL,CH           ;… „†
        OUT     TRACK,AL        ;‚›‚„ …€ „†
SEEK22: MOV     DX,DATA_F       ;€„…‘ ’€ „€›•
        MOV     AL,CH           ;„†€
        OUT     DX,AL           ;‚›‚„ …€ „†
        MOV     DX,CONTROL_STAT ;’ ‘‘’
        MOV     AL,BL           ;€„€ ‘€
        OUT     DX,AL           ;„€—€ €„›
        NOP
        NOP
        IN      AL,RD_INTRQ     ;—’…… ’€ ‘ INTRQ
        IN      AL,DX           ;—’…… ‘‘’
        AND     AL,19H          ;‚›„…‹…… „0,„3,„4
        CMP     AL,SEEK_OK      ;€‹?
        JNZ     SEEK20          ;…’
        AND     TRACK_PTR [SI],7FH ;‡€‰ „7
        JMP     SHORT EXIT_SEEK
SEEK20: MOV     AL,TRACK_PTR [SI]  ;
        AND     AL,80H          ;‚›„…‹…… „7
        CMP     AL,80H          ;„7=1?
        JZ      SEEK3           ;„€, “†… ‚’‹
        MOV     AH,80H          ;…’, ‚’’
        JMP     SEEK00
SEEK3:  OR      DISKETTE_STATUS,BAD_SEEK ;+€ ‘€
        MOV     TRACK_PTR [SI],0FFH      ;€
        STC                     ;CF=1-->€ ‘€
EXIT_SEEK:
        MOV     AL,CL           ;‘…’
        MOV     DX,SECTOR
        OUT     DX,AL           ;„€—€
        POP     DX
        POP     AX
        RET

;==============================================================
;       / —’…      ES:BX --> €„…‘ “”…€.
;==============================================================
READ:   PUSH    AX
        PUSH    DX
        MOV     DI,BX           ;‘…™……
        MOV     DX,DATA_F       ;’ „€›•
        MOV     AL,READ_COMMAND ;„ €„› "—’…… ‘…’€"
        CLI                     ;‡€…’ …›‚€‰
        OUT     CONTROL_STAT,AL ;‚›‚„ „€ …€–
        JMP     RLOOP+1         ;
RLOOP:  STOSB                   ;…‘›‹€ €‰’€  AL_-->ES:DI
        IN      AL,RD_INTRQ     ;—’.  INTRQ ‹ DRQ
        SHR     AL,1            ;
        IN      AL,DX           ;—’…… €‰’€ „€›•
        JC      RLOOP
        STI                     ;‡€…’ …›‚€‰
        CALL    ERR_TABL        ;„ ‡€‚……
        MOV     BX,DI           ;‘…™…… ‘‚„ƒ €‰’€
        POP     DX
        POP     AX
        RET                     ;‚‡‚€’

;==============================================================
;       / ‡€‘      ES:BX --> €„…‘ “”…€.
;==============================================================
WRITE:  PUSH    AX
        PUSH    DX
        PUSH    DS
        MOV     AX,ES           ;€„…‘ ES B DS
        MOV     DS,AX
        MOV     SI,BX           ;‘…™…… “”…€ ‚ SI
        MOV     DX,DATA_F       ;€„…‘ ’€ „€›•
        MOV     AL,WRITE_COMMAND ;„ €„› "‡€‘ ‘…’€"
        CLI                     ;‡€…’ …›‚€‰
        OUT     CONTROL_STAT,AL ;‚›‚„ „€
WLOOP:  IN      AL,RD_INTRQ
        SHR     AL,1
        LODSB                   ;AL <-- DS:SI
        OUT     DX,AL           ;‚›‚„ €‰’€
        JC      WLOOP
        STI                     ;€‡……… …›‚€‰
        DEC     SI              ;‘…™…… ‘‹…„…ƒ ‚›‚…„…ƒ €‰’€
        MOV     AX,DS           ;‚‘‘’€‚‹…… €„…‘€ ‘…ƒ…’€
        MOV     ES,AX
        MOV     BX,SI
        POP     DS
        CALL    ERR_TABL        ;”‚€… „€ ‡€‚……
        POP     DX
        POP     AX
        RET                     ;‚‡‚€’

;==============================================================
;   / ”‚€ „‚ ‡€‚……
;==============================================================
ERR_TABL:
        PUSH    AX              ;
        PUSH    DX
        MOV     DX,CONTROL_STAT ;’ ‘‘’
        IN      AL,DX           ;—’…… ‘‘’
        AND     AL,0DFH         ;—‘’€ ’€ 5  ???????????????
        CMP     AL,READ_WRITE_OK   ;€‹ (=0)?
        JZ      NORM_EXIT       ;„€
        IN      AL,DX           ;—’…… ‘‘’
        TEST    MOTOR_STATUS,80H   ;—’……?
        JZ      R_W_ERROR       ;„€
WRITE_ERROR:                    ;…‘‹ ‡€‘
        TEST    AL,40H          ;‡€™’€ ‡€‘ ?
        MOV     AH,WRITE_PROTECT  ;„  (‡€™’€ ‡€‘)
        JNZ     ERR_EXIT        ;„€, €
R_W_ERROR:
        TEST    AL,10H          ;‡€ "…’ ‡€‘" ?
        MOV     AH,RECORD_NOT_FND  ;„ ’‰ 
        JNZ     ERR_EXIT        ;„€, € "…’ ‡€‘"
        TEST    AL,8            ;„  CRC ?
        MOV     AH,BAD_CRC      ;„ ’‰ 
        JNZ     ERR_EXIT        ;„€, € CRC
        MOV     AH,BAD_FDC      ;„  „‚‰‰ ‹’‘’
ERR_EXIT:
        MOV     AL,AH           ;
        OR      DISKETTE_STATUS,AL ;‚ ‘’€’“‘ „‘€ „ 
        STC                     ;“‘’€‚€ ”‹€ƒ€ CF=1 (€)
NORM_EXIT:
        POP     DX              ;‚‘‘’€‚‹…… DX, AX
        POP     AX
        RET                     ;‚‡‚€’

;==============================================================
;       ‚› “‘’‰‘’‚€ : DL-->.“‘’., DH-->.ƒ‹‚
;==============================================================
SELECT_DRIVE:
        PUSH    AX              ;‘•. …ƒ‘’‚
        PUSH    CX
        MOV     CL,DL           ;DL=0 „‹ “‘’. 0,2(*)
        MOV     AL,5            ;“‘’. 0, ’ 0
        SAL     AL,CL           ;‘„‚ƒ  …“ “‘’‰‘’‚€
        MOV     AH,DH           ;… ƒ‹‚
        AND     AH,1            ;‹. ’
        MOV     CL,4            ;
        ROL     AH,CL           ;… ƒ‹‚ ‚ ‡. D4
        OR      AL,AH           ;“‘’ +’ +ƒ‹‚€
        OR      AL,40H          ;+‘‘ „‚. ‹’‘’
        OUT     RG_C,AL         ;‚›‚„ (‚› “‘’‰‘’‚€ )
        POP     CX              ;‚‘‘’€‚‹…… …ƒ‘’‚
        POP     AX
        RET                     ;‚‡‚€’

;=============================================================
;       / †„€ „‹ ’€. ‡€„…†€ ‹ 0.5SEC.
;=============================================================
TEST_WAIT:
        PUSH    AX
        PUSH    BX
        PUSH    CX
        MOV     BL,1
        IN      AL,MOTOR_EN     ;—’. ‘‘’ ’€ --> D0
        TEST    AL,1            ;’ ‚‹ (D0=0) ?
        OUT     MOTOR_ON,AL     ;‚‹ MOTO€
        JNZ     J36
        TEST    DRIVER_N,DL
        JNZ     J37

J36:    MOV     CX,0
DISK_TIME:
        LOOP    DISK_TIME       ;‡€„…†€
        CLI
        MOV     DRIVER_N,DL
        STI
        TEST    MOTOR_STATUS,80H  ;—’……?
        JZ      J37             ;„€
WAIT_WRITE:                     ;…‘‹ ‡€‘
        MOV     CX,0
        WAIT_TIME:
        LOOP    WAIT_TIME       ;‚… „‹ ‡€‘
J37:    MOV     AH,4
RET_RDY:
        OUT     MOTOR_ON,AL     ;‚‹ ’€
        MOV     CX,0
WT_RDY: IN      AL,CONTROL_STAT ;—’…… ‘‘’
        AND     AL,80H          ;ƒ’‚?
        JZ      END_RDY         ;„€
        LOOP    WT_RDY          ;65535 €‡ ‘
        DEC     AH              ; ‚‘… …™… 4 €‡€
        JNZ     RET_RDY
END_RDY:
        POP     CX              ;‚‘‘’€‚‹……
        POP     BX
        POP     AX
        RET                     ;‚‡‚€’


STEP:   PUSH    CX
        SUB     CX,CX            ;CX=0
        MOV     CL,AL            ;FOR LOOP
        XCHG    AL,AH
        OR      AL,STEP_COMMAND
STEPC:  OUT     CONTROL_STAT,AL  ;STEP_COMMAND AND DIR
        PUSH    AX
        IN      AL,RD_INTRQ
        POP     AX
        LOOP    STEPC
        POP     CX
        MOV     AL,CH
        OUT     TRACK,AL
        RET

CODE    ENDS
        end
