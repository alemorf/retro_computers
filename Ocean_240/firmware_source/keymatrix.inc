; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Драйвер клавиатуры МС7007

;----------------------------------------------------------------------------
; Функция возвращет ASCII нажатой клавиши. Фукнция ждет, если буфер пуст.

KeyRead:
        call KeyCheck
        ora  a
        jz   KeyRead
        xra  a
        sta  v_key_has_char
        lda  v_key_char
        ret

;----------------------------------------------------------------------------
; Функция A = 0FFh, если при следующем вызове фукнкция key_get выполнится
; без ожидания, иначе фукнция возвращает A = 0.

KeyCheck:
        ; Еще не настало время сканировать клавиатуру
        in   PORT_INT
        ani  KEY_INT_MASK
        jz   KeyCheckExit

        ; Сканирование столбца с CTRL
        lda  v_key_leds
        ani  KEY_FIX_LED | KEY_ALF_LED
        mov  l, a
        inr  a
        out  PORT_KEY_OUT
        in   PORT_KEY_IN
        ani  KEY_CTRL_BITS
        mov  b, a

        ; Сканирование 10 столбцов
        lxi  d, (KEY_SHIFT_BITS << 8) | KEY_CTRL_BITS
        mvi  h, 10
KeyCheck2:
        mov  a, l
        out  PORT_KEY_OUT
        in   PORT_KEY_IN
        mov  c, a
        ana  d
        ora  b
        mov  b, a
        mov  a, c
        ora  d
        inr  a
        jnz  KeyCheckPressed
        mov  d, e
        mvi  e, 0
        inr  l
        dcr  h
        jnz  KeyCheck2

        ; Сканирование последнего столбца
        mov  a, l
        ori  KEY_COLUMN_10
        out  PORT_KEY_OUT
        in   PORT_KEY_IN
        inr  a
        jnz  KeyCheckPressed

        ; Запись в v_key_pressed_now числа 0
        sta  v_key_pressed_now
        jmp  KeyCheckExit

;----------------------------------------------------------------------------

KeyCheckPressed:
        ; Умножение L на 8
        dad  h
        dad  h
        dad  h

        ; Прибавить к L номер строки нажатой клавиши
        dcr  a
KeyCheck4:
        inr  l
        add  a
        jc   KeyCheck4

        ; Сброс прерывания
        lda  v_key_leds
        ani  KEY_FIX_LED | KEY_ALF_LED
        ori  KEY_NO_COLUMN | KEY_RESET_IRQ
        out  PORT_KEY_OUT
        xri  KEY_RESET_IRQ
        out  PORT_KEY_OUT

        ; Если это нажатие клавиши, то устаналиваем переменную задержки и сразу обрабатываем
        lxi  d, v_key_pressed_now
        ldax d
        sub  l
        mvi  a, 20
        jnz  KeyCheck6

        ; Уменьшаем переменную задержки. Если она не 0, то выходим
        lda  v_key_delay_counter
        dcr  a
        sta  v_key_delay_counter
        jnz  KeyCheck

        ; Устаналиваем переменную задержки на значением повтора
        mvi  a, 3
KeyCheck6:
        sta  v_key_delay_counter

        ; Сохранение нажатой клавиши
        mov  a, l
        stax d

        ; Обработка клавиш ФИКС и АЛФ
        cpi  KEY_FIX
        jz   KeyCheckFix
        mvi  c, KEY_ALF_LED
        cpi  KEY_ALF
        jz   KeyCheckFixAlf

        ; Преобразование клавиши по таблице
        adi  (key_table - 1) & 0FFh
        mov  e, a
        aci  (key_table - 1) >> 8
        sub  e
        mov  d, a

        ; Если нажат УПР
        mov  a, b
        ani  KEY_CTRL_BITS
        jnz  KeyCheckNoUpr
        ldax d
        ani  1Fh
        jmp  KeyChecksave
KeyCheckNoUpr:

        ; Активная кодовая страница
        ; v_codepage = 0 - Латиница, 1 - Кирилица, 2 - Смешанная.
        mvi  c, 0FFh
        lda  v_codepage
        dcr  a
        lxi  h, '@' | (('_' + 1) << 8)  ; Клавиша АЛФ влияет на '@' .. '_'
        jz   KeyCheckCyr
        inr  c
        dcr  a
        jz   KeyCheckAll
        lxi  h, 'A' | (('Z' + 1) << 8)  ; Клавиша АЛФ влияет на 'A' .. 'Z'
KeyCheckCyr:
        ; В кирилице ФИКС работает инверсно
        ; Если нажат ФИКС
        lda  v_key_leds
        xra  c
        ani  KEY_FIX_LED
        ldax d
        jz   KeyCheckNoFix
        cmp  l
        jc   KeyCheckNoFix
        cmp  h
        jnc  KeyCheckNoFix
        xri  'a' - 'A'
KeyCheckNoFix:

        ; Если нажат ШИФТ
        mvi  c, 30h
KeyCheckGetShift:
        mov  l, a
        mov  a, b
        ani  KEY_SHIFT_BITS
        mov  a, l 
        jnz  KeyCheckNoShift
        cpi  '!'
        jc   KeyCheckNoShift
        xri  10h
        cpi  '@'
        jc   KeyCheckNoShift
        xra  c
KeyCheckNoShift:

KeyChecksave:
        ; Сохранение нажатой клавиши
        sta  v_key_char
        mvi  a, 0FFh
        sta  v_key_has_char

KeyCheckExit:
        lda  v_key_has_char
        ret

;----------------------------------------------------------------------------

KeyCheckAll:
        ; Шифт не влияет на символьные клавиши
        mvi  c, 10h

        ; Если нажат АЛФ, то заменяем все символы от '@' на кирилицу
        lda  v_key_leds
        ani  KEY_ALF_LED
        ldax d
        jnz  KeyCheckGetShift
        cpi  '@'
        jc   KeyCheckGetShift
        xri  20h
        jmp  KeyCheckGetShift

;----------------------------------------------------------------------------

KeyCheckFix:
        mvi  c, KEY_FIX_LED
KeyCheckFixAlf:
        lxi  h, v_key_leds
        mov  a, m
        xra  c
        mov  m, a
        jmp  KeyCheck

;----------------------------------------------------------------------------

key_table:
        .db ',',  '-',   '?', '?',    '?',    '7',    '8',      '9'
        .db 1Bh,  C_TAB, '?', C_GRAF, '?',    '0',    '.',      C_ENTER
        .db ';',  'J',   'F', 'Q',    '?',    '1',    '2',      '3'
        .db C_F1, '1',   'C', 'Y',    '^',    '4',    '5',      '6'
        .db C_F2, '2',   'U', 'W',    'S',    '+',     C_ISP,   C_RESET
        .db C_F3, '3',   'K', 'A',    'M',    C_BKSPC, C_UST,   C_POM
        .db '4',  'E',   'P', 'I',    ' ',    C_RIGHT, C_ENTER, '/'
        .db C_F4, '5',   'N', 'R',    'T',    C_DOWN,  C_UP,    '_'
        .db C_F5, '6',   'G', 'O',    'X',    '.',     ':',     '-'
        .db '7',  '[',   'L', 'B',    C_LEFT, '|',     'H',     '0'
        .db '8',  ']',   'D', '@',    ',',    'V',     'Z',   '  9'
