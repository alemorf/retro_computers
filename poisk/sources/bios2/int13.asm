
;-- INT 13 -------------------------------------------------------------
; DISKETTE I/O
;       ’Ž’ ˆ’…”…‰‘ Ž…‘…—ˆ‚€…’ „Ž‘’“ Š  5.25 „ž‰ŒŽ‚ŽŒ“ 360 KB,
;       1.2MB,720 KB, AND 1.44 MB „ˆ‘ŠŽ‚Ž„“
; ‚•Ž„
;       (AH)=OOH  ‘Ž‘ „ˆ‘ŠŽ‚Ž‰ ‘ˆ‘’…Œ›
;        €Ž€’›‰ ‘Ž‘ NEC, Ž„ƒŽ’Ž‚ˆ’…‹œ€Ÿ ŠŽŒ€„€
;----------------------------------------------------------------------------
;       (AH)=01H  —’…ˆ… ‘’€’“‘€ ‘ˆ‘’…Œ› ‚ (AH)
;                 DISKETTE_STATUS Ž‘‹…„…‰ „ˆ‘ŠŽ‚Ž‰ Ž…€–ˆˆ
;----------------------------------------------------------------------------
;       …ƒˆ‘’› „‹Ÿ —’…ˆŸ/‡€ˆ‘ˆ/‚…ˆ”ˆŠ€–ˆˆ
;       (DL) - ŽŒ… „ˆ‘ŠŽ‚Ž„€ (0-1 , ‡€—…ˆ… Ž‚…Ÿ…’‘Ÿ)
;       (DH) - ŽŒ… ƒŽ‹Ž‚Šˆ (0-1 ALLOWED, NOT VALUE CHECKED)
;       (CH) - ŽŒ… „ŽŽ†Šˆ (NOT VALUE CHECKED)
;                 MEDIA     DRIVE        TRACK NUMBER
;                320/360   320/360           0-39
;                320/360    1.2M             0-39
;                 1.2M      1.2M             0-79
;                 720K      720K             0-79
;                 1.44M     1.44M            0-79
;       (CL) - ŽŒ… ‘…Š’Ž€ (‡€—…ˆ… … Ž‚…Ÿ…’‘Ÿ, … ˆ‘Ž‹œ‡“…’‘Ÿ ˆ
;                            ”ŽŒ€’ˆŽ‚€ˆˆ)
;                 MEDIA     DRIVE        SECTOR NUMBER
;                320/360   320/360            1-8/9
;                320/360    1.2M              1-8/9
;                 1.2M      1.2M              1-15
;                 720K      720K              1-9
;                 1.44M     1.44M             1-18
;       (AL) - —ˆ‘‹Ž ‘…Š’ŽŽ‚ (‡€—…ˆ… … Ž‚…Ÿ…’‘Ÿ, … ˆ‘Ž‹œ‡“…’‘Ÿ ˆ
;			      ”ŽŒ€’ˆŽ‚€ˆˆ)
;                 MEDIA     DRIVE        MAX NUMBER OF SECTORS
;                320/360   320/360               8/9
;                320/360    1.2M                 8/9
;                 1.2M      1.2M                 15
;                 720K      720K                  9
;                 1.44M     1.44M                18
;
;       (ES:BX) - €„…‘‘ “””…€ (… ˆ‘Ž‹œ‡“…’‘Ÿ ˆ ‚…ˆ”ˆŠ€–ˆˆ)
;
;---------------------------------------------------------------------------
;       (AH)=02H  —’…ˆ… “Š€‡€ŽƒŽ ‘…Š’Ž€ ‚ €ŒŸ’œ
;----------------------------------------------------------------------------
;       (AH)=03H  ‡€ˆ‘œ “Š€‡€ŽƒŽ ‘“Š’Ž€ ‚ €ŒŸ’œ
;----------------------------------------------------------------------------
;       (AH)=04H  ‚…ˆ”ˆŠ€–ˆŸ “Š€‡€ŽƒŽ ‘…Š’Ž€
;----------------------------------------------------------------------------
;       (AH)=05H  ”ŽŒ€’ˆŽ‚€ˆ… “Š€‡€ŽƒŽ ‘…Š’Ž€
;                 (ES,BX) „Ž‹†… “Š€‡›‚€’œ € Ž‹€‘’œ „€›• €€Œ…’Ž‚
;                 „ˆ‘Š…’› . Š€†„€Ÿ Ž‹€‘’œ ‚Š‹ž—€…’ 4 €‰’€  (C,H,R,N),
;                 ƒ„…:
;                 C = —ˆ‘‹Ž „ŽŽ†…Š, H=—ˆ‘‹Ž ƒŽ‹Ž‚ŽŠ, R = —ˆ‘‹Ž ‘…Š’ŽŽ‚,
;		  N= —ˆ‘‹Ž €‰’ € ‘…Š’Ž (00=128, 01=256, 02=512, 03=1024,)
;                 Ž–…„“€ ”ŽŒ€’ˆŽ‚€ˆŸ „Ž“‘Š€…’
;                 “‘’€Ž‚Š“ ”ŽŒ€’€ Œ€Š‘ˆŒ€‹œŽ‰ ‹Ž’Ž‘’ˆ „‹Ÿ „€ŽƒŽ „ˆ‘ŠŽ‚Ž„€
;                 €€Œ…’› DISK_BASE „Ž‹†› ›’œ €‘Ž‹Ž†…› ‚ ŽŸ„Š…
;                 -------------------------------------------
;                 : MEDIA  :  DRIVE         : PARM1 : PARM2 :
;                 -------------------------------------------
;                 : 320K   : 320K/360K/1.2M :  50H  :   8   :
;                 : 360K   : 320K/360K/1.2M :  50H  :   9   :
;                 : 1.2M   :    1.2M        :  54H  :  15   :
;                 : 720K   :  720K/1.44M    :  50H  :   9   :
;                 : 1.44M  :  1.44M         :  6CH  :  18   :
;                 -------------------------------------------
;                 ‡€Œ…’ˆŒ:-PARM 1=ŽŒ…†“’ŽŠ „‹Ÿ ”ŽŒ€’€
;                         -PARM 2=EOT (Ž‘‹…„ˆ‰ ‘…Š’Ž ‚ ’…Š…)
;                         -DISK_BASE ’Ž “Š€‡€’…‹œ € Ž‹€‘’œ €‘Ž‹Ž†…ˆŸ
;                          €€Œ…’Ž‚ „ˆ‘Š€ ‘ €‘Ž‹ž’›Œ €„…‘ŽŒ 0:78
;------------------------------------------------------------------------------
;       (AH)=08H —’…ˆ… €€Œ…’Ž‚ „ˆ‘ŠŽ‚Ž„€
;         INPUT
;           (DL)-ŽŒ… „ˆ‘ŠŽ‚Ž„€ (0-1 ‡€—…ˆ… Ž‚…Ÿ…’‘Ÿ)
;         OUTPUT
;           (ES:DI) “Š€‡€’…‹œ € ’€‹ˆ–“ €€Œ…’Ž‚
;           (CH)-Œ€Š‘ˆŒ€‹œ›‰ ŽŒ… „ŽŽ†Šˆ (Œ‹€„˜ˆ… 8 ˆ’)
;           (CL)-Œ€Š‘ˆŒ€‹œ›‰ ŽŒ… ‘…Š’Ž€(ˆ ‘’€˜ˆ… ˆ’› Œ€Š‘ˆŒ€‹œŽƒŽ
;		 ŽŒ…€ „ŽŽ†Šˆ
;           (DH)-Œ€Š‘ˆŒ€‹œ›‰ ŽŒ… ƒŽ‹Ž‚Šˆ
;------------------------------------------------------------------------------
;15H ÝATÞ —¨â âì â¨¯ ¤¨áª  (­¥¤®áâã¯­  ¢ XT BIOS)
;     ‚å®¤: DL = ¤¨áª
;    ‚ëå®¤: AH = ª®¤ ãáâà®©áâ¢ :
;                0 = ãáâà®©áâ¢® DL ®âáãâáâ¢ã¥â
;                1 = ¤¨áª¥â ; «®£¨ª  § ¬¥­ë ¤¨áª  ®âáãâáâ¢ã¥â
;                2 = ¤¨áª¥â ; «®£¨ª  § ¬¥­ë ¤¨áª  ¤®áâã¯­  (¡®«ìè¨­áâ¢® á«ãç ¥¢)
;                3 = â¢¥à¤ë© ¤¨áª
;ßßß ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
;16H ÝATÞ —¨â âì áâ âãá § ¬¥­ë ¤¨áª 
;    ‚ëå®¤: AH = ª®¤ áâ âãá :
;                0 = ¤¨áª ­¥ ¡ë« § ¬¥­¥­
;                6 = § ¬¥­   ªâ¨¢­  (®âªàëâ  ¤¨áª®¢ ï ¤¢¥àì);
;                    DL = ­®¬¥à § ¬¥­ï¥¬®£® ¤¨áª 
;ßßß ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
;17H ÝATÞ ãáâ ­®¢¨âì â¨¯ ¤¨áª¥âë (¨á¯®«ì§ã¥âáï ¯¥à¥¤ ®¯¥à æ¨¥© ä®à¬ â¨à®¢ ­¨ï)
;     ‚å®¤: DL = ­®¬¥à ãáâà®©áâ¢  ¤¨áª  (0 ¨«¨ 1)
;           AL = â¨¯ ­®á¨â¥«ï ¤¨áª :
;                0 = ­¥ ¨á¯®«ì§ã¥âáï
;                1 = 360K ¤¨áª¥â  ¢ 360K ãáâà®©áâ¢¥
;                2 = 360K ¤¨áª¥â  ¢ 1.2M ãáâà®©áâ¢¥
;                3 = 1.2M ¤¨áª¥â  ¢ 1.2M ãáâà®©áâ¢¥
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;       (AH)=18H “‘’€Ž‚Š€ ’ˆ€ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
;       ‚•Ž„›… …ƒˆ‘’›
;       (CH) - ‘ 8 Ž 10 ˆ’› - Œ‹€„˜ˆ… ˆ’› Œ€Š‘ˆŒ€‹œŽƒŽ —ˆ‘‹€ „ŽŽ†…Š
;       (CL) - ˆ’› 7 ˆ 6 - ‘’€˜ˆ… „‚€ ˆ’€ Œ€Š‘ˆŒ€‹œŽƒŽ —ˆ‘‹€ „ŽŽ†…Š
;            - ˆ’› 5 - 0 -Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž ‘…Š’ŽŽ‚ € „ŽŽ†Š…
;       (DL) - ŽŒ… „ˆ‘ŠŽ‚Ž„€ (0-1 ‡€—…ˆ… Ž‚…Ÿ…’‘Ÿ)
;       ‚›•Ž„›… …ƒˆ‘’›
;       (ES:DI) - “Š€‡€’…‹œ € ’€‹ˆ–“ €€Œ…’Ž‚ ’ŽƒŽ ’ˆ€ „ˆ‘Š…’,
;		  …‘‹ˆ AH “‹…‚Ž…
;       (AH) - 00H, CY=0 ,’ˆ €€Œ…’› Ž„„…†ˆ‚€ž’‘Ÿ
;              01H, CY=1 ,’€ ”“Š–ˆŸ … „Ž‘’“€
;              0CH, CY=1 ,’ˆ €€Œ…’› … Ž„„…†ˆ‚€ž’‘Ÿ
;                         ˆ‹ˆ …ˆ‡‚…‘’›‰ ’ˆ
;            - 80H, CY=1 ,TIME OUT („ˆ‘Š…’’€ … ˆ‘“’‘’‚“…’)
;-----------------------------------------------------------------------------
;
;    ‘Ž‘’ŽŸˆŸ „ˆ‘Š€ - €‘Ž‹ž’›‰ €„…‘‘ 40:90 („ˆ‘ŠŽ‚Ž„ A) ˆ 91 („ˆ‘ŠŽ‚Ž„ B)
;
;   -----------------------------------------------------------------
;   |       |       |       |       |       |       |       |       |
;   |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;   |       |       |       |       |       |       |       |       |
;   -----------------------------------------------------------------
;       |       |       |       |       |       |       |       |
;       |       |       |       |       |       -----------------
;       |       |       |       |       |               |
;       |       |       |       |    …‡…‚             --’…Š“™…… ‘Ž‘’ŽŸˆ…
;       |       |       |       |
;       |       |       |       |        000: 360K ‚ 360K „ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
;       |       |       |       |        001: 360K ‚ 1.2M „ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
;       |       |       |       |        010: 1.2M ‚ 1.2M „ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
;       |       |       |       |        011: 360K ‚ 360K „ˆ‘ŠŽ‚Ž„ “‘’€Ž‚‹…
;       |       |       |       |        100: 360K ‚ 1.2M „ˆ‘ŠŽ‚Ž„ “‘’€Ž‚‹…
;       |       |       |       |        101: 1.2M ‚ 1.2M „ˆ‘ŠŽ‚Ž„ “‘’€Ž‚‹…
;       |       |       |       |        110: …‡…‚
;       |       |       |       |        111: … Ž‹œ˜…
;       |       |       |       |
;       |       |       |       ------> „ˆ‘Š…’€/„ˆ‘ŠŽ‚Ž„ “‘’€Ž‚‹…›
;       |       |       |
;       |       |       --------------> „‚Ž‰Ž‰ ˜€ƒ 360K ‚ 1.2M
;       |       |
;       |       |
;       ------------------------------> ‘ŠŽŽ‘’œ ……„€—ˆ „€›• „‹Ÿ ’ŽƒŽ „ˆ‘ŠŽ‚Ž„€
;
;                                               00: 500 KBS
;                                               01: 300 KBS
;                                               10: 250 KBS
;                                               11: …‡…‚
;--------------------------------------------------------------------------------

        ORG     0EC59H

DISKETTE_IO     PROC    FAR
        STI
        PUSH    BP
        PUSH    DI
        PUSH    DX
        PUSH    BX
        PUSH    CX
        MOV     BP,SP
        PUSH    DS
        PUSH    SI
        CALL    DDS

        MOV	LowLim,AX
        MOV	UPPP,055H
REPID_YES:        
	not	uppp
        CMP     AH,19H
                                        ; Ž‚…Š€  19H ”“Š–ˆˆ
        JB      OK_FUNC
        MOV     AH,14H
OK_FUNC:
        CMP     AH,1                    ; Ž‚…Š€ 1 ˆ 8 ”“Š–ˆ‰
        JBE     OK_DRV                  ;
        CMP     AH,8                    ;
        JE      OK_DRV                  ;
        CMP     DL,1                    ;
        JBE     OK_DRV                  ;
        MOV     AH,14H                  ;
OK_DRV :
        MOV     CL,AH                   ; ‚›—ˆ‘‹…ˆ… €„…‘€ ‚›Ž‹Ÿ…ŒŽ‰ ”“Š–ˆˆ
        XOR     CH,CH                   ;
        SHL     CL,1                    ;
        MOV     BX,OFFSET FNC_TAB       ;
        ADD     BX,CX                   ;
        MOV     AH,DH                   ;
        XOR     DH,DH                   ;
        MOV     SI,AX                   ;
        MOV     DI,DX                   ;
        MOV     AH,DISKETTE_STATUS      ; Ž“‹…ˆ… DISKETTE_STATUS
        MOV     DISKETTE_STATUS,0       ;

;       „‹Ÿ ‚‘…• ”“Š–ˆ‰ ˆŽ‘ ‘‹“†…€Ÿ ˆ”ŽŒ€–ˆŸ ‘Ž„…†ˆ’‘Ÿ ‚ …ƒˆ‘’€• ˆ ‚
;       Ž‹€‘’Ÿ• €ŒŸ’ˆ. … ‚‘… ”“Š–ˆˆ ’…“ž’ Ž‹ŽƒŽ ˆ‘Ž‹œ‡Ž‚€ˆŸ ‚‘…• €€
;       Œ…’Ž‚
;
;               DI      : „ˆ‘ŠŽ‚Ž„ #
;               SI-HI   : ƒŽ‹Ž‚Š€  #
;               SI-LOW  : # ‘…Š’ŽŽ‚ ˆ‹ˆ ’ˆ DASD „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
;               ES      : ‘…ƒŒ…’ “”…€
;               [BP]    : ‘…Š’Ž #
;               [BP+1]  : „ŽŽ†Š€ #
;               [BP2]   : BUFFER OFFSET
;
                                        ;
        CALL    WORD PTR CS:[BX]        ; ……•Ž„ € …Ž•Ž„ˆŒ“ž ”“Š–ˆž
        JNC	EXIT_OP
        CMP	UPPP,0AAH
        JNE	EXIT_OP
        MOV	AX,LowLim
        MOV	CX,[BP]
        MOV	BX,[BP+2]
        MOV	DX,[BP+4]
        JMP	REPID_YES
EXIT_OP:               
        POP     SI                      ;
        POP     DS
        POP     CX
        POP     BX
        POP     DX
        POP     DI
        MOV     BP,SP
        PUSH    AX
        PUSHF
        POP     AX
        MOV     [BP+6],AX
        POP     AX
        POP     BP
        IRET
;----------------------------------------------------------------------------
FNC_TAB DW      DISK_RESET              ; AH = 00H; ‘Ž‘
        DW      DISK_STATUS             ; AH = 01H; ‘’€’“‘
        DW      DISK_READ               ; AH = 02H; —’…ˆ…
        DW      DISK_WRITE              ; AH = 03H; ‡€ˆ‘œ
        DW      DISK_VERF               ; AH = 04H; ‚…ˆ”ˆŠ€–ˆŸ
        DW      DISK_FORMAT             ; AH = 05H; ”ŽŒ€’ˆŽ‚€ˆ…
        DW      FNC_ERR                 ; AH = 06H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 07H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      DISK_PARMS              ; AH = 08H; —’…ˆ… €€Œ…’Ž‚ „ˆ‘ŠŽ‚Ž„€
        DW      FNC_ERR                 ; AH = 09H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0AH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0BH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0CH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0DH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0EH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 0FH; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 10H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 11H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 12H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 13H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      FNC_ERR                 ; AH = 14H; … Ž„„…†ˆ‚€…’‘Ÿ
        DW      DISK_TYPE               ; AH = 15H; —’…ˆ… DASD ’ˆ€
        DW      DISK_CHANGE             ; AH = 16H; ‘Œ…€ ‘’€’“‘€
        DW      FORMAT_SET              ; AH = 17H; “‘’€Ž‚Š€ DASD ’ˆ€
        DW      SET_MEDIA               ; AH = 18H; “‘’€Ž‚Š€ ’ˆ€ „ˆ‘Š…’›
FNC_TAE EQU     $                       ; ŠŽ…–
DISKETTE_IO     ENDP

MD_STRUC        STRUC
MD_SPEC1        DB      ?       ; SRT=D,HD UNLOAD=OF -IST SPECIFY BYTE
MD_SPEC2        DB      ?       ; HD LOAD=1,MODE=DMA -2ND SPECIFY BYTE
MD_OFF_TIM      DB      ?       ; Ž†ˆ„€ˆ… Ž‘‹… ‚Š‹ž—…ˆŸ ŒŽ’Ž€         
MD_BYT_SEC      DB      ?       ; 512 €‰’/‘…Š’Ž
MD_SEC_TRK      DB      ?       ; EQT (Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)
MD_GAP          DB      ?       ; ŽŒ…†“’ŽŠ Œ…†„“ ‡€ˆ‘ŸŒˆ
MD_DTL          DB      ?       ; DTL
MD_GAP3         DB      ?       ; ŽŒ…†“’ŽŠ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
MD_FIL_BYT      DB      ?       ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
MD_HD_TIM       DB      ?       ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)
MD_STR_TIM      DB      ?       ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)
MD_MAX_TRK      DB      ?       ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š
MD_RATE         DB      ?       ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•
MD_STRUC        ENDS

