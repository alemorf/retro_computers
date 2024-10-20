; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Прочитать сектор с дискеты
; Вход: a - номер дисковода, c - код команды для К1818ВГ93
; Выход: a - код ошибки, cf - если была ошибка

FloppyRead:
        ; Выбор дисковода и головки
        push   psw
        call   FloppySetDriveHead
        pop    psw

        ; Запуск двигателя. Выбор дорожки и сектора.
        call   FloppyStartMotorSetTrackSector
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        jc     Return
#else
        rc
#endif
        ; Отправка команды в К1818ВГ93, получение блока данных из К1818ВГ93
        call   FloppyReadInteral
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        jc     Return
#else
        rc
#endif
        ; Выход с кодом ошибки 0
        xra    a
        ret
