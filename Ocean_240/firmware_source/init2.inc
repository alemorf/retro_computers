; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Инициализация компьютера

a_system_not_found:
        .db 0Dh, 0Ah
        .text "SYSTEM NOT FOUND"
        .db 0Dh, 0Ah, 0

Halt:
        hlt
