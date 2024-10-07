; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Стандартный звуковой сигнал

Beep:   ; Длительность стандартного звукового сигнала
        lhld   v_beep_duration
        xchg

        ; Запуск таймера с периодом стандартного звукового сигнала
        lhld   v_beep_period
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        mov    a, l
        out    PORT_TIMER_0
        mov    a, h
        out    PORT_TIMER_0

        ; Состояние порта PORT_PRINTER_CONTROL
        lda    v_printer_control
        mov    b, a

loc_E86F: ; Если счетчик цикла ноль, то выходим, иначе уменьшаем счетчик
          mov    a, d
          ora    e
          rz
          dcx    d

          ; Изменяем уровень на динамике
          mov    a, b
          xri    8
          mov    b, a
          out    PORT_PRINTER_CONTROL

          ; Ожидание таймера
loc_E879:   in     PORT_INT
            ani    10h
          jnz    loc_E879

          ; Изменяем уровень на динамике
          mov    a, b
          xri    8
          mov    b, a
          out    PORT_PRINTER_CONTROL

          ; Ожидание таймера
loc_E886:   in     PORT_INT
            ani    10h
          jz     loc_E886

        jmp    loc_E86F
