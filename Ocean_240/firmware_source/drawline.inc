; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Нарисовать линию
; Вход: v_arg_0 - X0, v_arg_1 - Y0, v_arg_2 - X1, v_arg_3 - Y1

DrawLine:
        ; Загрузка (X0, Y0) в (E, D), (X1, Y1) в (L, H)
        lxi    h, v_arg_0
        mov    e, m
        inx    h
        mov    d, m
        inx    h
        mov    a, m
        inx    h
        mov    h, m
        mov    l, a

        ; Упорядочивание точек: (L, H) - левая, (E, D) - правая. Сохранение левой в v_arg_0.
        cmp    e
        jc     loc_EF1B
          xchg
loc_EF1B:
        shld    v_arg_0

        ; Вычисление дельты: L = dX = X1 - X0, H = dY = Y1 - Y0
        mov    a, e
        sub    l
        mov    l, a
        mov    a, d
        sub    h
        mov    h, a

        ; Сохранение в стеке знака dY или флага CF
        push   psw

        ; Модуль dY
        jnc    loc_EF2B
          cma
          inr    a
          mov    h, a
loc_EF2B:

        ; Загрузка левой точки в DE
        xchg
        lhld   v_arg_0
        xchg

        ; Если dY == 0, то используется оптимизированная функция.
        jz     DrawLineHorz

        ; Если dX == 0, то используется оптимизированная функция.
        mov    a, l
        ora    a
        jz     DrawLineVert

        ; В b теперь находится dX
        mov    b, a

        ; Извлечение CF из стека. v_arg_4 = CF.
        pop    psw
        mvi    a, 0
        adc    a
        sta    v_arg_4

        ; Деление. HL = E / B = dY / dX
        mov    e, h
        mvi    c, 16
        mvi    d, 0
loc_EF45:
          dad    h
          xchg
          dad    h
          xchg
          mov    a, d
          jc     loc_EF51
          cmp    b
          jc     loc_EF54
loc_EF51:
          sub    b
          mov    d, a
          inx    h
loc_EF54:
          dcr    c
        jnz    loc_EF45

        ; Сохраняем в стеке IX = 0 и dY / dX
        lxi    d, 0
        push   d
        push   h

        ; Вычисление адреса точки v_arg_0 в видеопамяти
        lhld   v_arg_0
        xchg
        mov    c, b  ; В с теперь находится dX
        call   CalcPixelAddress
        ; Выход: hl - адрес, b - смещение внутри байта.

        ; Вычисление маски
        mvi    a, 80h
loc_EF67: rlc
          dcr    b
        jp    loc_EF67
        cma
        mov    b, a

loc_EF6E:
        ; IX += dY / dX; c = IX - IX';
        pop    d
        xthl
        mov    a, h
        dad    d
        sub    h
        cma
        inr    a
        xthl
        push   d
        push   b
        mov    c, a

        ; Цвет точки
        xchg
        lhld    v_color
        xchg

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Если v_arg_4 не ноль, то рисуем вниз
        lda    v_arg_4
        ora    a
        jnz    loc_EF9F

loc_EF89:
          ; Рисование точки в первой плоскости
          mov    a, m
          xra    e
          ana    b
          xra    e
          mov    m, a

          ; Рисование точки во второй плоскости
          inr    h
          mov    a, m
          xra    d
          ana    b
          xra    d
          mov    m, a
          dcr    h

          ; Если счетчик цикла 0, то выходим, иначе уменьшаем счетчик цикла
          mov    a, c
          ora    a
          jz     loc_EFB5
          dcr    c

          ; Вверх на 1 пиксель
          dcr    l
        jmp    loc_EF89

;----------------------------------------------------------------------------

