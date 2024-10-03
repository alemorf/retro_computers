; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Проверка наличия данных в буфере клавиатуры
; Выход: a = 0 если буфер клавиатуры пуст.

KeyCheck:
        in    PORT_INT

#ifndef NO_DEAD_CODE
        nop
#endif

        ani   KEYBOARD_INT_MASK

#ifndef NO_DEAD_CODE
        mvi   a, 0
#endif

        rz
        cma
        ret
