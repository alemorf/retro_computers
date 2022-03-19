;--------------------------------------------------------------------------
; DISK_RESET (AH=00H)                                              :
;       ‘Ž‘ „ˆ‘ŠŽ‚Ž‰ ‘ˆ‘’…Œ›                                     :
;                                                                  :
; ‚›•Ž„:      DSKETTE_STATUS,CY Ž’€†€…’ “‘…• Ž…€–ˆˆ            :
;---------------------------------------------------------------------------
DISK_RESET      PROC    NEAR
        MOV     DX,03F2H                ; €„…‘ ‚›•Ž„ŽƒŽ –ˆ”Ž‚ŽƒŽ …ƒˆ‘…€
        CLI                             ; ‡€…’ …›‚€ˆ‰
        MOV     AL,MOTOR_STATUS         ; Ž‹“—…ˆ… Ž€‡€ –ˆ”Ž‚ŽƒŽ ‚›•Ž„ŽƒŽ
                                        ; …ƒˆ‘’€
        AND     AL,00111111B            ; ‚›„…‹…ˆ… ˆ’Ž‚ ‘Ž‘’ŽŸˆŸ ŒŽ’Ž€
        PUSH    CX
        MOV	CL,4
        ROL     AL,CL
        POP	CX                      ; ‘Ž‘’ŽŸˆ… ŒŽ’Ž€ ‚ ‘’€˜ˆ‰ ˆ‹
                                        ; ‚›Ž „ˆ‘ŠŽ‚Ž„€ ‚ Œ‹€„˜…Œ ˆ‹…
        OR      AL,00001000B            ; €‡…˜…ˆ… ‡€Ž‘Ž‚ …›‚€ˆ‰
        OUT     DX,AL                   ; ‘Ž‘ €„€’…€
        MOV     SEEK_STATUS,0           ; “‘’€Ž‚Š€ Ž’Œ…› ‚‘…• „ˆ‘ŠŽ‚Ž„Ž‚
        JMP     $+2                     ; Ž†ˆ„€ˆ… I/O
        JMP     $+2                     ; Ž†ˆ„€ˆ… I/O (Ž„‘’€•Ž‚Š€)                               ;     PULSE WIDTH)
        OR      AL,00000100B            ; ‚Š‹ž—…ˆ… ˆ’€ ‘Ž‘€
        OUT     DX,AL                   ; ‘Ž‘ €„€’…€
        STI                             ; €‡…˜…ˆ… …›‚€ˆ‰
        CALL    WAIT_INT                ; Ž†ˆ„€ˆ… …›‚€ˆŸ
        JC      DR_ERR                  ; Ž‚…Š€ Ž˜ˆŠˆ (…›‚€ˆŸ … Žˆ‡Ž˜‹Ž)
        MOV     CX,11000000B            ; CL=EXPECTED NEC_STATUS

NXT_DRV:
        PUSH    CX
        MOV     AX,OFFSET DR_POP_ERR    ; ‡€ƒ“‡Š€ NEC_OUTPUT €„…‘€ Ž˜ˆŠˆ
        PUSH    AX
        MOV     AH,08H                  ; ŠŽŒ€„€ “‘’€Ž‚Šˆ ‘’€’“‘€ …›‚€ˆ‰
        CALL    NEC_OUTPUT
        POP     AX
        CALL    RESULTS                 ; —’…ˆ… …‡“‹œ’€’€
        POP     CX
        JC      DR_ERR                  ; Ž˜ˆŠ€ - ‚Ž‡‚€’
        CMP     CL,NEC_STATUS           ; ’…‘’ „‹Ÿ ……•Ž„€ € —’…ˆ…
        JNZ     DR_ERR                  ; ‚‘… OK
        INC     CL                      ; ‘‹…„“ž™ˆ‰ NEC_STATUS
        CMP     CL,11000011B            ; ‚‘… ‚Ž‡ŒŽ†›… „ˆ‘ŠŽ‚Ž„› Ž—ˆ™…›
        JBE     NXT_DRV                 ; Ž˜ˆŠ€ …‘‹ˆ 11000100 ˆ‹ˆ >

        CALL    SEND_SPEC               ; Ž‘›‹€’œ ‘…–ˆ€‹œ“ž ŠŽŒ€„“ ‚ NEC
RESBAC:
        CALL    SETUP_END               ; “‘’€Ž‚Š€ ‚…Œ…ˆ ŒŽ’Ž€
        MOV     BX,SI
        MOV     AL,BL
        RET

DR_POP_ERR:
        POP     CX
DR_ERR:
        OR      DISKETTE_STATUS,BAD_NEC  ; “‘’€Ž‚Š€ ŠŽ„€ Ž˜ˆŠˆ
        JMP     SHORT RESBAC            ; ‚›•Ž„
DISK_RESET      ENDP
;-----------------------------------------------------------------------
; DISK_STATUS   (AH=01H)                                            :
;       ‘’€’“‘ „ˆ‘Š…’› .                                            :
;    ‚•Ž„ :     AH= ‘’€’“‘ …„›„“™…‰ Ž…€–ˆˆ                      :
;                                                                   :
;   ‚›•Ž„:      DSKETTE_STATUS,CY Ž’€†€…’ …‡“‹œ’€’ ”“Š–ˆˆ        :
;--------------------------------------------------------------------------

DISK_STATUS     PROC    NEAR
        MOV     DISKETTE_STATUS,AH      ; “‘’€€‚‹ˆ‚€…Œ „‹Ÿ …‡Ž˜ˆŽ—ŽƒŽ
					; Ž•Ž†„…ˆŸ SETUP_END
	JMP	SHORT RESBAC            ; ……•Ž„ € :
					; CALL    SETUP_END
					; MOV     BX,SI
					; MOV     AL,BL
					; RET
DISK_STATUS     ENDP
;-------------------------------------------------------------------------
; DISK_READ     (AH=02H)                                                  :
;       —’…ˆ… „ˆ‘Š…’›
; ˆ ‚•Ž„… ‚ ’“ ”“Š–ˆž, „€›… Žˆ‘›‚€ž™ˆ… ŽŒ… „ˆ‘ŠŽ‚Ž„€, ŽŒ…      :
; „ŽŽ†Šˆ ˆ ’.„. ……ƒ“†…› ‚ ‘‹…„“ž™ˆ… …ƒˆ‘’›:
;     ‚•Ž„:     DI      = ŽŒ… „ˆ‘ŠŽ‚Ž„€                                 :
;               SI-‘’€ = ŽŒ ƒŽ‹Ž‚Šˆ                                    :
;               SI-Œ‹€„ = ŠŽ‹ˆ—…‘’‚Ž —ˆ’€…Œ›• ‘…Š’ŽŽ‚                    :
;               ES      = “””…›‰ ‘…ƒŒ…’                               :
;               [BP]    = ŽŒ… ‘…Š’Ž€                                   :
;               [BP+1]  = ŽŒ… „ŽŽ†Šˆ                                   :
;               [BP+2]  = ‘Œ…™…ˆ… “”…€                                 :
;                                                                         :
;   ‚›•Ž„:      DISKETTE_STATUS,CY ‘’€’“‘ Ž…€–ˆˆ                        :
;--------------------------------------------------------------------------
DISK_READ       PROC NEAR
        AND     MOTOR_STATUS,01111111B  ; ˆ„ˆŠ€–ˆŸ Ž…€–ˆˆ —’…ˆŸ
        MOV     AX,0E646H               ; AX= NEC ŠŽŒ€„€, DMA ŠŽŒ€„€
RD_OB:  CALL    RD_WR_VF                ; Žƒ€ŒŒ€ —’…ˆŸ/‡€ˆ‘ˆ/‚…ˆ”ˆŠ€–ˆˆ
        RET
DISK_READ       ENDP
;-------------------------------------------------------------------------
; DISK_WRITE    (AH=03H)                                                  :
;       ‡€ˆ‘œ „ˆ‘Š…’›.                                                  :
;     ‚•Ž„:     DI      =  ŽŒ… „ˆ‘ŠŽ‚Ž„€                                :
;               SI-HI   =  ŽŒ ƒŽ‹Ž‚Šˆ                                   :
;               SI-LOW  =  ŠŽ‹ˆ—…‘’‚Ž —ˆ’€…Œ›• ‘…Š’ŽŽ‚                   :
;               ES      =  “””…›‰ ‘…ƒŒ…’                              :
;               [BP]    =  ŽŒ… ‘…Š’Ž€                                  :
;               [BP+1]  =  ŽŒ… „ŽŽ†Šˆ                                  :
;               [BP+2]  =  ‘Œ…™…ˆ… “”…€                                :
;                                                                         :
;   ‚›•Ž„:      DSKETTE_STATUS,CY ‘’€’“‘ Ž…€–ˆˆ                         :
;--------------------------------------------------------------------------
DISK_WRITE      PROC NEAR
        MOV     AX,0C54AH               ; AX= NEC ŠŽŒ€„€, DMA ŠŽŒ€„€
        OR      MOTOR_STATUS,10000000B  ; ˆ„ˆŠ€–ˆŸ Ž…€–ˆˆ ‡€ˆ‘ˆ
	JMP	SHORT RD_OB
DISK_WRITE      ENDP
;-------------------------------------------------------------------------
; DISK_VERF     (AH=04H)                                                  :
;       ‚…ˆ”ˆŠ€–ˆŸ „ˆ‘Š…’›                                               :
;     ‚•Ž„:     DI      =  ŽŒ… „ˆ‘ŠŽ‚Ž„€                                :
;               SI-HI   =  ŽŒ ƒŽ‹Ž‚Šˆ                                   :
;               SI-LOW  =  ŠŽ‹ˆ—…‘’‚Ž —ˆ’€…Œ›• ‘…Š’ŽŽ‚                   :
;               ES      =  “””…›‰ ‘…ƒŒ…’                              :
;               [BP]    =  ŽŒ… ‘…Š’Ž€                                  :
;               [BP+1]  =  ŽŒ… „ŽŽ†Šˆ                                  :
;               [BP+2]  =  ‘Œ…™…ˆ… “”…€                                :
;                                                                         :
;   ‚›•Ž„:      DSKETTE_STATUS,CY ‘’€’“‘ Ž…€–ˆˆ                         :
;--------------------------------------------------------------------------
DISK_VERF       PROC NEAR
        AND     MOTOR_STATUS,01111111B  ; ˆ„ˆŠ€–ˆŸ Ž…€–ˆˆ —’…ˆŸ
        MOV     AX,0E642H               ; AX= NEC ŠŽŒ€„€, DMA ŠŽŒ€„€
	JMP	SHORT RD_OB
