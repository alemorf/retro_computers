; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Проверка паузы между блоками данных на магнитной ленте
; Выход: A = 0 или 0xFF

TapeCheckPause:
        in    PORT_TAPE_IN
        ani   8
        mvi   a, 0
        rz
        cma
        ret
