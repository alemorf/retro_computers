; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Чтение блока с магнитной ленты
; Вход: hl - адрес массива из 128 байт
; Выход: bc - идентификатор, de - сохраняется, hl - сохраняется

TapeReadBlock3:
        push    h
        push    d

        ; Настройка таймера
        mvi    a, 0Ah
        out    PORT_INT
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        mvi    a, 0
        out    PORT_TIMER_0
        out    PORT_TIMER_0

        mvi    c, 3
loc_FC79: call   TapeWaitChangeBreakable
          inr    a
          jz     TapeReadBlock3_key

          mov    a, b
          adi    4
          jp     loc_FC79
          dcr    c
        jnz    loc_FC79

loc_FC8A: call   TapeWaitChangeBreakable
          inr    a
          jz     TapeReadBlock3_key

          mov    a, b
          adi    4
        jm     loc_FC8A

        ; Поиск F5 в данных
        mvi    c, 0
loc_FC99:
          call   TapeWaitChangeBreakable
          inr    a
          jz     TapeReadBlock3_key
          dcr    a

          ; Добавляем загруженный бит к регистру D
          rar
          mov    a, c
          rar
          mov    c, a

          ; Цикл длится, пока не получим F5
          cpi    0F5h
        jnz    loc_FC99

        ; Для расчета контрольной суммы
        mvi    e, 0

        ; Чтение индентификатора с магнитной ленты
        call   TapeReadByte
        jnc    loc_FCDE
        mov    c, d
        call   TapeReadByte
        jnc    loc_FCDE
        mov    b, d
        push   b

        ; Чтение 128 байт данных с магнитной ленты
        mvi    c, 128
loc_FCBD: call   TapeReadByte
          jnc    loc_FCDA
          mov    m, d
          inx    h
          dcr    c
        jnz    loc_FCBD

        ; Чтение контрольной суммы с магнитной ленты
        call   TapeReadByte
        jnc    loc_FCDA

        ; Проверка контрольной суммы
        mov    a, e
        ora    a
        jz     loc_FCD6
          mvi    a, 1 ; Код ошибки
loc_FCD6:
        pop    b

TapeReadBlock3_exit:
        pop    d
        pop    h
        ret

;----------------------------------------------------------------------------

loc_FCDA:
        pop    b
        lxi    b, 0 ; Зачем?
loc_FCDE:
        mvi    a, 2 ; Код ошибки
        jmp    TapeReadBlock3_exit

;----------------------------------------------------------------------------

TapeReadBlock3_key:
        call   KeyRead
        mov    c, a  ; Код нажатой клавиши
        mvi    b, 0
        mvi    a, 4  ; Код ошибки
        jmp    TapeReadBlock3_exit