DISK_VERF       ENDP
;-------------------------------------------------------------------------
; DISK_FORMAT   (AH=02H)                                                  :
;       ”ŽŒ€’ˆŽ‚€ˆ… „ˆ‘Š…’›                                            :
;     ‚•Ž„:     DI      = ŽŒ… „ˆ‘ŠŽ‚Ž„€                                 :
;               SI-HI   = ŽŒ ƒŽ‹Ž‚Šˆ                                    :
;               SI-LOW  = ŠŽ‹ˆ—…‘’‚Ž —ˆ’€…Œ›• ‘…Š’ŽŽ‚                    :
;               ES      = “””…›‰ ‘…ƒŒ…’                               :
;               [BP]    = ŽŒ… ‘…Š’Ž€                                   :
;               [BP+1]  = ŽŒ… „ŽŽ†Šˆ                                   :
;               [BP+2]  = ‘Œ…™…ˆ… “”…€                                 :
;               DISK_POINTER “Š€‡›‚€…’ € ’€‹ˆ–“ €€Œ…’Ž‚ ’ŽƒŽ        :
;                               „ˆ‘ŠŽ‚Ž„€                                 :
;                                                                         :
;   ‚›•Ž„:      DSKETTE_STATUS,CY ‘’€’“‘ Ž…€–ˆˆ                         :
;--------------------------------------------------------------------------
DISK_FORMAT    PROC NEAR
        CALL    XLAT_NEW                ; ……„€—€ ‘Ž‘’ŽŸˆŸ „‹Ÿ €Ž€’Ž‰ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        CALL    FMT_INIT                ; “‘’€Ž‚Š€ ‘Ž‘’ŽŸˆŸ, …‘‹ˆ …Ž…„…‹…Ž
        OR      MOTOR_STATUS,10000000B  ; ˆ„ˆŠ€–ˆŸ Ž…€–ˆˆ ‡€ˆ‘ˆ
        CALL    MED_CHANGE              ; Ž‚…Š€ ‘Œ…› Ž‘ˆ’…‹Ÿ
        JC      FM_DON                  ; … Œ…Ÿ‹ˆ, Ž“‘Š Ž‚…ŽŠ
        CALL    SEND_SPEC               ; ‘…–ˆ€‹œ€Ÿ ŠŽŒ€„€  NEC
        CALL    CHK_LASTRATE            ; ZF=1 Ž‚…Š€, ‘ŠŽŽ‘’œ ’€ †… ?
        JZ      FM_WR                   ; „€, Ž“‘Š ‘…–ˆ€‹œŽ‰ ŠŽŒ€„›
        CALL    SEND_RATE               ; “‘’€Ž‚Š€ ‘ŠŽŽ‘’ˆ ‚€™…ˆŸ
FM_WR:
        CALL    FMTDMA_SET              ; “‘’€Ž‚Š€ DMA „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
        JC      FM_DON                  ; ‚Ž‡‚€’ ‘ Ž˜ˆŠŽ‰
        MOV     AH,4DH                  ; “‘’€Ž‚Š€ ŠŽŒ€„› ”ŽŒ€’ˆŽ‚€ˆŸ
        CALL    NEC_INIT                ; ˆˆ–ˆ€‹ˆ‡€–ˆŸ NEC
        JC      FM_DON                  ; Ž˜ˆŠ€ - ‚›•Ž„
        MOV     AX,OFFSET FM_DON        ; ‡€ƒ“‡Š€ €„…‘€ Ž˜ˆŠˆ
        PUSH    AX                      ; PUSH NEC_OUT Ž˜ˆŠˆ
        MOV     DL,3                    ; BYTES/SECTOR ‡€—…ˆ… „‹Ÿ NEC
        CALL    GET_PARM
        CALL    NEC_OUTPUT
        MOV     DL,4                    ; SECTORS/TRACK
        CALL    GET_PARM
        CALL    NEC_OUTPUT
        MOV     DL,7                    ; GAP LENGTH
        CALL    GET_PARM
        CALL    NEC_OUTPUT
        MOV     DL,8                    ; FILLER BYTE
        CALL    GET_PARM
        CALL    NEC_OUTPUT
        POP     AX                      ; ‚Ž‡‚€™…ˆ… Ž˜ˆŠˆ
        CALL    NEC_TERM                ; ‡€‚…˜…ˆ… ˆ Ž‹“—…ˆ… ‘’€’“‘€
FM_DON:
        CALL    XLAT_OLD                ; ……„€—€ ‘Ž‘’ŽŸˆŸ „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‰ ŒŽ„…‹ˆ
        CALL    SETUP_END               ; Ž—ˆ‘’Š€
        MOV     BX,SI
        MOV     AL,BL
        RET
DISK_FORMAT     ENDP
;--------------------------------------------------------------------------
; FNC_ERR                                                                 :
;       …€‚ˆ‹œ€Ÿ ”“Š–ˆŸ ˆ‹ˆ …€‚ˆ‹œ›‰ „ˆ‘ŠŽ‚Ž„                    :
;       “‘’€Ž‚Š€ …€‚ˆ‹œŽ‰ ŠŽŒ€„› ‚ ‘’€’“‘…                          :
;                                                                         :
;   ‚›•Ž„:      DSKETTE_STATUS,CY ‘’€’“‘ Ž…€–ˆˆ                         :
;--------------------------------------------------------------------------
FNC_ERR          PROC    NEAR
        MOV     AX,SI
        MOV     AH,BAD_CMD
        MOV     DISKETTE_STATUS,AH
        STC                             ; “‘’€Ž‚Š€ ”‹€ƒ€ Ž˜ˆŠˆ
        RET
FNC_ERR          ENDP
;----------------------------------------------------------------
; DISK_PARMS  (AH=08H)                                           :
;       —’…ˆ… €€Œ…’Ž‚ „ˆ‘ŠŽ‚Ž„€                              :
;     ‚•Ž„:                                                      :
;       DI = ŽŒ… „ˆ‘ŠŽ‚Ž„€                                     :
;   ‚›•Ž„:                                                       :
;       CL/[BP]  = ˆ’› 7&6 ‘’€˜ˆ… 2 ˆ’€ Œ€Š‘. —ˆ‘‹Ž –ˆ‹ˆ„Ž‚ :
;                  ˆ’› 0-5 Œ€Š‘ ‘…Š’Ž/’…Š                     :
;       CH/[BP+1]= Œ‹. 8 ˆ’ Œ€Š‘. —ˆ‘‹€ –ˆ‹ˆ„Ž‚               :
;       BL/[BP+2]= ˆ’› 7-4 = 0                                  :
;                  ˆ’› 3-0 = ’ˆ „ˆ‘ŠŽ‚Ž„€ ˆ‡ ŠŒŽ              :
;       BH/[BP+3]= 0                                             :
;       DL/[BP+4]= Š-‚Ž Ž„Š‹ž—…›• „ˆ‘ŠŽ‚Ž„Ž‚                  :
;       DH/[BP+5]= Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž ƒŽ‹Ž‚ŽŠ                    :
;       DI/[BP+6]= ‘Œ…™…ˆ… ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„            :
;       ES       = ‘…ƒŒ…’ ’€‹ˆ–›                               :
;       AX       = 0                                             :
; NOTE  : ‡€Œ…’ˆŒ, —’Ž ˆ”ŽŒ€–ˆž Ž‹œ‡Ž‚€’…‹œ ŒŽ†…’ ˆ‡‚‹…— ˆ‡   :
;         ‘’…Š€ ‚ …Ž•Ž„ˆŒ›… …Œ“ …ƒˆ‘’›, Ž‘‹… ‚Ž‡‚€’€ ˆ‡    :
;         Ž–…„“›                                              :
;----------------------------------------------------------------
DISK_PARMS          PROC    NEAR
        CALL    XLAT_NEW                ; ‘Ž‘’ŽŸˆ… Ž„Š‹ž—…ŽƒŽ €„€’…€
        MOV     WORD PTR [BP+2],0       ; ’ˆ „ˆ‘ŠŽ‚Ž„€ = 0
        MOV     AX,EQUIP_FLAG           ; —’…ˆ… ‘‹Ž‚€ ŽŽ“„Ž‚€ˆŸ „‹Ÿ Ž…„…
        AND     AL,11000001B            ; ‹…ˆŸ —ˆ‘‹€ „ˆ‘ŠŽ‚Ž„Ž‚
        MOV     DL,2                    ; „ˆ‘ŠŽ‚Ž„› = 2
        CMP     AL,01000001B            ; Ž„Š‹ž—…Ž 2 ?
        JZ      STO_DL                  ; ……•Ž„ …‘‹ˆ „€
        DEC     DL                      ; „ˆ‘ŠŽ‚Ž„ =1
        CMP     AL,00000001B            ; Ž„Š‹ž—… 1?
        JNZ     NON_DRV                 ; ……•Ž„ …‘‹ˆ … Ž„ŽƒŽ
STO_DL:
        MOV     [BP+4],DL               ; ‚Ž‘‘’€Ž‚‹…ˆ… —ˆ‘‹€ „ˆ‘ŠŽ‚Ž„Ž‚
        CMP     DI,1                    ; Ž‚…Š€ €‚ˆ‹œŽ‘’ˆ ŽŒ…€ „ˆ‘ŠŽ‚Ž„€
        JA      NON_DRV1                ; …€‚ˆ‹œŽ
        MOV     BYTE PTR[BP+5],1        ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž ƒŽ‹Ž‚ŽŠ = 1
        CALL    CMOS_TYPE               ; ’ˆ „ˆ‘ŠŽ‚Ž„€ ‚ AL
        JC      CHK_EST                 ; Ž˜ˆŠ€ ŠŒŽ
        OR      AL,AL                   ; ’…‘’ Ž’‘“’‘’‚ˆŸ „ˆ‘ŠŽ‚Ž„€
        JZ      CHK_EST                 ; ……•Ž„ …‘‹ˆ Ž’‘“’‘’‚“…’
        CALL    DR_TYPE_CHECK           ; Ž‹“—…ˆ… SEG:OFFSET ’€‹ˆ–› Ž‘/„ˆ‘Š.
        JC      CHK_EST                 ; JMP …‘‹ˆ …‘ŽŽ’‚…’‘’‚ˆ… ’ˆ€
        MOV     [BP+2],AL               ; ‚Ž‘‘’€Ž‚‹…ˆ… ’ˆ€ ˆ‡ ŠŒŽ
        MOV     CL,CS:[BX].MD_SEC_TRK   ; Ž‹“—…ˆ… ‘…Š’Ž/„ŽŽ†Š€
        MOV     CH,CS:[BX].MD_MAX_TRK   ; Ž‹“—…ˆ… Œ€Š‘ˆŒ€‹œŽƒŽ —ˆ‘‹€ ‘…Š’ŽŽ‚
        JMP     SHORT STO_CX            ; ŠŒŽ €‚ˆ‹œ.,ˆ‘Ž‹œ‡“…Œ ŠŒŽ
