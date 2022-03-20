; SD BIOS для компьютера Специалист
; (c) 22-05-2013 vinxru

     .org 0D800h

CLC_PORT        = 0F001h
DATA_PORT       = 0F002h
CTL_PORT        = 0F003h
CLC_BIT         = 80h;
SEND_MODE       = 10010000b ; Настройка: 1 0 0 A СH 0 B CL   1=ввод 0=вывод
RECV_MODE       = 10011001b

MONITOR         = 0C003h

ERR_START  	= 040h
ERR_WAIT   	= 041h
ERR_OK_DISK 	= 042h
ERR_OK          = 043h
ERR_OK_READ	= 044h
ERR_OK_RKS  	= 047h

;----------------------------------------------------------------------------

Entry:
     ; Схема начального запуска
     EI
     MVI 	A, 82h
     STA 	0FF03h
     
     ; Инициализация стека
     LXI	SP, 07FFFh

     ; Какие то системные переменные (взято из стандартной ПЗУ)
     LXI	H, 0C473h
     LXI	D, 0C494h
     LXI	B, 08FDFh
     CALL	0C42Dh

     ; Очистка экрана и вывод логотипа
     LXI	H, aHello
     CALL	0C438h

     ; Первым этапом происходит синхронизация с контроллером
     ; Принимается 256 попыток. Для этого в регистр C заносится 0
     MVI	C, 0

RetrySync:
     ; Режим передачи
     MVI	A, SEND_MODE
     STA	CTL_PORT

     ; Передаем начало команды
     MVI	A, 013h
     CALL	Send
     MVI	A, 0B4h
     CALL	Send
     MVI	A, 057h
     CALL	Send
     XRA	A
     CALL	Send

     ; Режим приема  
     MVI	A, RECV_MODE
     STA	CTL_PORT

     ; Если есть синхронизация, то контроллер ответит ERR_START
     CALL	Recv
     CPI	ERR_START
     JZ 	Sync

     ; Пауза / Пропускаем 256 байт, если контроллер еще что то передает.
     ; В сумме будет пропущено 64 Кб данных
     MVI	B, 0
RetrySync2:
     CALL	Recv
     DCR	B
     JNZ	RetrySync2

     ; Попытки
     DCR	C
     JZ 	MONITOR ; Ошибка синхронизации

     JMP	RetrySync

;----------------------------------------------------------------------------
; Что бы МК освободил шину

Error:
    CALL	Recv
    JMP 	MONITOR

;----------------------------------------------------------------------------

Sync:
     ; Ждем пока МК прочитает файл.
     CALL	WaitForReady
     CPI	ERR_OK_RKS
     JNZ	Error ; Ошибка чтения файла

     ; Адрес загрузки в BC
     CALL	Recv
     MOV	C, A
     CALL	Recv
     MOV	B, A

     ; Сохраняем в стек адрес запуска
     PUSH	B

RecvLoop:
     ; Подождать
     CALL	WaitForReady
     CPI 	ERR_OK_READ
     JZ 	Recv	; Всё загружено, запуск
     ORA A	; Ошибка, перезагрузка
     JNZ 	Error	; Ошибка чтения файла

     ; Длина очередного блока
     CALL	Recv
     MOV	E, A
     CALL	Recv
     MOV	D, A

     ; Используется ниже
     LXI	H, CLC_PORT

     ; Принять очередной блок
     INR	D
     XRA	A
     ORA	E
     JZ 	RecvBlock2
RecvBlock1:
     MVI	M, CLC_BIT    ; 11
     MVI	M, 0          ; 11
     LDA	DATA_PORT     ; 13
     STAX	B             ; 7
     INX	B             ; 5
     DCR	E             ; 5
     JNZ	RecvBlock1    ; 10
RecvBlock2:
     DCR	D
     JNZ	RecvBlock1

     JMP RecvLoop

;----------------------------------------------------------------------------
; Отправка и прием байта

Send:
     STA	DATA_PORT     
Recv:
     MVI	A, CLC_BIT
     STA	CLC_PORT
     XRA	A
     STA	CLC_PORT
     LDA	DATA_PORT
     RET

;----------------------------------------------------------------------------
; Ожидание готовности МК

WaitForReady:
     CALL       Recv
     CPI	ERR_WAIT
     JZ		WaitForReady
     RET

;----------------------------------------------------------------------------

aHello: .db 1Fh,"SD STARTER V1.0",13,10,0

	.db "(c) 22-05-2013 vinxru"

;----------------------------------------------------------------------------

     .org 0DFFFh
     .db  0
     .end