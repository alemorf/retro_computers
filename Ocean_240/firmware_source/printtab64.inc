; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод кода 9 (TAB) в консоль в режиме 64x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

PrintTab64:
        inx    h
        mov    a, m  ; Координата X
        adi    8
        ani    38h
        mov    m, a
        dcx    h
        rnz
        jmp    PrintDown64