TYPEDSK		EQU	42h    ;43H     ; ‚…Œ…Ž €‡€—…Ž !!! A=720K  B=1.44M

BIT7OFF         EQU     7FH
BIT7ON          EQU     80H

;--------- DISKETTE ERRORS-

MED_NOT_FND     EQU     00CH            ;’ˆ „ˆ‘Š…’› … Ž…„…‹…

;----------Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ ˆ„ˆŠ€’Ž› ‘Ž‘’ŽŸˆŸ

TRK_CAPA        EQU     00000001B       ;80 „ŽŽ†…—›‰    
FMT_CAPA        EQU     00000010B       ;ŒŽƒŽ‘ŠŽŽ‘’Ž‰ (1.2MB)
DRV_DET         EQU     00000100B       ;ˆ’ Ž…„…‹…ˆŸ „ˆ‘ŠŽ‚Ž„€
MED_DET         EQU     00010000B       ;ˆ’ Ž…„…‹…ˆŸ „ˆ‘Š…’›
DBL_STEP        EQU     00100000B       ;ˆ’ Ž…„…‹…ˆŸ „ˆ‘Š…’›
RATE_MSK        EQU     11000000B       ;Œ€‘Š€ „‹Ÿ Ž—ˆ‘’Šˆ ‚‘…• ˆ’ ‘ŠŽŽ‘’ˆ
RATE_250        EQU     10000000B       ;250 KBS ‘ŠŽŽ‘’œ ……„€—ˆ
RATE_300        EQU     01000000B       ;300 KBS ‘ŠŽŽ‘’œ ……„€—ˆ
RATE_500        EQU     00000000B       ;500 KBS ‘ŠŽŽ‘’œ ……„€—ˆ
STRT_MSK        EQU     00001100B       ;Œ€‘Š€ ‘’€’Ž‚Ž‰ ‘ŠŽŽ‘’ˆ 
SEND_MSK        EQU     11000000B       ;Œ€‘Š€ „‹Ÿ Ž‘›‹Šˆ ˆ’ ‘ŠŽŽ‘’ˆ

