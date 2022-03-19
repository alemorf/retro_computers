;----INT 12--------------------------------------------------------------
;       AS REPRESENTED BY THE SWITCHES ON THE PLANAR. NOTE THAT THE
;       SYSTEM MAY NOT BE ABLE TO USE I/O MEMORY UNLESS THERE
;       IS A FULL COMPLEMENT OF 64K BYTES ON THE PLANAR.
; INPUT
;       NO REGISTERS
;       THE MEMORY_SIZE VARIABLE IS SET DURING POWER ON DIAGNOSTICS
;       ACCORDING TO THE FOLLOWING HARDWARE ASSUMPTIONS:
;       PORT 60 BITS 3,2=00-16K BASE RAM
;                       01-32K BASE RAM
;                       10-48K BASE RAM
;                       11-64K BASE RAM
;       PORT 62 BITS 3-0 INDICATE AMOUNT OF I/O RAM IN 32K INCREMENTS
;               E.G.,0000-NO RAM IN I/O CHANNEL
;                    0010-64K RAM IN I/O CHANNEL,ETC.
; OUTPUT
;       (AX)=NUMBER OF CONTIGUOUS 1K BLOCKS OF MEMORY
;--------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA
        ORG     0F841H
MEMORY_SIZE_DET   PROC  FAR
        STI                          ;INTERRUPTS BACK ON
        PUSH    DS                   ;SAVE SEGMENT
        CALL    DDS
        MOV     AX,MEMORY_SIZE       ;GET VALUE
        POP     DS                   ;RECOVER SEGMENT
        IRET                         ;RETURN TO CALLER
MEMORY_SIZE_DET  ENDP

