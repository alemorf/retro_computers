
;---INT 1A-----------------------------------------------------------------
; TIME_OF_DAY
;  THIS ROUTINE ALLOWS THE CLOCK TO BE SET/READ
;
;INPUT
;  (AH)=0       READ THE CURRENT CLOCK SETTING
;               RETURNS CX=HIGH PORTION OF COUNT
;                      DX=LOW PORTION OF COUNT
;                      AL=0 IF TIMER HAS NOT PASSED 24 HOURS SINCE LAST READ
;                       <>0 IF ON ANOTHER DAY
;  (AH)=1       SET THE CURRENT CLOCK
;       CX=HIGH PORTION OF COUNT
;       DX=LOW PORTION OF COUNT
; NOTE:COUNTS OCCUR AT THE RATE OF 1193180/65536 COUNTS/SEC
;       (OR ABOUT 18.2 PER SECOND -- SEE EQUATES BELOW)
;----------------------------------------------------------------------------
        ORG     0FE6EH
TIME_OF_DAY:     jmp     TIME_2

