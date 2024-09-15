; MS7007 keyboard driver for Ocean 240
; Version 0.5
; Copyright (c) 2024 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, version 3.
;
; This program is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <http://www.gnu.org/licenses/>.

; TODO: Влияние CAPS на символы в конце ASCII таблицы
; TODO: Не конфликтуют ли переменные клавиатуры?
; TODO: Инвертировать светодиоды

; Порты ввода-вывода
PORT_INT         = 80h
PORT_KEYB_IN     = 40h
PORT_KEYB_OUT    = 42h
PORT_KEYB_CONFIG = 43h

; Биты порта PORT_INT
KEYB_INT_MASK = 1 << 1  ; Клавиатуры

; Биты для порта PORT_KEYB_CONFIG
KEYB_CONFIG        = 1 << 7
KEYB_CONFIG_A_IN   = 1 << 4
KEYB_CONFIG_A_OUT  = 0
KEYB_CONFIG_B_IN   = 1 << 1
KEYB_CONFIG_B_OUT  = 0
KEYB_CONFIG_CL_IN  = 1 << 0
KEYB_CONFIG_CL_OUT = 0
KEYB_CONFIG_CH_IN  = 1 << 3
KEYB_CONFIG_CH_OUT = 0

; Биты порта PORT_KEYB_OUT
KEYB_NO_COLUMN = 0Fh                       ; Отключение подачи земли на столбцы клавиатуры 0 - 9
KEYB_COLUMN_10 = (1 << 4) | KEYB_NO_COLUMN ; Подать землю на 10-ый столбец
KEYB_RESET_IRQ = 1 << 5                    ; Выключить прерывание и сбросить таймер прерывания
KEYB_FIX_LED   = 1 << 6                    ; Светодиод "ФИКС"
KEYB_ALF_LED   = 1 << 7                    ; Светодиод "АЛФ"

; Битовые маски для выделения клавиши в матрице
SHIFT_BITS = 1 << 3
CTRL_BITS  = 1 << 5

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

; Переменнные
v_keyb_char          = 0BFFAh ; ASCII код последней нажатой клавиши
v_keyb_has_char      = 0BFFBh ; Последнюю нажатую клавишу уже передали программе
v_keyb_pressed_now   = 0BFFCh ; Номер нажатой клавиши или 0
v_keyb_leds          = 0BFFDh ; Состояние светодиодов
v_keyb_delay_counter = 0BFFEh ; Счетчик опеспечивающий задержку перед автоповторением

; Нулевое смещение в BIN файле будет соответствовать этому адресу

    .org 0E000h

; Нужно для компилятора TASM.

    .db 0, 0, 0, 0, 0, 0

; Новые точки входа в ПЗУ

    jmp keyb_check
    jmp keyb_get

.org 0E040h ; смещение для DD = 64

    call keyb_init
keyb_init_end:

; Тут будет размещена наше программа. В оригинальном ПЗУ тут начинается свободное место.
    .org 0FDEDh

;----------------------------------------------------------------------------
; Точка входа.
; Функция возвращет ASCII нажатой клавиши. Фукнция ждет, если буфер пуст.

keyb_init:
        mvi  a, KEYB_CONFIG | KEYB_CONFIG_A_IN | KEYB_CONFIG_B_IN | KEYB_CONFIG_CL_OUT | KEYB_CONFIG_CH_OUT
        out  PORT_KEYB_CONFIG
        
        xra  a
        sta  v_keyb_has_char
        sta  v_keyb_pressed_now
        mvi  a, KEYB_FIX_LED | KEYB_ALF_LED
        sta  v_keyb_leds
        ori  KEYB_NO_COLUMN | KEYB_RESET_IRQ
        out  PORT_KEYB_OUT
        jmp  keyb_init_end

;----------------------------------------------------------------------------
; Точка входа.
; Функция возвращет ASCII нажатой клавиши. Фукнция ждет, если буфер пуст.

keyb_get:
        call keyb_check
        ora  a
        jz   keyb_get
        xra  a
        sta  v_keyb_has_char
        lda  v_keyb_char
        ret

;----------------------------------------------------------------------------
; Точка входа.
; Функция A = 0FFh, если при следующем вызове фукнкция keyb_get выполнится 
; без ожидания, иначе фукнция возвращает A = 0.

keyb_check: 
        ; Еще не настало время сканировать клавиатуру
        in   PORT_INT
        ani  KEYB_INT_MASK
        jz   keyb_check_exit

        ; Сканирование столбца с CTRL
        lda  v_keyb_leds
        ani  KEYB_FIX_LED | KEYB_ALF_LED
        mov  l, a
        inr  a
        out  PORT_KEYB_OUT
        in   PORT_KEYB_IN
        ani  CTRL_BITS
        mov  b, a

        ; Сканирование 10 столбцов
        lxi  d, (SHIFT_BITS << 8) | CTRL_BITS
        mvi  h, 10