CHK_EST:
        MOV     AH,DSK_STATE[DI]        ; ‡€ƒ“‡Š€ ‘Ž‘’ŽŸˆŸ ’ŽƒŽ „ˆ‘ŠŽ‚Ž„€
        TEST    AH,MED_DET              ; Ž‚…Š€ “‘’€Ž‚Šˆ ‘Ž‘’ŽŸˆŸ
        JZ      NON_DRV1                ; Ž˜ˆŠ€ ŠŒŽ

USE_EST:
        AND     AH,RATE_MSK             ; ‚›„…‹…ˆ… ‘ŠŽŽ‘’ˆ
        CMP     AH,RATE_250             ; ‘ŠŽŽ‘’œ ? 250
        JNE     USE_EST2                ; …’, Ž‚…Š€ „“ƒˆ• ‘ŠŽŽ‘’…‰

;----‘ŠŽŽ‘’œ 250 KBS, Ž‚…Š€ ’€‹ˆ–› 360 KB
        MOV     AL,01                   ; ’ˆ „ˆ‘ŠŽ‚Ž„€ 1 (360KB)
        CALL    DR_TYPE_CHECK           ; Ž‹“—…ˆ… CX:BX = ’€‹ˆ–› €€Œ…’Ž‚
        MOV     CL,CS:[BX].MD_SEC_TRK   ; Ž‹“—…ˆ… ‘…Š’Ž/„Ž.
        MOV     CH,CS:[BX].MD_MAX_TRK   ; Œ€Š‘ˆŒ. —ˆ‘‹Ž ‘…Š’ŽŽ‚
        TEST    DSK_STATE[DI],TRK_CAPA  ; 80 „Ž. ?
        JZ      STO_CX                  ; „Ž‹†… ›’œ 360KB „ˆ‘ŠŽ‚Ž„

; ---…‘‹ˆ ’Ž 1.44 „ˆ‘ŠŽ‚Ž„

PARM144:
        MOV     AL,04                   ; ’ˆ 4 (1.44MB)
        CALL    DR_TYPE_CHECK           ; Ž‹“—…ˆ… CX:BX = ’€‹ˆ–› €€Œ…’Ž‚
        MOV     CL,CS:[BX].MD_SEC_TRK   ; Ž‹“—…ˆ… ‘…Š’Ž/„Ž.
        MOV     CH,CS:[BX].MD_MAX_TRK   ; Œ€Š‘ˆŒ. —ˆ‘‹Ž ‘…Š’ŽŽ‚
STO_CX:
        MOV     [BP],CX                 ; ‡€ˆ‘œ ‚ ‘’…Š „‹Ÿ ‚Ž‡‚€’€
        MOV     [BP+6],BX               ; €„…‘ ’€‹ˆ–›
        MOV     AX,CS                   ; ‘…ƒŒ…’ ’€‹ˆ–›
        MOV     ES,AX                   ; ES ‘…ƒŒ…’
DP_OUT:
        CALL    XLAT_OLD                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        XOR     AX,AX                   ; Ž—ˆ‘’Š€
        CLC
        RET

;-------- Ž’€Ž’Š€ Ž’‘“’‘’‚ˆŸ „ˆ‘ŠŽ‚Ž„€

NON_DRV:
        MOV     BYTE PTR [BP+4],0       ; Ž—ˆ‘’Š€ —ˆ‘‹€ „ˆ‘ŠŽ‚Ž„Ž‚
NON_DRV1:
        CMP     DI,80H                  ; Ž‚…Š€ ‡€Ž‘€ †…‘’ŠŽƒŽ „ˆ‘Š€
        JB      NON_DRV2                ; Ž„Ž‹†…ˆ… …‘‹ˆ … †…‘’Šˆ‰

;--------†…‘’Šˆ‰ „ˆ‘Š, Ž˜ˆŠ€ ‡€Ž‘€

        CALL    XLAT_OLD                ; …™… „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        MOV     AX,SI                   ; ‚Ž‘‘’€Ž‚‹…ˆ… AL
        MOV     AH,BAD_CMD              ; “‘’€Ž‚Š€ Ž˜ˆŠˆ - …€‚ˆ‹œ€Ÿ ŠŽŒ€„€
        STC                             ; “‘’€Ž‚Š€ Ž˜ˆŠˆ
        RET

NON_DRV2:
        XOR     AX,AX                ; Ž—ˆ‘’Š€ €€Œ…’Ž‚ …‘‹ˆ …’ „ˆ‘ŠŽ‚Ž„€
				     ; ˆ‹ˆ Ž˜ˆŠ€ ŠŒŽ
        MOV     [BP],AX              ; „ŽŽ†…Š, ‘…Š’Ž/„ŽŽ† = 0
        MOV     [BP+5],AH            ; ƒŽ‹. = 0
        MOV     [BP+6],AX            ; ‘Œ…™…ˆ… DISK_BASE = 0
        MOV     ES,AX                ; ‘…ƒŒ…’
        JMP     SHORT DP_OUT

;------- ‘ŠŽŽ‘’œ ‚€™…ˆŸ 300KBS ˆ‹ˆ 500 KBS,Ž›’Š€ ’€‹ˆ–› 1.2 MB

USE_EST2:
        MOV     AL,02                   ; ’ˆ „ˆ‘ŠŽ‚. 1 (1.2MB)
        CALL    DR_TYPE_CHECK           ; €‹ CX:BX = Ž‘ˆ’/„ˆ‘ŠŽ‚Ž„ ’€‹ˆ–›
        MOV     CL,CS:[BX].MD_SEC_TRK   ; Ž‹“—…ˆ… ‘…Š’Ž/„Ž.
        MOV     CH,CS:[BX].MD_MAX_TRK   ; Œ€Š‘. —ˆ‘‹Ž „ŽŽ†…Š
        CMP     AH,RATE_300             ; ‘ŠŽ 300 ?
        JE      STO_CX                  ; „Ž‹†… ›’œ 1.2MB „ˆ‘ŠŽ‚Ž„
        JMP     SHORT PARM144           ; …™… ŒŽ†…’ ›’œ 1.44MB „ˆ‘ŠŽ‚Ž„

DISK_PARMS          ENDP

;-----------------------------------------------------------------
;  DISK_TYPE    (AH=15H)                                         :
;       ’€ Ž–…„“€ ‚Ž‡‚€™€…’ ’ˆ „ˆ‘ŠŽ‚Ž„€                   :
;       ‚•Ž„:   DI = ŽŒ… „ˆ‘ŠŽ‚Ž„€                             :
;                                                                :
;     ‚›•Ž„:    AH = ’ˆ „ˆ‘ŠŽ‚Ž„€, CY=0                         :
;-----------------------------------------------------------------
DISK_TYPE          PROC    NEAR
        CALL    XLAT_NEW                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        MOV     AL,DSK_STATE[DI]        ; Ž‹“—…ˆ… ‘Ž‘’ŽŸˆŸ
        OR      AL,AL                   ; Ž‚…Š€ €‹ˆ—ˆŸ „ˆ‘ŠŽ‚Ž„€
        JZ      NO_DRV
        MOV     AH,NOCHGLN              ; …’ ‹ˆˆˆ ‘Œ…› „ˆ‘Š€ „‹Ÿ 40 „ŽŽ†.„ˆ‘.
        TEST    AL,TRK_CAPA             ; ˆ‹ˆ ’Ž 80 ’…ŠŽ‚›‰?
        JZ      DT_BACK                 ; …‘‹ˆ …’ JUMP
        MOV     AH,CHGLN

DT_BACK:
        PUSH    AX                      ; ‡€ˆ‘œ ‚Ž‡‚€™€…ŒŽƒŽ ‡€—…ˆŸ
        CALL    XLAT_OLD                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        POP     AX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… ‚Ž‡‚€™€…Œ›• ‡€—…ˆ‰
        CLC                             ; …’ Ž˜ˆŠˆ
        MOV     BX,SI                   ;
        MOV     AL,BL                   ;
        RET

NO_DRV:
        XOR     AH,AH                   ; …’ „ˆ‘ŠŽ‚Ž„€ ˆ‹ˆ …Ž…„…‹…›‰ ’ˆ
        JMP     SHORT DT_BACK
DISK_TYPE          ENDP
;-----------------------------------------------------------------
;  DISK_CHANGE  (AH=16H)                                         :
;       ’€ Ž–…„“€ ‚Ž‡‚€™€…’ ‘Ž‘’ŽŸˆ… ‹ˆˆˆ ‘Œ…› „ˆ‘Š€     :
;                                                                :
;      ‚•Ž„:    DI = ŽŒ… „ˆ‘ŠŽ‚Ž„€                             :
;                                                                :
;    ‚›•Ž„:     AH = DSCETTE_STATUS                              :
;                    00 - ‹ˆˆŸ …€Š’ˆ‚€, CY = 0                :
;                    06 - ‹ˆˆŸ €Š’ˆ‚€  , CY = 1                :
;-----------------------------------------------------------------
DISK_CHANGE          PROC    NEAR
	not	uppp
        CALL    XLAT_NEW                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        MOV     AL,DSK_STATE[DI]        ; Ž‹“—…ˆ… ˆ”ŽŒ€–ˆˆ
        OR      AL,AL                   ; „ˆ‘ŠŽ‚Ž„ ˆ‘“’‘’‚“…’?
        JZ      DC_NON                  ; ……•Ž„ …‘‹ˆ …’
        TEST    AL,TRK_CAPA             ; 80 „ŽŽ†…—›‰ ?
        JZ      SETIT                   ; …‘‹ˆ ’€Š, Ž‚…Š€ ‹ˆˆˆ ‘Œ…› „ˆ‘Š€

