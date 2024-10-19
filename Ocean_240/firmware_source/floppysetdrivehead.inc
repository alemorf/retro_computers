; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Выбор дисковода и головки
; Вход: a - дисковод

FloppySetDriveHead:
        push   psw

        ; Задержка
        call   Delay175

        ; Выбор дисковода
        cpi    1
        jz     loc_FDDF
          mvi    a, PFE_MOTOR_1
        jmp    loc_FDE1
loc_FDDF:
          mvi    a, PFE_MOTOR_0 | PFE_DRIVE_SELECT
loc_FDE1:
        mov    b, a
        in     PORT_FLOPPY
        ani    PFE_SIDE_SELECT << 1
        rar
        ora    b
        out    PORT_FLOPPY
        mov    b, a

        ; Получение кол-ва дорожек дисковода в регистр А
        pop    psw
        dcr    a
        jz     loc_FDF6
          lda    v_disk_c_tracks
        jmp    loc_FDF9
loc_FDF6: lda    cfg_disk_b_tracks
loc_FDF9:
        push   b

        ; Продолжаем, если номер дорожки больше или равен кол-ву
        ; дорожек на одной стороне дискеты
        mov    b, a
        mov    a, d
        cmp    b
        jc     loc_FE15

        ; Вычитаем из номера дорожки кол-во дорожек на одной стороне дискеты
        sub    b
        mov    d, a

        ; Устанавливаем бит "сторона" в коде команды
        pop    b
        mov    a, c
        ori    8
        mov    c, a

        ; Выход, если SSEL установден
        mov    a, b
        ani    PFE_SIDE_SELECT
        ora    a
        rnz

        ; Установка SSEL
        mov    a, b
        ori    PFE_SIDE_SELECT
        out    PORT_FLOPPY

        ; Небольшая задержка
        call   Delay16
        ret

loc_FE15:
        pop    b

        ; Выход, если SSEL сброшен
        mov    a, b
        ani    PFE_SIDE_SELECT
        ora    a
        rz

        ; Сброс SSEL
        mov    a, b
        ani    PFE_MOTOR_0 | PFE_MOTOR_1 | PFE_DRIVE_SELECT
        out    PORT_FLOPPY

        ; Небольшая задержка
        call   Delay16
        ret

;----------------------------------------------------------------------------

Delay16:
        mvi    b, 16

;----------------------------------------------------------------------------

DelayB:
        dcr    b
        jnz    DelayB
        ret

;----------------------------------------------------------------------------

Delay175:
        mvi    b, 175
        jmp    DelayB
