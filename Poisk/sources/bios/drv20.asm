;------------   INT 13      --------------- 
;    **** ВВОД-ВЫВОД НА ДИСКЕТУ **** 
 
CONTROL_STAT   EQU    0C0H   ;ПОРТ КОНТРОЛЯ И СОСТОЯНИЯ 
;-------------------------------------------------- 
; НАЗНАЧЕНИЕ РАЗРЯДОВ РЕГИСТРА (ПОРТА) CONTROL_STAT 
;-------------------------------------------------- 
;       D0 - ЗАНЯТО 
;       D1 - ИНДЕКС ИМПУЛЬСА, СООТВ. DRQ 
;       D2 - МГ НА 0 ДОРОЖКЕ ИЛИ ТАЙМАУТ ПРИ ЗП И ЧТ 
;       D3 - ОШИБКА CRC (КК) 
;       D4 - НЕТ ЗАПИСИ, НЕ НАЙДЕН МАССИВ 
;       D5 - МГ ЗАГРУЖЕНА ИЛИ СО СТИРАНИЕМ АМ ПРИ ЧТ 
;            ИЛИ ДОРОЖКА НЕ НАЙДЕНА ПРИ ЗП 
;       D6 - ЗАЩИТА ЗАПИСИ 
;       D7 - НЕ ГОТОВ 
;--------------------------------------------------- 
 
TRACK          EQU    0C1H   ;ПОРТ НОМЕРА ДОРОЖКИ 
SECTOR         EQU    0C2H   ;ПОРТ НОМЕРА СЕКТОРА 
DATA_F         EQU    0C3H   ;ПОРТ ДАННЫХ 
;    ========   ДЛЯ ЧТЕНИЯ :  =========== 
; 
MOTOR_EN       EQU    0C6H   ;СОСТОЯНИЕ ДВИГАТЕЛЯ <D0> 
RD_INTRQ       EQU    0C4H   ;ЧТЕНИЕ INTRQ ИЛИ DRQ, D0-INTRQ 
; 
;   =========   ДЛЯ ЗАПИСИ :  =========== 
RG_C           EQU    0C4H   ;DDEN,HDSEL,FDRES, 
                             ;EN. MOTORS,DRIVES(SEL1,SEL2) 
;------------------------------------- 
; НАЗНАЧЕНИЕ РАЗРЯДОВ РЕГИСТРА (ПОРТА) RG_C 
;------------------------------------- 
;       D0 - DRIVE SELECT 0      -ВЫБОР УСТРОЙСТВА 0 
;       D1 - DRIVE SELECT 1      -ВЫБОР УСТРОЙСТВА 1 
;       D2 - MOTOR ON 0          -ВКЛ. МОТОР 0 
;       D3 - MOTOR ON 1          -ВКЛ. МОТОР 1 
;       D4 - SIDE (HEAD) SELECT  -ВЫБОР СТОРОНЫ (ГОЛОВКИ) 
;       D5 - DOUBLE DENSITY      -РЕЖИМ ДВОЙНОЙ ПЛОТНОСТИ 
;       D6 - FDC RESET           -СБРОС ДВОЙНОЙ ПЛОТНОСТИ 
;       D7 - NO USE              -НЕ ИСПОЛЬЗУЕТСЯ 
;------------------------------------- 
MOTOR_ON       EQU    0C6H   ;ВКЛ. МОТОРА 
 
; ========= Н А   В Х О Д Е  ============= 
;       АL      -КОЛИЧЕСТВО СЕКТОРОВ ДЛЯ ЧТ-ЗП 
;       AH      -КОД ОПЕРАЦИИ 
;            0    -СБРОС 
;            1    -ЧТЕНИЕ СОСТОЯНИЯ 
;            2    -ЧТЕНИЕ ДАННЫХ 
;            3    -ЗАПИСЬ ДАННЫХ 
;            4    -ОПРОС, ПРОВЕРКА 
;            5    -ФОРМАТИРОВАНИЕ 
;- - - - - - - - - - - - - - - - - - - - 
;       DH      -НОМЕР ГОЛОВКИ 
;       DL      -НОМЕР УСТРОЙСТВА (0-3) 
;- - - - - - - - - - - - - - - - - - - - 
;       CH      -НОМЕР ЦИЛИНДРА (ДОРОЖКИ) 
;       СL      -НОМЕР СЕКТОРА (1-17) 
;- - - - - - - - - - - - - - - - - - - - 
;       ES:BX   -АДРЕС БУФЕРА 
; 
; ============== КОДЫ ЗАВЕРШЕНИЯ ================== 
BAD_CMD         EQU    1        ;НЕВЕРНАЯ КОМАНДА (АН>5,DL>3) 
BAD_ADDR_MARK   EQU    2        ; 
WRITE_PROTECT   EQU    3        ;ЗАЩИТА ЗАПИСИ 
RECORD_NOT_FND  EQU    4        ; 
BAD_DMA         EQU    8        ; 
DMA_BOUNDARY    EQU    9        ; 
BAD_CRC         EQU    10H      ; 
BAD_FDC         EQU    20H      ;НЕТ СБРОСА 
BAD_SEEK        EQU    40H      ; 
TIME_OUT        EQU    80H      ;ТАЙМ-АУТ 
;=================================================== 
; 
SEEK_OK         EQU    0 
READ_WRITE_OK   EQU    0 
SEEK_COMMAND    EQU   1cH       ;V = 1,h = 1 
SEEK_COMNOV     EQU   10H       ;V = 0 
READ_COMMAND    EQU   80H 
WRITE_COMMAND   EQU   0A0H 
WR_TRACK        EQU   0F0H 
STEP_COMMAND    EQU   48H 
WORD_DDEN       EQU   0 
; 
data    segment at 40h 
        ORG     3EH 