DCO:    CALL    READ_DSKCHNG            ; Ž‹“—…ˆ… ‘Ž‘’ŽŸˆŸ ‹ˆˆˆ
        JZ      FINIS                   ; ‹ˆˆŸ …€Š’ˆ‚€

SETIT:  MOV     DISKETTE_STATUS,MEDIA_CHANGE    ; ˆ„ˆŠ€–ˆŸ ‘Œ…›

FINIS:  CALL    XLAT_OLD                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        CALL    SETUP_END               ; Ž—ˆ‘’Š€
        MOV     BX,SI
        MOV     AL,BL
        RET

DC_NON:
        OR      DISKETTE_STATUS,TIME_OUT        ; “‘’€Ž‚Š€ TIMEOUT,…’ „ˆ‘ŠŽ‚Ž„€
        JMP     SHORT FINIS
DISK_CHANGE     ENDP

;----------------------------------------------------------------
;  FORMAT_SET   (AH=17H)                                         :
;       ’€ Ž–…„“€ ˆ‘Ž‹œ‡“…’‘Ÿ „‹Ÿ Ž…„…‹…ˆŸ ’ˆ€          :
;       Ž‘ˆ’…‹Ÿ ˆ Ž…€–ˆˆ ”ŽŒ€’ˆŽ‚€ˆŸ                     :
;                                                                :
;      ‚•Ž„:    SI Œ‹. = ’ˆ ”ŽŒ€’€                             :
;               DI     = ŽŒ… „ˆ‘ŠŽ‚Ž„€                         :
;                                                                :
;    ‚›•Ž„:     DSKETTE_STATUS Ž’€†€…’ ‘’€’“‘ Ž…€–ˆˆ          :
;               AH = DSKETTE_STATUS                              :
;               CY = 1 …‘‹ˆ Ž˜ˆŠ€                               ;
;-----------------------------------------------------------------
FORMAT_SET          PROC    NEAR
        CALL    XLAT_NEW                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        PUSH    SI                      ; ‡€ˆ‘œ ’ˆ Ž‘ˆ’…‹Ÿ
        MOV     AX,SI                   ; AH = ? , AL = ’ˆ Ž‘ˆ’…‹Ÿ
        XOR     AH,AH                   ; AH = 0 , AL = ’ˆ Ž‘ˆ’…‹Ÿ
        MOV     SI,AX                   ; SI = ’ˆ Ž‘ˆ’…‹Ÿ
        AND     DSK_STATE[DI],NOT MED_DET+DBL_STEP+RATE_MSK     ; Ž—ˆ‘’Š€ ‘Ž‘’.
        DEC     SI                      ; Ž‚.„‹Ÿ 320/360K Ž‘ˆ’…‹Ÿ
        JNZ     NOT_320                 ; Ž•Ž„ …‘‹ˆ …’
        OR      DSK_STATE[DI],MED_DET+RATE_250          ; “‘’€Ž‚Š€ 320/360
        JMP     SHORT SO
NOT_320:
        CALL    MED_CHANGE              ; Ž‚. „‹Ÿ TIME_OUT
        CMP     DISKETTE_STATUS,TIME_OUT
        JZ      SO                      ; …‘‹ˆ ‚…ŒŸ ‚›˜‹Ž ‚›•Ž„

ss3:     DEC     SI                     ; Ž‚…Š€ „‹Ÿ 320/360K ‚ 1.2
        JNZ     NOT_320_12              ; Ž•Ž„ …‘‹ˆ …’
        OR      DSK_STATE[DI],MED_DET+DBL_STEP+RATE_300  ; “‘’€Ž‚Š€ ‘Ž‘’ŽŸˆŸ
        JMP     SHORT SO
NOT_320_12:
        DEC     SI                      ; Ž‚…Š€ „‹Ÿ 1.2M „ˆ‘Š“….‚ 1.2M „ˆ‘ŠŽ‚.
        JNZ     NOT_12                  ; Ž•Ž„ …‘‹ˆ …’
        OR      DSK_STATE[DI],MED_DET+RATE_500  ; “‘’€Ž‚Š€ ……Œ…ŽƒŽ ‘Ž‘’ŽŸˆŸ
        JMP     SHORT SO                ; ‚Ž‡‚€’
NOT_12:
        DEC     SI                      ; Ž‚…Š€ 4 ’ˆ€ Ž‘ˆ’…‹Ÿ
        JNZ     FS_ERR                  ; …€‚ˆ‹œ€Ÿ ŠŽŒ€„€,Ž‘ˆ’. ‚›•Ž„

        TEST    DSK_STATE[DI],DRV_DET   ; „ˆ‘ŠŽ‚Ž„ Ž…„…‹.?
        JZ      ASSUM                   ; …‘‹ˆ …Ž…„…‹…, ’Ž …„Ž‹Žƒ€…Œ
					; Œ…„‹…›‰
        MOV     AL,MED_DET+RATE_300
        TEST    DSK_STATE[DI],FMT_CAPA  ; ‚Ž‡ŒŽ†Ž‘’œ ŒŽƒŽ”ŽŒ€’ŽƒŽ ?
        JNZ     OR_IT_IN                ; …‘‹ˆ 1.2M ’Žƒ„€ ‘ŠŽŽ‘’œ 300
ASSUM:
        MOV     AL,MED_DET+RATE_250    ; “‘’€Ž‚Š€
OR_IT_IN:
        OR      DSK_STATE[DI],AL        ; OR ˆ ŠŽ…Š’ŽŒ ‘Ž‘’ŽŸˆˆ
SO:
        CALL    XLAT_OLD                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        CALL    SETUP_END               ; Ž—ˆ‘’Š€
        POP     BX
        MOV     AL,BL
        RET
FS_ERR:
        MOV     DISKETTE_STATUS,BAD_CMD  ; …Ž…„…‹…Ž… ‘Ž‘’ŽŸˆ…, …€‚.ŠŽŒ€„€
        JMP     SHORT SO                ;
FORMAT_SET          ENDP

; ----------------------------------------------------------------
;  SET_MEDIA    (AH=18)                                          :
;       ’€ Ž–…„“€ “‘’€€‚‹ˆ‚€…’ ’ˆ Ž‘ˆ’…‹Ÿ ˆ ‘ŠŽŽ‘’œ      :
;       ‚€™…ˆŸ ˆ‘Ž‹œ‡“…Œ›… ˆ ”ŽŒ€’ˆŽ‚€ˆˆ                 :
;      ‚•Ž„:                                                     :
;       [BP]   = ‘…Š’ŽŽ‚ € ’…Š                                :
;       [BP+1] = ŽŒ… ’…Š€                                     :
;       DI     = ŽŒ… „ˆ‘ŠŽ‚Ž„€                                 :
;    ‚›•Ž„:                                                      :
;       DSKETTE_STATUS Ž’€†€…’ ‘’€’“‘                           :
;       …‘‹ˆ …’ Ž˜ˆŠˆ:                                         :
;               AH = 0                                           :
;               CY = 0                                           :
;               ES = ‘…ƒŒ…’ ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„           :
;               DI/[BP+6] = ‘Œ…™…ˆ…                             :
;      …‘‹ˆ Ž˜ˆŠ€:                                              :
;               AH = DSKETTE_STATUS                              :
;               CY = 1                                           :
;-----------------------------------------------------------------
SET_MEDIA          PROC    NEAR
        CALL    XLAT_NEW                ; „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        TEST    DSK_STATE[DI],TRK_CAPA  ; Ž‚…Š€ €‹ˆ—ˆŸ ‹ˆˆˆ ‘Œ…› „ˆ‘Š€
        JZ      SM_CMOS                 ; JUMP …‘‹ˆ 40 „ŽŽ†…—›‰
        CALL    MED_CHANGE              ; Ž‚…Š€ ‚…Œ…ˆ
        CMP     DISKETTE_STATUS,TIME_OUT   ; ‚›•Ž„ …‘‹ˆ ‚…ŒŸ ‚›˜‹Ž
        JE      SM_RTN
        MOV     DISKETTE_STATUS,0        ; Ž—ˆ‘’Š€ ‘’€’“‘€
SM_CMOS:
        CALL    CMOS_TYPE               ; ’ˆ „ˆ‘ŠŽ‚Ž„€ ‚ (AL)
        JC      MD_NOT_FND              ; Ž˜ˆŠ€ ŠŒŽ
        OR      AL,AL                   ; ’…‘’ €‹ˆ—ˆŸ „Œ‘ŠŽ‚Ž„€
        JZ      SM_RTN                  ; ‚›•Ž„ …‘‹ˆ …’
        CALL    DR_TYPE_CHECK           ; €„ CX:BX = ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„
        JC      MD_NOT_FND              ; ’ˆ ‚ ’€‹ˆ–… …Ž…„…‹…, Ž˜ˆŠ€ ŠŒŽ
        PUSH    DI
        XOR     BX,BX                   ; BX = ˆ„…Š‘ DRV_TYPE ’€‹ˆ–›
        MOV     CX,6                    ; CX = ‘—…’—ˆŠ Ž‚’Ž…ˆ‰

DR_SEARCH:
        MOV     AH,CS:DR_TYPE[BX]       ; Ž‹“—…ˆ… ’ˆ€ „ˆ‘ŠŽ‚Ž„€(F000:20E9=1)
        AND     AH,BIT7OFF              ; Œ€‘Š€
        CMP     AL,AH                   ; ‘€‚…ˆ… ’ˆ€ „ˆ‘ŠŽ‚Ž„€ ?
        JNE     NXT_MD                  ; …’, Ž‚…Š€ Ž‘‹…„…ƒŽ ’ˆ€ „ˆ‘ŠŽ‚Ž„€

        MOV     DI,CS:WORD PTR DR_TYPE[BX+1]    ; DI=Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„
        MOV     AH,CS:[DI].MD_SEC_TRK   ; Ž‹“—…ˆ… ‘…Š’Ž/„ŽŽ†.
        CMP     [BP],AH                 ; ‘€‚…ˆ… ?
        JNE     NXT_MD                  ; …’, Ž‚…Š€ ‘‹…„.Ž‘ˆ’…‹Ÿ
        MOV     AH,CS:[DI].MD_MAX_TRK   ; Ž‚…Š€ Œ€Š‘. —ˆ‘‹€ „ŽŽ†…Š
        CMP     [BP+1],AH               ; ‘€‚. ?
        JE      MD_FND                  ; „€, Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ ‚€™…ˆŸ
