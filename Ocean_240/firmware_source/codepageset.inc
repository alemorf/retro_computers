; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Изменить кодовую страницу
; Вход: v_arg_0 - кодовая страница

CodepageSet:
        lda    v_arg_0
        ani    3
        sta    v_codepage
        ret
