;--------INT 16------------------------------------------------
;KEYBOARD I/O
;       THESE ROUTINES PROVIDE KEYBOARD SUPPORT
;INPUT
;       (AH)=0 READ THE NEXT ASCII CHARACTER STRUCK FROM THE KEYBOARD
;               RETURN THE RESULT IN (AL),SCAN CODE IN (AH)
;       (AH)=1  SET THE Z FLAG TO INDICATE IF AN ASCII CHARACTER IS
;               AVAILABLE TO BE READ.
;               (ZF)=1--NO CODE AVAILABLE
;               (ZF)=0--CODE IS AVAILABLE
;               IF ZF=0,THE NEXT CHARACTER IN THE
;                      BUFFER TO BE READ IS
;               IN AX,AND THE ENTRY REMAINS IN THE BUFFER
;       (AH)=2  RETURN THE CURRENT SHIFT STATUS IN AL REGISTER
;               THE BIT SETTINGS FOR THIS CODE ARE INDICATED IN
;               THE EQUATES FOR KB_FLAG
;OUTPUT
;       AS NOTED ABOVE,ONLY AX AND FLAGS CHANGED
;       ALL REGISTERS PRESERVED
;--------------------------------------------------------------.
        ASSUME CS:CODE,DS:DATA
        ORG    0E82EH
KEYBOARD_IO     PROC   FAR
        STI                   ;INTERUPTS BACK ON
        PUSH    DS            ;SAVE CURRENT DS
        PUSH    BX            ;SAVE BX TEMPORARILY
        CALL    DDS
        OR      AH,AH         ;AH=0
        JZ      K1            ;ASCII_READ
        DEC     AH            ;AH=1
        JZ      K2            ;ASCII_STATUS
        DEC     AH            ;AH=2
        JZ      K3            ;SHIFT_STATUS
        JMP     SHORT INTIO_END ;EXIT

;------READ THE KEY TO FIGURE OUT WHAT TO DO

K1:                           ;ASCII READ
        STI                   ;INTERRUPTS BACK ON DURING LOOP
        NOP                   ;ALLOW AN INTERRUPT TO OCCUR
        CLI                   ;INTERRUPTS BACK 0FF
        MOV     BX,BUFFER_HEAD ;GET POINTER TO HEAD OF BUFFER
        CMP     BX,BUFFER_TAIL ;TEST END OF BUFFER
        JZ      K1            ;LOOP UNTIL SOMETHING IN BUFFER
        MOV     AX,[BX]       ;GET SCAN CODE AND ASCII CODE
        CALL    K4            ;MOVE POINTER TO NEXT POSITION
        MOV     BUFFER_HEAD,BX ;STORE VALUE IN VARIABLE
        JMP     SHORT INTIO_END ;RETURN
;-------ASCII STATUS

K2:
        CLI                   ;INTERRUPTS 0FF
        MOV     BX,BUFFER_HEAD ;GET HEAD POINTER
        CMP     BX,BUFFER_TAIL ;IF EQUAL (Z=1)THEN NOTHING THERE
        MOV     AX,[BX]
        STI                   ;INTERRUPTS BACK ON
        POP     BX            ;RECOVER REGISTER
        POP     DS            ;RECOVER SEGMENT
        RET     2             ;THROW AWAY FLAGS

;---------SHIFT STATUS

K3:
        MOV     AL,KB_FLAG    ;GET THE SHIFT STATUS FLAGS
INTIO_END:
        POP     BX            ;RECOVER REGISTER
        POP     DS            ;RECOVER REGISTERS
        IRET                  ;RETURN TO CALLER
KEYBOARD_IO     ENDP

;--------INCREMENT A BUFFER POINTER

K4      PROC    NEAR
        INC     BX            ;MOVE TO NEXT WORD IN LIST
        INC     BX
        CMP     BX,BUFFER_END ;AT END OF BUFFER?
        JNE     K5            ;NO,CONTINUE
        MOV     BX,BUFFER_START ;YES,RESET TO BUFFER BEGINNING
