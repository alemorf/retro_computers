; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вычислить адрес символа в видеопамяти для текстового режима 80 символов в ширину
; Выход: HL - адрес, B - номер бита

CalcTextAddress80:
        lhld   v_cursor_position

        lda    v_scroll_y
        add    l
        mov    l, a

        mov    a, h
        cpi    4
        mov    b, a
        jm     loc_E633

        ani    3
        mov    b, a

        mov    a, h
        ora    a
        rar
        ora    a
        rar
        mov    c, a

        mvi    h, 3
        xra    a
loc_E62D: add    h
          dcr    c
        jnz    loc_E62D
        add    b

loc_E633:
        adi    42h
        mov    h, a

        mvi    c, 7
        ret
