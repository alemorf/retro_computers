; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Напечать строку
; Вход: hl - адрес строки завершающейся кодом 0

PrintString:
        mov    a, m
        ora    a
        rz
        push   b
        mov    c, a
        call   PrintChar
        inx    h
        pop    b
        jmp    PrintString