;----------Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ ˆ„ˆŠ€’Ž› ‘Ž‚Œ…‘’ˆŒŽ‘’ˆ

M3D3U           EQU     00000000B       ;360 Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
M3D1U           EQU     00000001B       ;360 Ž‘ˆ’,1.2„ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
M1D1U           EQU     00000010B       ;1.2 Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ … “‘’€Ž‚‹…
MED_UNK         EQU     00000111B       ;ˆŠ’Ž … Ž‹œ˜…  

;----------CMOS ’€‹ˆ–€ €‘Ž‹Ž†…ˆŸ

CMOS_DIAG       EQU     00EH            ;€‰’ „ˆ€ƒŽ‘’ˆŠˆ                   
CMOS_DISKETTE   EQU     010H            ;’ˆ› „ˆ‘ŠŽ‚Ž„Ž‚         



;------------------------------------------------------------------------------
;       ’€‹ˆ–› ’ˆŽ‚ „ˆ‘ŠŽ‚Ž„Ž‚
;----------------------------------------------------------------------------
DR_TYPE         DB      01              ; …‚›‰ ’ˆ            
                DW      OFFSET MD_TBL1
                DB      02+BIT7ON
                DW      OFFSET MD_TBL2
DR_DEFAULT      DB      02
                DW      OFFSET MD_TBL3
                DB      03
                DW      OFFSET MD_TBL4
                DB      04+BIT7ON
                DW      OFFSET MD_TBL5
                DB      04
                DW      OFFSET MD_TBL6