K5:
        RET
K4      ENDP

;-------TABLE OF SHIFT KEYS AND MASK VALUES

K6      LABEL   BYTE
        DB      INS_KEY        ;INSERT KEY
        DB      CAPS_KEY,NUM_KEY,SCROLL_KEY,ALT_KEY,CTL_KEY
        DB      LEFT_KEY,RIGHT_KEY
K6L     EQU     $-K6

;-------SHIFT_MASK_TABLE

K7      LABEL   BYTE
        DB      INS_SHIFT      ;INSERT MODE SHIFT
        DB      CAPS_SHIFT,NUM_SHIFT,SCROLL_SHIFT,ALT_SHIFT,CTL_SHIFT
        DB      LEFT_SHIFT,RIGHT_SHIFT

;-------SCAN CODE TABLES

K8      DB      27,-1,0,-1,-1,-1,30,-1
        DB      -1,-1,-1,31,-1,127,-1,17
        DB      23,5,18,20,25,21,9,15
        DB      16,27,29,10,-1,1,19
        DB      4,6,7,8,10,11,12,-1,-1
        DB      -1,-1,28,26,24,3,22,2
        DB      14,13,-1,-1,-1,-1,-1,-1
        DB      ' ',-1
;-------CTL TABLE SCAN
K9      LABEL   BYTE
        DB      94,95,96,97,98,99,100,101
        DB      102,103,-1,-1,119,-1,132,-1
        DB      115,-1,116,-1,117,-1,118,-1
        DB      -1
;-------LC TABLE
K10     LABEL   BYTE
        DB      01BH,'1234567890-=',08H,09H
        DB      'qwertyuiop[]',0DH,-1,'asdfghjkl;',027H
        DB      60H,-1,5CH,'zxcvbnm,./',-1,'*',-1,' '
        DB      -1
;-------UC TABLE
K11     LABEL   BYTE
        DB      27,'!@#$',37,05EH,'&*()_+',08H,0
        DB      'QWERTYUIOP{}',0DH,-1,'ASDFGHJKL:"'
        DB      07EH,-1,'|ZXCVBNM<>?',-1,0,-1,' ',-1
;-------UC TABLE SCAN
K12     LABEL   BYTE
        DB      84,85,86,87,88,89,90
        DB      91,92,93
;-------ALT TABLE SCAN
K13     LABEL   BYTE
        DB      104,105,106,107,108
        DB      109,110,111,112,113

;-------NUM STATE TABLE
K14     LABEL   BYTE
        DB      '789-456+1230.'
;--------BASE CASE TABLE
K15     LABEL   BYTE
        DB      71,72,73,-1,75,-1,77
        DB      -1,79,80,81,82,83

;--------KEYBOARD INTERRUPT ROUTINE

        ORG     0E987H
KB_INT  PROC    FAR
        STI                   ;ALLOW FURTHER INTERRUPTS
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        PUSH    DI
        PUSH    DS
        PUSH    ES
        CLD                   ;FORWARD DIRECTION
        CALL    DDS
        IN      AL,KB_DATA    ; READ IN THE CHARACTER
        PUSH    AX            ; SAVE IT
        IN      AL,KB_CTL     ; GET THE CONTROL PORT
        MOV     AH,AL         ; SAVE VALUE
        OR      AL,80H        ; RESET BIT FOR KEYBOARD
        OUT     KB_CTL,AL
        XCHG    AH,AL         ; GET BACK ORIGINAL CONTROL
        OUT     KB_CTL,AL     ; KB HAS BEEN RESET
        POP     AX            ; RECOVER SCAN CODE
        MOV     AH,AL         ; SAVE SCAN CODE IN AH ALSO

