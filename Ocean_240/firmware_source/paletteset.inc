; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Изменить палитру
; Вход: v_arg_0 - палитра

PaletteSet:
        ; Сохранить палитру
        lda    v_arg_0
        ani    3Fh
        sta    v_palette

        ; Обновить порт
        mov    b, a
        lda    v_screen_mode
        ani    3
        mvi    a, 0
        jnz    loc_E313
        mvi    a, 40h
loc_E313:
        ora    b
        out    PORT_COLOR
        ret
