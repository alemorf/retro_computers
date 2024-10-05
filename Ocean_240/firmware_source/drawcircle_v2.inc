; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Нарисовать круг
; Вход: v_arg_0 и v_arg_1 - координаты центра, v_arg_2 - радиус, v_arg_3 и v_arg_4 - масштаб

DrawCircle:
        ; Диаметр в B
        lda    v_arg_2
        mov    b, a

        ; Выход, если диаметр 0 или больше 127
        dcr    a
        cpi    127
        rnc

        ; Начальная точка (0, диаметр)
        xra    a
        mov    d, a
        mov    e, b

        ; h = 1
        mvi    h, 1

        ; c = 1 - b
        mov    a, h
        sub    b
        mov    c, a

        ; b *= 2
        mov    a, b
        add    a
        mov    b, a

        ; l = 1 - b
        mvi    a, 1
        sub    b
        mov    l, a
loc_F469:
          ; Рисуем точки
          call   DrawEightPixels

          ; d++, h += 2, l += 2
          inr    d
          inr    l
          inr    l
          inr    h
          inr    h

          ; c += h
          mov    a, c
          add    h
          mov    c, a
        jnc    loc_F469

loc_F480:
          ; Рисуем точки
          call   DrawEightPixels

          ; d++
          inr    d

          ; Если d = e, то выходим
          mov    a, e
          cmp    d
          rz

          ; e--, l += 4, h += 2
          dcr    e
          inr    l
          inr    l
          inr    l
          inr    l
          inr    h
          inr    h

          ; c += l
          mov    a, c
          add    l
          mov    c, a
        jc     loc_F480

        jmp    loc_F469

;----------------------------------------------------------------------------
; Рисование 8 пикселей: (v_arg_0 ± D, v_arg_1 ± E) и (v_arg_0 ± E, v_arg_1 ± D)

DrawEightPixels:
        push   h
        push   b

        push   d
        call   DrawCircleZoom
        lhld   v_arg_0 ; Центр круга
        call   DrawFourPixelsBC
        pop    d

        push   d
        mov    a, d
        mov    d, e
        mov    e, a
        call   DrawCircleZoom
        lhld   v_arg_0 ; Центр круга
        call   DrawFourPixelsBC
        pop    d

        pop    b
        pop    h

        ; Если d = e, то выходим
        mov    a, e
        cmp    d
        rnz

        ; Выход из вызывающей функции
        pop    h
        ret

;----------------------------------------------------------------------------
; Масштабирование

DrawCircleZoom:
        ; Результат в BC
        mov    c, d
        mov    b, e

        ; Загрузка L = v_arg_3, H = v_arg_4
        lhld   v_arg_3

        ; Пропуск умножения, если v_arg_4 == 0.
        mov    a, h
        ora    a
        mov    a, l
        jz     DrawCircleZoom1
           ; B = E * v_arg_4 / 256
           call   MulEH
           mov    b, h
DrawCircleZoom1:
        ; Пропуск умножения, если v_arg_3 == 0.
        mov    h, a
        ora    a
        rz

        ; C = D * v_arg_3 / 256
        mov    e, c
        call   MulEH
        mov    c, h
        ret

;----------------------------------------------------------------------------

MulEH:  mvi    d, 0
        mov    l, d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        jnc    $ + 4
        dad    d
        dad    h
        rnc
        dad    d
        ret

;----------------------------------------------------------------------------

DrawFourPixelsBC:
        ; Рисуем точку (H + B, L + C), если не за краями экрана
        mov    a, h
        add    b
        jc     loc_F540
          mov    d, a
          mov    a, l
          add    c
          call   SetPixelRc
loc_F540:
        ; Рисуем точку (H + B, L - C), если не за краями экрана
        mov    a, h
        add    b
        jc    loc_F54C
          mov    d, a
          mov    a, l
          sub    c
          call   SetPixelRc
loc_F54C:
        ; Рисуем точку (H - B, L - C), если не за краями экрана
        mov    a, h
        sub    b
        jc    loc_F558
          mov    d, a
          mov    a, l
          sub    c
          call   SetPixelRc
loc_F558:
        ; Рисуем точку (H - B, L + C), если не за краями экрана
        mov    a, h
        sub    b
        rc
          mov    d, a
          mov    a, l
          add    c
          call   SetPixelRc
        ret

;----------------------------------------------------------------------------

SetPixelRc:
        ; Точка за краями экрана
        mov    e, a
        rc

        push   h
        push   b

        ; Вычисление адреса в видеопамяти
        ; Вход: de - координаты. Выход: hl - адрес, b - смещение внутри байта.
        call   CalcPixelAddress

        ; Вычиление маски
        mvi    a, ~80h
loc_F59A: rlc
          dcr    b
        jp     loc_F59A
        mov    b, a

        ; Цвет
        xchg
        lhld   v_color

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Рисование точки в первой плоскости
        ldax   d
        xra    l
        ana    b
        xra    l
        stax   d

        ; Рисование точки во второй плоскости
        inr    d
        ldax   d
        xra    h
        ana    b
        xra    h
        stax   d

        ; Отключение видеопамяти
        xra    a
        out    PORT_MAPPER

        pop    b
        pop    h
        ret
