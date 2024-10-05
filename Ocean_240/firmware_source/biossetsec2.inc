; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция CP/M BIOS

BiosSetSec2:
        lxi    h, v_sector_128
        mov    m, c
        ret

