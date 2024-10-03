; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Напечать строку
; Вход: hl - адрес строки завершающейся кодом 0

PrintString4:
        mov    c, m
        mov    a, c
        ora    a
        rz
        call   PrintChar
        inx    h
        jmp    PrintString4
