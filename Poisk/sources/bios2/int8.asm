
;---------------------------------------------------------------------------
; ùíé èêÖêõÇÄçàÖ ìèêÄÇãüÖí èêÖêõÇÄçàüåà íÄâåÖêÄ äÄçÄãÄ 0
; INPUT FREQUENCY IS 1.19318 MHZ
; AND THE DIVISOR IS 65536,RESULTING IN APPROX. 18.2 INTERRUPTS
; EVERY SECOND.
;
; THE INTERRUPT HANDLER MAINTAINS A COUNT OF INTERRUPTS SINCE POWER
; ON TIME, WHICH MAY BE USED TO ESTABLISH TIME OF DAY.
; THE INTERRUPT HANDLER ALSO DECREMENTS THE MOTOR CONTROL COUNT
; OF THE DISKETTE, AND WHEN IT EXPIRES, WILL TURN OFF THE DISKETTE
; MOTOR, AND RESET THE MOTOR RUNNING FLAGS.
; THE INTERRUPT HANDLER WILL ALSO INVOKE A USER ROUTINE THROUGH INTERRUPT
; 1CH AT EVERY TIME TICK. THE USER MUST CODE A ROUTINE AND PLACE THE
; CORRECT ADDRESS IN THE VECTOR TABLE.
;--------------------------------------------------------------------------
        ORG     0FEA5H
TIMER_INT       PROC  FAR
        STI                          ;INTERRUPTS BACK ON
        PUSH    DS
        PUSH    AX
        PUSH    DX                   ;SAVE MACHINE STATE
        CALL    DDS
        INC     TIMER_LOW            ;INCREMENT TIME
        JNZ     T4                   ;TEST_DAY
        INC     TIMER_HIGH           ;INCREMENT HIGH WORD OF TIME
T4:                                  ;TEST_DAY
        CMP     TIMER_HIGH,018H      ;TEST FOR COUNT EQUALING 24 HOURS
        JNZ     T5                   ;DISKETTE_CTL
        CMP     TIMER_LOW,0B0H
        JNZ     T5                   ;DISKETTE_CTL

;------TIMER HAS GONE 24 HOURS
        SUB     AX,AX
        MOV     TIMER_HIGH,AX
        MOV     TIMER_LOW,AX
        MOV     TIMER_OFL,1

;------TEST FOR DISKETTE TIME OUT

T5:                                  ;DISKETTE_CTL
        DEC     MOTOR_COUNT
        JNZ     T6                   ;RETURN IF COUNT NOT OUT
        AND     MOTOR_STATUS,0F0H    ;TURN OFF MOTOR RUNNING BITS
        MOV     AL,0CH
        MOV     DX,03F2H             ;FDC CTL PORT
        OUT     DX,AL                ;TURN OFF THE MOTOR
T6:                                  ;TIMER_RET:
        NOP
        NOP
        INT     1CH                  ;TRANSFER CONTROL TO A USER ROUTINE
        MOV     AL,EOI
        OUT     020H,AL              ;END OF INTERRUPT TO 8259
        POP     DX
        POP     AX
        POP     DS                   ;RESET MACHINE STATE
        IRET                         ;RETURN FROM INTERRUPT
TIMER_INT       ENDP

