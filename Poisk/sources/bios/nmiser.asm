 
;------------------------------------------------------------------------ 
;                                                                       ; 
;     *******          Программа обслуживания NMI            *******    ; 
;                                                                       ; 
;------------------------------------------------------------------------ 
NMI_SERVICE: 
        CLD 
        PUSH    ES 
        PUSH    DS 
        PUSH    DX 
        PUSH    CX 
        PUSH    BX 
        PUSH    SI 
        PUSH    DI 
        PUSH    AX 
        MOV     AX,DSEGMENT 
        MOV     DS,AX 
        MOV     AX,START_BUFFER   ;Адрес начала буфера 
        MOV     ES,AX 
        IN      AX,TRAP_A 
        MOV     BX,AX 
        TEST    AH,40h 
        JNZ     IO_ROUTINES 
MWTC_ROUTINE:                     ;Подпрограмма обслуживания ВИДЕО 
                                  ; (запись текста) 
        CLI                       ;Запрет прерываний 
        MOV     DI,BX 
        AND     DI,3FFEh          ;Выбор части адреса 
        MOV     DX,ES:[DI]        ;Чтение символа/атрибута 
        SAR     DI,1 
        MOV     AX,DI 
        MOV     CL,AH 
        SAR     CL,1 
        SAR     CL,1 
        TEST    CRT_MODE,2        ;80x25 ? 
        JZ      MW4               ;Нет, 40x25 
        SAR     CL,1              ;CL = PageNo 
        MOV     CH,80             ;CH = 80 
        AND     AH,7 
MW2: 
        DIV     CH 
        XCHG    AH,AL 
        PUSH    AX 
        CBW 
        SUB     DI,AX 
        SAL     DI,1 
        SAL     DI,1 
        ADD     DI,AX 
        POP     AX 
        CMP     CL,ACTIVE_PAGE    ;Активная страница? 
        JNE     AX_NMI 
        XOR     CH,CH 
        MOV     SI,CX 
        SAL     SI,1 
        CMP     AX,[SI+OFFSET CURSOR_POSN] 
        MOV     BX,EXTRA_BUFFER 
        MOV     ES,BX 
        PUSHF 
        JNE     MW3 
        CALL    REMOVE_CURSOR 
MW3: 
        PUSH    AX 
        MOV     AX,DX 
        MOV     BL,AH 
        XOR     AH,AH 
        MOV     CL,1 
        TEST    CRT_MODE,2        ;\80x25 ? 
        JNZ     MW31              ;\ДА 
        and     di,0fffh          ;\ 
        JMP     MW32              ;\ 
MW31:   AND     DI,1FFFH          ;\ 
MW32:   CALL    S1B 
        POP     AX 
        POPF 
AX_NMI: 
        POP     AX 
NMI_RET: 
        JMP     VIDEO_RETURN      ;Переход на возврат из ВИДЕО 
MW4: 
        MOV     CH,40 
        AND     AH,3 
        JMP     MW2 
 
IO_ROUTINES:                      ;Дешифрация остальных NMI 
                                  ;  (обращение к портам ВИДЕО) 
        TEST    AH,80h 
        JNZ     IOWC_ROUTINE 
 
IORC_ROUTINE: 
        POP     AX 
        MOV     AL,0FFh 
        JMP     VIDEO_RETURN 
 
IOWC_ROUTINE: 
        IN      AL,TRAP_D 
        MOV     SI,AX 
        CMP     BL,0D4h ;         ;Порт 3D4 ? 
        JE      PORT_3D4 
        CMP     BL,0D5h           ;Порт 3D5 ? 
        JE      PORT_3D5 
        CMP     BL,0D8h           ;Порт 3D8 ? 
        JE      PORT_3D8 
        CMP     BL,0D9h           ;Порт 3D9 ? 
        JNE     AX_NMI 
PORT_3D9: 
        XCHG    AL,AH             ;Сохранить первоначальные данные 
        IN      AL,SCR_MODE       ;ввести байт текущего режима 
        AND     AX,37C8H          ;Маска D7,D6 и D3 
                                  ;Выбор D4,D5 и D2..D0 
        OR      AL,AH             ;Составить новый байт 
        OUT     SCR_MODE,AL       ;Задать новый режим экрана 
        JMP     AX_NMI 
PORT_3D4:                         ;Запись в порт 3D4 (число 6845) 
        MOV     REG_6845,AL       ;Сохранить это в памяти 
        JMP     AX_NMI            ;Все сделано 
PORT_3D5: 
        MOV     CL,REG_6845       ;Восстановить число 
        CMP     CL,11 
        JNZ     REG10 
        MOV     BYTE PTR CURSOR_MODE,AL 
REG10:  CMP     CL,10 
        JNZ     REG14 
        MOV     BYTE PTR CURSOR_MODE+1,AL 
REG14: 
        CMP     CL,15             ;Регистр=15? 
        JE      REG_15 
        CMP     CL,14             ;Регистр=14? 
        JNE     AX_NMI            ;Если регистр не 14 и не 15, ничего не делать 
        MOV     CURSOR_POS_H,AL   ;Сохранить верхнюю позицию курсора 
        JMP     AX_NMI            ;Все сделано 
REG_15:                           ;Регистр 15 
        MOV     CURSOR_POS_L,AL   ;Сохранить нижнюю позицию курсора 
        MOV     AH,CURSOR_POS_H 
        TEST    CRT_MODE,2 
        JZ      R_15_2 
        MOV     CL,80 
R_15_1: 
        and     ax,07ffh 
 
        DIV     CL 
        XCHG    AL,AH 
        MOV     DX,AX 
        POP     AX 
        MOV     BH,ACTIVE_PAGE 
        JMP     SET_CPOS 
R_15_2: 
        MOV     CL,40 
        JMP     R_15_1 
PORT_3D8:                         ;Порт 3D8 (порт режима) 
        AND     AL,1Fh            ;*** 
        JE      P_D8_RET 
        TEST    AL,8 
        JNZ     P_D8_RET 
        TEST    AL,12h               ;Графика? 
        JNZ     P_D8_3               ;Да 
        XOR     AH,AH 
        TEST    AL,1                 ; 80X25 ? 
        JZ      P_D8_1               ;Нет 
        MOV     AH,2 
P_D8_1: 
        TEST    AL,4                 ;Цветной? 
        JNZ     P_D8_2               ;Нет 
        INC     AH 
P_D8_2: 
        XCHG    AL,AH 
        XOR     AH,AH 
        CMP     AL,CRT_MODE 
        JE      P_D8_RET          ;Вызов обработки функций ВИДЕО 
        INT     10h 
P_D8_RET: 
        JMP     AX_NMI 
P_D8_3: 
        MOV     AH,6 
        TEST    AL,10h                ; 640X200 ? 
        JNZ     P_D8_2                ; Да 
        DEC     AH 
        TEST    AL,4                  ;Цветной? 
        JNZ     P_D8_2                ;Нет 
        DEC     AH 
        JMP     P_D8_2 
 
