; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Получить адрес символа в знакогенераторе с учетом v_codepage
; Вход: A - код символа от 20h до 7Fh
; Выход: HL - адрес

FontGet:
        ; hl = a * 7
        mov    l, a
        mov    e, a
        xra    a
        mov    d, a
        mov    h, a
        dad    h
        dad    d
        dad    h
        dad    d

        ; На символы от 20h до 3Fh переменная v_codepage не влияет
        mov    a, e
        cpi    40h
        jm     loc_E344

        ; Если v_codepage = 0, то отображается латиница
        lda    v_codepage
        ora    a
        jz     loc_E344

        ; Если v_codepage = 1, то отображается кирилица
        dcr    a
        jz     loc_E340

        ; Если v_codepage = 2, то символы 40h .. 5Fh отображаются
        ; отображается латиницей, а символы 60h .. 7Fh кирилицей
        mov    a, e
        cpi    60h
        jm     loc_E344

        ; Кирилица записана через 64 символа от латиницы
loc_E340:
        lxi    d, 64 * 7
        dad    d

loc_E344:
        ; Начало шрифта
        lxi    d, font - (32 * 7)
        dad    d
        ret