DR_TYPE_E       =$                      ; ŠŽ…– ’€‹ˆ–›
DR_CNT          EQU     (DR_TYPE_E-DR_TYPE)/3
;--------------------------------------------------------------------------
;       Ž‘ˆ’…‹œ/„ˆ‘ŠŽ‚Ž„ ’€‹ˆ–› €€Œ…’Ž‚                              :
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;       360 KB Ž‘ˆ’…‹œ ‚ 360 „ˆ‘ŠŽ‚Ž„…                                   :
;--------------------------------------------------------------------------
MD_TBL1         LABEL BYTE
        DB      11011111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ     
        DB      2               ; 512 €‰’ € ‘…Š’Ž
        DB      09              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)
        DB      02AH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ
        DB      0FFH            ; DTL
        DB      050H            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ   
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„) 
        DB      39              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š           
        DB      RATE_250        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•             
;------------------------------------------------------------------------------
;       360 KB Ž‘ˆ’…‹œ 1.2 MB „ˆ‘ŠŽ‚Ž„                                    :
;-----------------------------------------------------------------------------
MD_TBL2         LABEL BYTE
        DB      11011111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE    
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE    
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ    
        DB      2               ; 512 €‰’ € ‘…Š’Ž                     
        DB      09              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)     
        DB      02AH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ              
        DB      0FFH            ; DTL                                    
        DB      050H            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ          
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ     
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)  
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)   
        DB      39              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š             
        DB      RATE_300        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•               
