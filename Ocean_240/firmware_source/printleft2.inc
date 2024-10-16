; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод кода 8 (влево) в консоль в режиме 2-х строк
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

PrintLeft2:
        ; Не перемещаем курсор, если курсор в начале строки
        inx    h
        mov    a, m ; Координата X
        ora    a
        dcx    h
        rz

        ; Уменьшаем координату курсора X на 1
        inx    h
        sui    1
        ani    3Fh  ; Мертвый код
        mov    m, a
        dcx    h
        ret
