;--------------------------------------------------------------- 
; 
;              К Л А В И А Т У Р А       I N T 9 
; 
;--------------------------------------------------------------- 
;         Батьковский М.                    06.01.89 
;--------------------------------------------------------------- 
;    Программа обработки прерывания клавиатуры 
; 
; Программа считывает код сканирования клавиши в регистр AL. 
; Единичное состояние разряда 7 в коде сканирования означает, 
; что клавиша отжата. 
;   В результате выполнения программы в регистре AX формируется 
; слово, старший байт которого (AH) содержит код сканирования, 
; а младший (AL) - код ASCII. Эта информация помещается в буфер 
; клавиатуры. После заполнения буфера подается звуковой сигнал. 
; Модифицируются байты 0:417 и 0:418 
;  Проверяются и отрабатываются ситуации: 
;        - SHIFT + PrintScreen 
;        - CTRL  + NumLock 
;        - ALT   + CTRL + DEL 
;------------------------------------------------------------- 
 
;----------------------- I N T 9 ----------------------------------- 
 
 
KB_INT  PROC    FAR 
        STI                   ;разрешить прерывания 
        PUSH    AX 
        PUSH    BX 
        PUSH    CX 
        PUSH    DX 
        PUSH    SI 
        PUSH    DI 
        PUSH    DS 
        PUSH    ES 
 
        CLD                   ;направление вперед 
 
;------ Установка регистров 
 
        PUSH    CS 
        POP     ES            ;ES=CS 
        MOV     AX,DATA 
        MOV     DS,AX         ;указатель на сегмент джанных 
        IN      AL,KB_DATA    ;чтение скан_кода 
        MOV     AH,AL         ; (AH) - скан-код 
 
;        CALL    DISP_HEX     ;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
        AND     AL,7FH       ;сброс бита нажата-отжата 
        MOV     SI,OFFSET ALT_INPUT ; указатель на накопитель кода символа 
        MOV     DX,word ptr KB_FLAG    ; состояние управляющих клавиш: 
                              ;           DL - KB_FLAG,  DH - KB_FLAG1 
 
;------ Проверка на скан_код управляющей клавиши 
 
K16: 
        MOV     DI,OFFSET K6   ;таблица SHIFT KEY 
        MOV     CX,K6L         ;длина таблицы 
        REPNE   SCASB          ;поиск 
	JNE	K25	       ;не упрравляющая клавиша 
 
;------ Управляющая клавиша 
 
K17:                           ;(CL) - количество сдвигов 
        MOV     BH,80H 
        SHR     BH,CL          ;(BH) - маска клавиши для KB_FLAG 
 
        CMP     AH,AL          ;проверка на отжатие 
        JNZ     K23            ;если клавиша отжата 
 
;------ Управляющая клавиша нажата 
 
        CMP     BH,SCROLL_SHIFT 
        JAE     K18            ;если клавиша из множества 
                               ; { Scroll,Num,Caps,Ins } 
 
;------ Нажата клавиша из множества  { Alt,Ctl,ShiftLeft,ShiftRigth } 
 
        OR      DL,BH           ;установка флагов в KB_FLAG 
        JMP     SHORT K26       ;к выходу из прерывания 
 
;------ Нажата клавиша из множества  { Scroll,Num,Caps,Ins } 
 
K18: 
        TEST    DL,CTL_SHIFT+ALT_SHIFT; 
        JNZ     K25                ; обработка ка обычной клавиши 
        CMP     AL,INS_KEY         ; проверка на код INS 
        JNZ     K22 
 
;------ Нажата клавиша INS 
 
K19:    CALL    CALC_NUMKEY_SHIFT  ; определение статуса дополн. клавиатуры 
        JZ      K22  ; дополнительная клавиатура в управляющем состоянии 
        ; дополнительная клавиатура в цифровом состоянии 
        MOV     AL,'0'             ; запись в буфер цифры '0' 
        JMP     SHORT K23E 
 
;------ Изменение KB_FLAG для клавиши из множества  { Scroll,Num,Caps,Ins } 
 
K22: 
        TEST    BH,DH              ; повторная генерация при одном нажатии? 
        JNZ     K26                ; если генерация 
        OR      DH,BH              ; установка бита - клавиша нажата 
        XOR     DL,BH              ; инверсия режима 
        CMP     AL,INS_KEY         ; проверка INSERT KEY 
        JNE     K26                ; если нет 
        JMP     KW0_BUF            ; запись в буфер кода клавиши INS 
 
