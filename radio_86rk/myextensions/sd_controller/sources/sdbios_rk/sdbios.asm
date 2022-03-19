; SD BIOS for Computer "Radio 86RK"
; (c) 09-10-2014 vinxru (aleksey.f.morozov@gmail.com)

     .org 07600h-683 ; Последний байт кода должен быть 075FFh
                       
;----------------------------------------------------------------------------

INIT_VIDEO      = 0F82DH
USER_PORT       = 0A000H    ; Адрес КР580ВВ55
INIT_STACK      = 076CFh
SEND_MODE       = 10000000b ; Режим передачи (1 0 0 A СH 0 B CL)
RECV_MODE       = 10010000b ; Режим приема (1 0 0 A СH 0 B CL)

ERR_START   	= 040h
ERR_WAIT    	= 041h
ERR_OK_NEXT 	= 042h
ERR_OK          = 043h
ERR_OK_READ     = 044h
ERR_OK_ENTRY    = 045h
ERR_OK_WRITE	= 046h
ERR_OK_ADDR  	= 047h
ERR_OK_BLOCK    = 04Fh 

VER_BUF = 0

;----------------------------------------------------------------------------
; Заголовок RK файла

     .db ($+2)>>8, ($+2)&0FFh
     
;----------------------------------------------------------------------------
	      
Entry:
     ; Устанавливаем границу свободной памяти
     LXI	H, SELF_NAME
     CALL	0F833h

     ; Вывод названия контроллера на экран
     LXI	H, aHello
     CALL	0F818h

     ; Вывод версии контроллера
     CALL	PrintVer

     ; Перевод строки
     lxi	h, aCrLf
     CALL	0F818h

     ; Запускаем файл SHELL.RK без ком строки
     LXI	H, aShellRk
     LXI	D, aEmpty
     CALL	CmdExec
     PUSH	PSW

     ; Ошибка - файл не найден
     CPI	04h
     JNZ 	Error2

     ; Вывод сообщения "ФАЙЛ НЕ НАЙДЕН BOOT/SHELL.RK"
     LXI	H, aErrorShellRk
     CALL	0F818h
     JMP	$

;----------------------------------------------------------------------------

PrintVer:
     ; Команда получения версии
     MVI	A, 1
     CALL	StartCommand	; Лишний такт в котором пропустим версию
     CALL	SwitchRecv
     
     ; Получаем версию набора команд и текст
     LXI	B, VER_BUF
     LXI	D, 18          ; 1 ый байт версия, последний байт - отпускаем шину
     CALL	RecvBlock
          
     ; Вывод версии железа
     XRA	A
     STA	VER_BUF+17
     LXI	H, VER_BUF+1
     JMP 	0F818h

;----------------------------------------------------------------------------

aHello:         .db 13,10,"SD BIOS V1.0",13,10
aSdController:  .db "SD CONTROLLER ",0
aCrLf:          .db 13,10,0
aErrorShellRk:  .db "fajl ne najden "
aShellRk:       .db "BOOT/SHELL.RK",0
                .db "(c) 04-05-2014 vinxru"

; Код ниже будет затерт ком строкой и собственым именем

SELF_NAME    = $-512 ; путь (буфер 256 байт)
CMD_LINE     = $-256 ; команданая строка 256 байт

;----------------------------------------------------------------------------
; РЕЗИДЕНТНАЯ ЧАСТЬ SD BIOS
;----------------------------------------------------------------------------

aError:    .db "o{ibka SD "
aEmpty:    .db 0

;----------------------------------------------------------------------------
; Тут восстанавливается то, что можно быть испорчено при сбое

Error:     
     ; Инициализация стека
     LXI	SP, INIT_STACK

     ; Сохраняем код ошибки
     PUSH	PSW

     ; Очистка экрана
     ; Сначала надо удалить из области экрана все спец символы, а то синхра сбивается
     MVI	C, 1Fh
     CALL	0F809h     
     ; А теперь перезагрузить видеоконтроллер
     CALL       INIT_VIDEO

Error2:
     ; Вывод текста "ОШИБКА SD "
     LXI	H, aError
     CALL	0F818h

     ; Вывод кода ошибки
     POP	PSW
     CALL	0F815h

     ; Виснем
     JMP	$

;----------------------------------------------------------------------------

