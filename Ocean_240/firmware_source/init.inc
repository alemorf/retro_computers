; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Инициализация компьютера

Init:
        ; Отключение прерываний
        di

        ; Инициализция системных КР580ВВ55А
        mvi    a, VV55_CONFIG | VV55_A_OUT | VV55_B_OUT | VV55_CL_OUT | VV55_CH_OUT
        out    PORT_C3_V55_CONTROL
        out    PORT_E3_V55_CONFIG

        ; Инициализация клавиатуры и порта магнитофона
#ifdef KEY_DRIVER_TERMINAL
        mvi    a, 93h ; TODO
        out    PORT_KEY_CONFIG
#endif

        ; Установка черной палитры
        mvi    a, 7Fh
        out    PORT_COLOR

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Очистка видеопамяти
        mvi    b, 0
        lxi    h, 3F00h
        mov    a, h
        adi    41h
loc_E06C: mov    m, b
          inx    h
          cmp    h
        jnz    loc_E06C

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ; Прокрутка по оси Х
        mvi    a, 7
        out    PORT_SCROLL_X
        sta    v_scroll_x

        ; Видеорежим
        xra    a
        sta    v_screen_mode

        ; Прокрутка по оси Y
        sta    v_scroll_y

        ; Видеорежим и цвет по умолчанию
        sta    v_color + 1
        cma
        sta    v_color
        mvi    a, 3
        sta    v_palette
        mvi    a, 43h
        out    PORT_COLOR

        ; Установка линий порта принтера
        mvi    a, 4
        out    PORT_PRINTER_CONTROL
        sta    v_printer_control

        ; Частота и длительность звука по коду 7
        lxi    h, 1024
        shld   v_beep_period
        lxi    h, 320
        shld   v_beep_duration

        ; Настройка UART
        mvi    a, 0CEh
        out    PORT_UART_CONTROL
        mvi    a, 25h
        out    PORT_UART_CONTROL

        mvi    a, 76h
        out    PORT_TIMER_CONTROL
        mvi    a, 14h
        out    PORT_TIMER_1
        xra    a
        out    PORT_TIMER_1

        mvi    a, 12h ; A7 - A5 = 0, Interval 8, Single
        out    PORT_INT
        xra    a      ; A15 - A8 = 0
        out    PORT_INT_1
        cma           ; ALL IR INPUTS HAVE NO SLAVE DEVICES
        out    PORT_INT_1

        mvi    a, 20h ; NON-SPECIFIC EOI
        out    PORT_INT
        mvi    a, 0Ah ; POLL MODE / POLL ON NEXT RD
        out    PORT_INT

#ifdef KEY_DRIVER_TERMINAL
        ; Подтверждение приёма байта от контроллера клавиатуры
        ; Необходимо для работы контроллера прерываний
        mvi    a, 80h
        out    PORT_KEY_OUT
        nop
        nop
        xra    a
        out    PORT_KEY_OUT
#endif

#ifdef KEY_DRIVER_MATRIX
.include "keymatrixinit.inc"
#endif

        ; Инициализация стека
        lxi    sp, v_stack

        ; Отображение курсора
        call   DrawCursor

        ; Звуковой сигнал
        mvi    c, 7
        call   PrintChar

        ; Если подключена вторая ПЗУ, то переход на вторую ПЗУ
        lda    BiosBoot
        cpi    0C3h
        jz     BiosBoot

        ; Вывод сообщения об ошибке
        lxi    h, a_system_not_found
        call   PrintString4
        jmp    Halt