;---------------------------------------------------------------------------- 
; DISKETTE DATA AREAS     - ОБЛАСТЬ ДАННЫХ 
;---------------------------------------------------------------------------- 
SEEK_STATUS            DB     ?             ;DRIVE RECALIBRATION STATUS 
;                                           BIT 3-0= DRIVE 3-0 NEEDS RECAL 
;                                           BEFORE NEXT SEEK IF BIT IS=0 
INT_FLAG               EQU    080H          ;ФЛАГ НАЛИЧИЯ ПРЕРЫВАНИЯ 
MOTOR_STATUS           DB     ?             ;СОСТОЯНИЕ ДВИГАТЕЛЯ 
;                             BIT 3-0 = DRIVE 3-0 IS CURRENTLY RUNNING 
;                             BIT 7 = CURRENT OPERATION IS A WRITE, 
;                             REQUIRES DELAY 
;                                           DISKETES 
MOTOR_WAIT             EQU    37            ;TWO SECONDS OF COUNTS FOR 
;                                           MOTOR TURN OFF 
MOTOR_COUNT            DB      ? 
; 
DISKETTE_STATUS        DB     ?             ;БАЙТ КОДА ВОЗВРАТА 
; 
NEC_STATUS             LABEL BYTE              ;7 BYTE 
TRACK_PTR              DB     2 DUP(?) 



STEP_MULT              DB     ?             ;ПРИЗНАК 1 -УСТР 0,1 
                                            ;        2 -УСТР 2,3 
DRIVER_N               DB     0             ;НОМЕР АКТИВНОГО УСТР-ВА 
                       DB     3 DUP (?)       ;РЕЗЕРВ 



 
;----------------------------------------------------------------------- 
data ends 
 
; 
code    segment 
        assume cs:code,ds:data 
 
; КАРТРИДЖНАЯ СИГНАТУРА 
 
        DW      0AA55H 
        DB      03H 
 
DISK_INIT    PROC   FAR 
 
; П/П ИНИЦИАЛИЗАЦИИ ДИСКОВОГО АДАПТЕРА 
 
        MOV     AX,0H 
        MOV     DS,AX 
        MOV     BX,410H 
        MOV     AX,DS:[BX] 
        OR      AX,01H            ;Драйвер ГМД присутствует 
        MOV     DS:[BX],AX 
        MOV     BX,4CH            ;Установить вектор INT13H 
        LEA     AX,DISKETTE_IO 
        MOV     DS:[BX],AX 
        PUSH    CS 
        POP     AX 
        MOV     DS:[BX+2],AX 
        DB      0CBH           ;(RETF) 
DISK_INIT    ENDP 
 
DISKETTE_IO  PROC  FAR 
        STI                     ;РАЗРЕШЕНИЕ ПРЕРЫВАНИЙ 
        PUSH    BX              ;СОХРАНЕНИЕ РЕГИСТРОВ 
        PUSH    CX 
        PUSH    DS 
        PUSH    SI 
        PUSH    DI 
        PUSH    BP 
        PUSH    DX 
        MOV     BP,SP           ;УКАЗАТЕЛЬ СТЕКА 
        MOV     SI,DATA         ;DATA-СЕГМЕНТ 
        MOV     DS,SI           ;ИНИЦИАЦИЯ DATA-СЕГМЕНТА 
        PUSH    CX              ;СОХР. СХ 
        MOV     CH,1 
        TEST    DL,2            ;УСТРОЙСТВО 2,3? 
        JNZ     STM             ;ДА 
        MOV     STEP_MULT,1     ;УСТР0,УСТР1 
        JMP     STM1 
STM:    MOV     STEP_MULT,2     ;УСТР2(*),УСТР3(*) 
        AND     DL,1            ;СООТВ. В 0,1 
STM1:   MOV     CL,DL           ;НОМЕР УСТРОЙСТВА 
        ROL     CH,CL           ;СДВИГ 1 ПО НОМЕРУ УСТРОЙСТВА 
        MOV     MOTOR_STATUS,CH ;БАЙТ ИНИЦИАЛИЗАЦИИ (НОМЕР УСТРОЙСТВА) 
        POP     CX              ;ВОССТАНОВЛЕНИЕ СХ 
        CALL    J1              ;НА ОПРЕДЕЛЕНИЕ КОДА КОМАНДЫ 
        MOV     AH,DISKETTE_STATUS ;КОД ЗАВЕРШЕНИЯ 
        CMP     AH,1            ;ЕСЛИ АН=0,TO CF=1, ИНАЧЕ CF=0 
        CMC                     ;ИНВЕРСИЯ БИТА CF 
        POP     DX              ;ВОССТАНОВЛЕНИЕ РЕГИСТРОВ 
        POP     BP 
        POP     DI 
        POP     SI 
        POP     DS 
        POP     CX 
        POP     BX 
        RET     2               ;ВОЗВРАТ МЕЖСЕГМЕНТНЫЙ С СОХР. ФЛАГОВ 
DISKETTE_IO ENDP 
 