BiosEntry:
     PUSH       H
     LXI	H, JmpTbl
     ADD	L
     MOV	L, A
     MOV	L, M
     XTHL
     RET

;----------------------------------------------------------------------------
; Страница 8D00. Все переходы JmpTbl в пределах одной страницы

JmpTbl:
     .db CmdExec           ; 0 HL-имя файла, DE-командная строка  / A-код ошибки
     .db CmdFind           ; 1 HL-имя файла, DE-максимум файлов для загрузки, BC-адрес / HL-сколько загрузили, A-код ошибки
     .db CmdOpenDelete     ; 2 D-режим, HL-имя файла / A-код ошибки
     .db CmdSeekGetSize    ; 3 B-режим, DE:HL-позиция / A-код ошибки, DE:HL-позиция
     .db CmdRead           ; 4 HL-размер, DE-адрес / HL-сколько загрузили, A-код ошибки
     .db CmdWrite          ; 5 HL-размер, DE-адрес / A-код ошибки
     .db CmdMove           ; 6 HL-из, DE-в / A-код ошибки

;----------------------------------------------------------------------------
; HL-путь, DE-максимум файлов для загрузки, BC-адрес / HL-сколько загрузили, A-код ошибки

CmdFind:
     ; Код команды
     MVI	A, 3
     CALL	StartCommand

     ; Путь
     CALL	SendString

     ; Максимум файлов
     XCHG
     CALL	SendWord

     ; Переключаемся в режим приема
     CALL	SwitchRecv

     ; Счетчик
     LXI	H, 0

CmdFindLoop:
     ; Ждем пока МК прочитает
     CALL	WaitForReady
     CPI	ERR_OK
     JZ		Ret0
     CPI	ERR_OK_ENTRY
     JNZ	EndCommand

     ; Прием блока данных
     LXI	D, 20	; Длина блока
     CALL	RecvBlock

     ; Увеличиваем счетчик файлов
     INX	H

     ; Цикл
     JMP	CmdFindLoop

;----------------------------------------------------------------------------
; D-режим, HL-имя файла / A-код ошибки

CmdOpenDelete: 
     ; Код команды
     MVI	A, 4
     CALL	StartCommand

     ; Режим
     MOV	A, D
     CALL	Send

     ; Имя файла
     CALL	SendString

     ; Ждем пока МК сообразит
     CALL	SwitchRecvAndWait
     CPI	ERR_OK
     JZ		Ret0
     JMP	EndCommand
     
;----------------------------------------------------------------------------
; B-режим, DE:HL-позиция / A-код ошибки, DE:HL-позиция

CmdSeekGetSize:
     ; Код команды
     MVI 	A, 5
     CALL	StartCommand

     ; Режим     
     MOV	A, B
     CALL	Send

     ; Позиция     
     CALL	SendWord
     XCHG
     CALL	SendWord

     ; Ждем пока МК сообразит. МК должен ответить кодом ERR_OK
     CALL	SwitchRecvAndWait
     CPI	ERR_OK
     JNZ	EndCommand

     ; Длина файла
     CALL	RecvWord
     XCHG
     CALL	RecvWord

     ; Результат
     JMP	Ret0
     
;----------------------------------------------------------------------------
; HL-размер, DE-адрес / HL-сколько загрузили, A-код ошибки

CmdRead:
     ; Код команды
     MVI	A, 6
     CALL	StartCommand

     ; Адрес в BC
     MOV	B, D
     MOV	C, E

     ; Размер блока
     CALL	SendWord        ; HL-размер

     ; Переключаемся в режим приема
     CALL	SwitchRecv

     ; Прием блока. На входе адрес BC, принятая длина в HL
     JMP	RecvBuf

;----------------------------------------------------------------------------
; HL-размер, DE-адрес / A-код ошибки

CmdWrite:
     ; Код команды
     MVI	A, 7
     CALL	StartCommand
     
     ; Размер блока
     CALL	SendWord        ; HL-размер

     ; Теперь адрес в HL
     XCHG

CmdWriteFile2:
     ; Результат выполнения команды
     CALL	SwitchRecvAndWait
     CPI  	ERR_OK
     JZ  	Ret0
     CPI  	ERR_OK_WRITE
     JNZ	EndCommand

     ; Размер блока, который может принять МК в DE
     CALL	RecvWord

     ; Переключаемся в режим передачи    
     CALL	SwitchSend

     ; Передача блока. Адрес BC длина DE. (Можно оптимизировать цикл)
