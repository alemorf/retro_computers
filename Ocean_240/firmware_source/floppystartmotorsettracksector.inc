; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Запустить двигатель. Установить дорожку и сектор.
; Вход: a - дисковод
; Выход: a - код ошибки, cf - если была ошибка

FloppyStartMotorSetTrackSector:
        ; Запустить двигатель
        call   FloppyStartMotor
        rc

        ; Установить дорожку и сектор
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        call   FloppySetTrackSector
        rc
        ret
#else
        jmp    FloppySetTrackSector
#endif