;------ Управляющая клавиша отжата 
 
K23: 
        CMP     BH,SCROLL_SHIFT 
        JAE     K24 
 
;------ Отжата клавиша из множества  { Alt,Ctl,ShiftLeft,ShiftRigth } 
 
        NOT     BH                 ; инвертирование маски 
        AND     DL,BH              ; cброс бита признака в KB_FLAG 
        CMP     AH,ALT_KEY+80H     ; отжата клавиша ALT 
        JNE     K26                ; к выходу из прерывния 
 
;------ Отжата клавиша ALT, запись символа в буфер 
;       ( символ был введен в цифровом виде ) 
 
        MOV     AL,[SI] 
        SUB     AH,AH              ; скан_код=0 
        MOV     [SI],AH            ; сброс кода-накопителя 
        OR      AL,AL              ; код символа = 0 ? 
        JE      K26                ; к выходу из прерывания 
K23E:   JMP     KW_BUF             ; запись введеного кода символа в буфер 
 
 
;------ Отжата клавиша из множества  { Scroll,Num,Caps,Ins } 
 
K24: 
        NOT     BH                 ; инвертирование маски 
        AND     DH,BH              ; сброс бита-признака в KB_FLAG1 
        JMP     SHORT K26          ; к выходу из прерывания 
 
 
;------ СКАН-КОД ОБЫЧНОЙ КЛАВИШИ ----------------------------------------- 
 
K25: 
        CMP     AH,AL             ; проверка бита нажатия/отжатия 
        JNE     K26A               ; клавиша отжата 
        TEST    DH,HOLD_STATE      ; проверка режима-пауза 
        JZ      K28                ; режим пауза отсутствует 
        ;режим_пауза 
        CMP     AL,NUM_KEY 
        JE      K26A               ; если режим пауза продолжается 
        AND     DH,NOT HOLD_STATE  ; сброс режима пауза 
 
;------ ВОЗВРАТ ИЗ ПРЕРЫВАНИЯ 
K26: 
        MOV     word ptr KB_FLAG,DX      ; сохранение флагов клавиш управления 
K26A: 
        MOV     SCAN_CODE_OLD,AH; запоминание скан-кода 
        CLI                     ; запрет прерываний 
        MOV     AL,EOI          ; команда - конец прерывания 
        OUT     020H,AL         ; запись команды в контроллер прерываний 
K27: 
        POP     ES 
        POP     DS 
        POP     DI 
        POP     SI 
        POP     DX 
        POP     CX 
        POP     BX 
        POP     AX 
        IRET 
 
;-------------------------------------------------------------- 
;           ПОЛУЧЕН СКАН-КОД ОБЫЧНОЙ КЛАВИШИ 
;  ( перекодировка скан-кодов в альтернативную кодировку ) 
;-------------------------------------------------------------- 
 
K28:    ;проверка на дополнительный скан-код 
        CMP      SCAN_CODE_OLD,0E0H 
        JZ       K65AA        ; если дополнительный скан-код 
 
       ;проверка состояния управляющих клавиш 
       TEST    DL,ALT_SHIFT+CTL_SHIFT 
       JNZ     K70             ; если одна или две клавиши нажаты 
 
;-------------------------------------------------------------- 
;    проверка и обслуживание символов без ALT и CTRL 
;-------------------------------------------------------------- 
 
K60:   CMP     RUSS,TRUE 
       JNE     K61 
 
 
;----- SERVICE RUSS  -  проверка и обслуживание русских символов 
 
SERVICE_RUSS: 
        MOV     BX,offset KT_RUS0 
        CALL    CONTR_TABLE 
        JNZ     K61                     ; если не русская буква 
SR2: 
        MOV     BX,offset LR 
        XLAT    CS:LR            ; получение кода символа 
        ; 
        MOV     CL,DL 
        AND     CL,LEFT_SHIFT+RIGHT_SHIFT+CAPS_STATE 
        JZ      SR3                     ; клавиши управления не нажаты 
        CMP     CL,CAPS_STATE+1 
        JC      SR4                     ; нажата только одна из клавиш 
                                        ; SHIFT1 или CAPS_STATE 
SR3:    ; маленькие буквы 
        CMP     AL,0F0h 
        JNZ     SR0 
        INC     AL 
        JMP     short SR4 
 
