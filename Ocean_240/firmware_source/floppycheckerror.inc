; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Получение кода ошибки от К1818ВГ93
; Выход: a - код ошибки, cf - если была ошибка

FloppyCheckError:
        in     PORT_VG93_COMMAND
        ani    ~20h  ; Игнорируем: Ошибка записи, Загрузка МГ, Тип записи
        cpi    0
        jz     Return
        stc
Return:
        ret
