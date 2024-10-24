; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вычислить адрес символа в видеопамяти для текстового режима 40 символов в ширину
; Выход: HL - адрес, B - номер бита

CalcTextAddress40:
        lhld   v_cursor_position

        lda    v_scroll_y
        add    l
        mov    l, a

        mov    a, h
        cpi    4
        mov    b, a
        jm     loc_E45A

        ani    3
        mov    b, a

        mov    a, h
        ora    a
        rar
        ora    a
        rar
        mov    c, a

        mvi    h, 6
        xra    a
loc_E454: add    h
          dcr    c
        jnz    loc_E454
        add    b

loc_E45A:
        add    b
        adi    42h
        mov    h, a

        mvi    a, 7
        sta    v_a

        ret
