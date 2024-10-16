; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод кода 8 (влево) в консоль в режиме 64x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

PrintLeft64:
        inx    h
        mov    a, m  ; Координата X
        sui    1
        ani    3Fh
        mov    m, a
        cpi    63
        dcx    h
        rnz
        ; продолжение в следующей функции

; Вывод кода 19h (вверх) в консоль в режиме 64x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

PrintUp64:
        mov    a, m
        sui    TEXT_LINE_HEIGHT
          jnc    loc_E537
        mvi    a, TEXT_LINE_HEIGHT * (TEXT_LINES - 1)
loc_E537:
        mov    m, a
        ret
