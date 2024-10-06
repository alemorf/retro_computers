; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Нарисовать или стереть курсор (XOR)
; Вход: HL
; Выход: HL - сохраняется

DrawCursor:
        ; Выход, если курсор отключен
        lda    v_screen_mode
        ani    4
        rnz

        ; Продолжаем, если цветной видеорежим 40 символов
        lda    v_screen_mode
        ani    3
        jnz    DrawCursor64

        ; Выход, если курсор за пределами экрана
        xchg
        lhld   v_cursor_position
        mov    a, h
        cpi    40
        xchg
        rp

        ; Вычисление адреса в видеопамяти
        push   h
        xchg
        call   CalcTextAddress40

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Корректировка адреса в видеопамяти
        dcr    h
        dcr    h
        inr    l

        ; Высота курсора
        mvi    c, 7

        ; Вычисление маски
        mov    a, b
        ora    b
        jz     loc_E6CF
        dcr    b
        jz     loc_E6D7
        dcr    b
        jz     loc_E6DD
        jmp    loc_E6E3
loc_E6CF:
        inr    h
        inr    h
        lxi    d, 1Fh
        jmp    loc_E6E6
loc_E6D7:
        lxi    d, 1Fh << 6
        jmp    loc_E6E6
loc_E6DD:
        lxi    d, 1Fh << 4
        jmp    loc_E6E6
loc_E6E3:
        lxi    d, 1Fh << 2
loc_E6E6:

        ; Рисование курсора (XOR)
loc_E6E7:
          mov    a, m
          xra    e
          mov    m, a
          inr    h
          mov    a, m
          xra    e
          mov    m, a
          inr    h
          mov    a, m
          xra    d
          mov    m, a
          inr    h
          mov    a, m
          xra    d
          mov    m, a
          inr    l
          dcr    h
          dcr    h
          dcr    h
          dcr    c
        jnz    loc_E6E7

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        pop    h
        ret

;----------------------------------------------------------------------------

DrawCursor64:
        ; Продолжаем, если видеорежим 64 символов
        cpi   3
        jz    DrawCursor80

        ; Вычисление адреса в видеопамяти
        xchg
        lhld   v_cursor_position
        lda    v_scroll_y
        add    l
        mov    l, a

        ; Выход, если курсор за пределами экрана
        mov    a, h
        cpi    64
        xchg
        rp

        ; Вычисление адреса в видеопамяти
        xchg
        adi    40h
        mov    h, a

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Рисование курсора (XOR)
        lxi    b, 7F08h
loc_E721: mov    a, m
          xra    b
          mov    m, a
          inr    l
          dcr    c
        jnz    loc_E721
        xchg

        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        ret

;----------------------------------------------------------------------------

DrawCursor80:
        ; Монохромный видеорежим 80 символов

        ; Выход, если курсор за пределами экрана
        xchg
        lhld   v_cursor_position
        mov    a, h
        cpi    80
        xchg
        rp

        ; Вычисление адреса в видеопамяти
        push   h
        call   CalcTextAddress80

        ; Высота курсора
        mvi    c, 7

        ; Корректировка адреса в видеопамяти
        inr    l

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Вычисление маски
        mov    a, b
        ora    a
        mvi    b, 1Fh
        jz     loc_E75E
        dcr    a
        lxi    d, 0C007h
        jz     loc_E769
        dcr    a
        lxi    d, 0F001h
        jz     loc_E769
        mvi    b, 7Ch
        dcr    h
        jmp    loc_E75E
loc_E75E:

        ; Рисование курсора (XOR), когда кусор занимает 1 байт
loc_E75F: mov    a, m
          xra    b
          mov    m, a
          inr    l
          dcr    c
        jnz    loc_E75F
        jmp    loc_E776

        ; Рисование курсора (XOR), когда кусор занимает 2 байта
loc_E769: dcr    h
          mov    a, m
          xra    d
          mov    m, a
          inr    h
          mov    a, m
          xra    e
          mov    m, a
          inr    l
          dcr    c
        jnz    loc_E769

loc_E776:
        ; Отключение видеопамяти
        mvi    a, 0
        out    PORT_MAPPER

        pop    h
        ret
