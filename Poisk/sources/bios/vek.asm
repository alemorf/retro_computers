;--------------------------------------------------------------------------- 
; Эти векторы пересылаются в область прерываний 8086 
;  по включении питания 
;---------------------------------------------------------------------------- 
VECTOR_TABLE    LABEL  WORD          ;Таблица векторов прерываний 
        DW      DUMMY_RETURN           ;Прерывание 5H 
        DW      DUMMY_RETURN           ;Прерывание 6H 
        DW      DUMMY_RETURN           ;Прерывание 7H 
        DW      OFFSET TIMER_INT     ;Прерывание 8 
        DW      OFFSET KB_INT        ;Прерывание 9 
        DW      OFFSET HARD_RETURN   ;Прерывание A 
        DW      OFFSET HARD_RETURN   ;Прерывание B 
        DW      OFFSET HARD_RETURN   ;Прерывание C 
        DW      OFFSET HARD_RETURN   ;Прерывание D 
        DW      OFFSET SCANINT       ;Прерывание E 
        DW      OFFSET HARD_RETURN   ;Прерывание F 
        DW      OFFSET VIDEO_IO      ;Прерывание 10H 
        DW      OFFSET EQUIPMENT     ;Прерывание 11H 
        DW      OFFSET MEMORY_SIZE_DETERMINE   ;Прерывание 12H 
        DW      DUMMY_RETURN           ;Прерывание 13H 
        DW      DUMMY_RETURN           ;Прерывание 14H 
        DW      OFFSET CASSETTE_IO     ;Прерывание 15H 
        DW      KEYBOARD_IO            ;Прерывание 16H 
        DW      DUMMY_RETURN           ;Прерывание 17H 
        DW      OFFSET MONITOR         ;Прерывание 18H (Монитор) 
        DW      OFFSET BOOT_STRAP      ;Прерывание 19H 
        DW      TIME_OF_DAY            ;Прерывание 1AH (Время суток) 
        DW      DUMMY_RETURN           ;Прерывание 1BH (Прерывание клавиатуры) 
        DW      DUMMY_RETURN           ;Прерывание 1CH (Прерывание таймера) 
        DW      VIDEO_PARMS            ;Прерывание 1DH (Параметры ВИДЕО) 
        DW      DUMMY_RETURN           ;Прерывание 1EH (Параметры диска) 
        DW      OFFSET ALTC            ;Прерывание 1FH (Указатель VIDEO_EXT) 
 
