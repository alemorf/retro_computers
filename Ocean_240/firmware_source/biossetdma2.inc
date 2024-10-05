; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция CP/M BIOS

BiosSetDma2:
        mov    l, c
        mov    h, b
        shld   v_dma
        ret