SR0:    ADD     AL,20H 
        CMP     AL,0B0H 
        JC      SR4 
        ADD     AL,30H 
SR4: 
        JMP     KW_BUF                  ; к записи в буфер 
 
;----------------------------------------------------------------- 
;----- Проверка и обслуживание не русских букв 
K61: 
       CMP      AL,71         ; дополнительная клавиатура ? 
       JAE      K65           ; да 
 
;----- ОСНОВНАЯ КЛАВИАТУРА 
 
       TEST     DL,LEFT_SHIFT+RIGHT_SHIFT 
       JNZ      K62 
 
       ; основная клавиатура, клавиша SHIFT не нажата 
 
       MOV      BX, offset K10 
       CALL     CONTR_CODE 
       SUB      CL,CL 
       JMP      CONTR_FK 
 
       ; основная клавиатура, клавиша SHIFT нажата 
K62: 
 
K63:   ; проверка SHIFT + PrintScreen 
        CMP     AL,55           ; PRINT SCREEN KEY 
        JNE     K64 
        ; распечатка содержимого экрана 
        MOV     AL,EOI 
        OUT     020H,AL 
        INT     5H              ; 
        JMP     K27             ;  возврат без упр. контроллером прерываний 
 
K64:    MOV     BX,offset K11 
        CALL     CONTR_CODE 
        MOV     CL,84-59 
        JMP      CONTR_FK 
 
;------ ДОПОЛНИТЕЛЬНАЯ КЛАВИАТУРА 
 
K65:   CALL    CALC_NUMKEY_SHIFT  ; определение статуса дополн. клавиатуры 
       MOV     BX, offset K14     ; доп. клавиатура в цифровом состоянии 
       JNZ     K65A 
K65AA: MOV     BX, offset K15     ; доп. клавиатура в управляющем состоянии 
K65A:  CALL    CONTR_CODE 
       JMP     K26 
 
;----------------------------------------------------------------- 
;----- нажата ALT и/или CTL -------------------------------------- 
;----------------------------------------------------------------- 
 
K70:    TEST    DL,ALT_SHIFT 
        JZ      K80            ; если ALT не нажата (нажата CTRL) 
 
;----- проверка на комбинацию ALT + CTL + DEL 
 
        CMP     AL,DEL_KEY 
        JNE     K71             ; нет сброса 
 
        MOV     RESET_FLAG,1234H ; установка параметров для функции сброса 
        JMP     RESET           ; переход на сброс 
 
 
;-------------------------------------------------------------- 
;    проверка и обслуживание  символов  с ALT 
;-------------------------------------------------------------- 
 
K71:    ; проверка на цифры дополнительной клавиатуры 
        CMP     AL,71 
        JB      K72 
        CMP     AL,82 
        JA      K72 
        MOV     BX,offset  K14+2-71 
        XLAT    CS:K14 
        SUB     AL,'0' 
        JC      K72 
        ;накопление кода символа 
        XCHG    [SI],AL 
        MOV     AH,10 
        MUL     AH 
        ADD     [SI],AL 
        JMP     K26             ; выход из прерывания 
 K72: 
        MOV     AL,AH 
        MOV      byte ptr[SI],0        ; сброс накопленного кода 
 
        MOV     BX,offset KT_ALT ;A..Z, 0..9, -, + 
        CALL    CONTR_TABLE     ; проверка и перекодировка скан кодов 
        CMP     CL,84 
        JZ      K72A            ; если вне диапазона KT_ALT 
        CMP     CL,2            ; проверка на скан-коды 0..9-+ 
        JNZ     K72AA 
        ADD     AH,118          ; если в диапазоне  0..9-+ 
K72AA:  JMP     KW0_BUF 
 
K72A:   MOV     CL,104-59       ; приращение для получения псевдо скан-кода 
        JMP     CONTR_FK        ; проверка на функциональные клавиши 
 
 
;-------------------------------------------------------------- 
;    проверка и обслуживание  символов  с CTRL 
;-------------------------------------------------------------- 
K80: 
        MOV     BX, offset K8   ; основная клавиатура + CTRL 
        CALL    CONTR_CODE 
        MOV     BX, offset K9  ; дополнительная кдавиатура + CTRL 
        CALL    CONTR_CODE 
 
