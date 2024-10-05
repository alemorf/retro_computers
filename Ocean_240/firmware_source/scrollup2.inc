; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция прокрутки экрана вверх, когда используюстя только 2 верхние текстовые строки

ScrollUp2:
        ; Копирование 10..17 графических строк в 0..7 строку
        lda    v_scroll_y
        mov    l, a
        adi    10
        mov    e, a
        mvi    c, 8

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Копирование
loc_E47B: mvi    b, 64
          mvi    h, 40h
          mov    d, h
loc_E480:   ldax   d
            mov    m, a
            inr    h
            inr    d
            dcr    b
          jnz    loc_E480
          inr    l
          inr    e
          dcr    c
        jnz    loc_E47B

        ; Очистка 8..17 строк
        mvi    c, 10
        lda    v_scroll_y
        adi    8
        mov    e, a
loc_E496: mvi    b, 64
          mvi    d, 40h
          xra    a
loc_E49B:   stax   d
            inr    d
            dcr    b
          jnz    loc_E49B
          inr    e
          dcr    c
        jnz    loc_E496

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret
