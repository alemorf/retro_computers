
;---INT 11------------------------------------------------------------------
; EQUIPMENT DETERMINATION
;       THIS ROUTINE ATTEMPTS TO DETERMINE WHAT OPTIONAL
;       DEVICES ARE ATTACHED TO THE SYSTEM.
; INPUT
;       NO REGISTERS
;       THE EQUIP_FLAG VARIABLE IS SET DURING THE POWER ON DIAGNOSTICS
;       USING THE FOLLOWING HARDWARE ASSUMPTIONS:
;       PORT 60 = LOW ORDER BYTE OF EQUPMENT
;       PORT 3FA = INTERRUPT IO REGISTER OF 8250
;               BITS 7-3 ARE ALWAYS 0
;       PORT 378 = OUTPUT PORT OF PRINTER -- 8255 PORT THAT
;               CAN BE READ AS WELL AS WRITTEN
; OUTPUT
;       (AX) IS SET,BIT SIGNIFICANT,TO INDICATE ATTACHED I/O
;       BIT 15,14 = NUMBER OF PRINTERS ATTACHED
;       BIT 13 NOT USED
;       BIT 12 = GAME I/O ATTACHED
;       BIT 11,10,9 = NUMBER OF RS232 CARDS ATTACHED
;       BIT 8 UNUSED
;       BIT 7,6 = NUMBER OF DISKETTE DRIVES
;                 00=1,01=2,10=3,11=4 ONLY IF BIT 0 = 1
;       BIT 5,4 = INITIAL VIDEO MODE
;                      00 - UNUSED
;                      01 - 40*25 BW USING COLOR CARD
;                      10 - 80*25 BW USING COLOR CARD
;                      11 - 80*25 BW USING BW CARD
;       BIT 3,2 = PLANAR RAM SIZE (00=16K,01=32K,10=48K,11=64K)
;       BIT 1 NOT USED
;       BIT 0 = IPL FROM DISKETTE -- THIS BIT INDICATES THAT THERE
;               ARE DISKETTE DRIVES ON THE SYSTEM
;
;       NO OTHER REGISTERS AFFECTED
;---------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA
        ORG     0F84DH
EQUIPMENT       PROC   FAR
        STI                   ;INTERRUPTS BACK ON
        PUSH    DS            ;SAVE SEGMENT REGISTER
        CALL    DDS
        MOV     AX,EQUIP_FLAG ;GET THE CURRENT SETTING
        POP     DS            ;RECOVER SEGMENT
        IRET                  ;RETURN TO CALLER
EQUIPMENT       ENDP

