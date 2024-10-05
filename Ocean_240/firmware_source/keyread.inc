; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Получить код нажатой клавиши из буфера клавиатуры
; Выход: a - байт

KeyRead:
        ; Ожидание, пока в буфере клавиатуры не появится байт
        call  KeyCheck
        ora   a
        jz    KeyRead

        ; Получение кода
        in    PORT_KEY_IN

#ifndef NO_DEAD_CODE
        nop
        nop
#endif

        ; Подтверждение получения
        push   psw
        mvi    a, 80h
        out    PORT_KEY_OUT
        xra    a
        out    PORT_KEY_OUT
        pop    psw

        ret