;------ TEST FOR OVERRUN SCAN CODE FROM KEYBOARD

        CMP     AL,0FFH       ; IS THIS AN OVERRUN CHAR
        JNZ     K16           ; NO,TEST FOR SHIFT KEY
        JMP     K62           ; BUFFER_FULL_BEEP

;------ TEST FOR SHIFT KEYS

K16:                           ; TEST_SHIFT
        AND     AL,07FH        ; TURN 0FF THE BREAK BIT
        PUSH    CS
        POP     ES             ; ESTABLISH ADDRESS OF SHIFT TABLE
        MOV     DI,OFFSET K6   ; SHIFT KEY TABLE
        MOV     CX,K6L         ; LENGTH
        REPNE   SCASB          ; LOOK THROUGH THE TABLE FOR A MATCH


        MOV     AL,AH          ; RECOVER SCAN CODE
        JE      K17            ; JUMP IF MATCH FOUND
        JMP     K25            ; IF NO MATCH,THEN SHIFT NOT FOUND

;------ SHIFT KEY FOUND

K17:    SUB     DI,OFFSET K6+1 ; ADJUST PTR TO SCAN CODE MTCH
        MOV     AH,CS:K7[DI]   ; GET MASK INTO AH
        TEST    AL,80H         ; TEST FOR BREAK KEY
        JNZ     K23            ; BREAK_SHIFT_FOUND

;------ SHIFT MAKE FOUND, DETERMINE SET OR TOGGLE

        CMP     AH,SCROLL_SHIFT
        JAE     K18                ; IF SCROLL  SHIFT OR ABOVE, TOGGLE KEY

;------ PLAIN SHIFT KEY SET SHIFT ON

        OR KB_FLAG,AH              ; TURN ON SHIFT BIT
        JMP     K26                ; INTERRUPT_ RETURN

;------ TOGGLED SHIFT KEY, TEST FOR IST MAKE OR NOT

K18:                               ; SHIFT-TOGGLE
        TEST    KB_FLAG, CTL_SHIFT ; CHECK CTL SHIFT STATE
        JNZ     K25                ; JUMP IF CTL STATTE
        CMP     AL,INS_KEY         ; CHECK FOR INSERT KEY
        JNZ     K22                ; JUMP IF NOT INSERT KEY
        TEST    KB_FLAG, ALT_SHIFT ; CHECK FOR ALTERNATE SHIFT
        JNZ     K25                ; JUMP IF ATLTERNATE SHIFT
K19:    TEST    KB_FLAG, NUM_STATE ; CHECK FOR BAZE STATE
        JNZ     K21                ; JUMP IF NUM LOCK IS ON
        TEST    KB_FLAG, LEFT_SHIFT+RIGHT_SHIFT
        JZ      K22                ; JUMP IF BAZE STATE

K20:                               ; NUMERIC ZERO, NOT INSERT KEY
        MOV     AX, 5230H          ; PUT OUT AN ASCII ZERO
        JMP     K57                ; BUFFER_FILL
K21:                               ; MIGHT BE NUMERIC
        TEST    KB_FLAG, LEFT_SHIFT+RIGHT_SHIFT
        JZ      K20                ; JUMP NUMERIC, NOT INSERT

K22:                               ; SHIFT TOGGLE KEY NIT; PROCESS IT
        TEST    AH,KB_FLAG_1       ; IS KEY ALREADY DEPRESSED
        JNZ     K26                ; JUMP IF KEY ALREADY DEPRESSED
        OR      KB_FLAG_1,AH       ; INDICATE THAT THE KEY IS DEPRESSED
        XOR     KB_FLAG,AH         ; TOGGLE THE SHIFT STATE
        CMP     AL,INS_KEY         ; TEST FOR IST MAKE OF INSERT KEY
        JNE     K26                ; JUMP IF NOT INSERTT KEY
        MOV     AX,INS_KEY*256     ; SET SCAN CODE INTD AN, 0 INTO AL
        JMP     K57                ; PUT INT0 OUTPUT BUFFER

