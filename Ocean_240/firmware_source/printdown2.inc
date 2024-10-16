; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод кода 0Ah (вниз) в консоль в режиме 2-х строк
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

PrintDown2:
        ; Перемещаем курсор вниз, только если курсор в 0..4 графической строке,
        ; иначе прокручивем 0..17 графические строки вверх
        mov    a, m
        adi    TEXT_LINE_HEIGHT
        cpi    TEXT_LINE_HEIGHT + 5
        jnc    ScrollUp2
        mov    m, a
        ret

