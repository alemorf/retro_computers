; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Нарисовать закрашенный прямоугольник
; Вход: v_arg_0 - X0, v_arg_1 - Y0, v_arg_2 - X1, v_arg_3 - Y1

DrawFillRect:
        lxi    h, v_arg_0
        mov    e, m  ; X0, v_arg_1
        inx    h
        mov    c, m  ; Y0, v_arg_2
        inx    h
        inx    h
        mov    d, m  ; Y1, v_arg_3

        ; Вычисляем высоту (c = Y1 - Y0). Если высота 0, то увеличиваем её на единицу
        mov    a, d
        sub    c
        jnz    loc_EB73
          inr    a
loc_EB73:
        mov    c, a

        ; Вычисляем адрес в видеопамяти
        ; Вход: de - координаты. Выход: hl - адрес, b - смещение внутри байта.
        call   CalcPixelAddress

        ; Вычиляем левую маску
        xra    a
loc_EB78  stc
          ral
          dcr    b
        jp    loc_EB78
        rar
        sta    v_tmp_left_mask
        cma
        sta    v_tmp_neg_left_mask

        ; Вычиляем правую маску
        lda    v_arg_2 ; X1
        ani    7
        mov    b, a
        xra    a
loc_EB8D: stc
          ral
          dcr    b
        jp     loc_EB8D
        sta    v_tmp_neg_right_mask

        ; Теперь высота в регистре B
        mov    b, c

        ; 2-ой аргумент Ширина
        lda    v_arg_2
        rar
        rar
        ani    3Eh
        adi    40h
        sub    h
        rrc
        mov    c, a ; Ширина

        ; Увеличиваем высоту на 1. Еще раз.
        inr    b

        ; Если последний аргумент не 1, то рисуем прямоугольник по XOR
        lda    v_arg_4
        dcr    a
        jnz    FillRectXor

        ; Аргументы для DrawHorzLine
        lda    v_tmp_neg_right_mask
        cma
        sta    v_tmp_right_mask
        mov    d, a

        ; Аргументы для DrawHorzLine
        lda    v_tmp_left_mask
        mov    e, a

        ; Рисуем залитый прямоугольник
loc_EBB7: push   d
          push   h
          push   b
          call   DrawHorzLine
          pop    b
          pop    h
          pop    d
          inr    l
          dcr    b
        jnz    loc_EBB7
        ret

;----------------------------------------------------------------------------

FillRectXor:
        ; Загружаем макси для левого и правого байта в DE
        lda    v_tmp_neg_right_mask
        sta    v_tmp_right_mask
        mov    d, a
        lda    v_tmp_neg_left_mask
        mov    e, a

        ; Подключить видеопамять
        mvi    a, 1
        out    PORT_MAPPER

loc_EBD5:
        push   d
        push   h
        push   b

        ; Если ширина 0 (с == 0), то объединяем маски (e |= d)
        mov    a, c
        ora    a
        jnz    loc_EBE0
          mov    a, e
          ora    d
loc_EBDF:
          mov    e, a
loc_EBE0:
        mov    b, e

        ; Залить 8 точек по маске B
        xchg
        lhld    v_color
        xchg

        mov    a, e
        ana    b
        xra    m
        mov    m, a

        inr    h

        mov    a, d
        ana    b
        xra    m
        mov    m, a

        inr    h

        ; Если c == 0, то завершаем рисование
        mov    a, c
        ora    a
        jz     loc_EC0B

        ; Уменьшаем C
        dcr    c

        ; Если c == 0, то слеюущие 8 точек будем ставить используя правую маску
loc_EBF6:
        lda    v_tmp_right_mask
        jz     loc_EBDF

        ; Центральная часть прямоугольника выводится без маски
loc_EBFC: mov    a, m
          xra    e
          mov    m, a
          inr    h
          mov    a, m
          xra    d
          mov    m, a
          inr    h
          dcr    c
        jnz    loc_EBFC

        jmp    loc_EBF6

; ---------------------------------------------------------------------------

loc_EC0B:
        pop    b
        pop    h
        pop    d

        ; Следующая строка
        inr    l
        dcr    b
        jnz    loc_EBD5

        ; Отключить видеопамять
        mvi    a, 0
        out    PORT_MAPPER

        ret