NXT_MD:
        ADD     BX,3                    ; Ž‚…Š€ ‘‹…„“ž™…ƒŽ ’ˆ€ „ˆ‘ŠŽ‚Ž„€
        LOOP    DR_SEARCH
        POP     DI                      ; ‚Ž‘‘’€Ž‚‹…ˆ…
MD_NOT_FND:
        MOV     DISKETTE_STATUS,MED_NOT_FND  ; Ž˜ˆŠ€, „ˆ‘Š…’€ „€ŽƒŽ ’ˆ€ … €‰„…€
        JMP     SHORT SM_RTN                 ; ‚›•Ž„
MD_FND:
        MOV     AL,CS:[DI].MD_RATE      ; Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ
        CMP     AL,RATE_300             ; „‚Ž‰Ž‰ ˜€ƒ „‹Ÿ ‘ŠŽŽ‘’ˆ 300
        JNE     MD_SET
        OR      AL,DBL_STEP
MD_SET:
        MOV     [BP+6],DI               ; ‡€ˆ‘œ ’€‹ˆ–› “Š€‡€’…‹…‰ ‚ ‘’…Š
        OR      AL,MED_DET              ; “‘’€Ž‚Š€ "Œ…˜€ˆ›"
        POP     DI                      ; ‚Ž‘‘’€Ž‚‹…ˆ… …ƒˆ‘’Ž‚
        AND     DSK_STATE[DI],NOT MED_DET+DBL_STEP+RATE_MSK  ; Ž—ˆ‘’Š€ ‘Ž‘’ŽŸˆŸ
        OR      DSK_STATE[DI],AL        ; “‘’€Ž‚Š€ ‘Ž‘’ŽŸˆŸ
        MOV     AX,CS                   ; ‘…ƒŒ…’ Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„
        MOV     ES,AX                   ; ES ‘…ƒŒ…’
SM_RTN:
        CALL    XLAT_OLD
        CALL    SETUP_END
        RET
SET_MEDIA          ENDP

; ----------------------------------------------------------------
;  DR_TYPE_CHECK                                                 :
;       Ž‚…Š€ ‘ŽŽ’‚…’‘’‚ˆŸ ’ˆ€ „ˆ‘ŠŽ‚Ž„€ ‚  (AL)             :
;       ’€‹ˆ–€Œ •€Ÿ™ˆŒ‘Ÿ ‚ BIOS                               :
;      ‚•Ž„:                                                     :
;       AL = ’ˆ „ˆ‘ŠŽ‚Ž„€                                       :
;    ‚›•Ž„:                                                      :
;       CS = ‘…ƒŒ…’ ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„                   :
;       CY = 0 „€›‰ ’ˆ „ˆ‘ŠŽ‚Ž„€ Ž„„…†ˆ‚€…’‘Ÿ               :
;               BX = ‘Œ…™…ˆ… ’€‹ˆ–›                            :
;       CY = 1  ’ˆ „ˆ‘ŠŽ‚Ž„€ …Ž„„…†ˆ‚€…’‘Ÿ                   :
;  €‡“˜…:  BX                                                 :
;-----------------------------------------------------------------
DR_TYPE_CHECK          PROC    NEAR
        PUSH    AX
        PUSH    CX
        XOR     BX,BX                   ; BX = ˆ„…Š‘ ‚ DR_TYPE ’€‹ˆ–…
        MOV     CX,DR_CNT               ; CX = ‘—…’—ˆŠ Ž‚’Ž…ˆ‰

TYPE_CHK:
        MOV     AH,CS:DR_TYPE[BX]       ; Ž‹“—…ˆ… ’ˆ€ „ˆ‘ŠŽ‚Ž„€ (F000:20E9=1)
        CMP     AL,AH                   ; ‘€‚…ˆ… ’ˆ€ ˆ‡ ŠŒŽ ˆ ’€‹ˆ—ŽƒŽ
        JE      DR_TYPE_VALID           ; „€, ‚›•Ž„ ‘ ‘Ž˜…›Œ ”‹€ƒŽŒ
        ADD     BX,3                    ; Ž‚…Š€ ‘‹…„“ž™…ƒŽ ’ˆ€ „ˆ‘ŠŽ‚Ž„€
        LOOP    TYPE_CHK
        STC                             ; „€›‰ ’ˆ „ˆ‘ŠŽ‚Ž„€ … €‰„… ‚ ’€.
        JMP     SHORT TYPE_RTN
DR_TYPE_VALID:
        MOV     BX,CS:WORD PTR DR_TYPE[BX+1]    ; BX = ‘Œ…™…ˆ… ’€‹ˆ–› Ž‘ˆ’/„ˆ‘.
TYPE_RTN:
        POP     CX
        POP     AX
        RET
DR_TYPE_CHECK          ENDP

; ----------------------------------------------------------------
;  SEND_SPEC                                                        :
;       Ž‘›‹€…’ ‘…–ˆ€‹œ“ž ŠŽŒ€„“ ‚ ŠŽ’Ž‹‹… ˆ‘Ž‹œ‡“Ÿ „€-    :
;       ›… ˆ‡ ’€‹ˆ–› €€Œ…’Ž‚ € ŠŽ’Ž›… “Š€‡›‚€…’ DISK_POINTER :
;  ‚•Ž„:    DISK_POINTER = ’€‹ˆ–€ €€Œ…’Ž‚ „ˆ‘ŠŽ‚Ž„€             :
;  ‚›•Ž„:     …’                                                   :
;  ˆ‡Œ……›:  CX,BX                                                 :
;-----------------------------------------------------------------
SEND_SPEC          PROC    NEAR
        PUSH    AX
        MOV     AX,OFFSET SPECBAC       ; ‡€ƒ“‡Š€ €„…‘€ Ž˜ˆŠˆ
        PUSH    AX
        MOV     AH,03H                  ; ‘…–ˆ€‹œ€Ÿ ŠŽŒ€„€
        CALL    NEC_OUTPUT              ; Žƒ€ŒˆŽ‚€ˆ… NEC
        SUB     DL,DL                   ; …‚›‰ €‰’ €€Œ…’Ž‚
        CALL    GET_PARM                ; Ž‹“—…ˆ… €€Œ…’€ ‚ AH
        CALL    NEC_OUTPUT              ; ‚›‚Ž„ ŠŽŒ€„›
        MOV     DL,1                    ; ‘‹…„“ž™ˆ‰ €‰’     
        CALL    GET_PARM                ; Ž‹“—…ˆ… €€Œ…’€ ‚ AH
        CALL    NEC_OUTPUT              ; ‚›‚Ž„ ŠŽŒ€„›     
        POP     AX                      
SPECBAC:
        POP     AX                      
        RET
SEND_SPEC          ENDP

; ----------------------------------------------------------------
;  SEND_SPEC_MD                                                  :
;       Ž‘›‹Š€ ‘…–ˆ€‹œŽ‰ ŠŽŒ€„› ‚ ŠŽ’Ž‹‹…,ˆ‘Ž‹œ‡“ž™…‰    :
;       „€›… ˆ‡ ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ ‘ “Š€‡.(CX:BX)       :
;      ‚•Ž„:    CX:BX = “Š€‡€’…‹œ€ ’€‹ˆ–“                      :
;    ‚›•Ž„:     …’                                              :
;-----------------------------------------------------------------
SEND_SPEC_MD          PROC    NEAR
        PUSH    AX                      
        MOV     AX,OFFSET SPEC_ESBAC    ; ‡€ƒ“‡Š€ €„…‘€ Ž˜ˆŽŠ
        PUSH    AX                      ; ‘Ž•€…ˆ… €„…‘€        
        MOV     AH,03H                  ; ‘…–ˆ€‹œ€Ÿ ŠŽŒ€„€
        CALL    NEC_OUTPUT              ; ‚›‚Ž„ ŠŽŒ€„›     
        MOV     AH,CS:[BX].MD_SPEC1     ; Ž‹“—…ˆ… …‚ŽƒŽ ‘…–ˆ€‹œŽƒŽ €‰’€
        CALL    NEC_OUTPUT              ; ‚›‚Ž„ ŠŽŒ€„›     
        MOV     AH,CS:[BX].MD_SPEC2     ; Ž‹“—…ˆ… ‘…–ˆ€‹œŽƒŽ €‰’€
        CALL    NEC_OUTPUT              ; ‚›‚Ž„ ŠŽŒ€„›     
        POP     AX                      
SPEC_ESBAC:
        POP     AX                      
        RET
SEND_SPEC_MD          ENDP              

; ----------------------------------------------------------------
;  XLAT_NEW                                                      :
;       ’€‘‹ˆ“…’ Ž‹€‘’œ ‹ŽŠ€–ˆˆ „ˆ‘Š…’› „‹Ÿ €€€’Ž‰       :
;       ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ                                            :
;      ‚•Ž„:    DI:„ˆ‘ŠŽ‚Ž„                                      :
;-----------------------------------------------------------------

XLAT_NEW          PROC    NEAR
        CMP     DI,1                    ; €‚ˆ‹œ›‰ ŽŒ… „ˆ‘ŠŽ‚Ž„€ ?
        JA      XN_OUT                  ; Ž˜ˆŽ—›‰
        CMP     DSK_STATE[DI],0         ; Ž…„…‹… ?
        JZ      DO_DET                  ; …‘‹ˆ …’ Ž›’Š€ Ž…„…‹…ˆŸ
        MOV     CX,DI                   ; CX = ŽŒ… „ˆ‘ŠŽ‚Ž„€
        SHL     CL,1                    ; CL = ‘„‚ˆƒ  ,A=0,B=4
        SHL	CL,1
        MOV     AL,HF_CNTRL             ; ˆ”ŽŒ€–ˆŸ Ž „ˆ‘ŠŽ‚Ž„…
        ROR     AL,CL                   ; ‚›„ˆ‹…ˆ… ‘ŽŽ’‚…’‘’‚“ž™…ƒŽ ˆ‹€
        AND     AL,DRV_DET+FMT_CAPA+TRK_CAPA    ; ‚›„…‹…ˆ… …Ž•Ž„ˆŒ›• ˆ’
        AND     DSK_STATE[DI],NOT DRV_DET+FMT_CAPA+TRK_CAPA
        OR      DSK_STATE[DI],AL        ; ˆ‡Œ……ˆ… ‘Ž‘’ŽŸˆŸ „ˆ‘ŠŽ‚Ž„€
