; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Закрасить контур (продолжение)

loc_EE67:
        ; Вытаскиваем задачу из стека
        pop    h  ; l = X0, h = Y
        shld   v_tmp_x
        xchg
        pop    h  ; l = x1, h = mode

        ; Если mode = 0, то выход из функции Paint
        mov    a, h
        ora    a
        jz     loc_EEC6

        shld   v_tmp_x1

        ; Вычисление адреса в видеопамяти левой точки
        ; Выход: hl - адрес, b - смещение внутри байта
        call   CalcPixelAddress
        shld   v_arg_1

        ; Сохранение параметры для DrawHorzLine
        mov    c, b

        ; Вычисление левой маски
        mvi    a, 80h
loc_EE7E: rlc
          dcr    b
        jp     loc_EE7E
        sta    v_arg_3

        ; Вычисление адреса в видеопамяти правой точки
        ; Выход: hl - адрес, b - смещение внутри байта
        lda    v_tmp_x1
        mov    e, a
        lda    v_tmp_y
        mov    d, a
        call   CalcPixelAddress
        shld   v_arg_4

        ; Сохранение параметры для DrawHorzLine
        mov    d, b

        ; Вычисление маски
        mvi    a, 80h
loc_EE97: rlc
          dcr    b
        jp     loc_EE97
        sta    v_arg_6

        ; Мертвый код?
        lda    v_arg_3

        ; Вычисление левой маски
        xra    a
loc_EEA3: stc
          ral
          dcr    c
        jp    loc_EEA3
        rar
        mov    e, a

        ; Вычисление правой маски
        xra    a
loc_EEAC: stc
          ral
          dcr    d
        jp    loc_EEAC
        cma
        mov    d, a
        sta    v_tmp_right_mask

        ; Вычисление ширины в байтах
        lhld   v_arg_1 ; Это адреса в видеопамяти
        lda    v_arg_5
        sub    h
        rrc
        mov    c, a

        ; Вход: hl - адрес в видеопамяти, e - маска для первых 8 точек
        ; Вход: d - маска для последних 8 точек, c - ширина минус 1
        call   DrawHorzLine

        jmp    loc_EC9A

; ---------------------------------------------------------------------------

loc_EEC6:
        ; Восстановление цвета
        lhld    v_tmp_saved_color
        shld    v_color

        ; Восстановление стека
        lhld    v_tmp_saved_sp
        sphl

        ret