CmdWriteFile1:
     MOV	A, M
     INX	H
     CALL	Send
     DCX	D
     MOV	A, D
     ORA	E
     JNZ 	CmdWriteFile1

     JMP	CmdWriteFile2

;----------------------------------------------------------------------------
; HL-из, DE-в / A-код ошибки

CmdMove:     
     ; Код команды
     MVI	A, 8
     CALL	StartCommand

     ; Имя файла
     CALL	SendString

     ; Ждем пока МК сообразит
     CALL	SwitchRecvAndWait
     CPI	ERR_OK_WRITE
     JNZ	EndCommand

     ; Переключаемся в режим передачи
     CALL	SwitchSend

     ; Имя файла
     XCHG
     CALL	SendString

WaitEnd:
     ; Ждем пока МК сообразит
     CALL	SwitchRecvAndWait
     CPI	ERR_OK
     JZ		Ret0
     JMP	EndCommand

;----------------------------------------------------------------------------
; HL-имя файла, DE-командная строка / A-код ошибки

CmdExec:
     ; Код команды
     MVI	A, 2
     CALL	StartCommand

     ; Имя файла
     PUSH	H
     CALL	SendString
     POP	H

     ; Ждем пока МК прочитает файл
     ; МК должен ответить кодом ERR_OK_ADDR
     CALL	SwitchRecvAndWait
     CPI	ERR_OK_ADDR
     JNZ	EndCommand

     ; Сохраняем имя файла (HL-строка)
     PUSH	D
     XCHG
     LXI	H, SELF_NAME
     CALL	strcpy255
     POP	D

     ; Сохраняем командную строку (DE-строка)
     LXI	H, CMD_LINE
     CALL	strcpy255

     ; *** Это точка невозврата. Любая ошибка приведет к перезагрузке. ***

     ; Инициализация стека (аналогично стандартному монитору)
     LXI	SP, INIT_STACK

     ; Принимаем адрес загрузки в BC и сохраняем его в стек
     CALL	RecvWord
     PUSH	D
     MOV 	B, D
     MOV 	C, E

     ; Загружаем файл
     CALL	RecvBuf
     JNZ 	Error

     ; Очистка экрана
     ; Сначала надо удалить из области экрана все спец символы, а то синхра сбивается
     MVI	C, 1Fh
     CALL	0F809h     
     ; А теперь перезагрузить видеоконтроллер
     CALL       INIT_VIDEO

     ; Настройки для программы
     MVI  A, 1		; Версия контроллера
     LXI  B, BiosEntry  ; Точка входа SD BIOS
     LXI  D, SELF_NAME  ; Собственное имя
     LXI  H, CMD_LINE   ; Командная строка

     ; Запуск загруженной программы
     RET

;----------------------------------------------------------------------------
; Это была последняя команда. Дальше страница 8E00.
;----------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Начало любой команды. 
; A - код команды

StartCommand:
     ; Первым этапом происходит синхронизация с контроллером
     ; Принимается 256 попыток, в каждой из которых пропускается 256+ байт
     ; То есть это максимальное кол-во данных, которое может передать контроллер
     PUSH	B
     PUSH	H
     PUSH	PSW
     MVI	C, 0

StartCommand1:
     ; Режим передачи (освобождаем шину) и инициализируем HL
     CALL       SwitchRecv

     ; Начало любой команды (это шина адреса)
     LXI	H, USER_PORT+1
     MVI        M, 0
     MVI        M, 44h
     MVI        M, 40h
     MVI        M, 0h

     ; Если есть синхронизация, то контроллер ответит ERR_START
     CALL	Recv
     CPI	ERR_START
     JZ		StartCommand2

     ; Пауза. И за одно пропускаем 256 байт (в сумме будет 
     ; пропущено 64 Кб данных, максимальный размер пакета)
     PUSH	B
     MVI	C, 0
StartCommand3:
     CALL	Recv
     DCR	C
     JNZ	StartCommand3
     POP	B
        
     ; Попытки
     DCR	C
     JNZ	StartCommand1    

     ; Код ошибки
     MVI	A, ERR_START
StartCommandErr2:
     POP	B ; Прошлое значение PSW
     POP	H ; Прошлое значение H
     POP	B ; Прошлое значение B     
     POP	B ; Выходим через функцию.
     RET

;----------------------------------------------------------------------------
; Синхронизация с контроллером есть. Контроллер должен ответить ERR_OK_NEXT

StartCommand2:
     ; Ответ         	
     CALL	WaitForReady
     CPI	ERR_OK_NEXT
     JNZ	StartCommandErr2

     ; Переключаемся в режим передачи
     CALL       SwitchSend

     POP        PSW
     POP        H
     POP        B

     ; Передаем код команды
     JMP        Send

;----------------------------------------------------------------------------
; Переключиться в режим передачи

SwitchSend:
     CALL	Recv
SwitchSend0:
     MVI	A, SEND_MODE
     STA	USER_PORT+3
     RET

;----------------------------------------------------------------------------
; Успешное окончание команды 
; и дополнительный такт, что бы МК отпустил шину

Ret0:
     XRA	A

;----------------------------------------------------------------------------
; Окончание команды с ошибкой в A 
; и дополнительный такт, что бы МК отпустил шину

EndCommand:
     PUSH	PSW
     CALL	Recv
     POP	PSW
     RET

;----------------------------------------------------------------------------
; Принять слово в DE 
; Портим A.

RecvWord:
    CALL Recv
    MOV  E, A
    CALL Recv
    MOV  D, A
    RET
    
;----------------------------------------------------------------------------
; Отправить слово из HL 
; Портим A.

SendWord:
    MOV		A, L
    CALL	Send
    MOV		A, H
    JMP		Send
    
;----------------------------------------------------------------------------
; Отправка строки
; HL - строка
; Портим A.

SendString:
     XRA	A
     ORA	M
     JZ		Send
     CALL	Send
     INX	H
     JMP	SendString
     
;----------------------------------------------------------------------------
; Переключиться в режим приема

SwitchRecv:
     MVI	A, RECV_MODE
     STA	USER_PORT+3
     RET

;----------------------------------------------------------------------------
; Переключиться в режим передами и ожидание готовности МК.

SwitchRecvAndWait:
     CALL SwitchRecv

;----------------------------------------------------------------------------
; Ожидание готовности МК.

WaitForReady:
     CALL	Recv
     CPI	ERR_WAIT
     JZ		WaitForReady
     RET

;----------------------------------------------------------------------------
; Принять DE байт по адресу BC
; Портим A

RecvBlock:
     PUSH	H
     LXI 	H, USER_PORT+1
     INR 	D
     XRA 	A
     ORA 	E
     JZ 	RecvBlock2
RecvBlock1:
     MVI        M, 20h			; 7
     MVI        M, 0			; 7
     LDA	USER_PORT		; 13
     STAX	B		        ; 7
     INX	B		        ; 5
     DCR	E		        ; 5
     JNZ	RecvBlock1		; 10 = 54
RecvBlock2:
     DCR	D
     JNZ	RecvBlock1
     POP	H
     RET

;----------------------------------------------------------------------------
; Загрузка данных по адресу BC. 
; На выходе HL сколько загрузили
; Портим A
; Если загружено без ошибок, на выходе Z=1

RecvBuf:
     LXI	H, 0
RecvBuf0:   
     ; Подождать
     CALL	WaitForReady
     CPI	ERR_OK_READ
     JZ		Ret0		; на выходе Z (нет ошибки)
     SUI        ERR_OK_BLOCK
     JNZ	EndCommand	; на выходе NZ (ошибка)

     ; Размер загруженных данных в DE
     CALL	RecvWord

     ; В HL общий размер
     DAD D

     ; Принять DE байт по адресу BC
     CALL	RecvBlock

     JMP	RecvBuf0

;----------------------------------------------------------------------------
; Скопироваьт строку с ограничением 256 символов (включая терминатор)

strcpy255:
     MVI  B, 255
strcpy255_1:
     LDAX D
     INX  D
     MOV  M, A
     INX  H
     ORA  A
     RZ
     DCR  B
     JNZ  strcpy255_1
     MVI  M, 0 ; Терминатор
     RET

;----------------------------------------------------------------------------
; Отправить байт из A.

Send:
     STA	USER_PORT

;----------------------------------------------------------------------------
; Принять байт в А

Recv:
     MVI	A, 20h
     STA	USER_PORT+1
     XRA	A
     STA	USER_PORT+1
     LDA	USER_PORT
     RET

;----------------------------------------------------------------------------

.End