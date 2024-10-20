; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Чтение байта с магнитной ленты
; Вход: e - контрольная сумма
; Выход: bc - сохраняется, d - байт, e - контрольная сумма, nc - если ошибка

TapeReadByte:
        push   b

        ; Цикл чтения 8 бит
        mvi    c, 8
loc_FCF1: call   TapeWaitChange

          ; Добавление загруженного бита к регистру D
          rar
          mov    a, d
          rar
          mov    d, a

          ; Переход, если ошибка загрузки
          mvi    a, 4
          add    b
          jnc    loc_FD06

          ; Конец цикла
          dcr    c
        jnz    loc_FCF1

        ; Расчет контрольной суммы
        mov    a, d
        add    e
        mov    e, a

        ; Выход без ошибок
        stc

loc_FD06:
        pop    b
        ret