;----------------------------------------------------------------------------
;       1.2 MB Ž‘ˆ’…‹œ 1.2 MB „ˆ‘ŠŽ‚Ž„                                    :
;---------------------------------------------------------------------------
MD_TBL3         LABEL BYTE
        DB      11011111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE    
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE    
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ    
        DB      2               ; 512 €‰’ € ‘…Š’Ž                     
        DB      15              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)     
        DB      01BH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ              
        DB      0FFH            ; DTL                                    
        DB      054H            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ          
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ     
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)  
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)   
        DB      79              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š             
        DB      RATE_500        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•               
;-----------------------------------------------------------------------------
;       720 KB Ž‘ˆ’…‹œ 720 KB „ˆ‘ŠŽ‚Ž„                                       :
;-----------------------------------------------------------------------------
MD_TBL4         LABEL BYTE
        DB      11011111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE    
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE    
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ    
        DB      2               ; 512 €‰’ € ‘…Š’Ž                     
        DB      09              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)     
        DB      02AH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ              
        DB      0FFH            ; DTL                                    
        DB      050H            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ          
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ     
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)  
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)   
        DB      79              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š             
        DB      RATE_250        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•               
;----------------------------------------------------------------------------
;       720 KB Ž‘ˆ’…‹œ 1.44 MB „ˆ‘ŠŽ‚Ž„                                     :
;----------------------------------------------------------------------------

