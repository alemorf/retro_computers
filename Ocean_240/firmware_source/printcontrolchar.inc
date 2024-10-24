; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод специальных символов в консоль

PrintControlChar:
        ; Если получен ESC, то переход в режим обработки ESC последовательностей
        cpi    1Bh
        jnz    loc_E78A
        lxi    h, v_esc_mode
        mvi    m, 1
        inx    h
        mvi    m, 0FFh
        ret

; ---------------------------------------------------------------------------

loc_E78A:
        ; Звуковой сигнал
        cpi    7
        jz     Beep

        ; Нарисовать курсор в конце функции
        lxi    h, DrawCursor
        push   h

        ; Скрыть курсор
        lxi    h, v_cursor_position
        push   psw
        call   DrawCursor

        ; Переход, если не включен режим 40x2
        lda    v_screen_mode
        ani    8
        jz     loc_E7C4

        ; Функции режима 40x2
        pop    psw
        cpi    9
        jz     Print402Tab
        cpi    8
        jz     Print2Left
        cpi    18h
        jz     Print402Right
        cpi    1Fh
        jz     ClearScreen2
        cpi    0Ah
        jz     Print2Down
        cpi    0Dh
        rnz
        inx    h
        mvi    m, 0
        dcx    h
        ret

;----------------------------------------------------------------------------

loc_E7C4:
        pop    psw

        ; Общие функции для режимов 40x25, 64x25, 80x25
        cpi    1Fh
        jz     ClearScreen
        cpi    0Ch
        jz     CursorHome

        ; Переход, если включен режим 64x25 или 80x25
        push   psw
        lda    v_screen_mode
        ani    3
        jnz    loc_E7FF
        pop    psw

        ; Функции режима 40x25
        cpi    9
        jz     Print402Tab
        cpi    8
        jz     Print40Left
        cpi    18h
        jz     Print402Right
        cpi    19h
        jz     Print40Up
        cpi    1Ah
        jz     Print40Down
        cpi    0Ah
        jz     Print40Down
        cpi    0Dh
        rnz
        inx    h
        mvi    m, 0
        dcx    h
        ret

;----------------------------------------------------------------------------

loc_E7FF:
        ; Переход, если включен режим 80x25
        lda    v_screen_mode
        cpi    3
        jz     loc_E833
        cpi    7
        jz     loc_E833

        ; Функции режима 64x25
        pop    psw
        cpi    9
        jz     Print64Tab
        cpi    8
        jz     Print64Left
        cpi    18h
        jz     Print64Right
        cpi    19h
        jz     Print64Up
        cpi    1Ah
        jz     Print64Down
        cpi    0Ah
        jz     Print64Down
        cpi    0Dh
        rnz
        inx    h
        mvi    m, 0
        dcx    h
        ret

;----------------------------------------------------------------------------

loc_E833:
        ; Функции режима 80x25
        pop    psw
        cpi    9
        jz     Print80Tab
        cpi    8
        jz     Print80Left
        cpi    18h
        jz     Print80Right
        cpi    19h
        jz     Print80Up
        cpi    1Ah
        jz     Print80Down
        cpi    0Ah
        jz     Print80Down
        cpi    0Dh
        rnz
        inx    h
        mvi    m, 0
        dcx    h
        ret
