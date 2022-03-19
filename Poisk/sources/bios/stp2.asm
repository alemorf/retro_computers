 
AN_STR  PROC    NEAR 
        PUSH    AX 
        PUSH    DS 
        MOV     AX,DATA 
        MOV     DS,AX 
        MOV     AL,T_CURSOR 
        INC     K_CICL 
        ADD     AL,K_CICL 
        MOV     AH,80 
        TEST    CRT_MODE,2 
        JNZ     AN0 
        MOV     AH,40 
AN0: 
        CMP     AL,AH 
        JNZ     AN180 
        MOV     K_CICL,0 
        MOV     T_CURSOR,0 
        ADD     DI,80*3 
AN180: 
        POP     DS 
        POP     AX 
        RET 
AN_STR  ENDP 
 
;AN_STR40  PROC    NEAR 
;        PUSH    AX 
;        MOV     AL,T_CURSOR 
;        INC     K_CICL 
;        ADD     AL,K_CICL 
;        CMP     AL,40 
;        JNZ     AN140 
;        MOV     K_CICL,0 
;        MOV     T_CURSOR,0 
;        ADD     DI,80*4 
; 
;AN140: 
;        POP     AX 
;        RET 
;AN_STR40  ENDP 
 
 
 
        ORG    0F065H 
 