MD_TBL5         LABEL BYTE
        DB      11011111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE    
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE    
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ    
        DB      2               ; 512 €‰’ € ‘…Š’Ž                     
        DB      09              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)     
        DB      02AH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ              
        DB      0FFH            ; DTL                                    
        DB      050H            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ          
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ     
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)  
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)   
        DB      79              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š             
        DB      RATE_250        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•               
;----------------------------------------------------------------------------
;       1.44 MB Ž‘ˆ’…‹œ 1.44 MB „ˆ‘ŠŽ‚Ž„                                   :
;----------------------------------------------------------------------------

MD_TBL6         LABEL BYTE
        DB      10101111B       ; SRT=D,HD UNLOAD=OF-1ST SPECIFY BYTE    
        DB      2               ; HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE    
        DB      MOTOR_WAIT      ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ    
        DB      2               ; 512 €‰’ € ‘…Š’Ž                     
        DB      18              ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)     
        DB      01BH            ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ              
        DB      0FFH            ; DTL                                    
        DB      06CH            ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ          
        DB      0F6H            ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ     
        DB      15              ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)  
        DB      8               ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„)   
        DB      79              ; Œ€Š‘ˆŒ€‹œŽ… —ˆ‘‹Ž „ŽŽ†…Š             
        DB      RATE_500        ; ‘ŠŽŽ‘’œ ……„€—ˆ „€›•               

