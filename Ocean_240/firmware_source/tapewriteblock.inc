; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Запись блока на магнитную ленту
; Вход: de - идентификатор, hl - адрес массива из 128 байт
; Выход: de - сохраняется, hl - сохраняется

TapeWriteBlock3:
        push   h
        push   d
        push   d

        ; Настройка таймера
        lxi    b, 2550
        mvi    a, 0Ah
        out    PORT_INT
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        mov    a, c
        out    PORT_TIMER_0
        mov    a, b
        out    PORT_TIMER_0

        ; Запись 2-х колебаний
        lxi    d, 4
loc_FBAE:   ; Ожидание окончания счета таймера
            in     PORT_INT
            ani    TIMER_INT_MASK
          jnz    loc_FBAE

          ; Изменение амплитуды на выходе
          mov    a, d
          cma
          mov    d, a
          ora    a
          mvi    a, 5
          jnz    loc_FBC0
            mvi    a, 3
loc_FBC0: out    PORT_PRINTER_CONTROL

          ; Перезапуск таймера
          mvi    a, 36h
          out    PORT_TIMER_CONTROL
          mov    a, c
          out    PORT_TIMER_0
          mov    a, b
          out    PORT_TIMER_0

          ; Конец цикла
          dcr    e
        jnz    loc_FBAE

        ; Ожидание окончания счета таймера
loc_FBD0: in     PORT_INT
          ani    TIMER_INT_MASK
        jnz    loc_FBD0

        ; Запись стартового нуля
        mvi    a, 0
        call   WriteTapeByte

        ; Запись стартового байта
        mvi    a, 0F5h
        call   WriteTapeByte

        ; Для контрольной суммы
        mvi    e, 0

        ; Запись идентификатора
        pop    b
        mov    a, c
        call   WriteTapeByte
        mov    a, b
        call   WriteTapeByte

        ; Запись 128 байт данных
        mvi    b, 128
loc_FBEE: mov    a, m
          call   WriteTapeByte
          inx    h
          dcr    b
        jnz    loc_FBEE

        ; Запись контрольной суммы
        mov    a, e
        call   WriteTapeByte

        ; Запись финального нуля
        mvi    a, 0
        call   WriteTapeByte

        ; Ожидание окончания счета таймера
loc_FC00: in     PORT_INT
          ani    TIMER_INT_MASK
        jnz    loc_FC00

        ; Установка нулевого уровня на выходе
        mvi    a, 4
        out    PORT_PRINTER_CONTROL

        pop    d
        pop    h
        ret
