; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод символа в консоль

PrintChar:
        push   h
        push   d
        push   b
        call   PrintChar2
        pop    b
        pop    d
        pop    h
        ret

;----------------------------------------------------------------------------

PrintChar2:
        ; Если v_esc_mode = 0, то переход в функцию PrintChar3 (стандартная обработка)
        lxi    d, v_esc_mode
        ldax   d
        dcr    a
        ora    a
        jm     PrintChar3

        ; Если v_esc_mode > 1, то переход в функцию Game (игровая графика)
        jnz    Game

        ; Если v_esc_command != 0, то переход в функцию PrintCharEscArgs (получение аргументов)
        inx    d
        ldax   d
        ora    a
        jp     PrintCharEscArgs

        ; Иначе это получение первого байта ESC последовательности
        ; Сохранение символа, он же код команды
        ; v_esc_command = char & 0Fh
        mov    a, c
        ani    0Fh
        stax   d

        ; Сброс счетчика полученных аргументов
        ; v_esc_count = 0
        inx    d
        xra    a
        stax   d
        ret

;----------------------------------------------------------------------------

PrintCharEscArgs:
        ; Чтение в B код команды (v_esc_command)
        lxi    h, v_esc_command
        mov    b, m
        inx    h

        ; Увеличение счетчика полученых аргументов (v_esc_count)
        mov    a, m
        inr    a
        mov    m, a

        ; Сохранение очередного аргумента (v_arg_?)
        mov    e, a
        mvi    d, 0
        dad    d
        mov    m, c

        ; Выход, если не получено заданное кол-во аргументов
        lxi    h, esc_args_count
        mov    e, b
        dad    d
        cmp    m
        rm

        ; Получение в E кода команды (v_esc_command)
        lxi    h, v_esc_command
        mov    a, m
        ani    0Fh   ; Мертвый код (выше b не обрезается)
        mov    e, a

        ; Если получен нулевой код команды, то переход в режим игровой графики
        dcx    h
        ora    a
        mvi    m, 2
        rz

        ; v_esc_mode = 0
        mvi    d, 0
        mov    m, d

        ; Получение адреса ESC функции
        dcx    d
        lxi    h, esc_functions
        dad    d
        dad    d
        mov    e, m
        inx    h
        mov    d, m
        xchg

        ; Если это функции 0, 1, 2, 3 и v_screen_mode != 0, то выход
        cpi    4
        jp     loc_E1C1
        lda    v_screen_mode
        ani    3
        jnz    ExitEscMode
loc_E1C1:

        ; Выполнить ExitEscMode после выхода из ESC фунции
        lxi    d, ExitEscMode
        push   d
        pchl

;----------------------------------------------------------------------------

ExitEscMode:
        xra    a
        sta    v_esc_mode
        ret

;----------------------------------------------------------------------------

esc_args_count:
        .db 3  ; 0
        .db 5  ; A
        .db 4  ; B
        .db 3  ; C
        .db 1  ; D
        .db 2  ; E
        .db 1  ; F
        .db 1  ; G
        .db 1  ; H
        .db 2  ; I
        .db 1  ; J
        .db 5  ; K
        .db 5  ; L
        .db 7  ; M
        .db 6  ; N
        .db 4  ; O

esc_functions:
        .dw DrawFillRect       ; A
        .dw DrawLine           ; B
        .dw DrawPixel          ; C
        .dw ColorSet           ; D
        .dw CursorPositionSet  ; E
        .dw ScreenModeSet      ; F
        .dw CodepageSet        ; G
        .dw PaletteSet         ; H
        .dw CursorPositionSet2 ; I
        .dw PrinterScreen      ; J
        .dw DrawCircle         ; K
        .dw Paint              ; L
        .dw GetPutImage        ; M
        .dw Picture            ; N
        .dw BeepSet            ; O
