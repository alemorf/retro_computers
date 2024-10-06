; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Очистить только двух верхних текстовых строк или 20 графических строк.

ClearScreen2:
        lda    v_scroll_y
        mov    l, a

        mvi    c, 20

        ; Подключить видеопамять
        mvi    a, 1
        out    PORT_MAPPER

        ; Очистить 20 графических строк
loc_E683: mvi  h, 40h
          mvi  b, 64
          xra  a
loc_E688:   mov    m, a
            inr    h
            dcr    b
          jnz    loc_E688
          inr    l
          dcr    c
        jnz    loc_E683

        ; Отключить видеопамять
        mvi    a, 0
        out    PORT_MAPPER

        jmp    CursorHome