;========== ОПРЕДЕЛЕНИЕ КОДА КОМАНДЫ ПО AH =========== 
J1:     AND     MOTOR_STATUS,7FH  ;ИНДИКАЦИЯ ДЛЯ ЧТЕНИЯ (В7=0) 
        OR      AH,AH           ;AH = 0? 
        JZ      DISK_RESET      ;ДА, КОМАНДА СБРОСА 
        CMP     AH,6 
        JNL     J3              ;НЕВЕРНАЯ КОМАНДА (AH > 5) 
        CMP     AH,1            ;ЧТЕНИЕ СОСТОЯНИЯ? 
        JZ      DISK_STATUS     ;ДА, (AH = 1) 
        MOV     DISKETTE_STATUS,0   ;КОД ЗАВЕРШЕНИЯ НОРМАЛЬНЫЙ (0) 
        CMP     DL,2            ;УСТРОЙСТВО 0,1? 
        JAE     J3              ;НЕТ (DL > 3) 
        cmp     ah,5            ;АН=5? 
        jz      form            ;ДА, ФОРМАТИРОВАНИЕ 
        CMP     AH,3            ;КОД ОП-ЦИИ НЕ БОЛЬШЕ 3? 
        JBE     RW_OPN          ;ДА, ЧТ/ЗП ОПЕРАЦИЯ (AH = 2,AH = 3) 
        JMP     VERIFY_OPN      ;ОП-ЦИЯ ПРОВЕРКИ (AH = 4) 
J3:     MOV     DISKETTE_STATUS,BAD_CMD   ;КОД ОШИБКИ 
        RET                     ;ВОЗВРАТ 
form:   jmp     form1           ;НА П/П ФОРМАТИРОВАНИЯ 
 
;=============================================================== 
;       П/П ЧТЕНИЯ СОСТОЯНИЯ (АН=1) 
;=============================================================== 
; 
; 
DISK_STATUS: 
        MOV     AL,DISKETTE_STATUS 
        RET 
; 
; 
;=============================================================== 
;       П/П СБРОСА В ИСХОДНОЕ СОСТОЯНИЕ (АН=0) 
;=============================================================== 
DISK_RESET: 
        PUSH    AX              ;СОХРАНЕНИЕ РЕГИСТРОВ 
        PUSH    SI 
        PUSH    CX 
        PUSH    DX 
        CLI                     ;ЗАПРЕТ ПРЕРЫВАНИЙ 
        OUT     MOTOR_ON,AL     ;К-ВО СЕКТОРОВ-->C6 ????????????? 
        MOV     SI,DX           ;НОМЕР УСТРОЙСТВА 
        AND     SI,1            ;ВЫДЕЛЕНИЕ НОМЕРА УСТР. 
        MOV     TRACK_PTR [SI],0   ;0 В БАЙТ ПО НОМЕРУ УСТР. 
        MOV     CL,DL           ;НОМЕР УСТРОЙСТВА 
        MOV     AL,5            ;УСТР. 0, МОТОР 0 
        SAL     AL,CL           ;СДВИГ НА КОЛИЧЕСТВО ПО НОМЕРУ УСТР. 
        MOV     AH,DH           ;НОМЕР ГОЛОВКИ (СТОРОНЫ) 
        AND     AH,1            ;ВЫДЕЛЕНИЕ МЛ. БИТА (0 ИЛИ 1) 
        MOV     CL,4            ; 
        ROL     AH,CL           ;НОМЕР ГОЛОВКИ В D4 
        OR      AL,AH           ;(УСТР+МОТОР)+ГОЛОВКА 
        OUT     RG_C,AL         ;СБРОС .... ДВОЙНОЙ ПЛОТНОСТИ 
        OR      AL,40H          ;+ СБРОС ДВОЙНОЙ ПЛОТНОСТИ 
        MOV     SEEK_STATUS,0   ;СТАТУС ПОПЫТКИ 0 
        MOV     DISKETTE_STATUS,0  ;СТАТУС СОСТОЯНИЯ 0 
        OUT     RG_C,AL;        ;СО СБРОСОМ ДВОЙНОЙ ПЛОТНОСТИ 
        STI                     ;РАЗРЕШИТЬ ПРЕРЫВАНИЯ 
        MOV     AH,2            ;2 РАЗА 
RETR:   XOR     CX,CX           ;СХ=0 
RETR1:  PUSH    AX              ;СОХР. АХ 
        IN      AL,CONTROL_STAT   ;ЧТЕНИЕ СОСТОЯНИЯ 
        AND     AL,5            ;ВЫДЕЛЕНИЕ БИТОВ 0 И 2 
        CMP     AL,4            ;НОРМАЛЬНО? (МГ НА ДОР 0) 
        POP     AX 
        JZ      RESET_END       ;ДА, КОНЕЦ СБРОСА 
        LOOP    RETR1           ;НЕТ, ЕСТЬ ЕЩЕ "ЗАНЯТО" 
        DEC     AH              ; 
        JNZ     RETR            ;ПОПЫТАТЬСЯ 2 РАЗА 
        OR      DISKETTE_STATUS,BAD_FDC  ;НЕТ СБРОСА ДВ. ПЛОТНОСТИ 
                                         ;ВСЕ ВРЕМЯ "ЗАНЯТО" 
        MOV     TRACK_PTR [SI], 0FFH  ;FF В БАЙТ ПО НОМЕРУ УСТР. 
RESET_END: 
        POP     DX              ;ВОССТАНОВЛЕНИЕ РЕГИСТРОВ 
        POP     CX 
        POP     SI 
        POP     AX 
        RET 
 
;=============================================================== 
;       П/П ЧТЕНИЯ-ЗАПИСИ 
;=============================================================== 
; 
RW_OPN: OR      AH,AH           ;КОД АН=2 (ЧТЕНИЕ)? 
        JNP     J9              ;ДА       ???????????????? 
        OR      MOTOR_STATUS,80H   ;ПРИЗНАК ЗАПИСИ 
