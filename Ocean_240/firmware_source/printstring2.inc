; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Напечать строку
; Вход: hl - адрес строки завершающейся кодом 0

PrintString2:
        mov    a, m
        ora    a
        rz
        mov    c, a
        push   h
        call   BiosConout
        pop    h
        inx    h
        jmp    PrintString2