;------ BREAK SHEFT FOUND

K23:                               ; BREAK - SHIFT- FOUND
        CMP     AH,SCROLL_SHIFT    ; IS THIS A TOGGLE KEY
        JAE     K24                ; YES, HANDLE BREAK TOGGLE
        NOT     AH                 ; INVERT MASK
        AND     KB_FLAG,AH         ; TURN OFF SHIFT BIT
        CMP     AL,ALT_KEY+80H     ; IS THIS ALTERNATE SHIFT RELEASE
        JNE     K26                ; INTERRUPT_RETURN

;------ ALTERNATE SHIFT KEY RELEASED, GET THE VALUE INTO BUFFER

        MOV     AL,ALT_INPUT
        MOV     AH,0               ; SCAN COULD OF 0
        MOV     ALT_INPUT, AH      ; ZERO OUT THE FIELD
        CMP     AL,0               ; WAS THE INPUT=0
        JE      K26                ; INTERRUPT_RETURN
        JMP     K58                ; IT WASN'T, SO PUT IN BUFFER

K24:                               ; BREAK TOGGLE
        NOT     AH                 ; INVERT MASK
        AND     KB_FLAG_1,AH       ; INDICATE NO LONGER DEPRESSED
        JMP     SHORT K26          ; INTERRUPT_RETURN

;------ TEST FOR HOLD STATE

K25:                               ; NO-SHIFT-FOUND
        CMP     AL,80H             ; TEST FOR BREAK KEY
        JAE     K26                ; NOTHING FOR BREAK CHARS FROM HERE ON
        TEST    KB_FLAG_1,HOLD_STATE ; ARE WE IN HOLD STATE
        JZ      K28             ; BRANCH AROUND TEST IF NOT
        CMP     AL,NUM_KEY
        JE      K26             ; CAN'T END HOLD ON NUM_LOCK
        AND     KB_FLAG_1,NOT HOLD_STATE  ; TURN OFF THE HOLD STATE BIT
K26:                            ; INTERRUPT-RETURN
        CLI                     ; TURN OFF INTERRUPTS
        MOV     AL,EOI          ; END OF INTERRUPT COMMAND
        OUT     020H,AL         ; SEND COMMAND TO INT CONTROL PORT
K27:                            ;INTERRUPT-RETURN-NO-EOI
        POP     ES
        POP     DS
        POP     DI
        POP     SI
        POP     DX
        POP     CX
        POP     BX
        POP     AX              ; RESTORE STATE
        IRET                    ; RETURN,INTERRUPTS BACK ON
                                ; WITH FLAG CHANGE

;------ NOT IN HOLD STATE, TEST FOR SPECIAL CHARS

K28:                            ; NO-HOLD-STATE
        TEST    KB_FLAG,ALT_SHIFT ; ARE WE IN ALTERNATE SHIFT
        JNZ     K29             ; JUMP IF ALTERNATE SHIFT
        JMP     K38             ; JUMP IF NOT ALTERNATE

;------ TEST FOR RESET KEY SEQUENCE (CTL ALT DEL)

K29:                            ; TEST-RESET
        TEST    KB_FLAG,CTL_SHIFT ; ARE WE IN CTL SHIFT ALSO
        JZ      K31             ; NO_RESET
        CMP     AL,DEL_KEY      ; SHIFT STATE IS THERE, TEST KEY
        JNE     K31             ; NO_RESET

;------ CTL-ALT-DEL HAS BEEN FOUND, DO I/O CLEANUP

        MOV     RESET_FLAG,1234H      ; SET FLAG FOR RESET FUNCTION
;-------éóàëíäÄ ùäêÄçÄ
;        MOV     AX,3
;        INT     10H

;       DB      0EAH,5BH,0E0H,0,0F0H  ; JUMP TO POWER ON DIAGNOSTICS   (Kis !!!)
	JMP	START                 ;RESET_NEAR		; Near JMP to RESET
	NOP				; for Addr Adjusting
	NOP

