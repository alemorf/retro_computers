; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Рисование символа в режиме 80x25
; Вход: c - символ

Print80:
        ; Вычисление адреса символа в видеопамяти
        call   CalcTextAddress80

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Корректировка адреса
        xchg
        inr    e

        ; Выбор маски и битового смещения
        mov    a, b
        ora    a
        jz     loc_E55E
        dcr    a
        jz     loc_E56D
        dcr    a
        jz     loc_E58E
        jmp    loc_E5B3

;----------------------------------------------------------------------------

loc_E55E: mov    b, m
          ldax   d
          ani    0C0h
          ora    b
          stax   d
          inx    h
          inr    e
          dcr    c
        jnz    loc_E55E

        jmp    loc_E5C4

;----------------------------------------------------------------------------

loc_E56D: mov    a, m
          rrc
          rrc
          ani    7
          mov    b, a

          ldax   d
          ani    0F0h
          ora    b
          stax   d

          mov    a, m
          rrc
          rrc
          ani    0C0h
          mov    b, a

          dcr    d
          ldax   d
          ani    1Fh
          ora    b
          stax   d
          inr    d

          inx    h
          inr    e
          dcr    c
        jnz    loc_E56D

        jmp    loc_E5C4

;----------------------------------------------------------------------------

loc_E58E: mov    a, m
          rrc
          rrc
          rrc
          rrc
          ani    1
          mov    b, a

          ldax   d
          ani    0FCh
          ora    b
          stax   d

          mov    a, m
          rrc
          rrc
          rrc
          rrc
          ani    0F0h

          mov    b, a
          dcr    d
          ldax   d
          ani    7
          ora    b
          stax   d
          inr    d

          inx    h
          inr    e
          dcr    c
        jnz    loc_E58E

        jmp    loc_E5C4

;----------------------------------------------------------------------------

loc_E5B3:
        dcr    d
loc_E5B4:
          mov    a, m
          rlc
          rlc
          mov    b, a

          ldax   d
          ani    1
          ora    b
          stax   d

          inx    h
          inr    e
          dcr    c
        jnz    loc_E5B4

        inr    d

loc_E5C4:
        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ; После завершения функции нарисовать кусор
        lxi    h, DrawCursor
        push   h
        lxi    h, v_cursor_position

        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 18h (вправо) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print80Right:
        inx    h
        mov    a, m
        adi    1
        ani    7Fh  ; Мертвый код
        mov    m, a
        cpi    80   ; Ширина экрана
        dcx    h
        rm

loc_E5DA:
        inx    h
        xra    a
        mov    m, a
        dcx    h

        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 0Ah (вниз) или 1Ah (вниз) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print80Down:
        mov    a, m
        adi    TEXT_LINE_HEIGHT
        cpi    248
        jnc    ScrollUp
        mov    m, a
        ret

;----------------------------------------------------------------------------
; Вывод кода 8 (влево) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print80Left:
        inx    h
        mov    a, m
        sui    1
        ani    7Fh  ; Мертвый код
        cpi    7Fh
        jz     loc_E5F6
        mov    m, a
        dcx    h
        ret

;----------------------------------------------------------------------------

loc_E5F6:
        mvi    a, 80 - 1  ; Ширина экрана
        mov    m, a
        dcx    h
        ; продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 19h (вверх) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print80Up:
        mov    a, m
        sui    TEXT_LINE_HEIGHT
        jnc    loc_E602
          mvi    a, TEXT_LINE_HEIGHT * (TEXT_LINES - 1)
loc_E602:
        mov    m, a
        ret

;----------------------------------------------------------------------------
; Вывод кода 9 (TAB) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print80Tab:
        inx    h
        mov    a, m  ; Координата X
        adi    8
        ani    7Fh   ; Мертвый код
        mov    m, a
        cpi    80    ; Ширина экрана
        dcx    h
        rm
        jmp    loc_E5DA
