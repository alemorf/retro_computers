; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Запись байта на магнитную ленту
; Вход: b - байт, e - контрольная сумма
; Выход: bc - сохраняется, e - контрольная сумма

WriteTapeByte:
        push   b
        mov    b, a

        ; Вычисление контрольной суммы
        mov    a, e
        sub    b
        mov    e, a

        mvi    c, 8
loc_FC15:
        ; Получение очередного бита
        mov    a, b
        rar
        mov    b, a
        jc     loc_FC41

        ; Ожидание окончания счета таймера
loc_FC1B: in     PORT_INT
          ani    TIMER_INT_MASK
        jnz    loc_FC1B

        ; Перезапуск таймера
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        mvi    a, 104
        out    PORT_TIMER_0
        mvi    a, 1
        out    PORT_TIMER_0

        ; Изменение амплитуды на выходе
        mov    a, d
        cma
        mov    d, a
        ora    a
        mvi    a, 5
        jnz    loc_FC39
          mvi    a, 3
loc_FC39:
        out    PORT_PRINTER_CONTROL

        ; Конец цикла
        dcr    c
        jnz    loc_FC15

        pop    b
        ret

;----------------------------------------------------------------------------

        ; Ожидание окончания счета таймера
loc_FC41: in     PORT_INT
          ani    TIMER_INT_MASK
        jnz    loc_FC41

        ; Перезапуск таймера
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        mvi    a, 148
        out    PORT_TIMER_0
        mvi    a, 2
        out    PORT_TIMER_0

        ; Изменение амплитуды на выходе
        mov    a, d
        cma
        mov    d, a
        ora    a
        mvi    a, 5
        jnz    loc_FC5F
          mvi    a, 3
loc_FC5F:
        out    PORT_PRINTER_CONTROL

        ; Конец цикла
        dcr    c
        jnz    loc_FC15

        pop    b
        ret
