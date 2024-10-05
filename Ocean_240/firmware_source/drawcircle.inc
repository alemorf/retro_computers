; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Нарисовать круг
; Вход: v_arg_0 и v_arg_1 - координаты центра, v_arg_2 - радиус, v_arg_3 и v_arg_4 - масштаб

DrawCircle:
        ; Диаметр в B
        lda    v_arg_2
        mov    b, a

        ; Выход, если диаметр 0 или больше 127
        ora    a
        rz
        mvi    a, 127
        cmp    b
        rm

        ; Начальная точка (0, диаметр)
        xra    a
        mov    d, a
        mov    e, b
        call   DrawEightPixels

        ; h = 1
        mvi    a, 1
        mov    h, a

        ; c = 1 - b
        sub    b
        mov    c, a

        ; b *= 2
        mov    a, b
        rlc
        mov    b, a

        ; l = 1 - b
        mvi    a, 1
        sub    b
        mov    l, a

        ; А зачем?
        cmc

loc_F469:
          ; d++
          inr    d

          ; Если d = e, то рисуем последние точки
          mov    a, e
          cmp    d
          jz     DrawEightPixels

          ; Рисуем точки
          call   DrawEightPixels

          ; h += 2
          mov    a, h
          adi    2
          mov    h, a

          ; l += 2
          mov    a, l
          adi    2
          mov    l, a

          ; c += h
          mov    a, c
          add    h
          mov    c, a
        jnc    loc_F469

loc_F480:
          ; А зачем?
          cmc

          ; d++, e--
          inr    d
          dcr    e

          ; Если d = e, то рисуем последние точки
          mov    a, d
          cmp    e
          jz     DrawEightPixels

          ; Если d - e = 1, то выходим
          sub    e
          cpi    1
          rz

          ; Если e - d = 1, то рисуем последние точки
          mov    a, e
          sub    d
          cpi    1
          jz     DrawEightPixels

          ; Рисуем точки
          call   DrawEightPixels

          ; h += 2
          mov    a, h
          adi    2
          mov    h, a

          ; l += 4
          mov    a, l
          adi    4
          mov    l, a

          ; А зачем?
          jnc    loc_F4A2
            cmc
loc_F4A2:

          ; c += l
          mov    a, c
          add    l
          mov    c, a
          jnc    loc_F469

        jmp    loc_F480

;----------------------------------------------------------------------------
; Рисование 8 пикселей: (v_arg_0 ± D, v_arg_1 ± E) и (v_arg_0 ± E, v_arg_1 ± D)

DrawEightPixels:
        push   h
        push   d
        push   b

        push   d
        call   sub_F4C7 ; Умножить D на v_arg_3 и E на v_arg_4
        lhld   v_arg_0  ; H, L - центр круга
        call   DrawFourPixelsBC
        pop    d

        call   sub_F4E7
        lhld   v_arg_0 ; Центр круга
        call   DrawFourPixelsCB

        pop    b
        pop    d
        pop    h
        xra    a
        ret

;----------------------------------------------------------------------------
; Масштабирование
; if (v_arg_3 == 0) C = D; else C = D * v_arg_3 / 256;
; if (v_arg_4 == 0) B = E; else B = E * v_arg_4 / 256;

sub_F4C7:
        ; Если третий аругумент 0
        lhld   v_arg_3
        mov    a, l
        ora    a
        mov    c, d
        mov    b, e
        jnz    loc_F4D7

        ; Если четверный аругумент 0
        mov    a, h
        ora    a
        jnz    loc_F4E0
        ret

;----------------------------------------------------------------------------

loc_F4D7:
        mov    a, h

        ; С *= v_arg_3
        mov    h, l
        mov    e, c
        call   MulEH
        mov    c, e

        ; Если четверный аругумент 0
        ora    a
        rz

loc_F4E0:
        ; B *= v_arg_4
        mov    h, a
        mov    e, b
        call   MulEH
        mov    b, e
        ret