J9:     CALL    SELECT_DRIVE    ;ВЫБОР УСТР.+МОТОР+ГОЛОВКА 
        CALL    TEST_WAIT       ;ЗАДЕРЖКА 
        TEST    MOTOR_STATUS,80H   ;ЗАПИСЬ? 
        JNZ     WRITE_DISK      ;ДА 
READ_DISK:                      ;ЧТЕНИЕ С ДИСКА 
        MOV     DL,0            ;СЧЕТЧИК ЧИСЛА СЕКТОРОВ 
        PUSH    BX 
        MOV     BL,SEEK_COMMAND ;ПОИСК С ЗАГРУЗКОЙ МГ И ПРОВ. 
        CALL    SEEK            ;ПОИСК 
        POP     BX 
        JC      ERR_OUT         ;БЫЛА ОШИБКА (CF=1) 
READ_LENG: 
        CALL    READ            ;НА П/П ЧТЕНИЯ 
        JC      ERR_OUT         ;БЫЛА ОШИБКА 
        INC     DL              ;+1 К СЧЕТЧИКУ СЕКТРОВ 
        CALL    GET_SECTOR      ;УСТАНОВКА НА СЛЕД. СЕКТОР 
        CMP     AL,DL           ;ВСЕ СЕКТОРА? 
        JNZ     READ_LENG       ;ЕЩЕ НЕТ 
        RET                     ;ЧТЕНИЕ ЗАВЕРШЕНО 
ERR_OUT: 
        MOV     AL,DL           ;НОМЕР СЕКТОРА С ОШИБКОЙ 
        RET 
WRITE_DISK: 
        MOV     DL,0            ;СЧЕТЧИК ЧИСЛА СЕКТОРОВ 
        PUSH    BX 
        MOV     BL,SEEK_COMMAND ;ПОИСК С ЗАГРУЗКОЙ МГ И ПРОВ. 
        CALL    SEEK            ;ПОИСК 
        POP     BX 
        JC      ERR_OUT         ;БЫЛА ОШИБКА 
WRITE_LENG: 
        CALL    WRITE           ;ЗАПИСЬ 
        JC      ERR_OUT         ;БЫЛА ОШИБКА 
        INC     DL              ;+1 К СЧЕТЧИКУ СЕКТОРОВ 
        CALL    GET_SECTOR      ;УСТАНОВКА НА СЛЕД. СЕКТОР 
        CMP     AL,DL           ;ВСЕ СЕКТОРА? 
        JNZ     WRITE_LENG      ;НЕ ЩЕ 
        RET                     ;ЗАПИСЬ ЗАВЕРШЕНА 
 
 
;========================================================================== 
;       П/П ФОРМАТИРОВАНИЯ ДИСКЕТЫ ДОРОЖКИ 
;========================================================================== 
FORM1:  CALL    SELECT_DRIVE    ;УСТР+МОТОР+ГОЛОВКА 
        CALL    TEST_WAIT       ;ВКЛ МОТОРА 
        PUSH    BX 
        MOV     BL,SEEK_COMNOV  ;КОД 10 -ПОИСК 
        CALL    SEEK            ;НА П/П ПОИСКА 
        POP     BX 
        JC      ERR_FORM        ;ЕСЛИ БЫЛА ОШБ, CF=1 
        CALL    WRITE_TRACK 
ERR_FORM: 
        MOV     AL,9 
        RET 
 
;SUBROUTINE  WRITE TRACK FOR FORMAT-П/П ФОРМАТИРОВАНИЯ 
;SI-TRACK,SIDE                     -SI ДОРОЖКА,СТОРОНА 
;DI-END NUMB SEC ,SIZE SEC         -DI КОН.НОМ.СЕКТОРА,РАЗМЕР 
;AH-SECTOR                         -AH СЕКТОР 
;ES-SIZE SEC IN BYTE               -ES РАЗМЕР СЕКТОРА 
; 
WRITE_TRACK: 
        PUSH ES 
        MOV     AX,ES:[BX]      ;СЛОВО С БУФЕРА (ДОР., СТОР.) 
        MOV     SI,512          ;РАЗМЕР СЕКТОРА 
        MOV     ES,SI           ; 
WR_TRACK5: 
        MOV     SI,AX           ;ДОРОЖКА, СТОРОНА 
        MOV     DI,10*256+2     ;КОНЕЧНЫЙ  СЧЕТЧИК СЕКТОРОВ 
        MOV     AH,01           ;НАЧАЛЬНЫЙ СЧЕТЧИК СЕКТОРОВ 
        CALL    WRITE_TR        ;ЗАПИСЬ НА ДОРОЖКУ 
        POP     ES 
        RET 
 
       ;П/П ЗАПИСИ ФОРМАТА НА ДОРОЖКУ 
WRITE_TR: 
        MOV     DX,DATA_F       ;ПОРТ ДАННЫХ 
        MOV     AL,WR_TRACK     ;КОД "ЗАПИСЬ ДОРОЖКИ" 
        CLI                     ;ЗАПРЕТ ПРЕРЫВАНИЙ 
        OUT     CONTROL_STAT,AL ;КОМАНДА "ЗП ДОРОЖКИ" 
                        ;80 БАЙТ 4Е (ПРОБЕЛ) 
        MOV     CX,80 
WLD01:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,4EH 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD01 
                        ;12 БАЙТ 00 
        MOV     CX,12 
WLD02:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        SUB     AL,AL 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD02 
                        ;3 БАЙТА F6 (ЗП С2) 
        MOV     CX,3 
WLD03:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0F6H 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD03 
                        ;1 БАЙТ FC (ИМ) 
        IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0FCH 
        OUT     DX,AL          ;WRITE DATA 
                        ;50 БАЙТ 4Е (1-Й ПРОБЕЛ) 
        MOV     CX,50 
WLD05:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,4EH 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD05 
                        ;11 БАЙТ 00 
        MOV     CX,11 
WLD06:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        SUB     AL,AL 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD06 
                        ;+1 БАЙТ 00 
WR_SEC: 
        IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        SUB     AL,AL 
        OUT     DX,AL          ;WRITE DATA 
                        ;3 БАЙТА F5 (ЗП А1) 
        MOV     CX,3 
WLD08:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0F5H 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD08 
                        ;1 БАЙТ FE (АДРЕСНАЯ МЕТКА) 
WLD09:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0FEH 
        OUT     DX,AL          ;WRITE DATA 
                               ;adress label 
                        ;1 БАЙТ (НОМЕР ДОРОЖКИ) 
        MOV     BX,SI 
WLD0A:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,BL 
        OUT     DX,AL          ;WRITE DATA 
                               ;number track 
                        ;1 БАЙТ (НОМЕР СТОРОНЫ) 
WLD0B:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,BH 
        OUT     DX,AL          ;WRITE DATA 
                               ;number side 
                        ;1 БАЙТ (НОМЕР СЕКТОРА) 
WLD0C:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,AH 
        OUT     DX,AL          ;WRITE DATA 
                               ;number sector 
        INC     AH             ;+1 К НОМЕРУ СЕКТОРА 
                        ;1 БАЙТ (ДЛИНА СЕКТОРА) 
        MOV     BX,DI          ; <0А02> 
WLD0D:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,BL 
        OUT     DX,AL          ;WRITE DATA 
                                ;size sector 
                        ;1 БАЙТ F7 (2 БАЙТА КК) 
WLD0E:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0F7H 
        OUT     DX,AL          ;WRITE DATA 
                                 ;byte crc 
                        ;22 БАЙТА 4Е (2-Й ПРОБЕЛ) 
        MOV     CX,22 
WLD0F:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,4EH 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD0F 
                        ;12 БАЙТ 00 
        MOV     CX,12 
WLD10:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        SUB     AL,AL 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD10 
                        ;3 БАЙТА F5 (ЗП А1) 
        MOV     CX,3 
WLD11:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0F5H 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD11 
                        ;1 БАЙТ FB (АДР.МЕТКА ДАННЫХ) 
                        ;БЕЗ СТИРАНИЯ 
WLD12:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0FBH 
        OUT     DX,AL          ;WRITE DATA 
                        ;ПО РАЗМЕРУ СЕКТОРА <512> БАЙТ 4Е 
        MOV     CX,ES 
WLD13:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,4EH 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD13 
                        ;1 БАЙТ F7 (2 БАЙТА КК) 
WLD14:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,0F7H 
        OUT     DX,AL          ;WRITE DATA 
                        ;54 БАЙТА 4Е (3-Й ПРОБЕЛ) 
        MOV     CX,54 
WLD15:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,4EH 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD15 
                        ;11 БАЙТ 00 
        MOV     CX,11 
WLD16:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        SUB     AL,AL 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD16 
        CMP     AH,BH           ;ВСЕ СЕКТОРА ОТ 1-9 (АН=10) 
        JNZ     WR_SEC          ;НЕТ ЕЩЕ 
                        ;598 БАЙТ 4Е (4-Й ПРОБЕЛ) 
        MOV     CX,598 
        MOV     BL,04EH 
WLD17:  IN      AL,RD_INTRQ    ;WAIT FOR DRQ OR INTRQ 
        MOV     AL,BL 
        OUT     DX,AL          ;WRITE DATA 
        LOOP    WLD17 
        IN      AL,CONTROL_STAT ;ЧТЕНИЕ СОСТОЯНИЯ 
        AND     AL,47H          ; 
        JZ      WRDSK_END       ;НОРМАЛЬНО ЗАПИСАНО 
        TEST    AL,40H          ;ЗАЩИТА ЗАПИСИ? 
        MOV     AL,WRITE_PROTECT ;КОД ОШИБКИ "ЗАЩИТА" 
        JNZ     ERR_EX          ;ДА, ОШИБКА 
        MOV     AL,BAD_FDC      ;КОД ОБЩЕЙ ОШИБКИ 
ERR_EX:                         ; 
        OR      DISKETTE_STATUS,AL ;ДОБАВЛЕНИЕ КОДА ОШИБКИ 
        STC                     ;CF=1 -- ОШИБКА 
WRDSK_END: 
        RET 
 
;=============================================================== 
;       УСТАНОВКА НА СЛЕДУЮЩИЙ СЕКТОР 
;=============================================================== 
GET_SECTOR: 
        PUSH    AX 
        INC     CL              ;УВЕЛИЧЕНИЕ НОМЕРА СЕКТОРА 
        MOV     AL,CL 
        OUT     SECTOR,AL       ;ВЫВОД НОМЕРА СЕКТОРА 
        POP     AX 
        RET 
 
;=============================================================== 
;       П/П ПРОВЕРКИ ДОРОЖКИ 
;=============================================================== 
VERIFY_OPN: 
        CALL    SELECT_DRIVE    ;УСТР+МОТОР+ГОЛОВКА 
        CALL    TEST_WAIT       ;ВКЛ. МОТОРА 
        MOV     DL,0            ;СЧ. СЧИТАНЫХ СЕКТОРОВ 
        PUSH    BX 
        MOV     BL,SEEK_COMMAND ;ПОИСК С ЗАГРУЗКОЙ МГ И ПРОВЕРКОЙ 
        CALL    SEEK 
        POP     BX 
        JC      ERR_OUTL        ;БЫЛА ОШИБКА ПОИСКА 
VERIFY_LENG: 
        CALL    VERIFY          ;П/П ПРОВЕРКИ ЧТЕНИЕМ 
        JC      ERR_OUTL        ;БЫЛА ОШИБКА 
        INC     DL              ;+1 СЧИТАНЫЙ СЕКТОР 
        CALL    GET_SECTOR      ;УСТАНОВКА НА СЛЕДУЮЩИЙ СЕКТОР 
        CMP     AL,DL           ;ВСЕ СЕКТОРА ? 
        JNZ     VERIFY_LENG     ;НЕТ ЕЩЕ 
        RET                     ;ПРОВЕРКА ЗАВЕРШЕНА 
 
VERIFY: PUSH    AX 
        PUSH    DX 
        MOV     DX,DATA_F       ;ПОРТ ДАННЫХ 
        MOV     AL,READ_COMMAND ;КОД "ЧТЕНИЕ СЕКТОРА" 
        CLI                     ;ЗАПРЕТ ПРЕРЫВАНИЙ" 
        OUT     CONTROL_STAT,AL ;КОМАНДА 
        NOP 
VLOOP:  IN      AL,RD_INTRQ     ;ЧТЕНИЕ DRQ ИЛИ INTRQ 
        SHR     AL,1            ;МЛ. БИТ В СF 
        IN      AL,DX           ;ЧТЕНИЕ БАЙТА 
        JC      VLOOP           ;СЕКТОР ЕЩЕ НЕ ВЕСЬ 
        STI 
        CALL    ERR_TABL        ;ФОРМИРОВАНИЕ КОДА ЗАВЕРШЕНИЯ 
        POP     DX 
        POP     AX 
        RET                     ;ВОЗВРАТ 
ERR_OUTL: 
        JMP     ERR_OUT 
 
;=============================================================== 
;       П/П ПОИСКА ДОРОЖКИ 
;=============================================================== 
SEEK:   PUSH    AX              ;СОХР. AX,DX 
        PUSH    DX              ; 
        MOV     AH,0            ; 
        MOV     AL,MOTOR_STATUS ;СТАТУС МОТОРА 
        AND     AL,7FH          ;БЕЗ ОПЕРАЦИИ 
        SUB     AL,1            ;-1  ?????????????????????? 
        MOV     SI,AX           ;СОХР.СТАТУСА 
        CMP     TRACK_PTR [SI],0FFH  ;СБРОС БЫЛ НОРМАЛЬНЫЙ? 
        JNZ     SEEK0           ;ДА 
SEEK00: PUSH    AX              ;БЫЛА ОШИБКА СБРОСА 
        CALL    SELECT_DRIVE    ;ВЫБОР УСТР+ГОЛОВКА 
        PUSH    DX              ;CОХР. DX 
        MOV     DX,SI           ;СТАТУС УСТРОЙСТВА (НОМЕР) 
        CALL    DISK_RESET      ;СБРОС 
        POP     DX 
        POP     AX 
        CMP     DISKETTE_STATUS,0 ;СТАТУС 0 (СБРОС НОРМАЛЬНЫЙ)? 
        JNZ     SEEK3           ;НЕТ, ОШИБКА 
        OR      TRACK_PTR [SI],AH ;AH=0   ДЛЯ ПЕРВОГО ВХОДА В SEEK00 
                                  ;AH=80H ДЛЯ ВТОРОГО ВХОДА В SEEK00 
SEEK0:  MOV     AL,TRACK_PTR [SI] ;СБРОС БЫЛ НОРМАЛЬНЫЙ 
        MOV     AH,AL           ;0 
        AND     AH,80H          ;ВЫДЕЛЕНИЕ Д7 (0) 
        AND     AL,7FH          ;ВЫДЕЛЕНИЕ Д6-Д0 (0) 
        MOV     TRACK_PTR [SI],CH ;НОМЕР ДОРОЖКИ 
        OR      TRACK_PTR [SI],AH ;+ ???????????? 
        MOV     AH,20H 
        SUB     AL,CH 
        JZ      SEEK2           ;ДЛЯ AL = CH,AH:=21H 
        JNC     SEEK1           ;ДЛЯ AL > CH,AH:=21H 
        NEG     AL              ;ДЛЯ AL < CH,AH:=1 
        MOV     AH,0 
SEEK1:  CMP     STEP_MULT,1     ;УСТР 0,1 
        JZ      STM3            ;ДА 
        SHL     AL,1            ;ДЛЯ УСТР 2(*),3(*) AL:=AL*2 
STM3:   OR      AL,AL           ;ДЛЯ УСТР 0,1 
        JZ      SEEK2 
        CALL    STEP 
        JMP     SEEK22 
SEEK2:  MOV     AL,CH           ;НОМЕР ДОРОЖКИ 
        OUT     TRACK,AL        ;ВЫВОД НОМЕРА ДОРОЖКИ 