;------ ALT-INPUT-TABLE
K30     LABEL   BYTE
        DB      82,79,80,81,75,76,77
        DB      71,72,73        ; 10 NUMBERS ON KEYPAD
;------ SUPER-SHIFT - TABLE
        DB      16,17,18,19,20,21,22,23 ; A-Z TYPEWRITER CHARS
        DB      24,25,30,31,32,33,34,35
        DB      36,37,38,44,45,46,47,48
        DB      49,50

;------ IN ALTERNATE SHIFT, RESET NOT FOUND

K31:                            ; NO-RESET
        CMP     AL,57           ; TEST FOR SPACE KEY
        JNE     K32             ; NOT THERE
        MOV     AL,' '          ; SET SPACE CHAR
        JMP     K57             ; BUFFER_FILL

;------ LOOK FOR KEY PAD ENTRY

K32:                   ; ALT-KEY-PAD
        MOV     DI,OFFSET K30   ; ALT-INPUT-TABLE
        MOV     CX,10           ; LOCK FOR ENTRY USING KEYPAD
        REPNE   SCASB           ; LOOK FOR MATCH

        JNE     K33             ; NO_ALT_KEYPAD
        SUB     DI,OFFSET K30+1 ; DI NOW HAS ENTRY VALUE
        MOV     AL,ALT_INPUT    ; GET THE CURRENT BYTE
        MOV     AH,10           ; MULTIPLY BY 10
        MUL     AH
        ADD     AX,DI           ; ADD IN THE LATEST ENTRY
        MOV     ALT_INPUT,AL    ; STORE IT AWAY
        JMP     K26             ; THROW AWAY THAT KEYSTROKE

;------ LOOK FOR SUPERSHIFT ENTRY

K33:                            ; NO-ALT-KEYPAD
        MOV     ALT_INPUT,0     ; ZERO ANY PREVIOUS ENTRY INTO INPUT
        MOV     CX,26           ; DI,ES ALREADY POINTING
        REPNE   SCASB           ; LOOK FOR MATCH IN ALPHABET

        JNE     K34             ; NOT FOUND,FUNCTION KEY OR OTHER
        MOV     AL,0            ; ASCII CODE OF ZERO
        JMP     K57             ; PUT IT IN THE BUFFER


;------ LOOK FOR TOP ROW OF ALTERNATE SHIFT

K34:                            ; ALT-TOP-ROW
        CMP     AL,2            ; KEY WITH '1' ON IT
        JB      K35             ; NOT ONE OF INTERESTING KEYS
        CMP     AL,14           ; IS IT IN THE REGION
        JAE     K35             ; ALT-FUNCTION
        ADD     AH,118          ; CONVERT PSUEDO SCAN CODE TO RANGE
        MOV     AL,0            ; INDICATE AS SUCH
        JMP     K57             ; BUFFER_FILL

;------ TRANSLATE ALTERNATE SHIFT PSEUDO SCAN CODES

K35:                            ; ALT-FUNCTION
        CMP     AL,59           ; TEST FOR IN TABLE
        JAE     K37             ; ALT-CONTINUE
K36:                            ; CLOSE-RETURN
        JMP     K26             ; IGNORE THE KEY
K37:                            ; ALT-CONTINUE
        CMP     AL,71           ; IN KEYPAD REGION
        JAE     K36             ; IF SO, IGNORE
        MOV     BX,OFFSET K13   ; ALT SHIFT PSEUDO SCAN TABLE
        JMP     K63             ; TRANSLATE THAT

;------ NOT IN ALTERNATE SHIFT

K38:                            ; NOT- ALT-SHIFT
        TEST    KB_FLAG,CTL_SHIFT ; ARE WE IN CONTROL SHIFT
        JZ      K44             ; NOT-CTL-SHIFT

