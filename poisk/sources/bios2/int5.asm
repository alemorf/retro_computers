
;---INT5--------------------------------------------------------------------
;       THIS LOGIC WILL BE INVOKED BY INTERRUPT 05H TO PRINT
;       THE SCREEN. THE CURSOR POSITION AT THE TIME THIS ROUTINE
;       IS INVOKED WILL BE SAVED AND RESTORED UPON COMPLETION.
;       THE ROUTINE IS INTENDED TO RUN WITH INTERRUPTS ENABLED.
;       IF A SUBSEQUENT 'PRINT SCREEN' KEY IS DEPRESSED DURING THE
;       TIME THIS ROUTINE IS PRINTING IT WILL BE IGNORED.
;       ADDRESS 50:0 CONTAINS THE STATUS OF THE PRINT SCREEN:
;
;       50:0    =0     EITHER PRINT SCREEN HAS NOT BEEN CALLED
;                      OR UPON RETURN FROM A CALL THIS INDICATES
;                      A SUCCESSFUL OPERATION.
;               =1     PRINT SCREEN IS IN PROGRESS
;               =255   ERROR ENCOUNTERED DURING PRINTING
;---------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:XXDATA
        ORG     0FF54H
PRINT_SCREEN    PROC   FAR
        STI                          ;MUST RUN WITH INTERRUPTS ENABLED
        PUSH    DS                   ;MUST USE 50:0 FOR DATA AREA STORAGE
        PUSH    AX
        PUSH    BX
        PUSH    CX                   ;WILL USE THIS LATER FOR CURSOR LIMITS
        PUSH    DX                   ;WILL HOLD CURRENT CURSOR POSITION
        MOV     AX,XXDATA            ;HEX 50
        MOV     DS,AX
        CMP     STATUS_BYTE,1        ;SEE IF PRINT ALREADY IN PROGRESS
        JZ      EXIT                 ;JUMP IF PRINT ALREADY IN PROGRESS
        MOV     STATUS_BYTE,1        ;INDICATE PRINT NOW IN PROGRESS
        MOV     AH,15                ;WILL REQUEST THE CURRENT SCREEN MODE
        INT     10H                  ;      [AL]=MODE
                                     ;      [AH]=NUMBER COLUMNS/LINE
                                     ;      [BH]=VISUAL PAGE

;------------------------------------------------------------------
; AT THIS POINT WE KNOW THE COLUMNS/LINE ARE IN
; [AX] AND THE PAGE IF APPLICABLE IS IN [BH].
; THE STACK HAS DS,AX,BX,CX,DX PUSHED.
; [A] HAS VIDEO MODE
;--------------------------------------------------------------------
        MOV     CL,AH                ;WILL MAKE USE OF [CX] REGISTER TO
        MOV     CH,25                ;CONTROL ROW & COLUMNS
        CALL    CRLF                 ;CARRIAGE RETURN LINE FEED ROUTINE
        PUSH    CX                   ;SAVE SCREEN BOUNDS
        MOV     AH,3                 ;WILL NOW READ THE CURSOR
        INT     10H                  ;AND PRESERVE THE POSITION
        POP     CX                   ;RECALL SCREEN BOUNDS
        PUSH    DX                   ;RECALL [BH]=VISUAL PAGE
        XOR     DX,DX                ;WILL SET CURSOR POSITION TO [0,0]
;----------------------------------------------------------------------
; THE LOOP FROM PRI10 TO THE INSTRUCTION PRIOR TO PRI20
; IS THE LOOP TO READ EACH CURSOR POSITION FROM THE SCREEN
; AND PRINT.
;----------------------------------------------------------------------
PRI10:  MOV     AH,2                 ;TO INDICATE CURSOR SET REQUEST
        INT     10H                  ;NEW CURSOR POSITION ESTABLISHED
        MOV     AH,8                 ;TO INDICATE READ CHARACTER
        INT     10H                  ;CHARACTER NOW IN [AL]
        OR      AL,AL                ;SEE IF VALID CHAR
        JNZ     PRI15                ;JUMP IF VALID CHAR
        MOV     AL,' '               ;MAKE A BLANK
PRI15:
        PUSH    DX                   ;SAVE CURSOR POSITION
        XOR     DX,DX                ;INDICATE PRINTER 1
        XOR     AH,AH                ;TO INDICATE PRINT CHAR IN [AL]
        INT     17H                  ;PRINT TO CHARACTER
        POP     DX                   ;RECALL CURSOR POSITION
        TEST    AH,25H               ;TEST FOR PRINTER ERROR
        JNZ     ERR10                ;JUMP IF ERROR DETECTED
        INC     DL                   ;ADVANCE TO NEXT COLUMN
        CMP     CL,DL                ;SEE IF AT END OF LINE
        JNZ     PRI10                ;IF NOT PROCEED
        XOR     DL,DL                ;BACK TO COLUMN 0
        MOV     AH,DL                ;[AH]=0
        PUSH    DX                   ;SAVE NEW CURSOR POSITION
        CALL    CRLF                 ;LINE FEED CARRIAGE RETURN
        POP     DX                   ;RECALL CURSOR POSITION
        INC     DH                   ;ADVANCE TO NEXT LINE
        CMP     CH,DH                ;FINISHED?
        JNZ     PRI10                ;IF NOT CONTINUE
PRI20:
        POP     DX                   ;RECALL CURSOR POSITION
        MOV     AH,2                 ;TO INDICATE CURSOR SET REQUEST
        INT     10H                  ;CURSOR POSITION RESTORED
        MOV     STATUS_BYTE,0        ;INDICATE FINISHED
        JMP     SHORT EXIT           ;EXIT THE ROUTINE
ERR10:
        POP     DX                   ;GET CURSOR POSITION
        MOV     AH,2                 ;TO REQUEST CURSOR SET
        INT     10H                  ;CURSOR POSITION RESTORED
ERR20:
        MOV     STATUS_BYTE,0FFH     ;INDICATE ERROR

EXIT:   POP     DX                   ;RESTORE ALL THE REGISTERS USED
        POP     CX
        POP     BX
        POP     AX
        POP     DS
        IRET
PRINT_SCREEN    ENDP


;-------CARRIAGE RETURN, LINE FEED SUBROUTINE

CRLF    PROC    NEAR
        XOR     DX,DX                ;PRINTER 0
        XOR     AH,AH                ;WILL NOW SEND INITIAL LF,CR TO PRINTER
        MOV     AL,12Q               ;LF
        INT     17H                  ;SEND  THE LINE FEED
        XOR     AH,AH                ;NOW FOR THE CR
        MOV     AL,15Q               ;CR
        INT     17H                  ;SEND THE CARRIAGE RETURN
        RET
CRLF    ENDP

