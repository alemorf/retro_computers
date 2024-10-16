; Нарисовать горизонтальную линию
; Вход: hl - адрес в видеопамяти, e - маска для первых 8 точек
; Вход: d - маска для последних 8 точек, c - ширина минус 1

DrawHorzLine:
        ; Подключить видеопамять
        mvi    a, 1
        out    PORT_MAPPER

        ; Если ширина 0 (с == 0), то объединяем маски (e |= d)
        mov    a, c
        ora    a
        jnz    loc_EEDD
          mov    a, e
          ora    d
loc_EEDC:
          mov    e, a
loc_EEDD:
        mov    b, e

        ; Залить 8 точек по маске B
        xchg
        lhld   v_color
        xchg
        mov    a, m
        xra    e
        ana    b
        xra    e
        mov    m, a

        inr    h

        mov    a, m
        xra    d
        ana    b
        xra    d
        mov    m, a

        inr    h

        ; Если c == 0, то завершаем рисование
        mov    a, c
        ora    a
        jz     loc_EF06

        ; Уменьшаем C
        dcr    c

        ; Если c == 0, то слеюущие 8 точек будем ставить используя правую маску
loc_EEF5:
        lda    v_tmp_right_mask
        jz     loc_EEDC

        ; Центральная часть прямоугольника выводится без маски
loc_EEFB: mov    m, e
          inr    h
          mov    m, d
          inr    h
          dcr    c
        jnz    loc_EEFB

        jmp    loc_EEF5

;----------------------------------------------------------------------------

loc_EF06:
        ; Отключить видеопамять
        mvi    a, 0
        out    PORT_MAPPER

        ret