;------ CONTROL SHIFT, TEST SPECIAL CHARACTERS
;------ TEST FOR BREAK AND PAUSE KEYS

        CMP     AL,SCROLL_KEY   ; TEST FOR BREAK
        JNE     K39             ; NO-BREAK
        MOV     BX,BUFFER_START ; RESET BUFFER TO EMPTY
        MOV     BUFFER_HEAD,BX
        MOV     BUFFER_TAIL,BX
        MOV     BIOS_BREAK,80H  ; TURN ON BIOS_BREAK BIT
        INT     1BH             ; BREAK INTERRUPT  VECTOR
        SUB     AX,AX           ; PUT OUT DUMMY CHARACTER
        JMP     K57             ; BUFFER_FILL

K39:                            ; NO-BREAK
        CMP     AL,NUM_KEY      ; LOOK FOR PAUSE KEY
        JNE     K41             ; NO-PAUSE
        OR      KB_FLAG_1,HOLD_STATE ; TURN ON THE HOLD FLAG
        MOV     AL,EOI          ; END OF INTERRUPT TO CONTROL PORT
        OUT     020H,AL         ; ALLOW FURTHER KEYSTROKE INTS

;------ DURING PAUSE INTERVAL,TURN CRT BACK ON

        CMP     CRT_MODE,7      ; IS THIS BLACK AND WHITE CARD
        JE      K40             ; YES,NOTHING TO DO
        MOV     DX,03D8H        ; PORT FOR COLOR CARD
        MOV     AL,CRT_MODE_SET ; GET THE VALUE OF THE CURRENT MODE
        OUT     DX,AL           ; SET THE CRT MODE,SO THAT CRT IS ON
K40:                            ; PAUSE-LOOP
        TEST    KB_FLAG_1,HOLD_STATE
        JNZ     K40             ; LOOP UNTIL FLAG TURNED 0FF
        JMP     K27             ; INTERRUPT_RETURN_NO_EOI
K41:                            ; NO-PAUSE

;------ TEST SPECIAL CASE KEY 55

        CMP     AL,55
        JNE     K42             ; NOT-KEY-55
        MOV     AX,114*256      ; START/STOP PRINTING SWITCH
        JMP     K57             ; BUFFER_FILL

;------ SET UP TO TRANSLATE CONTROL SHIFT

K42:                            ; NOT-KEY 55
        MOV     BX,OFFSET K8    ; SET UP TO TRANSLATE CTL
        CMP     AL,59           ; IS IT IN TABLE
                                ; CTL-TABLE-TRANSLATE
        JB     K56              ; YES, GO TRANSLATE CHAR
K43:                            ; CTL-TABLE-TRANSLATE
        MOV     BX,OFFSET K9    ; CTL TABLE SCAN
        JMP     K63             ; TRANSLATE_SCAN

;------ NOT IN CONTROL SHIFT

K44:                            ; NOT-CTL-SHIFT
        CMP     AL,71           ; TEST FOR KEYPAD REGION
        JAE     K48             ; HANDLE KEYPAD REGION
        TEST    KB_FLAG,LEFT_SHIFT+RIGHT_SHIFT
        JZ      K54             ; TEST FOR SHIFT STATE

;------ UPPER CASE, HANDLE SPECIAL CASES

        CMP     AL,15           ; BACK TAB KEY
        JNE     K45             ; NOT-BACK-TAB
        MOV     AX,15*256       ; SET PSEUDO SCAN CODE
        JMP   SHORT K57         ; BUFFER_FILL

K45:                            ; NOT-BACK-TAB
        CMP     AL,55           ; PRINT SCREEN KEY
        JNE     K46             ; NOT-PRINT-SCREEN

;------ ISSUE INTERRUPT TO INDICATE PRINT SCREEN FUNCTION

        MOV     AL,EOI          ; END OF CURRENT INTERRUPT
        OUT     020H,AL         ; SO FURTHER THINGS CAN HAPPEN
        INT     5H              ; ISSUE PRINT SCREEN INTERRUPT
        JMP     K27             ; GO BACK WITHOUT EOI OCCURRING

