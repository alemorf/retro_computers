; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Установить цвет для текста и графики
; Вход: v_arg_0 - цвет

ColorSet:
        lda    v_arg_0
ColorSetInt:
        ani    3
        rar
        mov    b, a
        mvi    a, 0
        sbb    a
        sta    v_color
        mov    a, b
        dcr    a
        cma
        sta    v_color + 1
        ret
