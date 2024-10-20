; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Записать сектор на дискету
; Вход: a - номер дисковода, c - код команды для К1818ВГ93
; Выход: a - код ошибки, cf - если была ошибка

FloppyWrite:
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
        ; Отправка команды в К1818ВГ93, отправка блока данных в К1818ВГ93
        call   FloppyWriteInternal
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        jc     Return
#else
        rc
#endif
        ; Выход с кодом ошибки 0
        xra    a
        ret
