; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Запустить двигатель дисковода
; Вход: b - дисковод
; Выход: a - код ошибки, cf - если была ошибка

FloppyStartMotor:
        ; Если выбран другой дисковод, то нужна задержка на раскрутку
        mov    b, a
        lda    v_floppy_current
        cmp    b
        jz     loc_FE6B
        call   FloppyStartMotor2
        ret
loc_FE6B:

        ; Если двигатель выключен, то запустить двигатель
        in     PORT_FLOPPY
        rlc
        jc     FloppyStartMotor2

        ; Если дисковод не готов, то запустить двигатель
        in     PORT_VG93_COMMAND
        ani    80h  ; Not ready
        rz

;----------------------------------------------------------------------------

FloppyStartMotor2:
        push   b

        ; Значение для задержки на раскрутку
        lxi    b, 0FFFFh

        ; Короткий негативный импульс на INIT запускает двигатель
        call   FloppyToggleInit

        ; Ожидаение готовности дисковода или остановки двигателя по таймауту
loc_FE7D: in     PORT_VG93_COMMAND
          ani    80h  ; Not ready
          jz     loc_FE8F
          in     PORT_FLOPPY
          rlc
        jnc    loc_FE7D

        ; Таймаут. Выход с кодом ошибки.
        mvi    a, 20h
        jmp    loc_FE95

        ; Задержка на раскрутку
loc_FE8F: dcx    b
          mov    a, b
          ora    a
        jnz    loc_FE8F

loc_FE95:
        pop    b
        ret

;----------------------------------------------------------------------------

FloppyToggleInit:
        ; Установка 0 на линии INIT
        in     PORT_FLOPPY
        ani    4Eh
        rar
        out    PORT_FLOPPY

        ; Установка 1 на линии INIT
        ori    PFE_NEG_INIT
        out    PORT_FLOPPY
        ret