XN_OUT:
                RET
DO_DET:
                CALL    DRIVE_DET       ; Ž…„…‹…ˆ… „ˆ‘ŠŽ‚Ž„€
                RET
XLAT_NEW          ENDP

; ----------------------------------------------------------------
;  XLAT_OLD                                                      :
;       ……„€—€ €‘Ž‹Ž†…ˆŸ ’€‹ˆ–› Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„          :
;       ˆ‡ „“ƒŽ‰ €•ˆ’…Š’“› „‹Ÿ Ž„„…†€ˆŸ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ      :
;      ‚•Ž„:    DI:„ˆ‘ŠŽ‚Ž„                                      :
;-----------------------------------------------------------------
XLAT_OLD          PROC    NEAR
        CMP     DI,1                    ; €‚ˆ‹œŽ‘’œ ŽŒ…€ „ˆ‘ŠŽ‚Ž„€ ?
        JA      XN_OUT                  ; …‘‹ˆ …€‚ˆ‹œ›‰
        CMP     DSK_STATE[DI],0         ; …’ „ˆ‘ŠŽ‚Ž„€ ?
        JE      XN_OUT                  ; …‘‹ˆ …’

;-------   ’…‘’ …‘‹ˆ ˆ”ŽŒ€–ˆŸ Ž „ˆ‘ŠŽ‚Ž„… “†… “‘’€Ž‚‹…€

        MOV     CX,DI                   ; CX = ŽŒ… „ˆ‘ŠŽ‚Ž„€
        SHL     CL,1                    ; CL = ‘„‚ˆƒ ,A=0,B=4
        SHL	CL,1
        MOV     AH,FMT_CAPA             ; ‡€ƒ“‡Š€ Œ€‘Šˆ ŒŽƒŽ”ŽŒ€’ŽƒŽ „ˆ‘ŠŽ‚.
        ROR     AH,CL                   ; ‚€™…ˆ… Œ€‘Šˆ
        TEST    HF_CNTRL,AH             ; “‘’€Ž‚‹… ‹ˆ …†ˆŒ ŒŽƒŽ‘ŠŽŽ‘’. ?
        JNZ     SAVE_SET                ; …‘‹ˆ „€, ’Ž … “†„€…’‘Ÿ ‚ ……“‘’€Ž‚Š…

;-------  ‘’ˆ€’œ ˆ’ „ˆ‘ŠŽ‚Ž„€ ‚ HF_CNTRL „‹Ÿ ’ŽƒŽ „ˆ‘ŠŽ‚Ž„€

        MOV     AH,DRV_DET+FMT_CAPA+TRK_CAPA    ; Œ€‘Š€
        ROR     AH,CL
        NOT     AH
        AND     HF_CNTRL,AH

;-------  „Ž‘’“ Š ’…Š“™…Œ“ „ˆ‘ŠŽ‚Ž„“ ˆ “‘’€Ž‚Š€ ‚ HF_CNTRL

        MOV     AL,DSK_STATE[DI]        ; Ž‹“—…ˆ… ‘Ž‘’ŽŸˆŸ
        AND     AL,DRV_DET+FMT_CAPA+TRK_CAPA    ; ‚›„…‹…ˆ… ˆ’ „ˆ‘ŠŽ‚Ž„€
        ROR     AL,CL                   ; „‹Ÿ ‚›€ŽƒŽ „ˆ‘ŠŽ‚Ž„€
        OR      HF_CNTRL,AL             ; ‡€ˆ‘œ ˆ‡Œ……ŽƒŽ ‘Ž‘’ŽŸˆŸ

;------……„€—€ „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ    

SAVE_SET:
        MOV     AH,DSK_STATE[DI]        ; „Ž‘’“ Š ‘Ž‘’ŽŸˆž
        MOV     BH,AH                   ; ‚ BH „‹Ÿ ‘€‚…ˆŸ
        AND     AH,RATE_MSK             ; ‚›„…‹…ˆ… ‘ŠŽŽ‘’ˆ
        CMP     AH,RATE_500             ; ‘ŠŽ 500 ?
        JZ      CHK_144                 ; „€ 1.2/1.2 ˆ‹ˆ 1.44/1.44
        MOV     AL,M3D1U                ; AL =360 ‚ 1.2 
        CMP     AH,RATE_300             ; ‘ŠŽ 300 ?
        JNZ     CHK_250                 ; …’,360/360,720/720 ˆ‹ˆ 720/1.44
        TEST    BH,DBL_STEP             ; „€,„‚Ž‰Ž‰ ˜€ƒ ?
        JNZ     TST_DET                 ; „€, ’Ž 360 ‚ 1.2 
UNKNO:
        MOV     AL,MED_UNK              ; 'ˆŠ’Ž … Ž‹œ˜…'
        JMP     SHORT AL_SET            ; Ž–…‘‘ ‡€‚…˜…
CHK_144:
        CALL    CMOS_TYPE               ; ’ˆ „ˆ‘ŠŽ‚Ž„€ ‚ (AL)
        JC      UNKNO                   ; Ž˜ˆŠ€ “‘’€Ž‚Š€ '… Ž‹œ˜…'
        CMP     AL,02                   ; 1.2MB „ˆ‘ŠŽ‚Ž„ ?
        JNE     UNKNO                   ; …’,“‘’€Ž‚Š€ 'ˆŠ’Ž … Ž‹œ˜…'
        MOV     AL,M1D1U                ; AL = 1.2 ‚ 1.2
        JMP     SHORT TST_DET
CHK_250:
        MOV     AL,M3D3U                ; AL = 360 ‚ 360 
        CMP     AH,RATE_250             ; ‘ŠŽ 250 ?
        JNE     UNKNO                   ; …‘‹ˆ …’
        TEST    BH,TRK_CAPA             ; 80 ’…ŠŽ‚  ?
        JNZ     UNKNO                   
TST_DET:
        TEST    BH,MED_DET              ; Ž…„…‹… ?
        JZ      AL_SET                  ; …‘‹ˆ …’, ’Žƒ„€ “‘’€€‚‹ˆ‚€…Œ
        ADD     AL,3                    ; „…‹€Œ Ž…„…‹…/“‘’€Ž‚‹…
AL_SET:
        AND     DSK_STATE[DI],NOT DRV_DET+FMT_CAPA+TRK_CAPA     ; Ž—ˆ‘’Š€ „ˆ‘ŠŽ‚Ž„€
        OR      DSK_STATE[DI],AL        ; ŠŽˆŽ‚€ˆ… „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‰ ŒŽ„…‹ˆ
XO_OUT:
        RET
XLAT_OLD          ENDP

; ----------------------------------------------------------------
;  RD_WR_VF                                                      :
;       Ž–…„“€ —’…ˆŸ, ‡€ˆ‘ˆ ˆ ‚…ˆ”ˆŠ€–ˆˆ                   :
;       Ž‘Ž‚Ž‰ –ˆŠ‹ „‹Ÿ Ž‚’Ž…ˆŸ                             :
;      ‚•Ž„:    AH : €€Œ…’› NEC „‹Ÿ —’…ˆŸ, ‡€ˆ‘ˆ, ‚…ˆ”ˆŠ.  :
;               AL : €€Œ…’› DMA „‹Ÿ —’…ˆŸ, ‡€ˆ‘ˆ, ‚…ˆ”ˆŠ.  :
;    ‚›•Ž„:     DSKETTE_STATUS, CY ‘’€’“‘ Ž…€–ˆˆ               :
;-----------------------------------------------------------------

RD_WR_VF          PROC    NEAR
        PUSH    AX                      ; ‘Ž•€…ˆ… €€Œ…’Ž‚ DMA ˆ NEC
        CALL    XLAT_NEW                ; ’€‘‹ˆ“…’ ‘Ž‘’ŽŸˆ… Ž„Š‹ž—. „ˆ‘Š.
        CALL    SETUP_STATE             ; ˆˆ–ˆ€‹ˆ‡ˆ“…’ €—€‹œ“ž ˆ ŠŽ…—“ž
					; ‘ŠŽŽ‘’œ ‚ ‘‹“—€… …Ž…„…‹…Ž‘’ˆ
					; „ˆ‘ŠŽ‚Ž„€ ˆ ’ˆ€ Ž‘ˆ’…‹Ÿ
        POP     AX                      ; ‚Ž‘‘’€Ž‚‹…ˆ…
DO_AGAIN:
        PUSH    AX                      ; ‘Ž•€…ˆ… €€Œ…’Ž‚ DMA ˆ NEC
        CALL    MED_CHANGE              ; Ž‚…Š€ ‘Œ…› „ˆ‘Š…’› ˆ ‘Ž‘€

        POP     AX
        JNC     RWV
        JMP     RWV_END
RWV:
        PUSH    AX
        MOV     DH,DSK_STATE[DI]        ; Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ
        AND     DH,RATE_MSK
        CALL    CMOS_TYPE               ; ’ˆ „ˆ‘ŠŽ‚Ž„€ ‚ (AL)
        JC      RWV_ASSUME              ; Ž˜ˆŠ€ ‚ CMOS
        CMP     AL,1                    ; 40 ’…ŠŽ‚›‰ „ˆ‘ŠŽ‚Ž„ ?
        JNE     RWV_1                   ; …’, Ž•Ž„ ŠŽ…Š’Ž‘’ˆ CMOS
        TEST    DSK_STATE[DI],TRK_CAPA  ; Ž‚…Š€ „‹Ÿ 40 ’…ŠŽ‚ŽƒŽ „ˆ‘ŠŽ‚Ž„€
        JZ      RWV_2                   ; „€, CMOS ŠŽ…Š’Ž
        MOV     AL,2                    ; ‘Œ…€ 1.2M
        JMP     SHORT RWV_2             ; Ž„Ž‹†…ˆ…
