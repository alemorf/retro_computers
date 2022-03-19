MONITOR      PROC    FAR 
        JMP    M0 
MONITOR      ENDP 
 
; 
;--------------------------------------------- 
;   НАСТРОЙКА ЭКРАНА - 40*25 ЦВЕТНОЙ 
;--------------------------------------------- 
M0: 
        SUB     AX,AX 
	MOV	SS,AX 
	MOV	SP,03FFH 
 
        mov    ax,01 
        int    10h 
;--------------------------------------------- 
;        Вывод полного меню 
;--------------------------------------------- 
MX0:    lea    si,s0 
	mov	cx,LS0 
        call   P_MSG 
mX1:    call   read_char   ;ПРИЕМ ОТВЕТА 
        cmp    AH,3BH      ;РАБОТА С КАССЕТОЙ? 
        JZ     READ_CAS    ;ДА 
        cmp    AH,3CH      ;РАБОТА С ПЗУ 
        JNZ    MX1         ;НЕТ 
 
        PUSH   DS 
        MOV    AX,KARTR    ;(DS) - ОБЛАСТЬ КАРТРИДЖА 
        MOV    BX,0 
        MOV    DS,AX 
;ПРОВЕРКА КЛЮЧА (ПЕРВЫЙ БАЙТ = E9Н) 
        MOV    AL,BYTE PTR DS:[BX] 
        CMP    AL,0E9H 
        POP    DS 
        JNZ    MX0          ;КЛЮЧА НЕТ 
 
	MOV	AX,2 
	INT	10H 
        JMP     KARTRIDJ 
 
;--------------------------------------------- 
;      Загрузка файла с кассеты 
;--------------------------------------------- 
 
READ_CAS: 
        ASSUME DS:DATA 
        MOV    AX,DATA 
        MOV    DS,AX 
	mov    AX,LOAD_ADDR   ;УСТАНОВКА ОБЛАСТИ ЗАГРУЗКИ 
        mov    es,ax 
        CALL   READ_NAME   ;ПРИЕМ ИМЕНИ ФАЙЛА 
        LEA    si,SW5 
        MOV    cx,LSW5 
          CALL    P_MSG       ;ПОДГОТОВИТЬ МАГНИТОФОН 
RC4:      CALL    READ_CHAR   ;ПРИЕМ ОТВЕТА 
          CMP     AL,13       ;ГОТОВ? 
          JNZ     RC4         ;НЕТ 
          PUSH    ES 
          LEA     BX,BUFFERM 
          MOV     AH,4 
          INT     15H 
          JC      RCERROR 
          lea     si,sX12 
          MOV     cx,LSX12 
          call    P_MSG      ;запускать? 
          call    read_char 
          call    wr_1_char 
          cmp     al,'N' 
          jz      RC5 
          cmp     al,'n' 
          jz      RC5 
          cmp     al,'Н' 
	  jz	  rc5 
	  cmp	  al,'н' 
          jz      rc5 
          MOV     AX,0 
          PUSH    AX 
          DB      0CBH         ;(RETF) ПЕРЕДАТЬ УПРАВЛЕНИЕ ЗАГРУЖЕННОЙ ПРОГРАММЕ 
RC5:      JMP     M0           ;возврат в монитор 
rcerror: 
          lea     si,sX2 
          mov     cx,LSX2   ;--------------------- 
          call    P_MSG 
          call    read_char 
	  JMP	  MX0 
 
;        П/П ВВОДА ИМЕНИ ФАЙЛА 
;--------------------------------------------- 
READ_NAME: 
       LEA   si,SW2 
       MOV   cx,LSW2 
       CALL  P_MSG 
       MOV   SI,0 
RN1:   MOV   BUFFERM[SI],' ' 
       INC   SI 
       CMP   SI,8 
       JNZ   RN1 
       MOV   SI,0 
RN2:   CALL  READ_CHAR 
       CMP   AL,13 
       JZ    RN3 
       CMP   AL,1BH 
       JZ    READ_NAME 
       CMP   AL,20H 
       JB    RN2 
       CALL  WR_1_CHAR 
       MOV   BUFFERM[SI],AL 
       INC   SI 
       CMP   SI,8 
       JNZ   RN2 
RN3:   RET 
 
wr_1_char    proc 
        push   cx 
        PUSH   BX 
        PUSH   DX 
        MOV    AH,14 
        INT    10H 
        POP    DX 
        POP    BX 
        pop    cx 
        ret 
wr_1_char    endp 
 
;Чтение введенного символа 
 
read_char    proc   near 
        mov    ah,0 
        int    16h 
r_ret:  ret 
read_char    endp 
;Сообщения монитора 
s0:     db    13,10,0F6H,' "ПОИСК" ',0F7H,13,10 
        db    13,10 
s01:    db    'F1 - Работа с кассетой',13,10,13,10 
s03:    db    'F2 - Работа с ПЗУ',13,10,13,10 
S05:    DB    'Выберите РЕЖИМ' 
LS05	= $ - OFFSET S05 
LS0     = $ - OFFSET S0 
sX12:   db    13,10,'Запускать?' 
LSX12	= $ - OFFSET SX12 
sX2:    db    13,10,'Ошибка чтения ***',13,10 
LSX2	= $ - OFFSET SX2 
SW2:    DB    13,10,'Введите имя файла:' 
LSW2	= $ - OFFSET SW2 
SW5:    DB    13,10,'Вкл.  магнитофон, нажмите (BK)' 
LSW5	= $ - OFFSET SW5 
fn:     db    13,10,'Файл найден!',13,10 
LFN	= $ - OFFSET FN 
