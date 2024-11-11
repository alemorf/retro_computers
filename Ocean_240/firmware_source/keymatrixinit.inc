; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Драйвер клавиатуры МС7007

; Переменнные
v_key_char          = 0BFFAh ; ASCII код последней нажатой клавиши
v_key_has_char      = 0BFFBh ; Последнюю нажатую клавишу уже передали программе
v_key_pressed_now   = 0BFFCh ; Номер нажатой клавиши или 0
v_key_leds          = 0BFFDh ; Состояние светодиодов
v_key_delay_counter = 0BFFEh ; Счетчик опеспечивающий задержку перед автоповторением

; Биты порта PORT_KEY_OUT
KEY_COLUMN_ESC = 1                       ; Колонка с клавишей ESC
KEY_COLUMN_10 = (1 << 4) | 0Fh           ; Подать землю на 10-ый столбец
KEY_RESET_IRQ = 1 << 5                   ; Выключить прерывание и сбросить таймер прерывания
KEY_FIX_LED   = 1 << 6                   ; Светодиод "ФИКС"
KEY_ALF_LED   = 1 << 7                   ; Светодиод "АЛФ"

; Битовые маски для выделения клавиши в матрице
KEY_SHIFT_BITS = 1 << 3
KEY_CTRL_BITS  = 1 << 5
KEY_ESC_BITS   = 1 << 7

; Номера клавиш в матрице
KEY_FIX = 21
KEY_ALF = 13

; ASCII коды клавиш
C_BKSPC = 08h
C_LEFT  = 08h
C_RIGHT = 18h
C_UP    = 19h
C_DOWN  = 1Ah
C_TAB   = 09h
C_ENTER = 0Dh
C_ISP   = 7Fh ; Еще один код удаления. Кнопка над BKSPC.
C_RESET = 03h ; CTRL+C
C_F1    = 01h
C_F2    = 02h
C_F3    = 04h
C_F4    = 05h
C_F5    = 06h
C_POM   = 07h
C_UST   = 0Ah
C_GRAF  = 0Bh

;----------------------------------------------------------------------------
; Выход по нажатию клавиши (ESC)

; in     PORT_KEY_IN
; ani    KEY_ESC_BITS
; jz     LABEL

#define JUMP_IF_KEYBOARD(LABEL) .db 0DBh, PORT_KEY_IN, 0E6h, KEY_ESC_BITS, 0CAh, (LABEL) & 0FFh, (LABEL) >> 8

;----------------------------------------------------------------------------
; Код инициализации

        ; Настройка порта ввода-вывода
        mvi  a, VV55_CONFIG | VV55_A_IN | VV55_B_IN | VV55_CL_OUT | VV55_CH_OUT
        out  PORT_KEY_CONFIG

        ; Инициализация переменных
        xra  a
        sta  v_key_has_char
        sta  v_key_pressed_now
        mvi  a, KEY_ALF_LED
        sta  v_key_leds

        ; Предача KEY_RESET_IRQ необходима для работы контроллера прерываний
        ori  KEY_COLUMN_ESC | KEY_RESET_IRQ
        out  PORT_KEY_OUT

        ; Установка KEY_COLUMN_ESC необходима для JUMP_IF_KEYBOARD
        ani  ~KEY_RESET_IRQ
        out  PORT_KEY_OUT