;-------------------------------------------------------------------------
;DISK_BASE
;       ’€ ’€‹ˆ–€ ‘Ž„…†ˆ’ €€Œ…’› …Ž•Ž„ˆŒ›… „‹Ÿ
;       „ˆ‘Š…’›• Ž…€–ˆ‰.€ …… “Š€‡›‚€…’ DISK_POINTER
;       „‹Ÿ ŒŽ„ˆ”ˆŠ€–ˆˆ €€Œ…’Ž‚ …Ž•Ž„ˆŒŽ Ž‘’Žˆ’œ ‘‚Žž
;       ’€‹ˆ–“ ˆ ‡€ƒ“‡ˆ’œ “Š€‡€’…‹œ € …… ‚ DISK_POINTER      
;-------------------------------------------------------------------------
        ORG     0EFC7H
DISK_BASE       LABEL  BYTE
        DB      10011111B     ;SRT=9,HD UNLOAD=0F-IST SPECIFY BYTE
        DB      2             ;HD LOAD=1,MODE=DMA-2ND SPECIFY BYTE
        DB      MOTOR_WAIT    ; ‚…ŒŸ €Ž’› ŒŽ’Ž€ Ž‘‹… ‚Š‹ž—…ˆŸ  
        DB      2             ; 512 €‰’ € ‘…Š’Ž                   
        DB      18            ; EOT ( Ž‘‹…„ˆ‰ ‘…Š’Ž € „ŽŽ†Š…)   
        DB      02AH          ; €‘‘’ŽŸˆ… Œ…†„“ ‡€ˆ‘ŸŒˆ            
        DB      0FFH          ; DTL                                  
        DB      050H          ; €‘‘’ŽŸˆ… „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ        
        DB      0F6H          ; €‰’ ‡€Ž‹…ˆŸ „‹Ÿ ”ŽŒ€’ˆŽ‚€ˆŸ   
        DB      25            ; ‚…ŒŸ “‘’€Ž‚Šˆ ƒŽ‹Ž‚Šˆ (Œˆ‹‹ˆ‘…Š“„)
        DB      4             ; ‚…ŒŸ ‚Š‹ž—…ˆŸ ŒŽ’Ž€ ( 1/8 ‘…Š“„) 