loc_EF9F: ; Рисование точки в первой плоскости
          mov    a, m
          xra    e
          ana    b
          xra    e
          mov    m, a

          ; Рисование точки во второй плоскости
          inr    h
          mov    a, m
          xra    d
          ana    b
          xra    d
          mov    m, a
          dcr    h

          ; Если счетчик цикла 0, то выходим, иначе уменьшаем счетчик цикла
          mov    a, c
          ora    a
          jz     loc_EFB5
          dcr    c

          ; Вниз на 1 пиксель
          inr    l
        jmp    loc_EF9F

;----------------------------------------------------------------------------

loc_EFB5:
        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ; Вправо на 1 пиксель
        pop    b
        mov    a, b
        stc
        ral
        jc     loc_EFC3
          ral
          inr    h
          inr    h
loc_EFC3:
        mov    b, a

        ; Цикл
        dcr    c
        jnz    loc_EF6E

        pop    h
        pop    h
        ret

;----------------------------------------------------------------------------
; Нарисовать из точки (E, D) вертикальную линию длиной L

DrawLineVert:
        ; Далее в C длина линии
        mov    c, h

        ; Вычисление адреса в видеопамяти
        ; Вход: de - координаты. Выход: hl - адрес, b - смещение внутри байта.
        call   CalcPixelAddress

        ; Вычисление маски
        mvi    a, 80h
loc_EFD1: rlc
          dcr    b
        jp    loc_EFD1
        cma
        mov    b, a

        ; Загрузка цвета в DE
        xchg
        lhld   v_color
        xchg

        pop    psw

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Переход, если нужно рисовать линию вниз
        jc     loc_EFFB

loc_EFE5: ; Рисование точки в первой плоскости
          mov    a, m
          xra    e
          ana    b
          xra    e
          mov    m, a

          ; Рисование точки во второй плоскости
          inr    h
          mov    a, m
          xra    d
          ana    b
          xra    d
          mov    m, a
          dcr    h

          ; Если счетчик цикла 0, то выходим, иначе уменьшаем счетчик цикла
          mov    a, c
          ora    a
          jz     loc_F011
          dcr    c

          ; Пиксель вверх
          dcr    l
        jmp    loc_EFE5

;----------------------------------------------------------------------------

loc_EFFB: ; Рисование точки в первой плоскости
          mov    a, m
          xra    e
          ana    b
          xra    e
          mov    m, a

          ; Рисование точки во второй плоскости
          inr    h
          mov    a, m
          xra    d
          ana    b
          xra    d
          mov    m, a
          dcr    h

          ; Если счетчик цикла 0, то выходим, иначе уменьшаем счетчик цикла
          mov    a, c
          ora    a
          jz     loc_F011
          dcr    c

          ; Пиксель вниз
          inr    l
        jmp    loc_EFFB

;----------------------------------------------------------------------------

loc_F011:
        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret

;----------------------------------------------------------------------------
; Нарисовать из точки (E, D) горизонтальную линию длиной L

DrawLineHorz:
        pop    psw

        ; Далее в C длина линии
        mov    c, l

        ; Если длина 0, то увеличиваем длину на 1
        mov    a, l
        ora    a
        jnz    loc_F01E
          inr    c
loc_F01E:

        ; Вычисление адреса в видеопамяти
        ; Вход: de - координаты. Выход: hl - адрес, b - смещение внутри байта.
        call   CalcPixelAddress

        ; Вычисление маски
        mvi    a, 80h
loc_F023: rlc
          dcr    b
        jp     loc_F023
        cma
        mov    b, a

        ; Загрузка цвета в DE
        xchg
        lhld   v_color
        xchg

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

loc_F033:
          ; Рисование точки в первой плоскости
          mov    a, m
          xra    e
          ana    b
          xra    e
          mov    m, a

          ; Рисование точки во второй плоскости
          inr    h
          mov    a, m
          xra    d
          ana    b
          xra    d
          mov    m, a
          dcr    h

          ; Вправо на 1 пиксель
          mov    a, b
          stc
          ral
          jc    loc_F048
            ral
            inr    h
            inr    h
loc_F048: mov    b, a

          ; Цикл
          dcr    c
        jnz    loc_F033

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret
