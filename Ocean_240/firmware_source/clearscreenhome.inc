; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Очистить экран
; Вход: HL - указатель на v_cursor

ClearScreen:
        ; В режиме двух текстовых строк переходим в другую функцию
        lda    v_screen_mode
        ani    8
        jnz    ClearScreen2

        ; Включить черную палитру
        mvi    a, 7Fh
        out    PORT_COLOR

        ; Подключить видеопамять
        mvi    a, 1
        out    PORT_MAPPER

        ; Заполнить видеопамять нулями
        lxi    d, 4000h
        xchg
        mov    a, h
        adi    40h
        mvi    b, 0
loc_E652: mov    m, b
          inx    h
          cmp    h
        jnz    loc_E652
        xchg

        ; Восстановить регистр
        lda    v_palette
        mov    b, a
        lda    v_screen_mode
        ani    3
        mvi    a, 0
        jnz    loc_E669
          mvi    a, 40h
loc_E669:
        ora    b
        out    PORT_COLOR

; Переместить курсор в левый верхний угол
; Вход: HL - указатель на v_cursor

CursorHome:
        ; Установить текстовый курсор в верхний левый угол
        xra    a
        nop
        nop
        mov    m, a
        inx    h
        xra    a
        mov    m, a
        dcx    h

        ; Отключить видеопамять
        mvi    a, 0
        out    PORT_MAPPER
        ret
