; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Отправить байт в последовательный порт
; Вход: c - байт

UartWrite:
        ; Ожидание отправки прошлого байта
        in    PORT_UART_CONTROL
        ani   1
        jz    UartWrite

        ; Отправка байта
        mov   a, c
        out   PORT_UART_DATA
        ret