K46:                            ; NOT-PRINT SCREEN
        CMP     AL,59           ; FUNCTION KEYS
        JB      K47             ; NOT-UPPER-FINCTION
        MOV     BX,OFFSET K12   ; UPPER CASE PSEUDO SCAN CODES
        JMP     K63             ; TRANSLATE_SCAN

K47:                            ; NOT-UPPER-FUNCTION
        MOV     BX,OFFSET K11   ; POINT TO UPPER CASE TABLE
        JMP     SHORT K56       ; OK, TRANSLATE THE CHAR

;------ KEYPAD KEYS,MUST TEST NUM LOCK FOR THE DETERMINATION

K48:                            ; KEYPAD REGION
        TEST    KB_FLAG,NUM_STATE  ; ARE WE IN NUM_LOCK
        JNZ     K52             ; TEST FOR SURE
        TEST    KB_FLAG,LEFT_SHIFT+RIGHT_SHIFT  ; ARE WE IN SHIFT STATE
        JNZ     K53             ; IF SHIFTED, REALLY NUM STATE

;------ BASE CASE FOR KEYPAD

K49:                            ; BASE-CASE
        CMP     AL,74           ; SPECIAL CASE A COUPLE OF KEYS
        JE      K50             ; MINUS
        CMP     AL,78
        JE      K51
        SUB     AL,71           ; CONVERT ORIGIN
        MOV     BX,OFFSET K15   ; BASE CASE TABLE
        JMP     SHORT K64       ; CONVERT TO PSEUDO SCAN

K50:    MOV     AX,74*256+'-'   ; MINUS
        JMP     SHORT K57       ; BUFFER_FILL

K51:    MOV     AX,78*256+'+'   ; PLUS
        JMP     SHORT K57       ; BUFFER_FILL

;------ MIGHT BE NUM LOCK, TEST SHIFT STATUS

K52:                            ;ALMOST-NUM-STATE
        TEST    KB_FLAG,LEFT_SHIFT+RIGHT_SHIFT
        JNZ     K49             ;SHIFTED TEMP OUT OF NUM STATE
K53:                            ;REALLY_NUM_STATE
        SUB     AL,70           ;CONVERT ORIGIN
        MOV     BX,OFFSET K14   ;NUM STATE TABLE
        JMP     SHORT K56       ;TRANSLATE_CHAR
;-------PLAIN OLD LOWER CASE
K54:    CMP     AL,59           ;TEST FOR FUNCTION KEYS
        JB      K55             ;NOT-LOWER-FUNCTION
        MOV     AL,0            ;SCAN CODE IN AH ALREADY
        JMP     SHORT K57       ;BUFFER_FILL
K55:                            ; NOT-LOWER-FUNCTION
        MOV     BX,OFFSET K10   ; LC TABLE

;------ TRANSLATE THE CHARACTER

K56:                            ; TRANSLATE-CHAR
        DEC     AL              ; CONVERT ORIGIN
        XLAT    CS:K11          ; CONERT THE SCAN CODE TO ASCII

;------ PUT CHARACTER INTO BUFFER

K57:                            ; BUFFER-FILL
        CMP     AL,-1           ; IS THIS AN IGNORE CHAR
        JE      K59             ; YES, DO NOTHING WITH IT
        CMP     AH,-1           ; LOOK FOR -1 PSEUDO SCAN
        JE      K59             ; NEAR_INTERRUPT_RETURN

;------ HANDLE THE CAPS LOCK PROBLEM

K58:                            ; BUFFER-FILL-NOTEST
        TEST    KB_FLAG,CAPS_STATE ; ARE WE IN CAPS LOCK STATE
        JZ      K61             ; SKIP IF NOT