RWV_1:
        JB      RWV_2                   ; „ˆ‘ŠŽ‚Ž„ … Ž…„…‹…
        TEST    DSK_STATE[DI],1         ; …‘‹ˆ ’Ž 40 ’…ŠŽ‚›‰ ?
        JNZ     RWV_2                   ; …’ 80 ’…ŠŽ‚
        MOV     AL,1                    ; …‘‹ˆ 40 ’…ŠŽ‚, ’Ž ˆ‘€‚‹…ˆ… CMOS
RWV_2:
        OR      AL,AL
        JZ      RWV_ASSUME              ; …„Ž‹Žƒ€…Œ Œ€Š‘ˆŒ€‹œŽ… Š-‚Ž „ŽŽ†…Š
        CALL    DR_TYPE_CHECK           ; CX:BX = ’€‹ˆ–€ €€Œ…’Ž‚ Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„
        JC      RWV_ASSUME              ; ’ˆ€ …’ ‚ ’€‹ˆ–…(Ž˜ˆŠ€ CMOS)

;------ Žˆ‘Š „‹Ÿ ’€‹ˆ–› €€Œ…’Ž‚ Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„

        PUSH    DI                      ; ‘Ž•€…ˆ… ŽŒ…€ „ˆ‘ŠŽ‚Ž„€
        XOR     BX,BX                   ; BX = ˆ„Š‘ ‚ DR_TYPE ’€‹ˆ–…
        MOV     CX,DR_CNT               ; CX = ‘—…’—ˆŠ Ž‚’Ž…ˆ‰
RWV_DR_SEARCH:
        MOV     AH,CS:DR_TYPE[BX]       ; Ž‹“—…ˆ… ’ˆ€ „ˆ‘ŠŽ‚Ž„€
        AND     AH,BIT7OFF              ; Œ€‘Š€ 7 ˆ’€
        CMP     AL,AH                   ; ’ˆ ‘Ž‚Ž„€…’ ?
        JNE     RWV_NXT_MD              ; …’ Ž‚…Š€ ‘‹…„“ž™…ƒŽ ’ˆ€
RWV_RR_FND:
        MOV     DI,WORD PTR CS:DR_TYPE[BX+1]    ; Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ ’€‹ˆ–€ €€Œ…’Ž‚
RWV_MD_SEARCH:
        CMP     DH,CS:[DI].MD_RATE      ; ‘Ž‚€„€ž’ ?
        JE      RWV_MD_FND              ; „€, Ž‹“—…ˆ… …‚ŽƒŽ €‰’€
RWV_NXT_MD:
        ADD     BX,3                    ; Ž‚…Š€ ‘‹…„“ž™…ƒŽ „ˆ‘ŠŽ‚Ž„€
        LOOP    RWV_DR_SEARCH
        POP     DI                      ; ‚Ž‘‘’€Ž‚‹…ˆ… ŽŒ…€ „ˆ‘ŠŽ‚Ž„€

;------- …„Ž‹Žƒ€…Œ —’Ž …‚›‰ „ˆ‘ŠŽ‚Ž„ ‚…„“™ˆ‰

RWV_ASSUME:
        MOV     BX,OFFSET MD_TBL1       ; “Š€‡€’…‹œ € 40 „Ž ˆ ‘ŠŽŽ‘’œ 250
        TEST    DSK_STATE[DI],TRK_CAPA  ; ’…‘’ „‹Ÿ 80 „ŽŽ†…Š
        JZ      RWV_MD_FND1             ; ŒŽ†…’ ›’œ 40 „ŽŽ†…Š
        MOV     BX,OFFSET MD_TBL3       ; “Š€‡€’…‹œ € 80 ’ 500 KBS
	JMP     short RWV_MD_FND1             ; Ž‹“—…ˆ… ‘…–ˆ€‹œ›• €€Œ…’Ž‚

;------- CS:BX “Š€‡€’…‹œ € ’€‹ˆ–“ Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„

RWV_MD_FND:
        MOV     BX,DI
	POP     DI                      ; ‚Ž‘‘’€Ž‚‹…ˆ… ŽŒ…€ „ˆ‘ŠŽ‚Ž„€
RWV_MD_FND1:

;-------- Ž‘›‹Š€ ‘…–ˆ€‹œŽ‰ ŠŽŒ€„› ‚ NEC ŠŽ’Ž‹‹…

        CALL    SEND_SPEC_MD
        CALL    CHK_LASTRATE            ; ZF = 1 Ž›’Š€ ‘ŠŽŽ‘’ˆ Š€Š ‚ Ž‘‹-
					; ‹…„…‰ Ž…€–ˆˆ
        JZ      RWV_DBL                 ; „€, Ž“‘Š ŠŽŒ€„› “‘’€Ž‚Šˆ ‘ŠŽŽ‘’ˆ
        CALL    SEND_RATE               ; “‘’€Ž‚Š€ ‘ŠŽŽ‘’ˆ ‚€™…ˆŸ
RWV_DBL:
        PUSH    BX                      ; ‘Ž•€…ˆ… €„…‘€ ’€‹ˆ–›
        CALL    SETUP_DBL               ; Ž‚…Š€ „‹Ÿ „‚Ž‰ŽƒŽ ˜€ƒ€
        POP     BX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… €„…‘€
        JC      CHK_RET                 ; Ž˜ˆŠ€ —’…ˆŸ, ‚Ž‡ŒŽ†Ž Ž‚’Ž…ˆ…
        POP     AX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… NEC, DMA ŠŽŒ€„
        PUSH    AX                      ; ‘Ž•€…ˆ…
        PUSH    BX
        CALL    DMA_SETUP               ; Žƒ€ŒˆŽ‚€ˆ… DMA
        POP     BX
        POP     AX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… NEC ŠŽŒ€„›
        JC      RWV_BAC                 ; Ž‚…Š€ Ž˜ˆŠˆ DMA
        PUSH    AX                      ; ‘Ž•€…ˆ… NEC ŠŽŒ€„›
        PUSH    BX                      ; ‘Ž•€…ˆ… €„…‘€
        CALL    NEC_INIT                ; ˆˆ–ˆ€‹ˆ‡€–ˆŸ NEC
        POP     BX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… €„…‘€
        JC      CHK_RET                 ; ‚›•Ž„-Ž˜ˆŠ€
        CALL    RWV_COM                 ; ŠŽ„ —’…ˆŸ/‡€ˆ‘ˆ/‚…ˆ”ˆŠ€–ˆˆ
        JC      CHK_RET                 ; ‚›•Ž„-Ž˜ˆŠ€
        CALL    NEC_TERM                ; ‡€‚…˜…ˆ… Ž‹“—…ˆ… ‘’€’“‘€
CHK_RET:
        CALL    RETRY                   ; Ž‚…Š€ „‹Ÿ Ž‚’Ž€
        POP     AX                      ; ‚Ž‘‘’€Ž‚‹…ˆ… €€Œ…’Ž‚ —’/‡€/‚…
        JNC     RWV_END                 ; CY = 0 … Ž‚’ŽŸ’œ
        JMP     DO_AGAIN                ; CY = 1 Ž‚’ŽŸ’œ
RWV_END:
        CALL    DSTATE                  ; “‘’€Ž‚Š€ ‘Ž‘’ŽŸˆŸ, …‘‹ˆ “‘…•
        CALL    NUM_TRANS               ; AL = ……‘›‹€…ŒŽ… —ˆ‘‹Ž
RWV_BAC:
        PUSH    AX                      ; ‘Ž•€…ˆ…
        CALL    XLAT_OLD                ; ……„€—€ „‹Ÿ ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ
        POP     AX
        CALL    SETUP_END               ; Ž—ˆ‘’Š€
        RET
RD_WR_VF          ENDP
;--------------------------------------------------------------------
;  SETUP_STATE:    ˆˆ–ˆ€‹ˆ‡€–ˆŸ €—€‹œŽ‰ ˆ ŠŽ…—Ž‰ ‘ŠŽŽ‘’ˆ        :
;--------------------------------------------------------------------
SETUP_STATE          PROC    NEAR
        TEST    DSK_STATE[DI],MED_DET   ; „ˆ‘Š…’€ Ž…„…‹…€ ?
        JNZ     J1C                     ; Ž“‘Š, …‘‹ˆ Ž…„…‹…€
        MOV     AX,0040H                ; AH = ‘’€’Ž‚€Ÿ ‘ŠŽŽ‘’œ_500,
					; AL=ŠŽ…—€Ÿ ‘ŠŽŽ‘’œ_300
        TEST    DSK_STATE[DI],DRV_DET   ; „ˆ‘ŠŽ‚Ž„ Ž…„…‹… ?
        JZ      AX_SET                  ; … €„Ž Ž…„…‹Ÿ’œ
        TEST    DSK_STATE[DI],FMT_CAPA  ; ŒŽƒŽ-‘ŠŽŽ‘’Ž‰ (1.2M) ?
        JNZ     AX_SET                  ; JUMP …‘‹ˆ „€
        MOV     AX,8080H                ; ‘’€’Ž‚€Ÿ ‘ŠŽŽ‘’œ = 250 „‹Ÿ 360 „ˆ‘ŠŽ‚Ž„€
AX_SET:
        AND     DSK_STATE[DI],NOT RATE_MSK+DBL_STEP     ; ‚›Š‹ž—…ˆ… ˆ’Ž‚ ‘ŠŽŽ‘’ˆ
        OR      DSK_STATE[DI],AH        ; “‘’€Ž‚Š€ ‘ŠŽŽ‘’ˆ 250
        AND     LASTRATE,NOT STRT_MSK   ; ‘’ˆ€ˆ… Ž‘‹…„…ƒŽ ˆ’€ ‘ŠŽŽ‘’ˆ
        PUSH    CX
        MOV	CL,4
        ROR     AL,CL
        POP	CX                      ; Ž‘‹…„ŸŸ ‘ŠŽŽ‘’œ
        OR      LASTRATE,AL
J1C:
        RET
