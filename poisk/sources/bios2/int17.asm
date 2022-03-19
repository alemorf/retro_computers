;--- INT 17 -------------------------------------------------------------
; PRINTER_IO                                                            :
;       THIS ROUTINE PROVIDES COMMUNICATION WITH THE PRINTER            :
; INPUT                                                                 :
;       (AH)=0  PRINT THE CHARACTER IN (AL)                             :
;               ON RETURN, AH=1 IF CHARACTER COULD NOT BE PRINTED       :
;               (TIME OUT). OTHER BITS SET AS ON NORMAL STATUS CALL     :
;       (AH)=1  INITIALIZE THE PRINTER PORT                             :
;               RETURN WITH (AH) SET WITH PRINTER STATUS                :
;       (AH)=2  READ THE PRINTER STATUS INTO (AH)                       :
;               7       6       5       4       3       2-1  0          :
;               |       |       |       |       |       |    |_TIME OUT :
;               |       |       |       |       |       |_ UNUSED       :
;               |       |       |       |       |_ 1 = I/O ERROR        :
;               |       |       |       |_ 1 = SELECTED                 :
;               |       |       |_ 1 = OUT OF PAPER                     :
;               |       |_ 1 = ACKNOWLEDGE                              :
;               |_ 1 = NOT BUSY                                         :
;                                                                       :
;       (DX) = PRINTER TO BE USED (0,1,2) CORRESPONDING TO ACTUAL       :
;               VALUES IN PRINTER_BASE AREA                             :
;                                                                       :
; DATA AREA PRINTER_BASE CONTAINS THE BASE ADDRESS OF THE PRINTER       :
; CARD(S) AVAILABLE (LOCATED AT BEGINNING OF DATA SEGMENT,              :
; 408H ABSOLUTE, 3 WORDS)                                               :
;                                                                       :
; DATA AREA PRINT_TIM_OUT (BYTE) MAY BE CHANGED TO CAUSE DIFFERENT      :
; TIME-OUT WAITS. DEFAULT=20                                            :
;                                                                       :
; REGISTERS     AH IS MODIFIED                                          :
;               ALL OTHER UNCHANGED                                     :
;------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA
        ORG     0EFD2H
PRINTER_IO      PROC    FAR
        STI                             ; INTERRUPTS BACK ON
        PUSH    DS                      ; SAVE SEGMENT
        PUSH    DX
        PUSH    SI
        PUSH    CX
        PUSH    BX
        CALL    DDS
        MOV     SI,DX                   ; GET PRINTER PARM
        MOV     BL,PRINT_TIM_OUT[SI]    ; LOAD TIME-OUT PARM
        SHL     SI,1                    ; WORD OFFSET INTO TABLE
        MOV     DX,PRINTER_BASE[SI]     ; GET BASE ADDRESS FOR PRINTER CARD
        OR      DX,DX                   ; TEST DX FOR ZERO,
                                        ;  INDICATING NO PRINTER
        JZ      B1                      ; RETURN
        OR      AH,AH                   ; TEST FOR (AH)=0
        JZ      B2                      ; PRINT_AL
        DEC     AH                      ; TEST FOR (AH)=1
        JZ      B8                      ; INIT_PRT
        DEC     AH                      ; TEST FOR (AH)=2
        JZ      B5                      ; PINTER STATUS
B1:                                     ; RETURN
        POP     BX
        POP     CX
        POP     SI                      ; RECOVER REGISTERS
        POP     DX                      ; RECOVER REGISTERS
        POP     DS
        IRET

;-----  PRINT THE CHARACTER IN (AL)

B2:
        PUSH    AX                      ; SAVE VALUE TO PRINT
        OUT     DX,AL                   ; OUTPUT CHAR TO PORT
        INC     DX                      ; POINT TO STATUS PORT
B3:
        SUB     CX,CX                   ; WAIT_BUSY
B3_1:
        IN      AL,DX                   ; GET STATUS
        MOV     AH,AL                   ; STATUS TO AH ALSO
        TEST AL,80H                     ; IS THE PRINTER CURRENTLY BUSY
        JNZ     B4                      ; OUT_STROBE
        LOOP    B3_1                    ; TRY AGAIN
        DEC     BL                      ; DROP LOOP COUNT
        JNZ     B3                      ; GO TILL TIMEOUT ENDS
        OR      AH,1                    ; SET ERROR FLAG
        AND     AH,0F9H                 ; TURN OFF THE OTHER BITS
        JMP     SHORT B7                ; RETURN WITH ERROR FLAG SET
B4:                                     ; OUT_STROBE
        MOV     AL,0DH                  ; SET THE STROBE HIGH
        INC     DX                      ; STROBE IS BIT 0 OF PORT C OF 8255
        OUT     DX,AL
        MOV     AL,0CH                  ; SET THE STROBE LOW
        OUT     DX,AL
        POP     AX                      ; RECOVER THE OUTPUT CHAR

;-----  PRINTER STATUS

B5:
        PUSH    AX                      ; SAVE AL REG
B6:
        MOV     DX,PRINTER_BASE[SI]
        INC     DX
        IN      AL,DX                   ; GET PRINTER STATUS
        MOV     AH,AL
        AND     AH,0F8H                 ; TURN 0FF UNUSED BITS
B7:                                     ; STATUS_SET
        POP     DX                      ; RECOVER AL REG
        MOV     AL,DL                   ; GET CHARACTER INTO AL
        XOR     AH,48H                  ; FLIP A COUPLE OF BITS
        JMP     B1                      ; RETURN FROM ROUTINE

;------INITIALIZE THE PRINTER PORT

B8:
        PUSH    AX                      ; SAVE AL
        INC     DX                      ; POINT TO OUTPUT PORT
        INC     DX
        MOV     AL,8                    ; SET INIT LINE LOW
        OUT     DX,AL
        MOV     AX,1000
B9:                                     ; INIT_LOOP
        DEC     AX                      ; LOOP FOR RESET THE TAKE
        JNZ     B9                      ; INIT_LOOP
        MOV     AL,0CH                  ; NO INTERRUPTS, NON AUTO LF,
                                        ;  INIT HIGH
        OUT     DX,AL
        JMP     B6                      ; PRT_STATUS_1
PRINTER_IO      ENDP


