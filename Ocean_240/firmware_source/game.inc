; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод игровой графики
; Вход: TODO

Game:
        ; Выход, если сейчас установлен не цветной видеорежим
        lda    v_screen_mode
        ani    3
        jnz    ExitEscMode

        ; Сброс 7-ого бита кода символа
        mov    a, c
        ani    7Fh
        mov    c, a

        ; Код 1 включает спрайты
        cpi    1
        jz     GameEnableSprites

        ; Коды от 0 до 31 выключают режим игровой графики
        cpi    20h
        jm     GameExit

        ; Вычисление адреса в видеопамяти
        lxi    h, v_arg_0
        mov    a, m
        mov    e, a
        adi    8           ; Ошибка?
        jc     GameExit
        mov    m, a
        inx    h
        mvi    a, 255 - 8  ; Ошибка?
        cmp    m
        jc     GameExit
        mov    d, m
        call   CalcPixelAddress
        mov    a, l  ; Зачем?
        sui    8
        mov    l, a
        push   h

        ; Какой режим?
        lda    v_game_sprites
        ora    a
        jnz    loc_E986
          ; Режим вывода символов
          mov    a, c
          call   FontGet
          mvi    c, 7
          pop    d
          inr    e
          jmp    loc_E99B
loc_E986:
          ; Режим вывода спрайтов
          mov    a, c
          sui    20h
          cpi    23h
          jnc    loc_E9ED

          ; Вычисление адреса спрайта
          mov    l, a
          xra    a
          mov    h, a
          dad    h
          dad    h
          dad    h
          lxi    d, game_sprites
          dad    d

          ; Высота спрайта
          mvi    c, 8
          pop    d
loc_E99B:

        ; Переход, если вывод без XOR
        lda    v_arg_2
        dcr    a
        jz     loc_E9F1

        ; Вывод XOR
loc_E9A2:
          ; Сохранение адреса спрайта
          push   h

          ; Включение видеопамяти
          mvi    a, 1
          out    PORT_MAPPER

          ; Загрузка линии спрайта
          mov    l, m
          mvi    h, 0

          ; Сдвиг линии на B бит влево
          mov    a, b
          ora    a
          jz     loc_E9B4
loc_E9AF:   dad    h
            dcr    a
          jnz    loc_E9AF
loc_E9B4:

          ; Рисование в первой плоскости (XOR)
          xchg
          lda    v_color
          ana    e
          xra    m
          mov    m, a
          inr    h
          inr    h
          lda    v_color
          ana    d
          xra    m
          mov    m, a

          ; Рисование во второй плоскости (XOR)
          dcr    h
          lda    v_color + 1
          ana    e
          xra    m
          mov    m, a
          inr    h
          inr    h
          lda    v_color + 1
          ana    d
          xra    m
          mov    m, a

          ; Корректировка адреса
          dcr    h
          dcr    h
          dcr    h
          inr    l

          ; Адрес в видеопамяти далее в DE
          xchg

          ; Отключение видеопамяти
          mvi    a, 0
          out    PORT_MAPPER

          ; Восстановление HL - адреса спрайта. И увеличение адреса.
          pop    h
          inx    h

          ; Следующая строка спрайта
          dcr    c
        jnz    loc_E9A2
        ret

;----------------------------------------------------------------------------

GameEnableSprites:
        sta    v_game_sprites
        ret

;----------------------------------------------------------------------------

GameExit:
        xra    a
        sta    v_game_sprites
        jmp    ExitEscMode

;----------------------------------------------------------------------------

loc_E9ED:
        pop    d
        jmp    GameExit

;----------------------------------------------------------------------------

loc_E9F1:
          ; Сохранение адреса символа
          push    h

          ; Включение видеопамяти
          mvi    a, 1
          out    PORT_MAPPER

          ; Строка символа
          mov    l, m

          ; Сдвиг строки символа на B бит
          mvi    h, 0
          mov    a, b
          ora    a
          jz     loc_EA03
loc_E9FE:     dad    h
              dcr    a
            jnz    loc_E9FE
