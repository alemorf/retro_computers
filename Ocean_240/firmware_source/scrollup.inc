; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Прокрутить экран вверх на 1 текстовую строку

ScrollUp:
        ; Прокрутка экрана
        lda    v_scroll_y
        adi    10
        out    PORT_SCROLL_Y

        ; Вычисление адреса в видеопамяти нижних 16 текстовых строк
        sta    v_scroll_y
        lxi    h, 40F0h
        add    l
        mov    l, a
        mov    c, h

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Очистка нижних 16 строк
        xra    a
        lxi    d, 1040h
loc_E512: mov    h, c
          mov    b, e
loc_E514:   mov    m, a
            inr    h
            dcr    b
          jnz    loc_E514
          inr    l
          dcr    d
        jnz    loc_E512

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret
