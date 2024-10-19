; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Переместить головку на нулевую дорожку дисекты
; Вход: b - дисковод
; Выход: a - код ошибки, cf - если была ошибка

FloppyHome:
        ; Отправка команды "Поиск нулевой дорожки" в КР1818ВГ93
        mvi    a, 0
        out    PORT_VG93_DATA
        mvi    a, 3
        out    PORT_VG93_COMMAND

        ; Задержка
        nop
        nop

        ; Ожидание пока КР1818ВГ93 занят или не выбрана нулевая дорожка или не наступит таймаут
loc_FDA8: in     PORT_VG93_COMMAND
          ani    5
          cpi    4
          jz     loc_FDBA
          in     PORT_FLOPPY
          rlc
        jnc    loc_FDA8

        ; Таймаут. Выход с кодом ошибки.
        mvi    a, 20h
        ret

loc_FDBA:
        ; Обновление переменной содержащей номер дорожки
        mov    a, b
        dcr    a
        mvi    a, 1
        jz     loc_FDC9
        sta    v_floppy_0_inited
        xra    a
        sta    v_floppy_0_track
        ret

loc_FDC9:
        sta    v_floppy_1_inited
        xra    a
        sta    v_floppy_1_track
        ret
