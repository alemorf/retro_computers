; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Копирование памяти
; Вход: hl - куда, de - откуда, c - длина

MemcpyHlDeC:
          ldax   d
          mov    m, a
          inx    h
          inx    d
          dcr    c
        jnz    MemcpyHlDeC
        ret
