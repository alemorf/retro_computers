; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Если необходимо, то перезагрузить К1818ВГ93. Установить дорожку и сектор.
; Вход: a - дисковод
; Выход: a - код ошибки, cf - если была ошибка

FloppyReinitSetTrackSector:
        ; Если необходимо, то перезагрузить К1818ВГ93
        call   FloppyReinitIfNecessary
        rc

        ; Установить дорожку и сектор
        call   FloppySetTrackSector
        rc

        ret

;----------------------------------------------------------------------------

FloppyReinitIfNecessary:
        ; Если будет выбран другой дисковод, то перезагрузить К1818ВГ93
        mov    b, a
        lda    v_floppy_current
        cmp    b
        jz     loc_FE6B
        call   FloppyReinit
        ret
loc_FE6B:

        ; Если мотор выключен, то перезагрузить К1818ВГ93
        in     PORT_FLOPPY
        rlc
        jc     FloppyReinit

        ; Если К1818ВГ93 выполняет какую то команду, то перезагрузить К1818ВГ93
        in     PORT_VG93_COMMAND
        ani    80h  ; Not ready
        rz

;----------------------------------------------------------------------------

FloppyReinit:
        push   b

        ; Значение для задержки после перезагрузки
        lxi    b, 0FFFFh

        ; Перезагрузка К1818ВГ93
        call   FloppyToggleResetPin

        ; Ожидаение готовности К1818ВГ93 или таймаута
loc_FE7D: in     PORT_VG93_COMMAND
          ani    80h  ; Not ready
          jz     loc_FE8F
          in     PORT_FLOPPY
          rlc
        jnc    loc_FE7D

        ; Таймаут. Выход с кодом ошибки.
        mvi    a, 20h
        jmp    loc_FE95

        ; Задержка
loc_FE8F: dcx    b
          mov    a, b
          ora    a
        jnz    loc_FE8F

loc_FE95:
        pop    b
        ret

;----------------------------------------------------------------------------

FloppyToggleResetPin:
        ; Установка 0 на ножке перезагрузки К1818ВГ93
        in     PORT_FLOPPY
        ani    4Eh  ; Тут не снимается PFE_NEG_INIT!
        rar
        out    PORT_FLOPPY

        ; Установка 1 на ножке перезагрузки К1818ВГ93
        ori    PFE_NEG_INIT
        out    PORT_FLOPPY
        ret