SEEK22: MOV     DX,DATA_F       ;АДРЕС ПОРТА ДАННЫХ 
        MOV     AL,CH           ;ДОРОЖКА 
        OUT     DX,AL           ;ВЫВОД НОМЕРА ДОРОЖКИ 
        MOV     DX,CONTROL_STAT ;ПОРТ СОСТОЯНИЯ 
        MOV     AL,BL           ;КОМАНДА ПОИСКА 
        OUT     DX,AL           ;ПОДАЧА КОМАНДЫ 
        NOP 
        NOP 
        IN      AL,RD_INTRQ     ;ЧТЕНИЕ ПОРТА С INTRQ 
        IN      AL,DX           ;ЧТЕНИЕ СОСТОЯНИЯ 
        AND     AL,19H          ;ВЫДЕЛЕНИЕ Д0,Д3,Д4 
        CMP     AL,SEEK_OK      ;НОРМАЛЬНО? 
        JNZ     SEEK20          ;НЕТ 
        AND     TRACK_PTR [SI],7FH ;ЗАБОЙ Д7 
        JMP     SHORT EXIT_SEEK 
SEEK20: MOV     AL,TRACK_PTR [SI]  ; 
        AND     AL,80H          ;ВЫДЕЛЕНИЕ Д7 
        CMP     AL,80H          ;Д7=1? 
        JZ      SEEK3           ;ДА, УЖЕ ПОВТОРЯЛИ 
        MOV     AH,80H          ;НЕТ, ПОВТОРИТЬ 
        JMP     SEEK00 
SEEK3:  OR      DISKETTE_STATUS,BAD_SEEK ;+ОШИБКА ПОИСКА 
        MOV     TRACK_PTR [SI],0FFH      ;ОШИБКА 
        STC                     ;CF=1-->ОШИБКА ПОИСКА 
EXIT_SEEK: 
        MOV     AL,CL           ;СЕКТОР 
        MOV     DX,SECTOR 
        OUT     DX,AL           ;ПОДАЧА 
        POP     DX 
        POP     AX 
        RET 
 
;============================================================== 
;       П/П ЧТЕНИЯ      ES:BX --> АДРЕС БУФЕРА. 
;============================================================== 
READ:   PUSH    AX 
        PUSH    DX 
        MOV     DI,BX           ;СМЕЩЕНИЕ 
        MOV     DX,DATA_F       ;ПОРТ ДАННЫХ 
        MOV     AL,READ_COMMAND ;КОД КОМАНДЫ "ЧТЕНИЕ СЕКТОРА" 
        CLI                     ;ЗАПРЕТ ПРЕРЫВАНИЙ 
        OUT     CONTROL_STAT,AL ;ВЫВОД КОДА ОПЕРАЦИИ 
        JMP     RLOOP+1         ; 
RLOOP:  STOSB                   ;ПРЕСЫЛКА БАЙТА  AL_-->ES:DI 
        IN      AL,RD_INTRQ     ;ЧТ.  INTRQ ИЛИ DRQ 
        SHR     AL,1            ; 
        IN      AL,DX           ;ЧТЕНИЕ БАЙТА ДАННЫХ 
        JC      RLOOP 
        STI                     ;ЗАПРЕТ ПРЕРЫВАНЙ 
        CALL    ERR_TABL        ;КОД ЗАВЕШЕНИЯ 
        MOV     BX,DI           ;СМЕЩЕНИЕ СВОБОДНОГО БАЙТА 
        POP     DX 
        POP     AX 
        RET                     ;ВОЗВРАТ 
 
;============================================================== 
;       П/П ЗАПИСИ      ES:BX --> АДРЕС БУФЕРА. 
;============================================================== 
WRITE:  PUSH    AX 
        PUSH    DX 
        PUSH    DS 
        MOV     AX,ES           ;АДРЕС ES B DS 
        MOV     DS,AX 
        MOV     SI,BX           ;СМЕЩЕНИЕ БУФЕРА В SI 
        MOV     DX,DATA_F       ;АДРЕС ПОРТА ДАННЫХ 
        MOV     AL,WRITE_COMMAND ;КОД КОМАНДЫ "ЗАПИСЬ СЕКТОРА" 
        CLI                     ;ЗАПРЕТ ПРЕРЫВАНИЙ 
        OUT     CONTROL_STAT,AL ;ВЫВОД КОДА 
WLOOP:  IN      AL,RD_INTRQ 
        SHR     AL,1 
        LODSB                   ;AL <-- DS:SI 
        OUT     DX,AL           ;ВЫВОД БАЙТА 
        JC      WLOOP 
        STI                     ;РАЗРЕШЕНИЕ ПРЕРЫВАНИЙ 
        DEC     SI              ;СМЕЩЕНИЕ ПОСЛЕДНЕГО ВЫВЕДЕННОГО БАЙТА 
        MOV     AX,DS           ;ВОССТАНОВЛЕНИЕ АДРЕСА СЕГМЕНТА 
        MOV     ES,AX 
        MOV     BX,SI 
        POP     DS 
        CALL    ERR_TABL        ;ФОРМИРОВАНИЕ КОДА ЗАВЕРШЕНИЯ 
        POP     DX 
        POP     AX 
        RET                     ;ВОЗВРАТ 
 
;============================================================== 
;   П/П ФОРМИРОВАНИЯ КОДОВ ЗАВЕРШЕНИЯ 
;============================================================== 
ERR_TABL: 
        PUSH    AX              ; 
        PUSH    DX 
        MOV     DX,CONTROL_STAT ;ПОРТ СОСТОЯНИЯ 
        IN      AL,DX           ;ЧТЕНИЕ СОСТОЯНИЯ 
        AND     AL,0DFH         ;ОЧИСТКА БИТА 5  ??????????????? 
        CMP     AL,READ_WRITE_OK   ;НОРМАЛЬНО (=0)? 
        JZ      NORM_EXIT       ;ДА 
        IN      AL,DX           ;ЧТЕНИЕ СОСТОЯНИЯ 
        TEST    MOTOR_STATUS,80H   ;ЧТЕНИЕ? 
        JZ      R_W_ERROR       ;ДА 