keyb_check_2:
        mov  a, l
        out  PORT_KEYB_OUT
        in   PORT_KEYB_IN
        mov  c, a
        ana  d
        ora  b
        mov  b, a
        mov  a, c
        ora  d
        inr  a
        jnz  keyb_check_pressed        
        mov  d, e
        mvi  e, 0
        inr  l
        dcr  h
        jnz  keyb_check_2

        ; Сканирование последнего столбца
        mov  a, l
        ori  KEYB_COLUMN_10
        out  PORT_KEYB_OUT
        in   PORT_KEYB_IN
        inr  a
        jnz  keyb_check_pressed

        ; Запись в v_keyb_pressed_now числа 0
        sta v_keyb_pressed_now        
        jmp  keyb_check_exit

;----------------------------------------------------------------------------

keyb_check_pressed:
        ; Умножение L на 8
        dad  h
        dad  h
        dad  h

        ; Прибавить к L номер строки нажатой клавиши
        dcr  a
keyb_check_4:
        inr  l
        add  a
        jc   keyb_check_4

        ; Сброс прерывания
        lda  v_keyb_leds
        ani  KEYB_FIX_LED | KEYB_ALF_LED
        ori  KEYB_NO_COLUMN | KEYB_RESET_IRQ
        out  PORT_KEYB_OUT
        xri  KEYB_RESET_IRQ
        out  PORT_KEYB_OUT

        ; Если это нажатие клавиши, то устаналиваем переменную задержки и сразу обрабатываем
        lxi  d, v_keyb_pressed_now        
        ldax d
        sub  l
        mvi  a, 20
        jnz  keyb_check_6

        ; Уменьшаем переменную задержки. Если она не 0, то выходим
        lda  v_keyb_delay_counter
        dcr  a
        sta  v_keyb_delay_counter
        jnz  keyb_check

        ; Устаналиваем переменную задержки на значением повтора
        mvi  a, 3
keyb_check_6:
        sta  v_keyb_delay_counter

        ; Сохранение нажатой клавиши
        mov  a, l
        stax d

        ; Обработка клавиш ФИКС и АЛФ
        cpi  KEY_FIX
        jz   keyb_check_fix
        mvi  c, KEYB_ALF_LED
        cpi  KEY_ALF
        jz   keyb_check_fix_alf

        ; Преобразование клавиши по таблице
        adi  (v_keyboard_table - 1) & 0FFh
        mov  e, a
        aci  (v_keyboard_table - 1) >> 8
        sub  e
        mov  d, a

        ; Если нажат УПР
        mov  a, b
        ani  CTRL_BITS
        jnz  keyb_check_no_upr
        ldax d
        ani  1Fh
        jmp  keyb_check_save
keyb_check_no_upr:

        ; Если нажат ФИКС
        lda  v_keyb_leds
        ani  KEYB_FIX_LED
        ldax d
        jz   keyb_check_no_fix
        cpi  'a'
        jc   keyb_check_no_fix
        xri  'a' - 'A'
keyb_check_no_fix:

        ; Если нажат ШИФТ
        mov  l, a
        mov  a, b
        ani  SHIFT_BITS
        mov  a, l 
        jnz  keyb_get_no_shift
        cpi  '!'
        jc   keyb_get_no_shift
        xri  10h
        cpi  '@'
        jc   keyb_get_no_shift
        xri  30h
keyb_get_no_shift:

        ; Если нажат АЛФ
        mov  l, a
        lda  v_keyb_leds
        ani  KEYB_ALF_LED
        mov  a, l
        jnz  keyb_check_no_alf
        cpi  '@'
        jc   keyb_check_no_alf
        xri  80h
keyb_check_no_alf:

keyb_check_save:
        ; Сохранение нажатой клавиши
        sta  v_keyb_char
        mvi  a, 0FFh
        sta  v_keyb_has_char

keyb_check_exit:
        lda  v_keyb_has_char
        ret

;----------------------------------------------------------------------------

keyb_check_fix:
        mvi  c, KEYB_FIX_LED
keyb_check_fix_alf:
        lxi  h, v_keyb_leds
        mov  a, m
        xra  c
        mov  m, a
        jmp  keyb_check

;----------------------------------------------------------------------------

v_keyboard_table:
        .db ',',  '-',   '?', '?',    '?',    '7',    '8',      '9'
        .db 1Bh,  C_TAB, '?', C_GRAF, '?',    '0',    '.',      C_ENTER
        .db ';',  'j',   'f', 'q',    '?',    '1',    '2',      '3'
        .db C_F1, '1',   'c', 'y',    '^',    '4',    '5',      '6'
        .db C_F2, '2',   'u', 'w',    's',    '+',     C_ISP,   C_RESET
        .db C_F3, '3',   'k', 'a',    'm',    C_BKSPC, C_UST,   C_POM
        .db '4',  'e',   'p', 'i',    ' ',    C_RIGHT, C_ENTER, '/'
        .db C_F4, '5',   'n', 'r',    't',    C_DOWN,  C_UP,    '_'
        .db C_F5, '6',   'g', 'o',    'x',    '.',     ':',     '-'
        .db '7',  '[',   'l', 'b',    C_LEFT, '|',     'h',     '0'
        .db '8',  ']',   'd', '@',    ',',    'v',     'z',   '  9'

.end