;------ IN CAPS LOCK STATE

        TEST    KB_FLAG,LEFT_SHIFT+RIGHT_SHIFT ; TEST FOR SHIFT STATE
        JZ      K60             ; IF NOT SHIFT, CONVERT LOWER TO UPPER

;------ CONVERT ANY UPPER CASE TO LOWER CASE

        CMP     AL,'A'          ; FIND OUT IF ALPHABETIC
        JB      K61             ; NOT_CAPS_STATE
        CMP     AL,'Z'
        JA      K61             ; NOT_CAPS_STATE
        ADD     AL,'a'-'A'      ; CONVERT TO LOWER CASE
        JMP     SHORT K61       ; NOT_CAPS_STATE

K59:                            ; NEAR-INTERRUPT-RETURN
        JMP     K26             ; INTERRUPT_RETURN

;------ CONVERT ANY LOWER CASE TO UPPER CASE

K60:                            ; LOWER-TO-UPPER
        CMP     AL,'a'          ; FIND OUT IF ALPHABETIC
        JB      K61             ; NOT_CAPS_STATE
        CMP     AL,'z'
        JA      K61             ; NOT_CAPS_STATE
        SUB     AL,'a'-'A'      ; CONVERT TO UPPER CASE

K61:                            ; NOT-CAPS-STATE
        MOV     BX,BUFFER_TAIL  ; GET THE END POINTER TO THE BUFFER
        MOV     SI,BX           ; SAVE THE VALUE
        CALL    K4              ; ADVANCE THE TAIL
        CMP     BX,BUFFER_HEAD  ; HAS THE BUFFER WRAPPED AROUND
        JE      K62             ; BUFFER_FULL_BEEP
        MOV     [SI],AX         ; STORE THE VALUE
        MOV     BUFFER_TAIL,BX  ; MOVE THE POINTER UP
        JMP     K26             ; MNTERRUPT_RETURN

;------ TRANSLATE SCAN FOR PSEUDO SCAN CODES

K63:                          ; TRANSLATE-SCAN
        SUB     AL,59         ; CONVERT ORIGIN TO FUNCTION KEYS
K64:                          ; TRANSLATE-SCAN-ORGD
        XLAT    CS:K9         ; CTL TABLE SCAN
        MOV     AH,AL         ; PUT VALUE INTO AH
        MOV     AL,0          ; ZERO ASCII CODE
        JMP     K57           ; PUT IT INTO THE BUFFER

KB_INT ENDP

;------ BUFFER IS FULL,SOUND THE BEEPER

K62:                          ; BUFFER-FULL-BEEP
        MOV     AL,EOI        ;END OF INTERRUPT COMMAND
        OUT     20H,AL        ;SEND COMMAND TO INT CONTROL PORT
        MOV     BX,080H       ;NUMBER OF CYCLES FOR 1/12 SECOND TONE
        IN      AL,KB_CTL     ; GET CONTROL INFORMATION
        PUSH    AX            ; SAVE
K65:                          ; BEEP-CYCLE
        AND     AL,0FCH       ; TURN 0FF TIMER GATE AND SPEAKER DATA
        OUT     KB_CTL,AL     ; OUTPUT TO CONTROL
        MOV     CX,48H        ; HALF CYCLE TIME FOR TONE
K66:
        LOOP    K66           ; SPEAKER 0FF
        OR      AL,2          ; TURN ON SPEAKER BIT
        OUT     KB_CTL,AL     ;OUTPUT TO CONTROL
        MOV     CX,48H        ;SET UP COUNT
K67:
        LOOP    K67           ;ANOTHER HALF CYCLE
        DEC     BX            ;TOTAL TIME COUNT
        JNZ     K65           ;DO ANOTHER CYCLE
        POP     AX            ;RECOVER CONTROL
        OUT     KB_CTL,AL     ;OUTPUT THE CONTROL
        JMP     K27

F1      DB      ' 301',13,10  ;KEYBOARD ERROR
F3      DB      '601',13,10   ;DISKETTE ERROR

