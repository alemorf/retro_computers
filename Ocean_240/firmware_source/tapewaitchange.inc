; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Ожидание изменения уровня на входе с магнитофона
; Выход: a - прочитанный бит (0 или 1), b - прошло времени с прошлого измерения

TapeWaitChange:
        ; Сохранение состояния входа
        in     PORT_TAPE_IN
        ani    4
        mov    b, a

        ; Ожидание изменения состояния входа
loc_FD0D: in     PORT_TAPE_IN
          ani    4
          cmp    b
        jz    loc_FD0D

        ; Получение значения таймера
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        in     PORT_TIMER_0
        adi    20h
        in     PORT_TIMER_0
        mov    b, a
        aci    2

        ; Сброс таймера
        mvi    a, 0
        out    PORT_TIMER_0
        out    PORT_TIMER_0

        rp
        inr    a
        ret
