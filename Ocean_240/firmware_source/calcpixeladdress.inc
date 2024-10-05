; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вычисление адреса точки в видеопамяти и номера бита по координатам точки
; Вход: D - y, E - x
; Выход: HL - адрес, B - номер бита

CalcPixelAddress:
        lda    v_scroll_y
        sub    d
        dcr    a
        mov    l, a

        mov    a, e
        ani    7
        mov    b, a

        mov    a, e
        rar
        rar
        ani    3Eh
        adi    40h
        mov    h, a
        ret

