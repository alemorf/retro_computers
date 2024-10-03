; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Получить байт из последовательного порта
; Выход: a - байт

UartRead:
        ; Ожидание получения байта
        in    PORT_UART_CONTROL
        ani   2
        jz    UartRead

        ; Получение байта
        in    PORT_UART_DATA

        ; Лишнее
#ifndef NO_UART_READ_7F
        ani   7Fh
#endif

        ret

