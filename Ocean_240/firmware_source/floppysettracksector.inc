; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Установка дорожки и сектора дисковода
; Вход: b - дисковод
; Выход: a - код ошибки, cf - если была ошибка

FloppySetTrackSector:
        ; У каждого дисковода свои переменные
        mov    a, b
        dcr    a
        jz     loc_FEBC

        ; Если дисковод 0 не инициализирован
        lda    v_floppy_0_inited
        ora    a
        cz     FloppyHome
        rc

        ; Загрузка текущей дорожки в контроллер
        lda    v_floppy_0_track
        out    PORT_VG93_TRACK

        ; Сохранение текущей дорожки в память
        mov    a, d
        sta    v_floppy_0_track

        jmp    loc_FECD

;----------------------------------------------------------------------------

loc_FEBC:
        ; Если дисковод 1 не инициализирован
        lda    v_floppy_1_inited
        ora    a
        cz     FloppyHome
        rc

        ; Загрузка текущей дорожки в контроллер
        lda    v_floppy_1_track
        out    PORT_VG93_TRACK

        ; Сохранение текущей дорожки в память
        mov    a, d
        sta    v_floppy_1_track

loc_FECD:
        ; Если обращение к тому же дисководу, то пропускаем задержку
        lda    v_floppy_current
        cmp    b
        mov    a, b
        sta    v_floppy_current
        jnz    loc_FF06

        ; Если обращение к той же дорожке, то пропускаем задержку
        in     PORT_VG93_TRACK
        cmp    d
        jz     loc_FF06

        ; Если нужно перемещаться на дорожку с большим номером
        jc     loc_FEF5

        ; Если направление не изменилось, то пропускаем задержку
        lda    v_floppy_direction
        ora    a
        jnz    loc_FF06

        ; Задержка
        mvi    b, 255
        call   DelayB

        ; Сохраняем направление
        mvi    a, 1
        sta    v_floppy_direction
        jmp    loc_FF06

;----------------------------------------------------------------------------

loc_FEF5:
        ; Если направление не изменилось, то пропускаем задержку
        lda    v_floppy_direction
        ora    a
        jz     loc_FF06

        ; Задержка
        mvi    b, 255
        call   DelayB

        ; Сохраняем направление
        mvi    a, 0
        sta    v_floppy_direction

loc_FF06:
        ; Передаем контроллеру номер дорожки и команду перехода на дорожку
        mov    a, d
        out    PORT_VG93_DATA
        mvi    a, 1Fh
        out    PORT_VG93_COMMAND

        ; Задержка
        nop
        nop

        ; Остановка процессора до запроса прерывания от К1818ВГ93 или таймаута
        in     PORT_FLOPPY_WAIT

        ; Проверка результата выполнения команды
        in     PORT_VG93_COMMAND
        ani    19h ; Ошибка поиска + Ошибка КС + Занят
        cpi    0
        jnz    loc_FF1D
          jmp    loc_FF20
loc_FF1D:
          ; Код ошибки
          stc
          mvi    a, 40h
loc_FF20:
        ; Установка номера сектора
        push   psw
          mov    a, e
          out    PORT_VG93_SECTOR
        pop    psw
        ret