SETUP_STATE          ENDP
;--------------------------------------------------------------------
;  FMT_INIT: “‘’€Ž‚Š€ ‘Ž‘’ŽŸˆŸ, …‘‹ˆ ‚…ŒŸ ”ŽŒ€’ˆŽ‚€ˆŸ … “‘’€Ž‚‹…Ž
;--------------------------------------------------------------------
FMT_INIT        PROC    NEAR
        TEST    DSK_STATE[DI],MED_DET   ; Ž‘ˆ’…‹œ “‘’€Ž‚‹…
        JNZ     FI_OUT                  ; …‘‹ˆ ’€Š - ‚›•Ž„
        CALL    CMOS_TYPE               ; ’ˆ „ˆ‘ŠŽ‚Ž„€ ‚ AL
        JC      CL_DRV                  ; Ž˜ˆŠ€ ŠŒŽ, …„Ž‹Žƒ€…Œ Ž’‘“’‘-
					; ’‚ˆ… „ˆ‘ŠŽ‚Ž„€
        DEC     AL                      ; “‘’€Ž‚Š€ €—€‹œŽƒŽ ‘Ž‘’ŽŸˆŸ
        JS      CL_DRV                  ; …’ „ˆ‘ŠŽ‚Ž„€ …‘‹ˆ 0
        MOV     AH,DSK_STATE[DI]        ; AH = ’…Š“™…… ‘Ž‘’ŽŸˆ…
        AND     AH,NOT MED_DET+DBL_STEP+RATE_MSK        ; Ž—ˆ‘’Š€
        OR      AL,AL                   ; Ž‚…Š€ „‹Ÿ 360
        JNZ     N_360                   ; …‘‹ˆ 360 ’Ž 0
        OR      AH,MED_DET+RATE_250     ; “‘’€Ž‚Š€ Ž‘ˆ’…‹Ÿ
        JMP     SHORT SKP_STATE         ; Ž“‘Š „“ƒˆ• Ž€Ž’ŽŠ
N_360:
        DEC     AL                      ; 1.2 M „ˆ‘ŠŽ‚Ž„
        JNZ     N_12                    ; JUMP …‘‹ˆ …’
FI_RATE:
        OR      AH,MED_DET+RATE_500     ; “‘’€Ž‚Š€ ‘ŠŽŽ‘’ˆ ”ŽŒ€’ˆŽ‚€ˆŸ
        JMP     SHORT SKP_STATE         ; Ž“‘ „“ƒˆ• Ž€Ž’ŽŠ
N_12:
        DEC     AL                      ; Ž‚…Š€ 3 ’ˆ€
        JNZ     N_720                   ; JUMP …‘‹ˆ …’
        TEST    AH,DRV_DET              ; „ˆ‘ŠŽ‚Ž„ Ž…„…‹…
        JZ      ISNT_12                 ; Ž€™…ˆ… Š€Š … 1.2
        TEST    AH,FMT_CAPA             ; 1.2 M
        JZ      ISNT_12                 ; JUMP …‘‹ˆ …’
        OR      AH,MED_DET+RATE_300     ; 300
        JMP     SHORT SKP_STATE         ; Ž„Ž‹†…ˆ…
N_720:
        DEC     AL                      ; Ž‚…Š€ „‹Ÿ ’ˆ€ 4
        JNZ     CL_DRV                  ; …’ „ˆ‘ŠŽ‚Ž„€, Ž˜ˆŠ€ ŠŒŽ
        JMP     SHORT FI_RATE
ISNT_12:
        OR      AH,MED_DET+RATE_250     ; ‘ŠŽŽ‘’œ 250
SKP_STATE:
        MOV     DSK_STATE[DI],AH        ; “‘’€Ž‚Š€
FI_OUT:
        RET
CL_DRV:
        XOR     AH,AH                   ; Ž—ˆ‘’Š€ ‘Ž‘’ŽŸˆŸ
        JMP     SHORT SKP_STATE         ; ‡€ˆ‘œ …ƒŽ
FMT_INIT        ENDP
; ----------------------------------------------------------------
;  MED_CHANGE                                                    :
;       Ž‚…Š€ ‘Œ…› „ˆ‘Š…’›, ‘Ž‘ ‹ˆˆˆ ‘Œ…› „ˆ‘Š…’›        :
;       ˆ ‘Ž‚€ Ž‚…Š€ ‘Œ…›                                   :
;                                                                :
;    ‚›•Ž„:     CY = 1 „ˆ‘Š…’€ ‘Œ……€ ˆ‹ˆ ‚…ŒŸ ‚›˜‹Ž           :
;               DSKETTE_STATUS = ŠŽ„ Ž˜ˆŠˆ                      :
;-----------------------------------------------------------------
MED_CHANGE          PROC    NEAR
        CALL    READ_DSKCHNG            ; —’…ˆ… ‘Ž‘’ŽŸˆŸ ‹ˆˆˆ ‘Œ…› „ˆ‘Š…’›
        JZ      MC_OUT                  ; Ž•Ž„ …‘‹ˆ … ‘Œ……€
        AND     DSK_STATE[DI],NOT MED_DET       ; Ž—ˆ‘’Š€ ‘Ž‘’ŽŸˆŸ „‹Ÿ ‡€€-
						; ˜ˆ‚€…ŒŽƒŽ „ˆ‘ŠŽ‚Ž„€


        MOV     CX,DI                   ; CL = ŽŒ… „ˆ‘ŠŽ‚Ž„€
        MOV     AL,1                    ; ˆ’ Œ€‘Šˆ ŒŽ’Ž€
        SHL     AL,CL                   ; ‘ŽŽ’‚…’‘’‚“ž™€Ÿ Ž‡ˆ–ˆŸ
        NOT     AL
        CLI                             ; ‡€…’ …›‚€ˆ‰
        AND     MOTOR_STATUS,AL         ; Ž‚ŽŽ’ ŒŽ’Ž€ „‹Ÿ ˆ„ˆŠ€–ˆˆ
        STI                             ; €‡…˜…ˆ… …›‚€ˆ‰
        CALL    MOTOR_ON                ; Ž‚ŽŽ’ ŒŽ’Ž€

;--------  ‘Ž‘ ‘ˆƒ€‹€

        CALL    DISK_RESET              ; ‘Ž‘
        MOV     CH,01H                  ; ……„‚ˆ†…ˆ… € 1 „ŽŽ†Š“
        CALL    SEEK                    ; ‚›Ž‹…ˆ… ……„‚ˆ†…ˆŸ
        XOR     CH,CH                   ; ……„‚ˆ†…ˆ… € 0 „ŽŽ†Š“
        CALL    SEEK                    ; ‚›Ž‹…ˆ… ……„‚ˆ†…ˆŸ
        MOV     DISKETTE_STATUS,MEDIA_CHANGE    ; ‘Ž•€…ˆ… ‚ ‘’€’“‘…

OK1:    CALL    READ_DSKCHNG            ; Ž‚…Š€ ‘Œ…› ‘Ž‚€
        JZ	MC_OUT                  ; ???
;        JZ      OK2                     ; IF ACTIVE, NO DISKETTE, TIMEOUT

OK4:    MOV     DISKETTE_STATUS,TIME_OUT  ; ‚…ŒŸ ‚›˜‹Ž …‘‹ˆ „ˆ‘ŠŽ‚Ž„ “‘’
OK2:
        STC                             ; ‘Œ……€, “‘’€Ž‚Š€ CY
        RET
MC_OUT:
        CLC                             ; … ‘Œ……€
        RET
MED_CHANGE          ENDP
; ----------------------------------------------------------------
;  SEND_RATE                                                     :
;       Ž‘›‹Š€ ‘ŠŽŽ‘’ˆ ‚€™…ˆŸ ‚ NEC                          :
;      ‚•Ž„:    DI = ŽŒ… „ˆ‘ŠŽ‚Ž„€                             :
;    ‚›•Ž„:     …’                                              :
;  ˆ‡Œ……:     DX                                               :
;-----------------------------------------------------------------
SEND_RATE          PROC    NEAR

        PUSH    AX
        AND     LASTRATE,NOT SEND_MSK   ; Ž—ˆ‘’Š€ ‘ŠŽŽ‘’ˆ Ž‘‹…„…ƒŽ Ž€™…ˆŸ
        MOV     AL,DSK_STATE[DI]        ; Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ „€ŽƒŽ „ˆ‘ŠŽ‚Ž„€
        AND     AL,SEND_MSK             ; Ž‘’€‚ˆ’œ’Ž‹œŠŽ ˆ’› ‘ŠŽŽ‘’ˆ
        OR      LASTRATE,AL             ; ‘Ž•€…ˆ… Ž‚Ž‰ ‘ŠŽŽ‘’ˆ „‹Ÿ ‘‹…„“-
					; ž™…‰ Ž‚…Šˆ
        ROL     AL,1                    ; ……„‚ˆ†…ˆ… ˆ’Ž‚ ‚ “†“ž Ž‡ˆ–ˆž
        ROL	AL,1
        MOV     DX,03F7H                ; “‘’€Ž‚Š€ Ž‚Ž‰ ‘ŠŽŽ‘’ˆ
        OUT     DX,AL
        POP     AX
        RET
SEND_RATE          ENDP

; ----------------------------------------------------------------
;  CHK_LASTRATE                                                  :
;       Ž‚…Š€ …„›„“™…‰ ‘ŠŽŽ‘’ˆ ‚€™…ˆŸ                    :
;      ‚•Ž„:                                                     :
;       DI = ŽŒ… „ˆ‘ŠŽ‚Ž„€                                     :
;    ‚›•Ž„:                                                      :
;       ZF = 1 ‘ŠŽŽ‘’œ ’€ †…, —’Ž ˆ ‚ …„›„“™…‰ Ž…€–ˆˆ       :
;       ZF = 0 „“ƒ€Ÿ                                            :
;  ˆ‡Œ……:  BX                                                  :
;-----------------------------------------------------------------
CHK_LASTRATE          PROC    NEAR
        PUSH    AX
        MOV     AH,LASTRATE             ; Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ …„›„“™…‰ Ž…€–ˆˆ
        MOV     AL,DSK_STATE[DI]        ; Ž‹“—…ˆ… ‘ŠŽŽ‘’ˆ ’ŽƒŽ „ˆ‘ŠŽ‚Ž„€
        AND     AX,0C0C0H ;SEND_MSK*X   ; ’Ž‹œŠŽ ˆ’› ‘ŠŽŽ‘’ˆ
        CMP     AL,AH                   ; ‘€‚…ˆ… ‘ …„›„“™…‰
                                        ; ZF = 1 ‘ŠŽŽ‘’œ ’€ †…
        POP     AX
        RET
CHK_LASTRATE          ENDP