;----------------------------------------------------------------------------
; Масштабирование
; if (v_arg_3 == 0) B = E; else B = E * v_arg_3 / 256;
; if (v_arg_4 == 0) C = D; else C = D * v_arg_4 / 256;

sub_F4E7:
        ; Если третий аругумент 0
        lhld   v_arg_3
        mov    a, l
        ora    a
        mov    c, d
        mov    b, e
        jnz    loc_F4F7

        ; Если четверный аругумент 0
        mov    a, h
        ora    a
        jnz    loc_F500
        ret

;----------------------------------------------------------------------------

loc_F4F7:
        mov    a, h

        ; B *= v_arg_3
        mov    h, l
        mov    e, b
        call   MulEH
        mov    b, e

        ; Если четверный аругумент 0
        ora    a
        rz

loc_F500:
        ; C *= v_arg_4
        mov    h, a
        mov    e, c
        call   MulEH
        mov    c, e
        ret

;----------------------------------------------------------------------------

MulEH:  mvi    d, 0
        mov    l, d
        dad    h
        jnc    loc_0F
          dad  d
loc_0F: dad    h
        jnc    loc_14
          dad  d
loc_14: dad    h
        jnc    loc_19
          dad  d
loc_19: dad    h
        jnc    loc_1E
          dad  d
loc_1E: dad    h
        jnc    loc_23
          dad  d
loc_23: dad    h
        jnc    loc_28
          dad  d
loc_28: dad    h
        jnc    loc_2D
          dad  d
loc_2D: dad    h
        jnc    loc_32
          dad  d
loc_32: mov    e, h
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
          mov    e, a
          call   SetPixelRc
loc_F540:
        ; Рисуем точку (H + B, L - C), если не за краями экрана
        mov    a, h
        add    b
        jc    loc_F54C
          mov    d, a
          mov    a, l
          sub    c
          mov    e, a
          call   SetPixelRc
loc_F54C:
        ; Рисуем точку (H - B, L - C), если не за краями экрана
        mov    a, h
        sub    b
        jc    loc_F558
          mov    d, a
          mov    a, l
          sub    c
          mov    e, a
          call   SetPixelRc
loc_F558:
        ; Рисуем точку (H - B, L + C), если не за краями экрана
        mov    a, h
        sub    b
        rc
          mov    d, a
          mov    a, l
          add    c
          mov    e, a
          call   SetPixelRc
        ret

;----------------------------------------------------------------------------

DrawFourPixelsCB:
        ; Рисуем точку (H + C, L + B), если не за краями экрана
        mov    a, h
        add    c
        jc     loc_F56F
          mov    d, a
          mov    a, l
          add    b
          mov    e, a
          call   SetPixelRc
loc_F56F:
        ; Рисуем точку (H + C, L - B), если не за краями экрана
        mov    a, h
        add    c
        jc     loc_F57B
          mov    d, a
          mov    a, l
          sub    b
          mov    e, a
          call   SetPixelRc
loc_F57B:
        ; Рисуем точку (H - C, L - B), если не за краями экрана
        mov    a, h
        sub    c
        jc    loc_F587
          mov    d, a
          mov    a, l
          sub    b
          mov    e, a
          call   SetPixelRc
loc_F587:
        ; Рисуем точку (H - C, L + B), если не за краями экрана
        mov    a, h
        sub    c
        rc
          mov    d, a
          mov    a, l
          add    b
          mov    e, a
          call   SetPixelRc
        ret

;----------------------------------------------------------------------------

SetPixelRc:
        ; Точка за пределами экрана
        rc

        push   h
        push   b

        ; Вычисление адреса в видеопамяти
        ; Вход: de - координаты. Выход: hl - адрес, b - смещение внутри байта.
        call   CalcPixelAddress

        ; Вычиление маски
        mvi    a, 80h
loc_F59A: rlc
          dcr    b
        jp     loc_F59A
        cma
        mov    b, a

        ; Цвет
        xchg
        lhld   v_color
        xchg

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

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

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        pop    b
        pop    h
        ret
