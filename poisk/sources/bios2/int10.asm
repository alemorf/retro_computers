;----INT 10---------------------------------------------------
;VIDEO_IO
;
;AH  Сервис                              AH  Сервис
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;00H уст. видео режим                    0aH писать символ
;01H уст. размер и форму курсора         0bH выбрать палитру/цвет бордюра
;02H уст. позицию курсора                0cH писать графическую точку
;03H читать позицию курсора              0dH читать графическую точку
;04H читать световое перо              ( 0eH писать символ в режиме TTY
;05H выбрать активную страницу(дисплея   0fH читать видео режим
;06H листать окно вверх (или очистить)   10H EGA уст. палитру
;07H листать окно вниз                   11H EGA генератор символов
;08H читать символ/атрибут               12H EGA специальные функции
;09H писать символ/атрибут               13H писать строку (только ▌AT▐ + EGA )
;
;────────────────────────────────────────────────────────────────────────────────
;00H уст. видео режим. Очистить экран, установить поля BIOS, установить режим.
;    Вход:  AL=режим
;           AL  Тип      Формат   Цвета          Адаптер  Адрес Монитор
;           ═══ ═══════  ═══════  ═════════════  ═══════  ════  ═════════════════
;            0  текст    40x25    16/8 полутона  CGA,EGA  b800  Composite
;            1  текст    40x25    16/8           CGA,EGA  b800  Comp,RGB,Enhanced
;            2  текст    80x25    16/8 полутона  CGA,EGA  b800  Composite
;            3  текст    80x25    16/8           CGA,EGA  b800  Comp,RGB,Enhanced
;            4  графика  320x200  4              CGA,EGA  b800  Comp,RGB,Enhanced
;            5  графика  320x200  4 полутона     CGA,EGA  b800  Composite
;            6  графика  640x200  2              CGA,EGA  b800  Comp,RGB,Enhanced
;            7  текст    80x25    3 (b/w/bold)   MA,EGA   b000  TTL Monochrome
;       8,9,0aH  режимы PCjr
;	ЭТИ РЕЖИМЫ НЕ ПОДДЕРЖИВАЮТСЯ
;           0dH графика  320x200  16             EGA      A000  RGB,Enhanced
;           0eH графика  640x200  16             EGA      A000  RGB,Enhanced
;           0fH графика  640x350  3 (b/w/bold)   EGA      A000  Enhanced,TTL Mono
;           10H графика  640x350  4 или 16       EGA      A000  Enhanced
;       0bH,0cH  (резервируется для EGA BIOS)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;01H уст. размер/форму курсора (текст). Курсор, если он видим, всегда мерцает.
;    Вход:  CH = начальная строка (0-1fH; 20H=подавить курсор)
;           CL = конечная строка (0-1fH)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;02H уст. позицию курсора. Установка на строку 25 делает курсор невидимым.
;    Вход:  BH = видео страница
;           DH,DL = строка, колонка (считая от 0)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;03H читать позицию и размер курсора
;    Вход:  BH = видео страница
;   Выход:  DH,DL = текущие строка,колонка курсора
;           CH,CL = текущие начальная,конечная строки курсора (см. функцию 01H)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;04H читать световое перо
;    Вход:  нет
;   Выход:  AH = триггер (0=нет значений; 1=возвращены значения светового пера)
;           DH,DL = строка,колонка символа (текст)
;           BX = колонка точки (графика)
;           CH = строка точки (для графики EGA возвращается в CX)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;05H выбрать активную страницу дисплея
;    Вход:  AL = номер страницы (большинство программ использует страницу 0)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;06H листать окно вверх (или очистить). Листать на 1 или более строк вверх.
;    Вход:  CH,CL = строка,колонка верхнего левого угла окна (считая от 0)
;           DH,DL = строка,колонка нижнего правого угла окна (считая от 0)
;           AL = число пустых строк, вдвигаемых снизу (0=очистить все окно)
;           BH = видео атрибут, используемый для пустых строк
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;07H листать окно вниз (вдвинуть пустые строки в верхнюю часть окна)
;    Вход:  (аналогично функции 06H)
;
;08H читать символ/атрибут в текущей позиции курсора
;    Вход:  BH = номер видео страницы
;   Выход:  AL = прочитанный символ
;           AH = прочитанный видео атрибут (только для текстовых режимов)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;09H писать символ/атрибут в текущей позиции курсора
;    Вход:  BH = номер видео страницы
;           AL = записываемый символ
;           CX = счетчик (сколько экземпляров символа записать)
;           BL = видео атрибут (текст) или цвет (графика)
;                (графические режимы: +80H означает XOR с символом на экране)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;0aH писать символ в текущей позиции курсора
;    Вход:  BH = номер видео страницы
;           AL = записываемый символ
;           CX = счетчик (сколько экземпляров символа записать)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;0bH выбрать цвет палитры/бордюра (CGA-совместимые режимы)
;    Вход:  BH = 0: (текст) выбрать цвет бордюра
;                   BL = цвет бордюра (0-1fH; от 10H до 1fH - интенсивные)
;           BH = 1: (графика) выбрать палитру
;                   BL = 0: палитра green/red/brown
;                   BL = 1: палитра cyan/magenta/white
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;0cH писать графическую точку (слишком медленно для большинства приложений!)
;    Вход:  BH = номер видео страницы
;           DX,CX = строка,колонка
;           AL = значение цвета (+80H означает XOR с точкой на экране)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;0dH читать графическую точку (слишком медленно для большинства приложений!)
;    Вход:  BH = номер видео страницы
;           DX,CX = строка,колонка
;   Выход:  AL = прочитанное значение цвета
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;
;
;0eH писать символ на активную видео страницу (эмуляция телетайпа)
;    Вход:  AL = записываемый символ (использует существующий атрибут)
;           BL = цвет переднего плана (для графических режимов)
;▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;0fH читать текущий видео режим
;    Вход:  нет
;   Выход:  AL = текущий режим (см. функцию 00H)
;           AH = число текстовых колонок на экране
;           BH = текущий номер активной страницы дисплея
;───────────────────────────────────────────────────────────────────────────────


        ASSUME CS:CODE,DS:DATA,ES:VIDEO_RAM
        ORG     0F045H
M1      LABEL   WORD          ;TABLE OF ROUTINES WITHIN VIDEO I/O
        DW      OFFSET SET_MODE
        DW      OFFSET SET_CTYPE
        DW      OFFSET SET_CPOS
        DW      OFFSET READ_CURSOR
        DW      OFFSET READ_LPEN
        DW      OFFSET ACT_DISP_PAGE
        DW      OFFSET SCROLL_UP
        DW      OFFSET SCROLL_DOWN
        DW      OFFSET READ_AC_CURRENT
        DW      OFFSET WRITE_AC_CURRENT
        DW      OFFSET WRITE_C_CURRENT
        DW      OFFSET SET_COLOR
        DW      OFFSET WRITE_DOT
        DW      OFFSET READ_DOT
        DW      OFFSET WRITE_TTY
        DW      OFFSET VIDEO_STATE
M1L     EQU     $-M1

        ORG     0F065H
VIDEO_IO        PROC   NEAR
        STI
        CLD
        PUSH    ES
        PUSH    DS
        PUSH    DX
        PUSH    CX
        PUSH    BX
        PUSH    SI
        PUSH    DI
        PUSH    AX            ;СОХРАНЕНИЕ AX
        MOV     AL,AH         ;ПЕРЕМЕЩЕНИЕ В МЛАДШИЙ БАЙТ
        XOR     AH,AH         ;ОБНУЛЕНИЕ СТАРШЕГО БАЙТА
        SAL     AX,1          ;*2 ДЛЯ ПОИСКА В ТАБЛИЦЕ
        MOV     SI,AX         ;ЗАГРУЗКА  В SI ДЛЯ ПЕРЕХОДА
        CMP     AX,M1L        ;ТЕСТ НА ПРАВИЛЬНЫЙ ДИАПОЗОН
        JB      M2            ;ОБХОД
        POP     AX            ;ВОССТАНОВЛЕНИЕ ПАРАМЕТРОВ ДЛЯ ПОВТОРЕНИЯ
        JMP     VIDEO_RETURN  ;НИЧЕГО НЕ ДЕЛАЕМ, Т.К. НЕ В ДИАПОЗОНЕ
M2:
        CALL    DDS
        MOV     AX,0B800H     ; УСТАНОВКА ВИДЕОПАМЯТИ В СООТВЕТСТВИИ
        MOV     DI,EQUIP_FLAG ; С EQUIP_FLAG
        AND     DI,30H        ;
        CMP     DI,30H        ;
        JNE     M3            ;
        MOV     AH,0B0H       ;MONOCHROM
M3:
        MOV     ES,AX         ;УКАЗАТЕЛЬ НА ВИДЕОПАМЯТЬ
        POP     AX
        MOV     AH,CRT_MODE   ;ПОЛУЧЕНИЕ ТЕКУЩЕЙ МОДЕЛИ В AH
        JMP     WORD PTR CS:[SI+OFFSET M1] ;ПЕРЕХОД НА НЕОБХОДИМУЮ ФУНКЦИЮ
VIDEO_IO        ENDP
;-------------------------------------------------------------------
;SET_MODE
;       УСТАНОВКА ВИДЕОРЕЖИМА
;ВХОД
;       (AL)=НОМЕР РЕЖИМА  (ДИАПОЗОН 0-9)
;ВЫХОД
;       НЕТ
;--------------------------------------------------------------------

;-------ТАБЛИЦА ИСПОЛЬЗУЕМАЯ ДЛЯ УСТАНОВКИ РЕЖИМА

        ORG     0F0A4H
VIDEO_PARMS     LABEL  BYTE
;-------INIT_TABLE
        DB      38H,28H,2AH,0AH,1FH,6,19H      ; 40*25
        DB      1CH,2,7,6,7
        DB      0,0,0,0
M4      EQU     $-VIDEO_PARMS

        DB      71H,50H,5AH,0AH,1FH,6,19H      ; 80*25
        DB      1CH,2,7,6,7
        DB      0,0,0,0

        DB      38H,28H,2AH,0AH,7FH,6,64H      ; ГРАФИКА
        DB      70H,2,1,6,7
        DB      0,0,0,0

        DB      61H,50H,52H,0FH,19H,6,19H      ; 80*25 B&W CARD
        DB      19H,2,0DH,0BH,0CH
        DB      0,0,0,0

M5      LABEL   WORD          ;ТАБЛИЦА ДЛИНЫ РЕГЕНЕРАЦИИ
        DW      2048          ;40*25
        DW      4096          ;80*25
        DW      16384         ;ГРАФИКА
        DW      16384

;-------СТОЛБЦЫ

M6      LABEL   BYTE
        DB      40,40,80,80,40,40,80,80

;-------C_REG_TAB
M7      LABEL   BYTE          ;ТАБЛИЦА РЕЖИМА
        DB      2CH,28H,2DH,29H,2AH,2EH,1EH,29H ;

SET_MODE        PROC   NEAR
        MOV     DX,03D4H      ;АДРЕС ЦВЕТНОЙ КАРТЫ
        MOV     BL,0          ;УСТАНОВКА МОДЕЛИ ДЛЯ ЦВЕТНОГО АДАПТЕРА
        CMP     DI,30H        ;ЕСЛИ УСТАНОВЛЕН ЧЕРНО/БЕЛЫЙ АДАПТЕР
        JNE     M8            ;OK ЦВЕТНОЙ АДАПТЕР
        MOV     AL,7          ;ИНДИКАЦИЯ ЧЕРНО/БЕЛОГО АДАПТЕРА
        MOV     DL,0B4H       ;АДРЕС Ч/Б АДАПТЕРА (384)
        INC     BL            ;УСТАНОВКА МОДЕЛИ ДЛЯ Ч/Б АДАПТЕРА
M8:
        MOV     AH,AL         ;СОХРАНЕНИЕ МОДЕЛИ В AH
        MOV     CRT_MODE,AL   ;ЗАПИСЬ В ГЛОБАЛЬНУЮ ЯЧЕЙКУ
        MOV     ADDR_6845,DX  ;ЗАПИСЬ БАЗОВОГО АДРЕСА
        PUSH    DS            ;СОХРАНЕНИЕ УКАЗАТЕЛЯ НА СЕГМЕНТ ДАННЫХ
        PUSH    AX            ;СОХРАНЕНИЕ МОДЕЛИ
        PUSH    DX            ;СОХРАНЕНИЕ АДРЕСА ПОРТА ВЫВОДА
        ADD     DX,4          ;УКАЗАТЕЛЬ НА РЕГИСТР КОНТРОЛЯ
        MOV     AL,BL         ;ПОЛУЧЕНИЕ ТИПА ВИДЕОАДАПТЕРА
        OUT     DX,AL         ;СБРОС АДАПТЕРА
        POP     DX            ;БАЗОВЫЙ РЕГИСТР
        SUB     AX,AX         ;УСТАНОВКА ДЛЯ ABSO СЕГМЕНТА
        MOV     DS,AX         ;УСТАНОВКА ВЕКТОРА ТАБЛИЦЫ ДАННЫХ
        ASSUME  DS:ABS0
        LDS     BX,PARM_PTR   ;ПОЛУЧЕНИЕ УКАЗАТЕЛЯ НА ВИДЕО ПАРАМЕТРЫ
        POP     AX            ;ВОЗВРАТ ПАРАМЕТРА
        ASSUME  DS:CODE
        MOV     CX,M4         ;ДЛИНА КАЖДОЙ СТРОКИ В ТАБЛИЦЕ
        CMP     AH,2          ;ОПРЕДЕЛЯЕМ КТО ИСПОЛЬЗУЕТСЯ
        JC      M9            ;МОДЕЛЬ ЭТА 0 ИЛИ 1
        ADD     BX,CX         ;ПЕРЕХОД НА СЛЕДУЮЩУЮ СТРОКУ В ТАБЛИЦЕ
        CMP     AH,4
        JC      M9            ;МОДЕЛЬ 2 ИЛИ 3
        ADD     BX,CX         ;ПЕРЕХОД НА ГРАФИЧЕСКУЮ СТРОКУ В INIT_TABLE
        CMP     AH,7
        JC      M9            ;МОДЕЛЬ  4,5 ИЛИ 6
        ADD     BX,CX         ;ПЕРЕХОДИМ НА Ч/БЕЛ В INIT_TABLE

;-------BX УКАЗЫВАЕТ НА ПРАВИЛЬНУЮ СТРОКУ В ТАБЛИЦЕ ИНИЦИАЛИЗАЦИИ

M9:                           ;OUT_INIT
        PUSH    AX            ;СОХРАНЕНИЕ МОДЕЛИ
        XOR     AH,AH         ;AH ДЛЯ СЧЕТЧИКА ТЕЧЕНИЯ ОПЕРАЦИИ

;-------ПОЛУЧАЕМ АДРЕСА РЕГИСТРОВ

M10:                          ;УСТАНОВКА СЧЕТЧИКА
        MOV     AL,AH         ;ПОЛУЧЕНИЕ НОМЕРА РЕГИСТРА 6845
        OUT     DX,AL
        INC     DX            ;УКАЗАТЕЛЬ НА ПОРТ ДАННЫХ
        INC     AH            ;СЛЕДУЮЩИЙ РЕГИСТР
        MOV     AL,[BX]       ;ПОЛУЧЕНИЕ ЗНАЧЕНИЯ ИЗ ТАБЛИЦЫ
        OUT     DX,AL         ;ЗАПИСЬ В ЧИП
        INC     BX            ;СЛЕДУЮЩИЙ ИЗ ТАБЛИЦЫ
        DEC     DX
        LOOP    M10           ;ПРОХОДИМ ВСЮ ТАБЛИЦУ
        POP     AX            ;ПОЛУЧЕНИЕ РЕЖИМА
        POP     DS            ;ВОССТАНОВЛЕНИЕ ЗНАЧЕНИЯ СЕГМЕНТА
        ASSUME  DS:DATA

;-------ЗАПОЛНЕНИЕ ОБЛАСТИ РЕГЕНЕРАЦИИ

        XOR     DI,DI         ;УСТАНОВКА УКАЗАТЕЛЯ НА ОБЛАСТЬ РЕГЕНЕРАЦИИ
        MOV     CRT_START,DI  ;СТАРТОВЫЙ АДРЕС ЗАПИСЫВАЕМ В ГЛОБАЛЬНУЮ ЯЧЕЙКУ
        MOV     ACTIVE_PAGE,0 ;УСТАНОВКА ЗНАЧЕНИЯ СТРАНИЦЫ
        MOV     CX,8192       ;ЧИСЛО СЛОВ В ЦВЕТНОМ АДАПТЕРЕ
        CMP     AH,4          ;ТЕСТ ГРАФИКИ
        JC      M12           ;NO_GRAPHICS_INIT
        CMP     AH,7          ;ТЕСТ Ч/Б
        JE      M11           ;BW_CARD_INIT
        XOR     AX,AX         ;ЗАПОЛНЕНИЕ ДЛЯ ГРАФИЧЕСКОЙ МОДЕЛИ
        JMP     SHORT M13     ;CLEAR_BUFFER
M11:                          ;BW_CARD_INIT
        MOV     CH,08H        ;РАЗМЕР БУФЕРА ДЛЯ Ч/Б
M12:                          ;NO_GRAPHICS_INIT
        MOV     AX,' '+7*256  ;ЗАПОЛНЕНИЕ СИМВОЛОВ
M13:                          ;CLEAR_BUFFER
        REP     STOSW         ;ЗАПОЛНЕНИЕ РЕГЕНЕРИРУЕМОГО БУФЕРА

;------РАЗРЕШЕНИЕ ВИДЕО И УСТАНОВКА ПОРТОВ

        MOV     CURSOR_MODE,607H ;УСТАНОВКА РАЗМЕРА КУРСОРА
        MOV     AL,CRT_MODE   ;ПОЛУЧЕНИЕ МОДЕЛИ
        XOR     AH,AH         ;ЗНАЧЕНИЕ В AX РЕГИСТРЕ
        MOV     SI,AX         ;УКАЗАТЕЛЬ НА ТАБЛИЦУ
        MOV     DX,ADDR_6845  ;ПОДГОТОВКА ДЛЯ ЗАПИСИ В ВИДЕО ПОРТ
        ADD     DX,4
        MOV     AL,CS:[SI+OFFSET M7]
        OUT     DX,AL         ;УСТАНОВКА РАЗРЕШЕНИЯ ЗАПИСИ
        MOV     CRT_MODE_SET,AL  ;ЗАПИСЬ ЗНАЧЕНИЯ

;------ОПРЕДЕЛЕНИЕ ЧИСЛА СТОЛБЦОВ ДЛЯ ЗАПОЛНЕНИЯ ДИСПЛЕЯ

        MOV     AL,CS:[SI+OFFSET M6]
        XOR     AH,AH
        MOV     CRT_COLS,AX   ;ЧИСЛО СТОЛБЦОВ В ЭТОМ ОКНЕ

;-------УСТАНОВКА ПОЗИЦИИ КУРСОРА

        AND     SI,0EH        ;СМЕЩЕНИЕ СЛОВА ОЧИСТКИ
        MOV     CX,CS:[SI+OFFSET M5] ;ДЛИНА ОЧИСТКИ
        MOV     CRT_LEN,CX    ;ЗАПИСЬ ДЛИНЫ НЕ ИСПОЛЬЗУЕМОЙ В Ч/Б МОДЕЛИ
        MOV     CX,8          ;ОЧИСТКА ПОЗИЦИЙ КУРСОРА   
        MOV     DI,OFFSET CURSOR_POSN
        PUSH    DS            ;УСТАНОВКА СЕГМЕНТА
        POP     ES            ;  АДРЕСА    
        XOR     AX,AX
        REP     STOSW         ;ЗАПОЛНЕНИЕ НУЛЯМИ

;------SET UP OVERSCAN REGISTER

        INC     DX            ;SET OVERSCAN PORT TO A DEFAULT
        MOV     AL,30H        ;VALUE OF 30H FOR ALL MODES EXEPT 640*200
        CMP     CRT_MODE,6    ;SEE IF THE MODE IS 640*200 BW
        JNZ     M14           ;IF IT ISNT 640*200,THEN GOTO REGULAR
        MOV     AL,3FH        ;IF IT IS 640*200, THEN PUT IT 3FH
M14:
        OUT     DX,AL         ;OUTPUT THE CORRECT VALUE TO 3D9 PORT
        MOV     CRT_PALETTE,AL  ;SAVE THE VALUE FOR FUTURE USE

;------ NORMAL RETURN FROM ALL VIDEO RETURNS

VIDEO_RETURN:
        POP     DI
        POP     SI
        POP     BX
M15:                          ;VIDEO_RETURN_C
        POP     CX
        POP     DX
        POP     DS
        POP     ES            ;RECOVER SEGMENTS
        IRET                  ;ALL DONE
SET_MODE        ENDP
;-------------------------------------------------------------------------
; SET_CTYPE
;       THIS ROUTINE SETS THE CURSOR VALUE
; INPUT
;       (CX) HAS CURSOR VALUE CH-START LINE, CL-STOP LINE
; OUTPUT
;       NONE
;---------------------------------------------------------------------------
SET_CTYPE       PROC   NEAR
        MOV     AH,10                ;6845 REGISTER FOR CURSOR SET
        MOV     CURSOR_MODE,CX       ;SAVE IN DATA AREA
        CALL    M16                  ;OUTPUT CX REG
        JMP     VIDEO_RETURN

;-----THIS ROUTINE OUTPUTS THE CX REGISTER TO THE 6845 REGS NAMED IN AH

M16:
        MOV     DX,ADDR_6845         ;ADDRESS REGISTER
        MOV     AL,AH                ;GET VALUE
        OUT     DX,AL                ;REGISTER SET
        INC     DX                   ;DATA REGISTER
        MOV     AL,CH                ;DATA
        OUT     DX,AL
        DEC     DX
        MOV     AL,AH
        INC     AL                   ;POINT TO OTHER DATA REGISTER
        OUT     DX,AL                ;SET FOR SECOND REGISTER
        INC     DX
        MOV     AL,CL                ;SECOND DATA VALUE
        OUT     DX,AL
        RET                          ;ALL DONE
SET_CTYPE       ENDP

;---------------------------------------------------------------------------
; SET_CPOS
;       THIS ROUTINE SETS THE CURRENT CURSOR POSITION TO THE
;       NEW X-Y VALUES PASSED
; INPUT
;       DX-ROW,COLUMN OF NEW CURSOR
;       BH-DISPLAY PAGE OF CURSOR
; OUTPUT
;       CURSOR IS SET AT 6845 IF DISPLAY PAGE IS CURRENT DISPLAY
;--------------------------------------------------------------------------
SET_CPOS        PROC   NEAR
        MOV     CL,BH
        XOR     CH,CH                ;ESTABLISH LOOP COUNT
        SAL     CX,1                 ;WORD OFFSET
        MOV     SI,CX                ;USE INDEX REGISTER
        DB      89H,54H,50H    ;MOV     [SI+OFFSET CURSOR_POSN],DX
                                     ;SAVE THE POINTER
        CMP     ACTIVE_PAGE,BH
        JNZ     M17                  ;SET_CPOS_RETURN
        MOV     AX,DX                ;GET ROW/COLUMN TO AX
        CALL    M18                  ;CURSOR_SET
M17:                                 ;SET_CPOS_PETURN
        JMP     VIDEO_RETURN
SET_CPOS        ENDP

;-----SET CURSOR POSITION, AX HAS ROW/COLUMN FOR CURSOR

M18     PROC    NEAR
        CALL    POSITION             ;DETERMINE LOCATION IN REGEN BUFFER
        MOV     CX,AX
        ADD     CX,CRT_START         ;ADD IN THE START ADDR FOR THIS
                                     ;PAGE
        SAR     CX,1                 ;DIVIDE BY 2 FOR CHAR ONLY COUNT
        MOV     AH,14                ;REGISTER NUMBER FOR CURSOR
        CALL    M16                  ;OUTPUT THE VALUE TO THE 6845
        RET
M18     ENDP
;-------------------------------------------------------------------------
; ACT_DISP_PAGE
;       THIS ROUTINE SETS THE ACTIVE DISPLAY PAGE, ALLOWING
;       THE FULL USE OF THE RAM SET ASIDE FOR THE VIDEO ATTACHMENT
; INPUT
;       AL HAS THE NEW ACTIVE DISPLAY PAGE
; OUTPUT
;       THE 6845 IS RESET TO DISPLAY THAT PAGE
;--------------------------------------------------------------------------
ACT_DISP_PAGE   PROC   NEAR
        MOV     ACTIVE_PAGE,AL       ;SAVE ACTIVE PAGE VALUE
        MOV     CX,CRT_LEN           ;GET SAVED LENGTH OF REGEN BUFFER
        CBW                          ;CONVERT AL TO WORD
        PUSH    AX                   ;SAVE PAGE VALUE
        MUL     CX                   ;DISPLAY PAGE TIMES REGEN LENGTH
        MOV     CRT_START,AX         ;SAVE START ADDRESS FOR LATER
                                     ;REQUIREMENTS
        MOV     CX,AX                ;START ADDRESS TO CX
        SAR     CX,1                 ;DIVIDE BY 2 FOR 6845 HANDLING
        MOV     AH,12                ;6845 REGISTER FOR START ADDRESS
        CALL    M16
        POP     BX                   ;RECOVER PAGE VALUE
        SAL     BX,1                 ;*2 FOR WORD OFFSET
        DB      8BH,47H,50H ;MOV AX,[BX+OFFSET CURSOR_POSN] ;GET CURSOR FOR THIS PAGE
        CALL    M18                  ;SET THE CURSOR POSITION
        JMP     SHORT VIDEO_RETURN
ACT_DISP_PAGE   ENDP
;-------------------------------------------------------------------------
; READ_CURSOR
;       THIS ROUTINE READS THE CURRENT CURSOR VALUE FROM THE
;       6845, FORMATS IT, AND SENDS IT BACK TO THE CALLER
; INPUT
;       BH-PAGE OF CURSOR
; OUTPUT
;       DX-ROW,COLUMN OF THE CURRENT CURSOR POSITION
;       CX-CURRENT_CURSOR_MODE
;--------------------------------------------------------------------------
READ_CURSOR     PROC   NEAR
        MOV     BL,BH
        XOR     BH,BH
        SAL     BX,1                 ;WORD OFFSET
        DB      8BH,57H,50H      ;MOV  DX,[BX+OFFSET CURSOR_POSN]
        MOV     CX,CURSOR_MODE
        POP     DI
        POP     SI
        POP     BX
        POP     AX                   ;DISCARD SAVED CX AND DX
        POP     AX
        POP     DS
        POP     ES
        IRET
READ_CURSOR     ENDP
;-------------------------------------------------------------------------
;SET COLOR
;       THIS ROUTINE WILL ESTABLISH THE BACKGROUND COLOR, THE OVERSCAN COLOR,
;       AND THE FOREGROUND COLOR SET FOR MEDIUM RESOLUTION GRAPHICS
;INPUT
;       (BH) HAS COLOR IO
;               IF BH=0, THE BACKGROUND COLOR VALUE IS SET
;                       FROM THE LOW BITS OF BL (0-31)
;               IF BH=1, THE PALLETTE SELECTION IS MADE
;                       BASED ON THE LOW BIT OF BL:
;                             0=GREEN, RED, YELLOW FOR COLORS 1,2,3
;                             1=BLUE,CYAN,MAGENTA FOR COLORS 1,2,3
;       (BL) HAS THE COLOR VALUE TO BE USED
; OUTPUT
;       THE COLOR SELECTION IS UPDATED
;---------------------------------------------------------------------------
SET_COLOR       PROC   NEAR
        MOV     DX,ADDR_6845         ;I/O PORT FOR PALLETTE
        ADD     DX,5                 ;OVERSCAN PORT
        MOV     AL,CRT_PALETTE       ;GET THE CURRENT PALETTE VALUE
        OR      BH,BH                ;IS THIS COLOR 0?
        JNZ     M20                  ;OUTPUT COLOR 1

;------HANDLE COLOR 0 BY SETTING THE BACKGROUND COLOR

        AND     AL,0E0H              ;TURN OFF LOW 5 BITS OF CURRENT
        AND     BL,01FH              ;TURN OFF HIGH 3 BITS OF INPUT VALUE
        OR      AL,BL                ;PUT VALUE INTO REGISTER
M19:                                 ;OUTPUT THE PALETTE
        OUT     DX,AL                ;OUTPUT COLOR SELECTION TO 3D9 PORT
        MOV     CRT_PALETTE,AL       ;SAVE THE COLOR VALUE
        JMP     VIDEO_RETURN

;------HANDLE COLOR 1 BY SELECTING THE PALETTE TO BE USED

M20:
        AND     AL,0DFH              ;TURN OFF PALETTE SELECT BIT
        SHR     BL,1                 ;TEST THE LOW ORDER BIT OF BL
        JNC     M19                  ;ALREADY DONE
        OR      AL,20H               ;TURN ON PALETTE SELECT BIT
        JMP     M19                  ;GO DO IT
SET_COLOR       ENDP
;--------------------------------------------------------------------------
;VIDEO STATE
; RETURNS THE CURRENT VIDEO STATE IN AX
; AH = NUMBER OF COLUMNS ON THE SCREEN
; AL = CURRENT VIDEO MODE
; BH = CURRENT ACTIVE PAGE
;----------------------------------------------------------------------------
VIDEO_STATE     PROC   NEAR
        MOV     AH,BYTE PTR CRT_COLS ;GET NUMBER OF COLUMNS
        MOV     AL,CRT_MODE          ;CURRENT MODE
        MOV     BH,ACTIVE_PAGE       ;GET CURRENT ACTIVE PAGE
        POP     DI                   ;RECOVER REGISTERS
        POP     SI
        POP     CX                   ;DISCARD SAVED BX
        JMP     M15                  ;RETURN TO CALLER
VIDEO_STATE     ENDP
;----------------------------------------------------------------------------
; POSITION
;       THIS SERVICE ROUTINE CALCULATES THE REGEN BUFFER ADDRESS
;       OF A CHARACTER IN THE ALPHA MODE
;INPUT
;       AX = ROW,COLUMN POSITION
;OUTPUT
;       AX = OFFSET OF CHAR POSITION IN REGEN BUFFER
;----------------------------------------------------------------------------
POSITION        PROC   NEAR
        PUSH    BX                   ;SAVE REGISTER
        MOV     BX,AX
        MOV     AL,AH                ;ROWS TO AL
        MUL     BYTE PTR CRT_COLS    ;DETERMINE BYTES TO ROW
        XOR     BH,BH
        ADD     AX,BX                ;ADD IN COLUMN VALUE
        SAL     AX,1                 ;* 2 FOR ATTRIBUTE BYTES
        POP     BX
        RET
POSITION        ENDP
;------------------------------------------------------------------------------
;SCROLL UP
;       THIS ROUTINE MOVES A BLOCK OF CHARACTERS UP
;       ON THE SCREEN
;INPUT
;       (AH)= CURRENT CRT MODE
;       (AL)= NUMBER OF ROWS TO SCROLL
;       (CX)= ROW/COLUMN OF UPPER LEFT CORNER
;       (DX)= ROW/COLUMN OF LOWER RIGHT CORNER
;       (BH)= ATTRIBUTE TO BE USED ON BLANKED LINE
;       (DS)= DATA SEGMENT
;       (ES)= REGEN BUFFER SEGMENT
;OUTPUT
;       NONE-- THE REGEN BUFFER IS MODIFIED
;------------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA,ES:DATA
SCROLL_UP       PROC   NEAR
        MOV     BL,AL                ;SAVE LINE COUNT IN BL
        CMP     AH,4                 ;TEST FOR GRAPHICS MODE
        JC      N1                   ;HANDLE SEPARATELY
        CMP     AH,7                 ;TEST FOR BW CARD
        JE      N1
        JMP     GRAPHICS_UP
N1:                                  ;UP_CONTINUE
        PUSH    BX                   ;SAVE FILL ATTRIBUTE IN BH
        MOV     AX,CX                ;UPPER LEFT POSITION
        CALL    SCROLL_POSITION      ;DO SETUP FOR SCROLL
        JZ      N7                   ;BLANK_FIELD
        ADD     SI,AX                ;FROM ADDRESS
        MOV     AH,DH                ;# ROWS IN BLOCK
        SUB     AH,BL                ;# ROWS TO BE MOVED
N2:                                  ;ROW_LOOP
        CALL    N10                  ;MOVE ONE ROW
        ADD     SI,BP
        ADD     DI,BP                ;POINT TO NEXT LINE IN BLOCK
        DEC     AH                   ;COUNT OF LINES TO MOVE
        JNZ     N2                   ;ROW_LOOP
N3:                                  ;CLEAR_ENTRY
        POP     AX                   ;RECOVER ATTRIBUTE IN AH
        MOV     AL,' '               ;FILL WITH BLANKS
N4:                                  ;CLEAR_LOOP
        CALL    N11                  ;CLEAR THE ROW
        ADD     DI,BP                ;POINT TO NEXT LINE
        DEC     BL                   ;COUNTER OF LINES TO SCROLL
        JNZ     N4                   ;CLEAR_LOOP
N5:                                  ;SCROLL_END
        CALL    DDS
        CMP     CRT_MODE,7           ;IS THIS THE BLACK AND WHITE CARD
        JE      N6                   ;IF SO,SKIP THE MODE RESET
        MOV     AL,CRT_MODE_SET      ;GET THE VALUE OF THE MODE SET
        MOV     DX,03D8H             ;ALWAYS SET COLOR CARD PORT
        OUT     DX,AL
N6:                                  ;VIDEO_RET_HERE
        JMP     VIDEO_RETURN
N7:                                  ;BLANK_FIELD
        MOV     BL,DH                ;GET ROW COUNT
        JMP     N3                   ;GO CLEAR THAT AREA
SCROLL_UP       ENDP

;------HANDLE COMMON SCROLL SET UP HERE

SCROLL_POSITION PROC NEAR
        CMP     CRT_MODE,2           ;TEST FOR SPECIAL CASE HERE
        JB      N9                   ;HAVE TO HANDLE 80*25 SEPARATELY
        CMP     CRT_MODE,3
        JA      N9

;------80*25 COLOR CARD SCROLL

        PUSH    DX
        MOV     DX,3DAH              ;GUARANTEED TO BE COLOR CARD HERE
        PUSH    AX
N8:                                  ;WAIT_DISP_ENABLE
;       IN      AL,DX                ;GET PORT
;       TEST    AL,8                 ;WAIT FOR VERTICAL RETRACE
;       JZ      N8                   ;WAIT_DISP_ENABLE
    ;    MOV     AL,2dh     ; 25H
    ;    MOV     DL,0D8H              ;DX=3D8
    ;    OUT     DX,AL                ;TURN OFF VIDEO
        POP     AX                   ;DURING VERTICAL RETRACE
        POP     DX
N9:
        CALL    POSITION             ;CONVERT TO REGEN POINTER
        ADD     AX,CRT_START         ;OFFSET OF ACTIVE PAGE
        MOV     DI,AX                ;TO ADDRESS FOR SCROLL
        MOV     SI,AX                ;FROM ADDRESS FOR SCROLL
        SUB     DX,CX                ;DX=#ROWS,#COLS IN BLOCK
        INC     DH
        INC     DL                   ;INCREMENT FOR 0 ORIGIN
        XOR     CH,CH                ;SET HIGH BYTE OF COUNT TO ZERO
        MOV     BP,CRT_COLS          ;GET NUMBER OF COLUMNS IN DISPLAY
        ADD     BP,BP                ;TIMES 2 FOR ATTRIBUTE BYTE
        MOV     AL,BL                ;GET LINE COUNT
        MUL     BYTE PTR CRT_COLS    ;DETERMINE OFFSET TO FROM ADDRESS
        ADD     AX,AX                ;*2 FOR ATTRIBUTE BYTE
        PUSH    ES                   ;ESTABLISH ADDRESSING TO REGEN BUFFER
        POP     DS                   ;FOR BOTH POINTERS
        CMP     BL,0                 ;0 SCROLL MEANS BLANK FIELD
        RET                          ;RETURN WITH FLAGS SET
SCROLL_POSITION ENDP

;-----MOVE_ROW

N10     PROC    NEAR
        MOV     CL,DL                ;GET # OF COLS TO MOVE
        PUSH    SI
        PUSH    DI                   ;SAVE START ADDRESS
        REP     MOVSW                ;MOVE THAT LINE ON SCREEN

        POP     DI
        POP     SI                   ;RECOVER ADDRESSES
        RET
N10     ENDP

;-----CLEAR_ROW

N11     PROC    NEAR
        MOV     CL,DL                ;GET # COLUMNS TO CLEAR
        PUSH    DI
        REP     STOSW                ;STORE THE FILL CHARACTER

        POP     DI
        RET
N11     ENDP
;------------------------------------------------------------------------
;SCROLL_DOWN
;       THIS ROUTINE MOVES THE CHARACTERS WITHIN A DEFINED
;       BLOCK DOWN ON THE SCREEN, FILLING THE TOP LINES
;       WITH A DEFINED CHARACTER
;INPUT
;       (AH) = CURRENT CRT MODE
;       (AL) = NUMBER OF LINES TO SCROLL
;       (CX) = UPPER LEFT CORNER OF REGION
;       (DX) = LOWER RIGHT CORNER OF REGION
;       (BH) = FILL CHARACTER
;       (DS) = DATA SEGMENT
;       (ES) = REGEN SEGMENT
;OUTPUT
;       NONE -- SCREEN IS SCROLLED
;---------------------------------------------------------------------------
SCROLL_DOWN     PROC   NEAR
        STD                          ;DIRECTION FOR SCROLL DOWN
        MOV     BL,AL                ;LINE COUNT TO BL
        CMP     AH,4                 ;TEST FOR GRAPHICS
        JC      N12
        CMP     AH,7                 ;TEST FOR BW CARD
        JE      N12
        JMP     GRAPHICS_DOWN
N12:                                 ;CONTINUE_DOWN
        PUSH    BX                   ;SAVE ATTRIBUTE IN BH
        MOV     AX,DX                ;LOWER RIGHT CORNER
        CALL    SCROLL_POSITION      ;GET REGEN LOCATION
        JZ      N16
        SUB     SI,AX                ;SI IS FROM ADDRESS
        MOV     AH,DH                ;GET TOTAL # ROWS
        SUB     AH,BL                ;COUNT TO MOVE IN SCROLL
N13:
        CALL    N10                  ;MOVE ONE ROW
        SUB     SI,BP
        SUB     DI,BP
        DEC     AH
        JNZ     N13
N14:
        POP     AX                   ;RECOVER ATTRIBUTE IN AH
        MOV     AL,' '
N15:
        CALL    N11                  ;CLEAR ONE ROW
        SUB     DI,BP                ;GO TO NEXT ROW
        DEC     BL
        JNZ     N15
        JMP     N5                   ;SCROLL_END
N16:
        MOV     BL,DH
        JMP     N14
SCROLL_DOWN     ENDP
;-----------------------------------------------------------------------
;READ_AC_CURRENT
;       THIS ROUTINE READS THE ATTRIBUTE AND CHARACTER
;       AT THE CURRENT CURSOR POSITION AND RETURNS THEM
;       TO THE CALLER
;INPUT
;       (AH) = CURRENT CRT MODE
;       (BH) = DISPLAY PAGE ( ALPHA MODES ONLY )
;       (DS) = DATA SEGMENT
;       (ES) = REGEN SEGMENT
;OUTPUT
;       (AL) = CHAR READ
;       (AH) = ATTRIBUTE READ
;----------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA,ES:DATA
READ_AC_CURRENT PROC    NEAR
        CMP     AH,4                 ;IS THIS GRAPHICS
        JC      P1
        CMP     AH,7                 ;IS THIS BW CARD
        JE      P1
        JMP     GRAPHICS_READ
P1:                                  ;READ_AC_CONTINUE
        CALL    FIND_POSITION
        MOV     SI,BX                ;ESTABLISH ADDRESSING IN SI

;------WAIT FOR HORIZONTAL RETRACE

        MOV     DX,ADDR_6845         ;GET BASE ADDRESS
        ADD     DX,6                 ;POINT AT STATUS PORT
        PUSH    ES
        POP     DS                   ;GET SEGMENT FOR QUICK ACCESS
;P2:                                  ;WAIT FOR RETRACE LOW
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS HORZ RETRACE LOW
;        JNZ     P2                   ;WAIT UNTIL IT IS
        CLI                          ;NO MORE INTERRUPTS
;P3:                                  ;WAIT FOR RETRACE HIGH
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS IT HIGH
;        JZ      P3                   ;WAIT UNTIL IT IS
        LODSW                        ;GET THE CHAR/ATTR
        JMP     VIDEO_RETURN
READ_AC_CURRENT ENDP

FIND_POSITION   PROC   NEAR
        MOV     CL,BH                ;DISPLAY PAGE TO CX
        XOR     CH,CH
        MOV     SI,CX                ;MOVE TO SI FOR INDEX
        SAL     SI,1                 ;* 2 FOR WORD OFFSET
        DB      8BH,44H,50H   ;MOV     AX,[SI+ OFFSET CURSOR_POSN]
                                     ;GET ROW/COLUMN OF THAT PAGE
        XOR     BX,BX                ;SET START ADDRESS TO ZERO
        JCXZ    P5                   ;NO_PAGE
P4:                                  ;PAGE_LOOP
        ADD     BX,CRT_LEN           ;LENGTH OF BUFFER
        LOOP    P4
P5:                                  ;NO_PAGE
        CALL    POSITION             ;DETERMINE LOCATION IN REGEN
        ADD     BX,AX                ;ADD TO START OF REGEN
        RET
FIND_POSITION   ENDP
;---------------------------------------------------------------------------
;WRITE_AC_CURRENT
;       THIS ROUTINE WRITES THE ATTRIBUTE AND CHARACTER AT
;       THE CURRENT CURSOR POSITION
;INPUT
;       (AH) = CURRENT CRT MODE
;       (BH) = DISPLAY PAGE
;       (CX) = COUNT OF CHARACTERS TO WRITE
;       (AL) = CHAR TO WRITE
;       (BL) = ATTRIBUTE OF CHAR TO WRITE
;       (DS) = DATA SEGMEENT
;       (ES) = REGEN SEGMENT
;OUTPUT
;       NONE
;---------------------------------------------------------------------------
WRITE_AC_CURRENT        PROC  NEAR
        CMP     AH,4                 ;IS THIS GRAPHICS
        JC      P6
        CMP     AH,7                 ;IS THIS BW CARD
        JE      P6
        JMP     GRAPHICS_WRITE
P6:                                  ;WRITE_AC_CONTINUE
        MOV     AH,BL                ;GET ATTRIBUTE TO AH
        PUSH    AX                   ;SAVE ON STACK
        PUSH    CX                   ;SAVE WRITE COUNT
        CALL    FIND_POSITION
        MOV     DI,BX                ;ADDRESS TO DI REGISTER
        POP     CX                   ;WRITE COUNT
        POP     BX                   ;CHARACTER IN BX REG
P7:                                  ;WRITE_LOOP

;------WAIT FOR HORIZONTAL RETRACE

        MOV     DX,ADDR_6845         ;GET BASE ADDRESS
        ADD     DX,6                 ;POINT AT STATUS PORT
;P8:
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS IT LOW
;        JNZ     P8                   ;WAIT UNTIL IT IS
        CLI                          ;NO MORE INTERRUPTS
;P9:
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS IT HIGH
;        JZ      P9                   ;WAIT UNTIL IT IS
        MOV     AX,BX                ;RECOVER THE CHAR/ATTR
        STOSW                        ;PUT THE CHAR/ATTR
        STI                          ;INTERRUPTS BACK ON
        LOOP    P7                   ;AS MANY TIMES AS REQUESTED
        JMP     VIDEO_RETURN
WRITE_AC_CURRENT        ENDP

;----------------------------------------------------------------------------
;WRITE_C_CURRENT
;       THIS ROUTINE WRITES THE CHARACTER AT
;       THE CURRENT CURSOR POSITION, ATTRIBUTE UNCHANGED
;INPUT
;       (AH) = CURRENT CRT MODE
;       (BH) = DISPLAY PAGE
;       (CX) = COUNT OF CHARACTERS TO WRITE
;       (AL) = CHAR TO WRITE
;       (DS) = DATA SEGMENT
;       (ES) = REGEN SEGMENT
;OUTPUT
;       NONE
;-----------------------------------------------------------------------------
WRITE_C_CURRENT PROC    NEAR
        CMP     AH,4                 ;IS THIS CRAPHICS
        JC      P10
        CMP     AH,7                 ;IS THIS BW CARD
        JE      P10
        JMP     GRAPHICS_WRITE
P10:
        PUSH    AX                   ;SAVE ON STACK
        PUSH    CX                   ;SAVE WRITE COUNT
        CALL    FIND_POSITION
        MOV     DI,BX                ;ADDRESS TO DI
        POP     CX                   ;WRITE COUNT
        POP     BX                   ;BL HAS CHAR TO WRITE
P11:                                 ;WRITE_LOOP

;------WAIT FOR HORIZONTAL RETRACE

;        MOV     DX,ADDR_6845         ;GET BASE ADDRESS
;        ADD     DX,6                 ;POINT AT STATUS PORT
;P12:
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS IT LOW
;        JNZ     P12                  ;WAIT UNTIL IT IS
        CLI                          ;NO MORE INTERRUPTS
;P13:
;        IN      AL,DX                ;GET STATUS
;        TEST    AL,1                 ;IS IT HIGH
;        JZ      P13                  ;WAIT UNTIL IT IS
        MOV     AL,BL                ;RECOVER CHAR
        STOSB                        ;PUT THE CHAR/ATTR
        STI                          ;INTERRUPTS BACK ON
        INC     DI                   ;BUMP POINTER PAST ATTRIBUTE
        LOOP    P11                  ;AS MANY TIMES AS REQUESTED
        JMP     VIDEO_RETURN
WRITE_C_CURRENT ENDP

;----------------------------------------------------------------------------
;READ DOT  --  WRITE DOT
;      THESE ROUTINES WILL WRITE A DOT, OR READ THE
; DOT AT THE INDICATED LOCATION
;ENTRY --
;  DX = ROW (0-199)   (THE ACTUAL VALUE DEPENDS ON THE MODE)
;  CX = COLUMN (0-639) (THE VALUES ARE NOT RANGE CHECKED)
;  AL = DOT VALUE TO WRITE (1,2 OR 4 BITS DEPENDING ON MODE,
;      REQ'D FOR WRITE DOT ONLY, RIGHT JUSTIFIED)
;      BIT 7 OF AL = 1 INDICATES XOR THE VALUE INTO THE LOCATION
;  DS = DATA SEGMENT
;  ES = REGEN SEGMENT
;
;EXIT
;       AL = DOT VALUE READ,RIGHT JUSTIFIED, READ ONLY
;----------------------------------------------------------------------------
        ASSUME CS:CODE,DS:DATA,ES:DATA
READ_DOT        PROC   NEAR
        CALL    R3            ;DETERMINE BYTE POSITION OF DOT
        MOV     AL,ES:[SI]    ;GET THE BYTE
        AND     AL,AH         ;MASK OFF THE OTHER BITS IN THE BYTE
        SHL     AL,CL         ;LEFT JUSTIFY THE VALUE
        MOV     CL,DH         ;GET NUMBER OF BITS IN RESULT
        ROL     AL,CL         ;RIGHT JUSTIFY THE RESULT
        JMP     VIDEO_RETURN  ;RETURN FROM VIDEO IO
READ_DOT        ENDP

WRITE_DOT       PROC   NEAR
        PUSH    AX            ;SAVE DOT VALUE
        PUSH    AX            ;TWICE
        CALL    R3            ;DETERMINE BYTE POSITION OF THE DOT
        SHR     AL,CL         ;SHIFT TO SET UP THE BITS FOR OUTPUT
        AND     AL,AH         ;STRIP OFF THE OTHER BITS
        MOV     CL,ES:[SI]    ;GET THE CURRENT BYTE
        POP     BX            ;RECOVER XOR FLAG
        TEST    BL,80H        ;IS IT ON
        JNZ     R2            ;YES, XOR THE DOT
        NOT     AH            ;SET THE MASK TO REMOVE THE INDICATED BITS
        AND     CL,AH         ;INDICATED BITS
        OR      AL,CL         ;OR IN THE NEW VALUE OF THOSE BITS
R1:                           ;FINISH_DOT
        MOV     ES:[SI],AL    ;RESTORE THE BYTE IN MEMORY
        POP     AX
        JMP     VIDEO_RETURN  ;RETURN FROM VIDEO IO
R2:                           ;XOR_DOT
        XOR     AL,CL         ;EXCLUSIVE OR THE DOTS
        JMP     R1            ;FINISH UP THE WRITING
WRITE_DOT       ENDP
;--------------------------------------------------------------------------
;THIS SUBROUTINE DETERMINES THE REGEN BYTE LOCATION OF THE
;INDICATED ROW COLUMN VALUE IN GRAPHICS MODE.
;ENTRY --
; DX = ROW VALUE (0-199)
; CX = COLUMN VALUE (0-639)
;EXIT --
; SI = OFFSET INTO REGEN BUFFER FOR BYTE OF INTEREST
; AH = MASK TO STRIP OFF THE BITS OF INTEREST
; CL = BITS TO SHIFT TO RIGHT JUSTIFY THE MASK IN AH
; DH = # BITS IN RESULT
;-----------------------------------------------------------------------------
R3      PROC    NEAR
        PUSH    BX                   ;SAVE BX DURING OPERATION
        PUSH    AX                   ;WILL SAVE AL DURING OPERATION

;------DETERMINE IST BYTE IN IDICATED ROW BY MULTIPLYING ROW VALUE BY 40
;------( LOW BIT OF ROW DETERMINES EVEN/ODD, 80 BYTES/ROW

        MOV     AL,40
        PUSH    DX                   ;SAVE ROW VALUE
        AND     DL,0FEH              ;STRIP OFF ODD/EVEN BIT
        MUL     DL                   ;AX HAS ADDRESS OF IST BYTE OF
                                     ;INDICATED ROW
        POP     DX                   ;RECOVER IT
        TEST    DL,1                 ;TEST FOR EVEN/ODD
        JZ      R4                   ;JUMP IF EVEN ROW
        ADD     AX,2000H             ;OFFSET TO LOCATION OF ODD ROWS
R4:                                  ;EVEN_ROW
        MOV     SI,AX                ;MOVE POINTER TO SI
        POP     AX                   ;RECOVER AL VALUE
        MOV     DX,CX                ;COLUMN VALUE TO DX

;-------DETERMINE GRAPHICS MODE CURRENTLY IN EFFECT
;--------------------------------------------------------------------
;SET UP THE REGISTERS ACCORDING TO THE MODE
;  CH = MASK FOR LOW OF COLUMN ADDRESS ( 7/3 FOR HIGH/MED RES)
;  CL = # OF ADDRESS BITS IN COLUMN VALUE ( 3/2 FOR H/M)
;  BL = MASK TO SELECT BITS FROM POINTED BYTE (80H/C0H FOR H/M)
;  BH = NUMBER OF VALID BITS IN POINTED BYTE ( 1/2 FOR H/M)
;---------------------------------------------------------------------

        MOV     BX,2C0H
        MOV     CX,302H              ;SET PARMS FOR MED RES
        CMP     CRT_MODE,6
        JC      R5                   ;HANDLE IN MED ARES
        MOV     BX,180H
        MOV     CX,703H              ;SET PARMS FOR HIGH RES

;------DETERMINE BIT OFFSET IN BYTE FROM COLUMN MASK
R5:
        AND     CH,DL                ;ADDRESS OF PEL WITHIN BYTE TO CH

;------DETERMINE BYTE OFFSET FOR THIS LOCATION IN COLUMN

        SHR     DX,CL                ;SHIFT BY CORRECT AMOUNT
        ADD     SI,DX                ;INCREMENT THE POINTER
        MOV     DH,BH                ;GET THE # OF BITS IN RESULT TO DH

;------MULTIPLY BH (VALID BITS IN BYTE) BY CH (BIT OFFSET)

        SUB     CL,CL                ;ZERO INTO STORAGE LOCATION
R6:
        ROR     AL,1                 ;LEFT JUSTIFY THE VALUE IN AL
                                     ;(FOR WRITE)
        ADD     CL,CH                ;ADD IN THE BIT OFFSET VALUE
        DEC     BH                   ;LOOP CONTROL
        JNZ     R6                   ;ON EXIT, CL HAS SHIFT COUNT
                                     ;TO RESTORE BITS
        MOV     AH,BL                ;GET MASK TO AH
        SHR     AH,CL                ;MOVE THE MASK TO CORRECT LOCATION
        POP     BX                   ;RECOVER REG
        RET                          ;RETURN WITH EVERYTHING SET UP
R3      ENDP

;----------------------------------------------------------------------------
;SCROLL UP
;  THIS ROUTINE SCROLLS UP THE INFORMATION ON THE CRT
;ENTRY --
; CH,CL = UPPER LEFT CORNER OF REGION TO SCROLL
; DH,DL = LOWER RIGHT CORNER OF REGION TO SCROLL
;  BOTH OF THE ABOVE ARE IN CHARACTER POSITIONS
; BH = FILL VALUE FOR BLANKED LINES
; AL = # LINES TO SCROLL (AL=0 MEANS BLANK THE ENTIRE FIELD)
; DS = DATA SEGMENT
; ES = REGEN SEGMENT
;EXIT--
; NOTHING, THE SCREEN IS SCROLLED
;----------------------------------------------------------------------------
GRAPHICS_UP     PROC   NEAR
        MOV     BL,AL                ;SAVE LINE COUNT IN BL
        MOV     AX,CX                ;GET UPPER LEFT POSITION INTO AX REG

;------USE CHARACTER SUBROUTINE FOR POSITIONING
;------ADDRESS RETURNED IS MULTIPLIED BY 2 FROM CORRECT VALUE

        CALL    GRAPH_POSN
        MOV     DI,AX                ;SAVE RESULT AS DESTINATION ADDRESS

;------DETERMINE SIZE OF WINDOW
        SUB     DX,CX
        ADD     DX,101H              ;ADJUST VALUES
        SAL     DH,1                 ;MULTIPLY # ROUSE BY 4 SINCE 8 VERT
                                     ;DOTS/CHAR
        SAL     DH,1                 ;AND EVEN/ODD ROWS

;-------DETERMINE CRT MODE

        CMP     CRT_MODE,6           ;TEST FOR MEDIUM RES
        JNC     R7                   ;FIND_SOURCE

;------MEDIUM RES UP

        SAL     DL,1                 ;# COLUMNS * 2, SINCE 2 BYTES/CHAR
        SAL     DI,1                 ;OFFSET * 2 SINCE 2 BYTES/CHAR

;------DETERMINE THE SOURCE ADDRESS IN THE BUFFER

R7:                                  ;FIND_SOURCE
        PUSH    ES                   ;GET SEGMENTS BOTH POINTING TO REGEN
        POP     DS
        SUB     CH,CH                ;ZERO TO HIGH OF COUNT REG
        SAL     BL,1                 ;MULTIPLY NUMBER OF LINES BY 4
        SAL     BL,1
        JZ      R11                  ;IF ZERO THEN BLANK ENTIRE FIELD
        MOV     AL,BL                ;GET NUMBER OF LINES IN AL
        MOV     AH,80                ;80 BYTES/ROW
        MUL     AH                   ;DETERMINE OFFSET TO SOURCE
        MOV     SI,DI                ;SET UP SOURCE
        ADD     SI,AX                ;ADD IN OFFSET TO IT
        MOV     AH,DH                ;NUMBER OF ROWS IN FIELD
        SUB     AH,BL                ;DETERMINE NUMBER TO MOVE

;------LOOP THROUGH,MOVING ONE ROW AT A TIME,BOTH EVEN AND ODD FIELDS
R8:                                  ;ROW_LOOP
        CALL    R17                  ;MOVE ONE ROW
        SUB     SI,2000H-80          ;MOVE THE NEXT ROW
        SUB     DI,2000H-80
        DEC     AH                   ;NUMBER OF ROWS TO MOVE
        JNZ     R8                   ;CONTINUE TILL ALL MOVED

;------FILL IN THE VACATED LINE(S)
R9:                                  ;CLEAR_ENTRY
        MOV     AL,BH                ;ATTRIBUTE TO FILL WITH
R10:
        CALL    R18                  ;CLEAR THAT ROW
        SUB     DI,2000H-80          ;POINT TO NEXT LINE
        DEC     BL                   ;NUMBER OF LINES TO FILL
        JNZ     R10                  ;CLEAR_LOOP
        JMP     VIDEO_RETURN         ;EVERYTHING DONE
R11:                                 ;BLANK_FIELD
        MOV     BL,DH                ;SET BLANK COUNT TO EVERYTHING IN FIELD
        JMP     R9                   ;CLEAR THE FIELD
GRAPHICS_UP     ENDP
;-----------------------------------------------------------------------------
;SCROLL DOWN
;  THIS ROUTINE SCROLLS DOWN THE INFORMATION ON THE CRT
;ENTRY
;  CH,CL = UPPER LEFT CORNER OF REGION TO SCROLL
;  DH,DL = LOWER RIGHT CORNER OF REGION TO SCROLL
;   BOTH OF THE ABOVE ARE IN CHARACTER POSITIONS
;  BH = FILL VALUE FOR BLANKED LINES
;  AL = # LINES TO SCROLL (AL=0 MEANS BLANK THE ENTIRE FIELD)
;  DS = DATA SEGMENT
;  ES = REGEN SEGMENT
;EXIT
;  NOTHING, THE SCREEN IS SCROLLED
;----------------------------------------------------------------------------
GRAPHICS_DOWN   PROC   NEAR
        STD                          ;SET DIRECTION
        MOV     BL,AL                ;SAVE LINE COUNT IN BL
        MOV     AX,DX                ;GET LOWER RIGHT POSITION INTO AX REG

;------USE CHARACTER SUBROUTINE FOR POSITIONING
;------ADDRESS RETURNED IS MULTIPLIED BY 2 FROM CORRECT VALUE

        CALL    GRAPH_POSN
        MOV     DI,AX                ;SAVE RESULT AS DESTINATION ADDRESS

;------DETERMINE SIZE OF WINDOW

        SUB     DX,CX
        ADD     DX,101H              ;ADJUST VALUES
        SAL     DH,1                 ;MULTIPLY # ROWS BY 4 SINCE 8 VERT
                                     ;DOTS/CHAR
        SAL     DH,1                 ;AND EVEN/ODD ROWS

;------DETERMINE CRT MODE

        CMP     CRT_MODE,6           ;TEST FOR MEDIUM RES
        JNC     R12                  ;FIND_SOURCE_DOWN

;------MEDIUM RES DOWN
        SAL     DL,1                 ;# COLUMNS * 2,SINCE 2 BYTES/CHAR
                                     ;(OFFSET OK)
        SAL     DI,1                 ; OFFSET *2 SINCE 2 BYTES/CHAR
        INC     DI                   ;POINT TO LAST BYTE

;------DETERMINE THE SOURCE ADDRESS IN THE BUFFER
R12:                                 ;FIND_SOURCE_DOWN
        PUSH    ES                   ;BOTH SEGMENTS TO REGEN
        POP     DS
        SUB     CH,CH                ;ZERO TO HIGH OF COUNT REG
        ADD     DI,240               ;POINT TO LAST ROW OF PIXELS
        SAL     BL,1                 ;MULTIPLY NUMBER OF LINES BY 4
        SAL     BL,1
        JZ      R16                  ;IF ZERO,THEN BLANK ENTIRE FIELD
        MOV     AL,BL                ;GET NUMBER OF LINES IN AL
        MOV     AH,80                ;80 BYTES/ROW
        MUL     AH                   ;DETERMINE OFFSET TO SOURCE
        MOV     SI,DI                ;SET UP SOURCE
        SUB     SI,AX                ;SUBTRACT THE OFFSET
        MOV     AH,DH                ;NUMBER OF ROWS IN FIELD
        SUB     AH,BL                ;DETERMINE NUMBER TO MOVE

;------LOOP TROUGH, MOVING ONE ROW AT A TIME,BOTH EVEN AND ODD FIELDS
R13:                                 ;ROW_LOOP_DOWN
        CALL    R17                  ;MOVE ONE ROW
        SUB     SI,2000H+80          ;MOVE TO NEXT ROW
        SUB     DI,2000H+80
        DEC     AH                   ;NUMBER OF ROWS TO MOVE
        JNZ     R13                  ;CONTINUE TILL ALL MOVED

;------FILL IN THE VACATED LINE(S)
R14:                                 ;CLEAR_ENTRY_DOWN
        MOV     AL,BH                ;ATTRIBUTE TO FILL WITH
R15:                                 ;CLEAR_LOOP_DOWN
        CALL    R18                  ;CLEAR A ROW
        SUB     DI,2000H+80          ;POINT TO NEXT LINE
        DEC     BL                   ;NUMBER OF LINES TO FILL
        JNZ     R15                  ;CLEAR_LOOP_DOWN
        CLD                          ;RESET THE DIRECTION FLAG
        JMP     VIDEO_RETURN         ;EVERYTHING DONE

R16:                                 ;BLANK_FIELD_DOWN
        MOV     BL,DH                ;SET BLANK COUNT TO EVERYTHING IN FIELD
        JMP     R14                  ;CLEAR THE FIELD
GRAPHICS_DOWN   ENDP

;------ROUTINE TO MOVE ONE ROW OF INFORMATION

R17     PROC    NEAR
        MOV     CL,DL                ;NUMBER BYTES IN THE ROW
        PUSH    SI
        PUSH    DI                   ;SAVE POINTERS
        REP     MOVSB                ;MOVE THE EVEN FIELD
        POP     DI
        POP     SI
        ADD     SI,2000H
        ADD     DI,2000H             ;POINT TO THE ODD FIELD
        PUSH    SI
        PUSH    DI                   ;SAVE THE POINTERS
        MOV     CL,DL                ;COUNT BACK
        REP     MOVSB                ;MOVE THE ODD FIELD
        POP     DI
        POP     SI                   ;POINTERS BACK
        RET                          ;RETURN TO CALLER
R17     ENDP

;------CLEAR A SINGLE ROW

R18     PROC    NEAR
        MOV     CL,DL                ;NUMBER OF BYTES IN FIELD
        PUSH    DI                   ;SAVE POINTER
        REP     STOSB                ;STORE THE NEW VALUE
        POP     DI                   ;POINTER BACK
        ADD     DI,2000H             ;POINT TO ODD FIELD
        PUSH    DI
        MOV     CL,DL
        REP     STOSB                ;FILL THE ODD FIELD
        POP     DI
        RET                          ;RETURN TO CALLER
R18     ENDP
;---------------------------------------------------------------------------
;GRAPHICS WRITE
;THIS ROUTINE WRITES THE ASCII CHARACTER TO THE CURRENT
; POSITION ON THE SCREEN.
;ENTRY
; AL = SHARACTER TO WRITE
; BL = COLOR ATTRIBUTE TO BE USED FOR FOREGROUND COLOR
;       IF BIT 7 IS SET, THE CHAR IS XOR'D INTO THE REGEN BUFFER
;       (0 IS USED FOR THE BACKGROUND COLOR)
; CX = NUMBER OF CHARS TO WRITE
; DS = DATA SEGMENT
; ES = REGEN SEGMENT
;EXIT
;NOTHING IS RETURNED
;
;GRAPHICS READ
;  THIS ROUTINE READS THE ASCII CHARASTER AT THE CURRENT CURSOR
;  POSITION ON THE SCREEN BY MATCHING THE DOTS ON THE SCREEN TO THE
;  CHARASTER GENERATOR CODE POINTS
;ENTRY
; NONE ( 0 IS ASSUMED AS THE BACKGROUND COLOR
;EXIT
; AL = CHARACTER READ AT THAT POSITION ( O RETURNED IF NONE FOUND)
;
;FOR BOTH ROUTINES, THE IMAGES USED TO FORM CHARS ARE CONTAINED IN ROM
; FOR THE IST 128 CHARS. TO ACCESS CHARS IN THE SECOND HALF, THE USER
; MUST INITIALIZE THE VECTOR AT INTERRUPT 1FH (LOCATION 0007CH) TO
; POINT TO THE USER SUPPLIED TABLE OF GRAPHIC IMAGES (8X8 BOXES)
; FAILURE TO DO SO WILL CAUSE IN STRANGE RESULTS
;------------------------------------------------------------------------
        ASSUME CS:CODE,DS:DATA,ES:DATA
GRAPHICS_WRITE  PROC   NEAR
        MOV     AH,0                 ;ZERO TO HIGH OF CODE POINT
        PUSH    AX                   ;SAVE CODE POINT VALUE

;-------DETERMINE POSITION IN REGEN BUFFER TO PUT CODE POINTS

        CALL    S26                  ;FIND LOCATION IN REGEN BUFFER
        MOV     DI,AX                ;REGEN POINTER IN DI

;------ DETERMINE REGION TO GET CODE POINTS FROM

        POP     AX                   ;RECOVER CODE POINT
        CMP     AL,80H               ;IS IT IN SECOND HALF
        JAE     S1                   ;YES

;------ IMAGE IS IN FIRST HALF, CONTAINED IN ROM

        MOV     SI,0FA6EH            ;CRT_CHAR_GEN (OFFSET OF IMAGES)
        PUSH    CS                   ; SAVE SEGMENT ON STACK
        JMP     SHORT S2             ; DETERMINE_MODE

;------ IMAGE IS IN SECOND HALF, IN USER RAM

S1:                                  ; EXSTEND_CHAR
        SUB     AL,80H               ; ZERO ORIGIN FOR SECOND HALF
        PUSH    DS                   ; SAVE DATA POINTER
        SUB     SI,SI
        MOV     DS,SI                ; ESTABLISH VECTOR ADDRESSING
        ASSUME  DS:ABS0
        LDS     SI,EXT_PTR           ; GET THE OFFSET OF THE TABLE
        MOV     DX,DS                ; GET THE SEGMENT OF THE TABLE
        ASSUME  DS:DATA
        POP     DS                   ; RECOVER DATA SEGMENT
        PUSH    DX                   ; SAVE TABLE SEGMENT ON STACK

;------ DETERMINE GRAPHICS MODE IN OPERATION

S2:                                  ; DETERMINE_MODE
        SAL     AX,1                 ; MULTIPLY CODE POINT
        SAL     AX,1                 ;  VALUE BY 8
        SAL     AX,1
        ADD     SI,AX                ; SI HES OFFSET OF DESIRED CODES
        CMP     CRT_MODE,6
        POP     DS                   ;RECOVER TABLE POINTER SEGMENT
        JC      S7                   ;TEST FOR MEDIUM RESOLUTION MODE

;------ HIGH RESOLUTION MODE
S3:                           ;HIGH_CHAR
        PUSH    DI            ;SAVE REGEN POINTER
        PUSH    SI            ;SAVE CODE POINTER
        MOV     DH,4          ;NUMBER OF TIMES THROUGH LOOP
S4:
        LODSB                 ;GET BYTE FROM POINTS
        TEST    BL,80H        ;SHOULD WE USE THE FUNCTION
        JNZ     S6            ; TO PUT SHAR IN
        STOSB                 ;STORE IN REGEN BUFFER
        LODSB
S5:
        MOV     ES:[DI+2000H-1],AL ; STORE IN SECOND HALF
        ADD     DI,79         ;MOVE TO NEXT ROW IN REGEN
        DEC     DH            ;DONE WITH LOOP
        JNZ     S4
        POP     SI
        POP     DI            ;RECOVER REGEN POINTER
        INC     DI            ;POINT TO NEXT CHAR POSITION
        LOOP    S3            ;MORE CHARS TO WRITE
        JMP     VIDEO_RETURN
S6:
        XOR     AL,ES:[DI]    ; EXCLUSIVE OR WITH CURRENT
        STOSB                 ; STORE THE CODE POINT
        LODSB                 ; AGAIN FOR ODD FIELD
        XOR     AL,ES:[DI+2000H-1]
        JMP     S5            ;BACK TO MAINSTREAM

;------ MEDIUM RESOLUTION WRITE
S7:                           ;MED_RES_WRITE
        MOV     DL,BL         ;SAVE HIGH COLOR BIT
        SAL     DI,1          ;OFFSET*2 SINCE 2 BYTES/CHAR
        CALL    S19           ;EXPAND BL TO FULL WORD OF COLOR
S8:                           ;MED_CHAR
        PUSH    DI            ;SAVE REGEN POINTER
        PUSH    SI            ;SAVE THE CODE POINTER
        MOV     DH,4          ;NUMBER OF LOOPS
S9:
        LODSB                 ;GET CODE POINT
        CALL    S21           ;DOUBLE UP ALL THE BITS
        AND     AX,BX         ;CONVERT THEM TO FOREGROUND COLOR (0 BACK )
        TEST    DL,80H        ;IS THIS XOR FUNCTION
        JZ      S10           ;NO, STORE IT IN AS IT IS
        XOR     AH,ES:[DI]    ;DO FUCTION WITH HALF
        XOR     AL,ES:[DI+1]  ; AND WITH OTHER HALF
S10:
        MOV     ES:[DI],AH    ;STORE FIRST BYTE
        MOV     ES:[DI+1],AL  ;STORE SECOND BYTE
        LODSB                 ;GET CODE POINT
        CALL    S21
        AND     AX,BX         ;CONVERT TO COLOR
        TEST    DL,80H        ;AGAIN,IS THIS XOR FUNCTION
        JZ      S11           ;NO, JUST STORE THE VALUES
        XOR     AH,ES:[DI+2000H] ;FUNCTION WITH FIRST HALF
        XOR     AL,ES:[DI+2001H] ;AND WITH SECOND HALF
S11:

        MOV     ES:[DI+2000H],AH
        MOV     ES:[DI+2000H+1],AL ; STORE IN SECOND PORTION OF BUFFER
        ADD     DI,80         ; POINT TO NEXT LOCATION
        DEC     DH
        JNZ     S9            ; KEEP GOING
        POP     SI            ; RECOVER CODE POINTER
        POP     DI            ; RECOVER REGEN POINTER
        INC     DI            ; POINT TO NEXT CHAR POSITION
        INC     DI
        LOOP    S8            ; MORE TO WRITE
        JMP     VIDEO_RETURN
GRAPHICS_WRITE  ENDP
;-----------------------------------
; GRAPHICS READ
;-----------------------------------
GRAPHICS_READ   PROC   NEAR
        CALL    S26           ;CONVERTED TO OFFSET IN REGEN
        MOV     SI,AX         ;SAVE IN SI
        SUB     SP,8          ;ALLOCATE SPACE TO SAVE THE READ CODE POINT
        MOV     BP,SP         ;POINTER TO SAVE AREA

;------ DETERMINE GRAPHICS MODES

        CMP     CRT_MODE,6
        PUSH    ES
        POP     DS            ;POINT TO REGEN SEGMENT
        JC      S13           ;MEDIUM RESOLUTION

;------ HIGH RESOLUTION READ

;------ GET VALUES FROM REGEN BUFFER AND CONVERT TO CODE POINT

        MOV     DH,4          ;NAMBER OF PASSES
S12:
        MOV     AL,[SI]       ;GET FIRST BYTE
        MOV     [BP],AL       ;SAVE IN STORAGE AREA
        INC     BP            ;NEXT LOCATION
        MOV     AL,[SI+2000H] ;GET LOWER REGION BYTE
        MOV     [BP],AL       ;ADJUST AND STORE
        INC     BP
        ADD     SI,80         ;POINTER INTO REGEN
        DEC     DH            ;LOOP CONTROL
        JNZ     S12           ;DO IT SOME MORE
	JMP     short S15     ;GO MATCH THE SAVED CODE POINTS

;------ MEDIUM RESOLUTION READ
S13:                          ;MED_DES_READ
        SAL     SI,1          ;OFFSET*2 SINCE 2 BYTES/CHAR
        MOV     DH,4          ;NUMBER OF PASSES
S14:
        CALL    S23           ;GET PAIR BYTES FROM REGEN INTO SINGLE SAVE
        ADD     SI,2000H      ;GO TO LOWER REGION
        CALL    S23           ;GET THIS PAIR INTO SAVE
        SUB     SI,2000H-80   ;ADJUST POINTER BACK INTO UPPER
        DEC     DH
        JNZ     S14           ;KEEP GOING UNTIL ALL 8 DONE

;------ SAVE AREA HAS CHARACTER IN IT, MATCH IT
S15:                           ;FIND_CHAR
        MOV    DI,OFFSET CRT_CHAR_GEN ;ESTABLISH ADDRESSING
        NOP
        PUSH    CS
        POP     ES            ;CODE POINTS IN CS
        SUB     BP,8          ;ADJAST POINTER TO BEGINNING OF SAVE AREA
        MOV     SI,BP
        CLD                   ;ENSURE DIRECTION
        MOV     AL,0          ;CURRENT CODE POINT BEING MATCHED
S16:
        PUSH    SS            ;ESTABLISH ADDRESSING TO STACK
        POP     DS            ;FOR THE STRING COMPARE
        MOV     DX,128        ;NUMBER TO TEST AGAINTS
S17:
        PUSH    SI            ;SAVE SAVE AREA POINTER
        PUSH    DI            ;SAVE CODE POINTER
        MOV     CX,8          ;NUMBER OF BYTES TO MATCH
        REPE    CMPSB         ;COMPARE THE 8 BYTES

        POP     DI            ;RECOVER THE POINTERS
        POP     SI
        JZ      S18           ;IF ZERO FLAG SET, THEN MATCH OCCURRED
        INC     AL            ;NO, MATCH, MOVE ON TO NEXT
        ADD     DI,8          ;NEXT CODE POINT
        DEC     DX            ;LOOP CONTROL
        JNZ     S17           ;DO ALL OF THEM

;------ CHAR NOT MATCHED, MIGHT BE IN USER SUPLIED SECOND HALF

        CMP     AL,0          ;AL <> 0 IF ONLY IST HALF SCANNED
        JE      S18           ;IF = 0, THEN ALL HAS BEEN SCANNED
        SUB     AX,AX
        MOV     DS,AX         ;ESTABLISH ADDRESSING TO VECTOR
        ASSUME  DS:ABS0
        LES     DI,EXT_PTR    ;GET POINTER
        MOV     AX,ES         ;SEE IF THE POINTER REALLY EXISTS
        OR      AX,DI         ;IF ALL 0, THEN DOESN'T EXIST
        JZ      S18           ;NO SENSE LOOKING
        MOV     AL,128        ;ORIGIN FOR SECOND HALF
        JMP     S16           ;GO BACK AND TRY FOR IT
        ASSUME  DS:DATA

;------ CHARACTER IS FOUND ( AL=0 IF NOT FOUND )
S18:
        ADD     SP,8          ;READJUST THE STACK, THROW AWAY SAVE
        JMP     VIDEO_RETURN  ;ALL DONE
GRAPHICS_READ   ENDP
;--------------------------------------------------------------------
;EXSPAND_MED_COLOR
;      THIS ROUTINE EXPANDS THE LOW 2 BITS IN BL TO
;      FILL THE ENTIRE BX REGISTRE
;ENTRY
;      BL = COLOR TO BE USED ( LOW 2 BITS )
;EXIT
; BX = COLOR TO BE USED ( 8 REPLICATIONS OF THE 2 COLOR BITS )
;------------------------------------------------------------------------
S19     PROC    NEAR
        AND     BL,3          ;ISOLATE THE COLOR BITS
        MOV     AL,BL         ;COPY TO AL
        PUSH    CX            ;SAVE REGISTER
        MOV     CX,3          ;NUMBER OF TIMES TO DO THIS
S20:
        SAL     AL,1
        SAL     AL,1          ;LEFT SHIFT  BY 2
        OR      BL,AL         ;ANOTHER COLOR VERSION INTO BL
        LOOP    S20           ;FILL ALL OF BL
        MOV     BH,BL         ;FILL UPPER PORTION
        POP     CX            ;REGISTER BACK
        RET                   ;ALL DONE
S19     ENDP
;------------------------------------------------------------------------
; EXPAND_BYTE
;     THIS ROUNTINE TAKES THE BYTE IN AL AND DOUBLES ALL
;     OF THE BITS, TURNING THE 8 BITS INTO 16 BITS.
;     THE RESULT IS LEFT IN AX
;-------------------------------------------------------------------------
S21     PROC    NEAR
        PUSH    DX            ;SAVE REGISTERS
        PUSH    CX
        PUSH    BX
        SUB     DX,DX         ;RESULT REGISTER
        MOV     CX,1          ;MASK REGISTER
S22:
        MOV     BX,AX         ;BASE INTO TEMP
        AND     BX,CX         ;USE MASK TO EXTRACT A BIT
        OR      DX,BX         ;PUT INTO RESULT REGISTER
        SHL     AX,1
        SHL     CX,1          ;SHIFT BASE AND MASK BY 1
        MOV     BX,AX         ;BASE TO TEMP
        AND     BX,CX         ;EXTRACT THE SAME BIT
        OR      DX,BX         ;PUT INTO RESULT
        SHL     CX,1          ;SHIFT ONLY MASK NOW, MOVING TO NEXT BASE
        JNC     S22           ;USE MASK BIT COMING TO TERMINATE
        MOV     AX,DX         ;RESULT TO PARM REGISTER
        POP     BX
        POP     CX            ;RECOVER REGISTERS
        POP     DX
        RET                   ;ALL DONE
S21     ENDP
;---------------------------------------------------------------------------
; MED_READ_BYTE
; THIS ROUTINE MILL TAKE 2 BYTES FROM THE REGEN BUFFER,
;  COMPARE AGAINST THE CURRENT FOREGROUND COLOR,AND PLACE
;  THE CORRESPONDING ON/OFF BIT PATTERN INTO THE CURRENT
;  POSITION IN THE SAVE AREA
; ENTRY
;  SI,DS = POINTER TO REGEN AREA OF INTEREST
;  BX = EXPANDED FOREGROUND COLOR
;  BP = POINTER TO SAVE AREA
; EXIT
;  BP IS INCREMENT AFTER SAVE
;--------------------------------------------------------------------------
S23     PROC    NEAR
        MOV     AH,[SI]        ;GET FIRST BYTE
        MOV     AL,[SI+1]      ;GET SECOND BYTE
        MOV     CX,0C000H      ;2 BIT MASK TO TEST THE ENTRIES
        MOV     DL,0           ;RESULT REGISTER
S24:
        TEST    AX,CX          ;IS THIS SECTION BACKGROUND?
        CLC                    ;CLEAR CARRY IN HOPES THAT IT IS
        JZ      S25            ;IF ZERO,IT IS BACKGROUND
        STC                    ;WASN'T, SO SET CARRY
S25:    RCL     DL,1           ;MOVE THAT BIT INTO THE RESULT
        SHR     CX,1
        SHR     CX,1          ;MOVE THE MASK TO THE RIGHT BY 2 BITS
        JNC     S24           ;DO IT AGAIN IF MASK DIDN'T FALL OUT
        MOV     [BP],DL       ;STORE RESULT IN SAVE AREA
        INC     BP            ;ADJUST POINTER
        RET                   ;ALL DONE
S23     ENDP
;---------------------------------------------------------------------------
; V4_POSITION
;  THIS ROUTINE TAKES THE CURSOR POSITION CONTAINED IN
;  THE MEMORY LOCATION, AND CONVERTS IT INTO AN OFFSET
;  INTO THE REGEN BUFFER, ASSUMING ONE BYTE/CHAR.
;  FOR MEDIUM RESOLUTION GRAPHICS, THE NUMBER MUST
;  BE DOUBLED.
; ENTRY
;       NO REGISTERS, MEMORY LOCATION
;       CURSOR_POSN IS USED
; EXIT
;  AX CONTAINS OFFSET INTO REGEN BUFFER
;--------------------------------------------------------------------------
S26     PROC    NEAR
        MOV     AX,CURSOR_POSN       ;GET CURRENT CURSOR
GRAPH_POSN      LABEL  NEAR
        PUSH    BX                   ;SAVE REGISTER
        MOV     BX,AX                ;SAVE A COPY OF CURRENT CURSOR
        MOV     AL,AH                ;GET ROWS TO AL
        MUL     BYTE PTR CRT_COLS    ;MULTIPLY BY BYTES/COLUMN
        SHL     AX,1                 ;MULTIPLY * 4 SINCE 4 ROWS/BYTE
          SHL     AX,1
        SUB     BH,BH                ;ISOLATE COLUMN VALUE
        ADD     AX,BX                ;DETERMINE OFFSET
        POP     BX                   ;RECOVER POINTER
        RET                          ;ALL DONE
S26     ENDP
;--------------------------------------------------------------------------
; WRITE_TTY
; THIS INTERFACE PROVIDES A TELETYPE LIKE INTERFACE TO THE
;  VIDEO CARD. THE INPUT CHARACTER IS WRITTEN TO THE CURRENT
;  CURSOR POSITION, AND THE CURSOR IS MOVED TO THE NEXT POSITION.
;  IF THE CURSOR LEAVES THE LAST COLUMN OF THE FIELD, THE COLUMN
;  IS SET TO ZERO, AND THE ROW VALUE IS INCREMENTED. IF THE ROW
;  VALUE LEAVES THE FIELD, THE CURSOR IS PLACED ON THE LAST ROW,
;  FIRST COLUMN, AND THE ENTIRE SCREEN IS SCROLLED UP ONE LINE.
;  WHEN THE SCREEN IS SCROLLED UP, THE ATTRIBUTE FOR FILLING THE
;  NEWLY BLANKED LINE IS READ FROM THE CURSOR POSITION ON THE PREVIOUS
;  LINE BEFORE THE SCROLL, IN CHERESTER MODE. IN GRAPHICS MODE,
;  THE 0 COLOR IS USED.
;ENTRY
;  (AH) = CURRENT CRT MODE
;  (AL) = CHARACTER TO BE WRITTEN
;         NOTE THAT BACK SPACE, CAR RET, BELL AND LINE FEED ARE HANDLED
;         AS COMMANDS RATHER THAN AS DISPLAYABLE GRAPHICS
;  (BL) = FOREGROUND COLOR FOR CHAR WRITE IF CURRENTLY IN A GRAPHICS MODE
;EXIT
;  ALL REGISTERS SAVED
;---------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA
WRITE_TTY       PROC   NEAR
        PUSH    AX            ;SAVE REGISTERS
        PUSH    AX            ;SAVE CHAR TO WRITE
        MOV     AH,3
        MOV     BH,ACTIVE_PAGE;GET THE CURRENT ACTIVE PAGE
        INT     10H           ;READ THE CURRENT CURSOR POSITION
        POP     AX            ;RECOVER CHAR

;------ DX NOW HAS THE CURRENT CURSOR POSITION

        CMP     AL,8          ;IS IT A BACKSPACE
        JE      U8            ;BACK_SPACE
        CMP     AL,0DH        ;IS IT CARRIAGE RETURN
        JE      U9            ;CAR_RET
        CMP     AL,0AH        ;IS IT A LINE FEED
        JE      U10           ;LINE_FEED
        CMP     AL,07H        ;IS IT A BELL
        JE      U11           ;BELL

;------ WRITE THE CHAR TO THE SCREEN

        MOV     AH,10         ;WRITE CHAR ONLY
        MOV     CX,1          ;ONLY ONE CHAR
        INT     10H           ;WRITE THE CHAR

;------ POSITION THE CURSOR FOR NEXT CHAR

        INC     DL
        CMP     DL,BYTE PTR CRT_COLS; TEST FOR COLUMN OVERFLOW
        JNZ     U7            ; SET_CURSOR
        MOV     DL,0          ; COLUMN FOR CURSOR
        CMP     DH,24
        JNZ     U6            ; SET_CURSOR_INC

;------ SCROLL REQUIRED

U1:
        MOV     AH,2
        INT     10H           ; SET THE CURSOR

;------ DETERMINE VALUE TO FILL WITH DURING SCROLL

        MOV     AL,CRT_MODE   ; GET THE CURRENT MODE
        CMP     AL,4
        JC      U2            ; READ-CURSOR
        CMP     AL,7
        MOV     BH,0          ; FILL WITH BACKGROUND
        JNE     U3            ; SCROLL-UP
U2:                           ; READ-CURSOR
        MOV     AH,8
        INT     10H           ; READ CHAR/ATTR AT CURRENT CURSOR
        MOV     BH,AH         ; STORE IN BH

U3:                           ; SCROLL-UP
        MOV     AX,601H       ; SCROLL ONE LINE
        SUB     CX,CX         ; UPPER LEFT CORNER
        MOV     DH,24         ;LOWER RIGHT ROW
        MOV     DL,BYTE PTR CRT_COLS;LOWER RIGHT COLUMN
        DEC     DL
U4:                           ; VIDEO-CALL-RETURN
        INT     10H           ; SCROLL UP THE SCREEN
U5:                           ;TTY-RETURN
        POP     AX            ;RESTORE THE CHARACTER
        mov     ah,0eh
        JMP     VIDEO_RETURN  ;RETURN TO CALLER

U6:                           ;SET-CURSOR-INC
        INC     DH            ;NEXT ROW
U7:                           ;SET-CURSOR
        MOV     AH,2
        JMP     short U4            ;ESTALISH THE NEW CURSOR

;------ BACK SPACE FOUND

U8:
        CMP     DL,0          ;ALREADY AT END OF LINE
        JE      U7            ;SET_CURSOR
        DEC     DL            ;NO -- JUST MOVE IT BACK
        JMP     short U7            ;SET_CURSOR

;------ CARRIAGE RETURN FOUND

U9:
        MOV     DL,0          ;MOVE TO FIRST COLUMN
        JMP     U7            ;SET_CURSOR

;------ LINE FEED FOUND

U10:
        CMP     DH,24         ;BOTTOM OF SCREEN
        JNE     U6            ;YES, SCROLL THE SCREEN
        JMP     U1            ;NO, JUST SET THE CURSOR

;------ BELL FOUND

U11:
        MOV     BL,2          ;SET UP COUNT FOR BEEP
        CALL    BEEP          ;SOUND THE POD BELL
        JMP     U5            ;TTY_RETURN
WRITE_TTY       ENDP
;---------------------------------------------------------------------------
;LIGHT PEN
;       THIS ROUTINE TESTS THE LIGHT PEN SWITCH AND THE LIGHT
;         PEN TRIGGER. IF BOTH ARE SET, THE LOCATION OF THE LIGHT
;         PEN IS DETERMINED. OTHERWISE, A RETURN WITH NO INFORMATION
;         IS MADE.
;       ON EXIT
;       (AH) = 0 IF NO LIGHT PEN INFORMATION IS AVAILABLE
;               BX,CX,DX ARE DESTROYED
;       (AH) = 1 IF LIGHT PEN IS AVAILABLE
;               (DH,DL) = ROW,COLUMN OF CURRENT LIGHT PEN POSITION
;               (CH) = RASTER POSITION
;               (BX) = BEST GUESS AT PIXEL HORIZONTAL POSITION
;----------------------------------------------------------------------------
        ASSUME  CS:CODE,DS:DATA

;------SUBTRACT_TABLE
V1      LABEL   BYTE
        DB      3,3,5,5,3,3,3,4 ;
READ_LPEN       PROC   NEAR

;------ WAIT FOR LIGHT PEN TO BE DEPRESSED

        MOV     AH,0                 ; SET NO LIGHT PEN RETURN CODE
        MOV     DX,ADDR_6845         ; GET BASE ADDRESS OF 6845
        ADD     DX,6                 ; POINT TO STATUS REGISTER
        IN      AL,DX                ; GET STATUS REGISTER
        TEST    AL,4                 ; TEST LIGHT PEN SWITCH
        JNZ     V6                   ; NOT SET, RETURN

;------ NOW TEST FOR LIGHT PEN TRIGGER

        TEST    AL,2                 ; TEST LIGHT PEN TRIGGER
        JNZ     V7A                  ; RETURN WITHOUT RESETTING TRIGGER
        JMP     V7

;------ TRIGGER HAS BEEN SET, READ THE VALUE IN

V7A:
        MOV     AH,16                ; LIGHT PEN REGISTERS ON 6845

;------ INPUT REGS POINTED TO BY AH, AND CONVERT TO ROW COLUMN IN DX

        MOV     DX,ADDR_6845         ;ADDRESS REGISTER FOR 6845
        MOV     AL,AH                ;REGISTER TO READ
        OUT     DX,AL                ;SET IT UP
        INC     DX                   ;DATA REGISTER
        IN      AL,DX                ;GET THE VALUE
        MOV     CH,AL                ;SAVE IN CX
        DEC     DX                   ;ADDRESS REGISTER
        INC     AH
        MOV     AL,AH                ;SECOND DATA REGISTER
        OUT     DX,AL
        INC     DX                   ;POINT TO DATA REGISTER
        IN      AL,DX                ;GET SECOND DATA VALUE
        MOV     AH,CH                ;AX HAS INPUT VALUE

;------AX HAS THE VALUE READ IN FROM THE 6845

        MOV     BL,CRT_MODE
        SUB     BH,BH                ;MODE VALUE TO BX
        MOV     BL,CS:V1[BX]         ;DETERMINE AMOUNT TO SUBTRACT
        SUB     AX,BX                ;TAKE IT AWAY
        MOV     BX,CRT_START
        SHR     BX,1
        SUB     AX,BX
        JNS     V2                   ;IF POSITIVE, DETERMINE MODE
        SUB     AX,AX                 ;<0 PLAYS AS 0

;------DETERMINE MODE OF OPERATION

V2:                                  ;DETERMINE_MODE
        MOV     CL,3                 ;SET *8 SHIFT COUNT
        CMP     CRT_MODE,4           ;DETERMINE IF GRAPHICS OR ALPHA
        JB      V4                   ;ALPHA_PEN
        CMP     CRT_MODE,7
        JE      V4                   ;ALPHA_PEN

;------GRAPHICS MODE

        MOV     DL,40                ;DIVISOR FOR GRAPHICS
        DIV     DL                   ;DETERMINE ROW(AL) AND COLUMN(AH)
                                     ;AL RANGE 0-99,AH RANGE 0-39

;------DETERMINE GRAPHIC ROW POSITION

        MOV     CH,AL                ;SAVE ROW VALUE IN CH
        ADD     CH,CH                ;*2 FOR EVEN/ODD FIELD
        MOV     BL,AH                ;COLUMN VALUE TO BX
        SUB     BH,BH                ;MULTIPLY BY 8 FOR MEDIUM RES
        CMP     CRT_MODE,6           ;DETERMINE MEDIUM OR HIGH RES
        JNE     V3                   ;NOT_HIGH_RES
        MOV     CL,4                 ;SHIFT VALUE FOR HIGH RES
        SAL     AH,1                 ;COLUMN VALUE TIMES 2 FOR HIGH RES
V3:                                  ;NOT_HIGH_RES
        SHL     BX,CL                ;MULTIPLY *16 FOR HIGH RES

;------DETERMINE ALPHA CHAR POSITION

        MOV     DL,AH                ;COLUMN VALUE FOR RETURN
        MOV     DH,AL                ;ROW VALUE
        SHR     DH,1                 ;DIVIDE BY 4
        SHR     DH,1                 ; FOR VALUE IN 0-24 RANGE
        JMP     SHORT V5             ;LIGHT_PEN_RETURN_SET

;------ALPHA MODE ON LIGHT PEN

V4:                                  ;ALPHA_PEN
        DIV     BYTE PTR CRT_COLS    ;DETERMINE ROW,COLUMN VALUE
        MOV     DH,AL                ;ROWS TO DH
        MOV     DL,AH                ;COLS TO DL
        SAL     AL,CL                ;MULTIPLY ROWS * 8
        MOV     CH,AL                ;GET RASTER VALUE TO RETURN REG
        MOV     BL,AH                ;COLUMN VALUE
        XOR     BH,BH                ; TO BX
        SAL     BX,CL
V5:                                  ;LIGHT_PEN_RETURN_SET
        MOV     AH,1                 ;INDICATE EVERTHING SET
V6:                                  ;LIGHT_PEN_RETURN
        PUSH    DX                   ;SAVE RETURN VALUE (IN CASE)
        MOV     DX,ADDR_6845         ;GET BASE ADDRESS
        ADD     DX,7                 ;POINT TO RESET PARM
        OUT     DX,AL                ;ADDR, NOT DATA, IS IMPORTANT
        POP     DX                   ;RECOVER VALUE
V7:                                  ;RETURN_NO_RESET
        POP     DI
        POP     SI
        POP     DS                   ;DISCARD SAVED BX,CX,DX
        POP     DS
        POP     DS
        POP     DS
        POP     ES
        IRET
READ_LPEN       ENDP

test_clok  proc near
;	MOV	BL,03H
D_OK1:	SUB	CX,CX
E_OK:	MOV	AL,CLK_UP
	OUT	CMOS_PORT,AL
	IN	AL,CMOS_PORT+1
	TEST	AL,80H
	JNZ	G_OK
	LOOP	E_OK
	DEC	BL
	JNZ	D_OK1
;УСТАНОВКА ОШИБКИ ЧАСОВ В DIAG_STATUS БИТ 04 /CLOCK ERROR/
F_OK:	MOV	AL,DIAG_STATUS
	OUT	CMOS_PORT,AL
	XCHG	AL,AH
	IN	AL,CMOS_PORT+1
	OR	AL,CMOS_CLK_FAIL
	XCHG	AL,AH
	OUT	CMOS_PORT,AL
	XCHG	AL,AH
	OUT	CMOS_PORT+1,AL
	JMP	SHORT H_OK
; ПРОВЕРКА МОДИФИКАЦИИ ЧАСОВ
G_OK:
	MOV	CX,600
I_OK:	MOV	AL,CLK_UP
	OUT	CMOS_PORT,AL
	IN	AL,CMOS_PORT+1
	TEST	AL,80H
	LOOPNZ	I_OK
	JCXZ	F_OK
H_OK:
        ret
test_clok endp