loc_EA03:

          ; Адрес в видеопамяти далее в HL
          xchg

          ; Сохранение B
          push   b

          ; Рисование в первой плоскости
          lda    v_color
          cma
          mov    b, a
          mov    a, m
          xra    b
          ora    e
          xra    b
          mov    m, a
          inr    h
          inr    h
          mov    a, m
          xra    b
          ora    d
          xra    b
          mov    m, a

          ; Рисование во второй плоскости
          dcr    h
          lda    v_color+1
          cma
          mov    b, a
          mov    a, m
          xra    b
          ora    e
          xra    b
          mov    m, a
          inr    h
          inr    h
          mov    a, m
          xra    b
          ora    d
          xra    b
          mov    m, a

          ; Корректировка адреса
          dcr    h
          dcr    h
          dcr    h
          inr    l

          ; Адрес в видеопамяти далее в DE
          xchg

          ; Восстановление B
          pop    b

          ; Отключение видеопамяти
          mvi    a, 0
          out    PORT_MAPPER

          ; Восстановление HL - адреса символа. И увеличение адреса.
          pop    h
          inx    h

          ; Следующая строка спрайта
          dcr    c
        jnz    loc_E9F1
        ret

;----------------------------------------------------------------------------

game_sprites:
        .db    0,    0,    0,    0,    0,    0,    0,    0
        .db  7Eh,  81h, 0A5h,  81h, 0BDh,  99h,  81h,  7Eh
        .db  7Eh, 0FFh, 0DBh, 0FFh, 0C3h, 0E7h, 0FFh,  7Eh
        .db    0,    8,    8,  14h,  63h,  14h,    8,    8
        .db  36h,  7Fh,  7Fh,  7Fh,  3Eh,  1Ch,    8,    0
        .db    8,  1Ch,  3Eh,  7Fh,  3Eh,  1Ch,    8,    0
        .db  1Ch,  3Eh,  1Ch,  7Fh,  7Fh,  6Bh,    8,  1Ch
        .db    8,    8,  1Ch,  3Eh,  7Fh,  3Eh,    8,  1Ch
        .db  3Ch,  66h,  66h,  66h,  3Ch,  18h,  7Eh,  18h
        .db  18h, 0DBh,  3Ch, 0E7h, 0E7h,  3Ch, 0DBh,  18h
        .db 0E7h, 0E7h,    0,  7Eh,  7Eh,    0, 0E7h, 0E7h
        .db  7Eh,  81h,  81h, 0FFh, 0FFh,  81h,  81h,  7Eh
        .db    0,  18h,  3Ch,  7Eh,  18h,  18h,  18h,  18h
        .db  18h,  18h,  18h,  18h,  7Eh,  3Ch,  18h,    0
        .db    0,  10h,  30h,  7Fh,  7Fh,  30h,  10h,    0
        .db    0,    8,  0Ch, 0FEh, 0FEh,  0Ch,    8,    0
        .db  88h,  44h,  22h,  11h,  88h,  44h,  22h,  11h
        .db  11h,  22h,  44h,  88h,  11h,  22h,  44h,  88h
        .db  0Fh,  0Fh,  0Fh,  0Fh, 0F0h, 0F0h, 0F0h, 0F0h
        .db 0F0h, 0F0h, 0F0h, 0F0h,  0Fh,  0Fh,  0Fh,  0Fh
        .db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
        .db    0,    0,    0,    0, 0FFh, 0FFh, 0FFh, 0FFh
        .db  0Fh,  0Fh,  0Fh,  0Fh,  0Fh,  0Fh,  0Fh,  0Fh
        .db 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h, 0F0h
        .db 0FFh, 0FFh, 0FFh, 0FFh,    0,    0,    0,    0
        .db 0CCh, 0CCh,  33h,  33h, 0CCh, 0CCh,  33h,  33h
        .db  70h,    8,  76h, 0FFh, 0FFh, 0FFh,  7Eh,  18h
        .db 0C3h, 0DBh, 0DBh,  18h,  18h, 0DBh, 0DBh, 0C3h
        .db 0FCh, 0CCh, 0FCh,  0Ch,  0Ch,  0Eh,  0Fh,    7
        .db 0FEh, 0C6h, 0FEh, 0C6h, 0C6h, 0E6h,  67h,    3
        .db  18h,  3Ch,  3Ch,  18h,  7Eh,  18h,  24h,  66h
        .db    1,    2,    4,    8,  10h,  20h,  40h,  80h
        .db  80h,  40h,  20h,  10h,    8,    4,    2,    1
        .db    1,    1,    1,    1,    1,    1,    1,    1
        .db    0,    0,    0,    0,    0,    0,    0, 0FFh
