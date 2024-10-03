; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Напечать строку
; Вход: hl - адрес строки завершающейся кодом 0

PrintString3:
        mov    a, m
        ora    a
        rz
        mov    c, a
        call   BiosConout
        inx    h
        jmp    PrintString3
