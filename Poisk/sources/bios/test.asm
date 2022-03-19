;--------------------------------------------------------------------------- 
; Начальные тест-программы, инициализация 
;--------------------------------------------------------------------------- 
        ASSUME  CS:CODE, DS:DATA 
RESET   LABEL   NEAR 
START:  CLI                          ;Точка ахода в BIOS (по сбросу, 
                                     ;по включению питания) 
        IN      AL,TRAP_A            ;Сброс триггера NMI 
        MOV     AL,89H               ;Установка режима 8255 (TRAP) 
        OUT     PPIC,AL 
        MOV     AL,88H               ;Установка режима 
        OUT     SCR_MODE,AL 
        IN      AL,TRAP_A            ;Сброс триггера NMI 
        MOV     AL,83H               ;Установка режима 8255 (KBD) 
        OUT     KEY_SERV_MODE,AL     ;Установка режима клавиатуры 
; Передача управления привелигированному ПЗУ, если оно есть 
        MOV     AX,0C000H 
        SUB     BX,BX 
        MOV     DS,AX 
        CMP     DS:[BX],055AAH 
        JNZ     ST0 
        JMP     KARTRIDJ+3 
 
ST0:    SUB     AX,AX 
        MOV     ES,AX                ;Сегмент=0 
        XOR     DI,DI 
        MOV     CX,0FFFFH 
        CLD                          ;Очистка области памяти=64К 
        REP     STOSB 
        MOV     CX,0800H 
        MOV     ES,CX 
        MOV     DI,8000H 
        MOV     CX,DI 
        CLD 
        REP     STOSB 
        MOV     ES,AX                ;Сегмент=0 
        XOR     DI,DI 
        MOV     CX,0FFFFH 
        CLD                          ;Очистка области памяти=64К 
        REP     SCASB 
        CMP     CX,0 
        JZ      CLR1 
        HLT 
CLR1:   MOV     CX,0800H 
        MOV     ES,CX 
        MOV     DI,8000H 
        MOV     CX,DI 
        CLD 
        REP     SCASB 
        CMP     CX,0 
        JZ      CLR2 
	MOV	DX,04 
	CALL	BEEP_ERROR 
        HLT 
 
CLR2: 
        MOV     ES,AX 
	MOV	SS,AX 
	MOV	SP,03FFH 
        PUSH    CS                   ;Установка таблицы прерываний: 
        PUSH    CS 
        POP     BX 
        POP     DS 
        MOV     CX,1EH               ;Установка счетчика векторов 
        MOV     SI,OFFSET VECTOR_TABLE      ;Смещение таблицы векторов 
        MOV     DI,OFFSET INT5_PTR 
SM0:    LODSW                        ;Пересылка таблицы векторов 
        STOSW                        ;(Адреса обслуживания прерываний) 
        MOV     AX,BX 
        STOSW 
        LOOP    SM0 
        MOV     DI,8 
        MOV     AX,OFFSET NMI_SERVICE ;Засылка вектора NMI 
        STOSW 
        MOV     AX,BX 
        STOSW 
        MOV     AX,DATA 
        MOV     ES,AX 
        MOV     CX,10H               ;Размер TEST_TABLIC 
        MOV     SI,OFFSET TEST_TABLIC ;(Таблица конфигурации) 
        MOV     DI,OFFSET RS232_BASE 
        REP     MOVSW 
	SUB	AX,AX 
IX0:    ADD     AX,4000H 
	PUSH	AX 
	MOV	DS,AX 
	SUB	BX,BX 
	MOV	AX,5AA5H 
	MOV	[BX],AX 
	NOT	AX 
	NOT	WORD PTR [BX] 
	CMP	WORD PTR [BX],AX 
	POP	AX 
	PUSH	ES 
	POP	DS 
	JNZ	IX1 
	ADD	MEMORY_SIZE+1,1 
	JMP	IX0 
IX1:    MOV     MOTOR_STATUS,1 
    ;;; MOV     EMPTY,0            ; клавиатура пустая 
        MOV     FBEEP,TRUE 
    ;;;	MOV	RUSS,FALSE 
    ;;; MOV     SHIFT1,LEFT_KEY    ; клавиша отжата 
        MOV     AL,13H                ;Установить режим 8259 
        OUT     INTA00,AL             ;Контроллер прерываний 
        MOV     AL,8 
        OUT     INTA01,AL 
        MOV     AL,9 
        OUT     INTA01,AL 
        MOV     AL,36H               ;Установить режим 8253 
        OUT     TIM_CTL,AL           ;Таймер 
        XOR     AL,AL 
        OUT     TIMER0,AL            ;Канал 0 
        OUT     TIMER0,AL 
        MOV     AL,76H 
        OUT     TIM_CTL,AL 
        XOR     AL,AL 
        OUT     TIMER0+1,AL          ;Канал 1 
        OUT     TIMER0+1,AL 
 
; Установка режима VIDEO 
 
        MOV     AX,0003H 
        INT     10H 
 
; Тест BIOS 
        PUSH    DS 
        PUSH    CS 
        POP     DS 
        MOV     BX,0E000H 
        MOV     CX,2000H 
        CALL    ROS_CHECKSUM         ;Проверка контрольной суммы 
        JZ      IX2 
        MOV     DX,3 
        CALL    BEEP_ERROR 
        HLT 
; Установка начальных значений дисковых переменных 
IX2:    POP     DS 
        MOV     BYTE PTR TRACK_PTR,0H 
        MOV     BYTE PTR TRACK_PTR+1,0H 
;Заполнение начального значения адреса загрузки 
 
        MOV     WORD PTR LOAD_ADDR,0060H 
        STI                          ;Разрещить прерывания 
 
; Выдачы заставки 
 
; Проверка и инициализация ПЗУ и картреджей 
 
        MOV     DX,0C000H 
ROM_CH0: 
        MOV     DS,DX 
        SUB     BX,BX 
        CMP     [BX],0AA55H 
        JNE     ROM_CH1 
        CALL    ROM_INIT 
ROM_CH1: 
        ADD     DX,20H 
        CMP     DX,0FE00H 
        JL      ROM_CH0 
SYS_BOOT: 
        PUSH    DS 
        INT     19H                  ;Загрузка системы 
        POP     DS 
        INT     18H                  ;Передача управления ПЗУ 
                                     ;или работа с кассетой 
 
 
 
 
