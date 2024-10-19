; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Прочитать сектор с дискеты
; Вход: a - диск, c - Код команды для К1818ВГ93
; Выход: a - код ошибки, cf - если была ошибка

FloppyRead:
        push   psw

        ; Выбор дисковода и головки
        call   FloppySetDriveHead
        pop    psw

        ; Если необходимо, то перезагрузить К1818ВГ93. Установить дорожку и сектор.
        call   FloppyReinitSetTrackSector
        jc     Return

        ; Отправка команды в К1818ВГ93, получение блока данных из К1818ВГ93
        call   FloppyReadInteral
        jc     Return

        ; Возврат кода ошибки 0
        xra    a
        ret