WRITE_ERROR:                    ;ЕСЛИ ЗАПИСЬ 
        TEST    AL,40H          ;ЗАЩИТА ЗАПИСИ ? 
        MOV     AH,WRITE_PROTECT  ;КОД ОШИБКИ (ЗАЩИТА ЗАПИСИ) 
        JNZ     ERR_EXIT        ;ДА, ОШИБКА 
R_W_ERROR: 
        TEST    AL,10H          ;ПРИЗНАК "НЕТ ЗАПИСИ" ? 
        MOV     AH,RECORD_NOT_FND  ;КОД ЭТОЙ ОШИБКИ 
        JNZ     ERR_EXIT        ;ДА, ОШИБКА "НЕТ ЗАПИСИ" 
        TEST    AL,8            ;КОД ОШИБКИ CRC ? 
        MOV     AH,BAD_CRC      ;КОД ЭТОЙ ОШИБКИ 
        JNZ     ERR_EXIT        ;ДА, ОШИБКА CRC 
        MOV     AH,BAD_FDC      ;КОД ОШИБКИ ДВОЙНОЙ ПЛОТНОСТИ 
ERR_EXIT: 
        MOV     AL,AH           ; 
        OR      DISKETTE_STATUS,AL ;В СТАТУС ДИСКА КОД ОШИБКИ 
        STC                     ;УСТАНОВКА ФЛАГА CF=1 (ОШИБКА) 
NORM_EXIT: 
        POP     DX              ;ВОССТАНОВЛЕНИЕ DX, AX 
        POP     AX 
        RET                     ;ВОЗВРАТ 
 
;============================================================== 
;       ВЫБОР УСТРОЙСТВА : DL-->НОМ.УСТР., DH-->НОМ.ГОЛОВКИ 
;============================================================== 
SELECT_DRIVE: 
        PUSH    AX              ;СОХР. РЕГИСТРОВ 
        PUSH    CX 
        MOV     CL,DL           ;DL=0 ДЛЯ УСТР. 0,2(*) 
        MOV     AL,5            ;УСТР. 0, МОТОР 0 
        SAL     AL,CL           ;СДВИГ ПО НОМЕРУ УСТРОЙСТВА 
        MOV     AH,DH           ;НОМЕР ГОЛОВКИ 
        AND     AH,1            ;МЛ. БИТ 
        MOV     CL,4            ; 
        ROL     AH,CL           ;НОМЕР ГОЛОВКИ В ПОЗ. D4 
        OR      AL,AH           ;УСТР +МОТОР +ГОЛОВКА 
        OR      AL,40H          ;+СБРОС ДВ. ПЛОТНОСТИ 
        OUT     RG_C,AL         ;ВЫВОД (ВЫБОР УСТРОЙСТВА ) 
        POP     CX              ;ВОССТАНОВЛЕНИЕ РЕГИСТРОВ 
        POP     AX 
        RET                     ;ВОЗВРАТ 
 
;============================================================= 
;       П/П ОЖИДАНИЯ ДЛЯ МОТОРА. ЗАДЕРЖКА ОКОЛО 0.5SEC. 
;============================================================= 
TEST_WAIT: 
        PUSH    AX 
        PUSH    BX 
        PUSH    CX 
        MOV     BL,1 
        IN      AL,MOTOR_EN     ;ЧТ. СОСТОЯНИЯ МОТОРА --> D0 
        TEST    AL,1            ;МОТОР ВКЛ (D0=0) ? 
        OUT     MOTOR_ON,AL     ;ВКЛ MOTOРА 
        JNZ     J36 
        TEST    DRIVER_N,DL 
        JNZ     J37 
 
J36:    MOV     CX,0 
DISK_TIME: 
        LOOP    DISK_TIME       ;ЗАДЕРЖКА 
        CLI 
        MOV     DRIVER_N,DL 
        STI 
        TEST    MOTOR_STATUS,80H  ;ЧТЕНИЕ? 
        JZ      J37             ;ДА 
WAIT_WRITE:                     ;ЕСЛИ ЗАПИСЬ 
        MOV     CX,0 
        WAIT_TIME: 
        LOOP    WAIT_TIME       ;ВРЕМЯ ДЛЯ ЗАПИСИ 
J37:    MOV     AH,4 
RET_RDY: 
        OUT     MOTOR_ON,AL     ;ВКЛ МОТОРА 
        MOV     CX,0 
WT_RDY: IN      AL,CONTROL_STAT ;ЧТЕНИЕ СОСТОЯНИЯ 
        AND     AL,80H          ;ГОТОВ? 
        JZ      END_RDY         ;ДА 
        LOOP    WT_RDY          ;65535 РАЗ ОПРОС 
        DEC     AH              ;И ВСЕ ЕЩЕ 4 РАЗА 
        JNZ     RET_RDY 
END_RDY: 
        POP     CX              ;ВОССТАНОВЛЕНИЕ 
        POP     BX 
        POP     AX 
        RET                     ;ВОЗВРАТ 
 
 
STEP:   PUSH    CX 
        SUB     CX,CX            ;CX=0 
        MOV     CL,AL            ;FOR LOOP 
        XCHG    AL,AH 
        OR      AL,STEP_COMMAND 
STEPC:  OUT     CONTROL_STAT,AL  ;STEP_COMMAND AND DIR 
        PUSH    AX 
        IN      AL,RD_INTRQ 
        POP     AX 
        LOOP    STEPC 
        POP     CX 
        MOV     AL,CH 
        OUT     TRACK,AL 
        RET 
 
CODE    ENDS 
        end