; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Рисование черной точки
; Вход: v_arg_0 - x, v_arg_1 - y, v_arg_2 = 0

; Рисование цветной точки
; Вход: v_arg_0 - x, v_arg_1 - y, v_arg_2 = 1, v_color - цвет точки

; Получение цвета точки
; Вход: v_arg_0 - x, v_arg_1 - y, v_arg_2 = 2
; Выход: v_get_color - цвет точки

DrawPixel:
        ; Вычисление адреса точки в видеопамяти
        lhld    v_arg_0
        xchg
        call    CalcPixelAddress

        ; Вычисление маски
        mvi     a, 80h
loc_F05B: rlc
          dcr    b
        jp     loc_F05B
        mov    b, a

        ; Режим: Получение цвета точки
        lda    v_arg_2
        cpi    3
        jz     loc_F09D

        ; Инвертирование маски
        mov    a, b
        cma
        mov    b, a

        ; Режим: Рисование цветной точки
        lda    v_arg_2
        cpi    2
        jz     loc_F084

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Рисование черной точки
        mov    a, m
        ana    b
        mov    m, a
        inr    h
        mov    a, m
        ana    b
        mov    m, a

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret

;----------------------------------------------------------------------------

loc_F084:
        ; Цвет
        xchg
        lhld   v_color
        xchg

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Рисование цветной точки
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

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER
        ret

;----------------------------------------------------------------------------

loc_F09D:
        call   GetPointColor
        sta    v_get_color
        ret
