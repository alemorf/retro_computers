; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Ожидание изменения уровня на входе с магнитофона с возможностью остановки нажатием клавиши
; Выход: a - прочитанный бит (0, 1) или нажата клавиша клавиатуры (0FFh)
; Выход: b - прошло времени с прошлого измерения

TapeWaitChangeBreakable:
        ; Сохранение состояния входа
        in     PORT_TAPE_IN
        ani    4
        mov    b, a

        ; Ожидание изменения состояния входа
loc_FD30:
#ifdef KEY_DRIVER_TERMINAL
          ; Выход, если нажата клавиша на клавиатуре
          in     PORT_INT
          ani    KEY_INT_MASK
          jnz    loc_FD55
#endif
          in     PORT_TAPE_IN
          ani    4
          cmp    b
        jz    loc_FD30

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

loc_FD55:
        mvi    a, 0FFh
        ret