;       проверка исполнительных клавиш 
        CMP     AL,SCROLL_KEY   ; проверка клавиши "BREAK" 
        JNE     K81             ; не "BREAK" 
 
        ;"BREAK" 
        ;очистка буфера ввода 
        MOV     AX,BUFFER_HEAD 
        MOV     BUFFER_TAIL,AX 
        MOV     BIOS_BREAK,80H  ; признак BREAK от клавиатуры 
        INT     1BH             ; запуск прерывания обработки BREAK 
        SUB     AX,AX           ; пустой символ 
        JMP     KW_BUF          ; к записи в буфер 
 
K81: 
        CMP     AL,NUM_KEY      ; проверка клавиши "PAUSE" 
        JNE     K82             ; NO-PAUSE 
 
        ;"PAUSE" 
        OR      KB_FLAG_1,HOLD_STATE ; установить флаг "PAUSE" 
        MOV     W_SCAN,FALSE   ; разрешение повторного входа в SCANINT 
        MOV     AL,EOI 
        OUT     020H,AL 
        ; 
;        CMP     CRT_MODE,7     ; IS THIS BLACK AND WHITE CARD 
;        JE      K81A           ; YES,NOTHING TO DO 
;        MOV     DX,03D8H       ; PORT FOR COLOR CARD 
;        MOV     AL,CRT_MODE_SET        ; GET THE VALUE OF THE CURRENT MODE 
;        OUT     DX,AL          ; SET THE CRT MODE,SO THAT CRT IS ON 
 
K81A:   ; цикл ожидания окончания паузы 
        TEST    KB_FLAG_1,HOLD_STATE 
        JNZ     K81A 
        JMP     K27            ; к выходу из прерывания 
 
K82: 
       ; проверка CTRL+PrintScreen 
        CMP     AL,55 
        JNE     K83 
        MOV     AH,114     ; START/STOP PRINTING SWITCH 
        JMP     KW0_BUF         ; к записи в буфер 
 K83: 
        MOV     CL,94-59        ; приращение для получения псевдо скан-кода 
 
;----------------------------------------------------------------------- 
;     КОНТРОЛЬ ФУНКЦИОНАЛЬНЫХ КЛАВИШ И ПРОБЕЛА 
;      (CL) - приращение для получение псевдо скан_кода 
 
CONTR_FK: 
         ; проверка на пробел 
         CMP     AL,57 
         JNE     C_FK1 
         MOV     AL,' ' 
         JMP     SHORT KW_BUF 
C_FK1:   ; проверка на функциональные клавиши 
         CMP     AL,59 
         JB      K90A 
         CMP     AL,68 
         JA      K90A 
         ADD     AH,CL 
 
;---------------------------------------------------------------------- 
;------- ЗАПИСЬ В БУФЕР 
 
KW0_BUF: SUB    AL,AL 
KW_BUF: 
 
;        CALL    DISP_AX     ;  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 
        ; занесение скан_кода (AH) и кода символа в буфер (AL) 
        MOV     BX,BUFFER_TAIL ; GET THE END POINTER TO THE BUFFER 
        MOV     SI,BX         ; SAVE THE VALUE 
        CALL    K4            ; ADVANCE THE TAIL 
        CMP     BX,BUFFER_HEAD ; HAS THE BUFFER WRAPPED AROUND 
        JE      K90           ; BUFFER_FULL_BEEP 
        MOV     [SI],AX        ; STORE THE VALUE 
        MOV     BUFFER_TAIL,BX ; MOVE THE POINTER UP 
        JMP     K90A           ; INTERRUPT RETURN 
 
;------ BUFFER IS FULL,SOUND THE BEEPER 
 
K90:                          ; BUFFER-FULL-BEEP 
 
;        MOV     AL,EOI 
;        OUT     20H,AL 
        MOV     BX,0504H       ; 
        CALL    BEEP 
K90A:   JMP     K26           ; INTERRUPT_RETURN 
 
 
KB_INT ENDP 
 
;========================================================================= 
 
;      определение статуса дополн. клавиатуры 
;      выход: 
;        Z=TRUE   -   управляющая клавиатура 
;        Z=FALSE  -   цифровая клавиатура 
 
 CALC_NUMKEY_SHIFT  PROC NEAR 
       MOV     BL,DL 
       AND     BL,NUM_SHIFT+LEFT_SHIFT+RIGHT_SHIFT 
       JZ      CALC_END 
       CMP     BL,NUM_SHIFT+1 
       JB      CALC_END 
       CMP     AL,AL    ;установка флага Z 
