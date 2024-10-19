; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Записать сектор на дискету
; Вход: a - Диск, c - Код команды для К1818ВГ93
; Выход: a - код ошибки, cf - если была ошибка

FloppyWrite:
        ; Выбор дисковода и головки
        push   psw
        call   FloppySetDriveHead
        pop    psw

        ; Если необходимо, то перезагрузить К1818ВГ93. Установить дорожку и сектор.
        call   FloppyReinitSetTrackSector
        jc     Return

        ; Отправка команды в К1818ВГ93, отправка блока данных в К1818ВГ93
        call   FloppyWriteInternal
        jc     Return

        ; Возврат кода ошибки 0
        xra    a
        ret
