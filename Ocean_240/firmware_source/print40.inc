; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Рисование символа
; Вход: c - символ

PrintChar3:        
        ; 7-ой бит кода символа игнорируется
        mov    a, c
        ani    7Fh

        ; Обработка непечатных символов в другой функции
        cpi    20h
        jm     PrintControlChar

        ; Получение адреса символа в знакогенераторе
        call   FontGet
        xchg

        ; Переход, если режим не 40x25
        lda    v_screen_mode
        ani    3
        jnz    Print64

        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Рисование символа в режиме 40x25
; Вход: c - символ

Print40:
        ; Вычисление адреса символа в видеопамяти
        call   CalcTextAddress40

        ; Корректировка адреса
        inr    l

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Корректировка адреса
        dcr    h
        dcr    h

        ; Выбор маски и битового смещения
        mov    a, b
        ora    b
        jz     loc_E377
        dcr    b
        jz     loc_E381
        dcr    b
        jz     loc_E389
        jmp    loc_E391

;----------------------------------------------------------------------------

loc_E377:
        inr    h
        inr    h
        lxi    b, 0FFC0h
        mvi    a, 0
        jmp    loc_E396

;----------------------------------------------------------------------------

loc_E381:
        lxi    b, 0F03Fh
        mvi    a, 6
        jmp    loc_E396

;----------------------------------------------------------------------------

loc_E389:
        lxi    b, 0FC0Fh
        mvi    a, 4
        jmp    loc_E396

;----------------------------------------------------------------------------

loc_E391:
        lxi    b, 0FF03h
        mvi    a, 2

loc_E396:
        sta    byte_BFF6
        xchg

        ; Рисование символа
loc_E39A:
        lda    byte_BFF6
        push   h
        mov    l, m
        mvi    h, 0
        ora    a
        jz     loc_E3AA

loc_E3A5:
        dad    h
        dcr    a
        jnz    loc_E3A5

loc_E3AA:
        xchg
        mov    a, m
        ana    c
        mov    m, a

        lda    v_color
        ana    e
        ora    m
        mov    m, a
        inr    h
        mov    a, m
        ana    c
        mov    m, a

        lda    v_color+1
        ana    e
        ora    m
        mov    m, a
        inr    h
        mov    a, m
        ana    b
        mov    m, a

        lda    v_color
        ana    d
        ora    m
        mov    m, a
        inr    h
        mov    a, m
        ana    b
        mov    m, a

        lda    v_color+1
        ana    d
        ora    m
        mov    m, a

        inr    l
        dcr    h
        dcr    h
        dcr    h
        xchg
        pop    h
        inx    h

        lda    v_tmp_char_height
        dcr    a
        sta    v_tmp_char_height

        jnz    loc_E39A

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ; После завершения функции нарисовать кусор
        lxi    h, DrawCursor
        push   h
        lxi    h, v_cursor_position

        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 18h (вправо) в консоль в режиме 40x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print40Right:
        inx    h
        mov    a, m
        adi    1
        ani    3Fh  ; Мертвый код
        mov    m, a
        cpi    40   ; Ширина экрана
        dcx    h
        rm

loc_E3F9:
        inx    h
        xra    a
        mov    m, a
        dcx    h

        ; Если используется только 2 верхних текстовых строки
        lda    v_screen_mode
        ani    8
        jnz    Print2Down

        ; Продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 0Ah (вниз) или 1Ah (вниз) в консоль в режиме 80x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print40Down:
        mov    a, m
        adi    TEXT_LINE_HEIGHT
        cpi    248
        jnc    ScrollUp
        mov    m, a
        ret

;----------------------------------------------------------------------------
; Вывод кода 8 (влево) в консоль в режиме 40x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print40Left:
        inx    h
        mov    a, m
        sui    1
        ani    3Fh  ; Мертвый код
        cpi    3Fh
        jz     loc_E41D
        mov    m, a
        dcx    h
        ret

;----------------------------------------------------------------------------

loc_E41D:
        mvi    a, 40 - 1  ; Ширина экрана
        mov    m, a
        dcx    h
        ; продолжение в следующей функции

;----------------------------------------------------------------------------
; Вывод кода 19h (вверх) в консоль в режиме 40x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print40Up:
        mov    a, m
        sui    TEXT_LINE_HEIGHT
        jnc    loc_E429
          mvi    a, TEXT_LINE_HEIGHT * (TEXT_LINES - 1)
loc_E429:
        mov    m, a
        ret

;----------------------------------------------------------------------------
; Вывод кода 9 (TAB) в консоль в режиме 40x25
; Вход: hl - v_cursor_position
; Выход: hl - сохраняется

Print40Tab:
        inx    h
        mov    a, m  ; Координата X
        adi    8
        ani    3Fh   ; Мертвый код
        mov    m, a
        cpi    40    ; Ширина экрана
        dcx    h
        rm
        jmp    loc_E3F9
