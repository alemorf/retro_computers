; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Отправить байт в принтер
; Вход: c - байт

PrinterWrite:
        ; Ожидание готовности принтера
        in     PORT_INT
        ani    PRINTER_INT_MASK
        jz     PrinterWrite

        ; Отправка байта
        mov    a, c
#ifndef NO_DEAD_CODE
        nop
#endif
        out    PORT_PRINTER_DATA

        ; Установка строб сигнала
        mvi    a, 14h
        out    PORT_PRINTER_CONTROL

        ; Ожидание ответа принтера
loc_E157:
        in     PORT_INT
        ani    PRINTER_INT_MASK
        jnz    loc_E157

        ; Снятие строб сигнала
        mvi    a, 4
        out    PORT_PRINTER_CONTROL
        ret