CALC_END: RET 
CALC_NUMKEY_SHIFT  ENDP 
 
;========================================================================= 
 
;      ПЕРЕКОДИРОВКА СИМВОЛОВ С ПРОВЕРКОЙ ГРУППЫ ДИАПАЗОНОВ 
;      (BX) - указатель на структуру 
;              <мин><макс><приращение> 
;       Выход: флаг Z=0  - неудачный поиск 
;              флаг Z=1  - удачный поиск, (AL)- порядковый номер 
 
 
 
CONTR_TABLE PROC  NEAR 
       PUSH    DX 
       SUB     DL,DL       ; суммарный диапазон 
CT0:   MOV     CX,CS:[BX] 
       CMP     AL,CL 
       JB      CTE 
       CMP     AL,CH 
       JBE     CT00 
 
       ;код вне интервала 
       SUB     CH,CL 
       ADD     DL,CH         ;накопление суммарной длины диапазонов 
       INC     DL 
       ADD     BX,2 
       CMP     CL,83 
       JB      CT0 
       JMP     SHORT CTE 
       ;код внутри интервала 
CT00:  SUB     AL,CL 
       ADD     AL,DL 
       CMP     AL,AL   ; установка флага Z 
CTE:   POP     DX 
       RET                   ;выход - удачный поиск 
 
CONTR_TABLE ENDP 
 
 
;========================================================================= 
 
;      ПЕРЕКОДИРОВКА СИМВОЛОВ С ПРОВЕРКОЙ ДИАПАЗОНА 
;      (BX) - указатель на структуру 
;             <мин><макс><таблица> 
; 
CONTR_CODE PROC  NEAR 
       MOV     CX,CS:[BX] 
 
;       PUSH    AX          ;  !!!!!!!!!!!!!!!!! 
;       MOV     AL,'=' 
;       CALL    DISP_CHAR 
;       MOV     AX,CX 
;       CALL    DISP_AX 
;       POP     AX 
       CMP     AL,CL 
       JB      CC_END 
       CMP     AL,CH 
       JA      CC_END 
 
 
       ; скан-код находится в допустимом диапазоне 
       SUB     AL,CL ; определение смещения относительно минимального кода 
       ADD     AL,2 
       XLAT    CS:K10 
       POP     CX    ; удаление из стека адреса возврата 
       TEST    AL,80H; проверка формирования псевдо скан_кода 
       JNZ     CC_C1; если особый код 
 
       ; проверка на латинские буквы 
       CMP     AL,'a' 
       JB      CC_C0 
       CMP     AL,'z' 
       JA      CC_C0 
       ; латинские буквы - анализ состояния упр. клавиш 
       MOV     CL,DL 
       AND     CL,LEFT_SHIFT+RIGHT_SHIFT+CAPS_STATE 
       JZ      CC_C0                    ; клавиши управления не нажаты 
       CMP     CL,CAPS_STATE+1 
       JAE     CC_C0                     ; нажата только одна из клавиш 
       SUB     AL,'a'-'A' 
CC_C0: JMP     KW_BUF 
 
CC_C1: ; проверка запрещенного скан_кода 
       CMP     AL,0FFH 
       JZ      K90A   ;запрещенный скан_код 
       CMP     AL,0FEH 
       JNZ     CC_C2; 
       MOV     AH,132 
       JMP     KW0_BUF 
 
CC_C2: ; псевдо скан_код 
       AND     AL,7FH 
       MOV     AH,AL 
       JMP     KW0_BUF 
 
CC_END: RET 
CONTR_CODE ENDP 
 
;======================================================================= 
;      ПРИРАЩЕНИЕ УКАЗАТЕЛЯ КОЛЬЦЕВОГО БУФЕРА ВВОДА 
;      (BX) - указатель 
 
K4      PROC    NEAR 
 
        ADD     BX,2          ;переход к следующему слову 
        CMP     BX,OFFSET KB_BUFFER_END ; конец буфера ? 
        JNE     K5            ;конец буфера не достигнут 
        MOV     BX,OFFSET KB_BUFFER ;в начало буфера (по кольцу) 
K5:     RET 
K4      ENDP 
 
;========================================================================= 
 
