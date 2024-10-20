; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Рисование символа в режиме 64x25
; Вход: hl - адрес строки завершающейся кодом 0

Print64:
        ; Переход, если видеорежим не 64x25
        cpi    3
        jz     Print80

        ; Вычисление адреса символа в видеопамяти
        lhld   v_cursor_position
        lda    v_scroll_y
        add    l
        mov    l, a
        mov    a, h
        adi    40h
        mov    h, a

        ; Высота символа
        mvi    c, 7

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Копирование символа
        xchg
        xra    a
        stax   d
        inr    e
loc_E4D3: mov    a, m
          add    a
          stax   d
          inx    h
          inr    e
          dcr    c
        jnz    loc_E4D3

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ; После завершения функции нарисовать кусор
        lxi    h, DrawCursor
        push   h
        lxi    h, v_cursor_position
        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 18h (вправо) в консоль в режиме 64x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print64Right:
        inx    h
        mov    a, m
        adi    1
        ani    3Fh
        mov    m, a
        dcx    h
        rnz
        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 0Ah (вниз) или 1Ah (вниз) в консоль в режиме 64x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print64Down:
        mov    a, m
        adi    TEXT_LINE_HEIGHT
        cpi    248
        jnc    ScrollUp
        mov    m, a
        ret
