; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Вывод символа в консоль

PrintChar:
        push   h
        push   d
        push   b
        call   PrintChar2
        pop    b
        pop    d
        pop    h
        ret

;----------------------------------------------------------------------------

PrintChar2:
        ; Если v_esc_mode = 0, то переход в функцию PrintChar3 (стандартная обработка)
        lxi    d, v_esc_mode
        ldax   d
        dcr    a
        ora    a
        jm     PrintChar3

        ; Если v_esc_mode > 1, то переход в функцию Game (игровая графика)
#ifndef CONFIG_NO_GAME
        jnz    Game
#else
        jnz    ExitEscMode
#endif

        ; Если v_esc_command != 0, то переход в функцию PrintCharEscArgs (получение аргументов)
        inx    d
        ldax   d
        ora    a
        jp     PrintCharEscArgs

        ; VT52
#ifdef CONFIG_VT52
        mov    a, c
        sui    'A'
        jnc    Vt52
#endif

        ; Иначе это получение первого байта ESC последовательности
        ; Сохранение символа, он же код команды
        ; v_esc_command = char & 0Fh
        mov    a, c
        ani    0Fh
PrintChar4:
        stax   d

        ; Сброс счетчика полученных аргументов
        ; v_esc_count = 0
        inx    d
        xra    a
        stax   d
        ret

;----------------------------------------------------------------------------

PrintCharEscArgs:
        ; Чтение в B код команды (v_esc_command)
        lxi    h, v_esc_command
        mov    b, m
        inx    h

        ; Увеличение счетчика полученых аргументов (v_esc_count)
        mov    a, m
        inr    a
        mov    m, a

        ; Сохранение очередного аргумента (v_arg_?)
        mov    e, a
        mvi    d, 0
        dad    d
        mov    m, c

        ; Выход, если не получено заданное кол-во аргументов
        lxi    h, esc_args_count
        mov    e, b
        dad    d
        cmp    m
        rm

        ; Получение в E кода команды (v_esc_command)
        lxi    h, v_esc_command
        mov    a, m
#ifndef CONFIG_VT52
        ani    0Fh   ; Мертвый код (выше b не обрезается)
#endif
        mov    e, a

        ; Если получен нулевой код команды, то переход в режим игровой графики
        dcx    h
        ora    a
        mvi    m, 2
        rz

        ; v_esc_mode = 0
        mvi    d, 0
        mov    m, d

        ; Получение адреса ESC функции
        dcx    d
        lxi    h, esc_functions
        dad    d
        dad    d
        mov    e, m
        inx    h
        mov    d, m
        xchg

        ; Если это функции 0, 1, 2, 3 и v_screen_mode != 0, то выход
        cpi    4
        jp     loc_E1C1
        lda    v_screen_mode
        ani    3
        jnz    ExitEscMode
loc_E1C1:

        ; Выполнить ExitEscMode после выхода из ESC фунции
        lxi    d, ExitEscMode
        push   d
        pchl

;----------------------------------------------------------------------------

ExitEscMode:
        xra    a
        sta    v_esc_mode
        ret

;----------------------------------------------------------------------------

esc_args_count:
        .db 3  ; 0
        .db 5  ; 1
        .db 4  ; 2
        .db 3  ; 3
        .db 1  ; 4
        .db 2  ; 5
        .db 1  ; 6
        .db 1  ; 7
        .db 1  ; 8
        .db 2  ; 9
        .db 1  ; :
        .db 5  ; ;
        .db 5  ; <
        .db 7  ; =
        .db 6  ; >
        .db 4  ; ?

esc_functions:
        .dw DrawFillRect       ; 1
        .dw DrawLine           ; 2
        .dw DrawPixel          ; 3
        .dw ColorSet           ; 4
        .dw CursorPositionSet  ; 5
        .dw ScreenModeSet      ; 6
        .dw CodepageSet        ; 7
        .dw PaletteSet         ; 8
        .dw CursorPositionSet2 ; 9
        .dw PrinterScreen      ; :
        .dw DrawCircle         ; ;
        .dw Paint              ; <
        .dw GetPutImage        ; =
        .dw Picture            ; >
        .dw BeepSet            ; ?

;----------------------------------------------------------------------------

#ifdef CONFIG_VT52

Vt52:   jz     Vt52Up
        dcr    a ; B
        jz     Vt52Down
        dcr    a ; C
        jz     Vt52Right
        dcr    a ; D
        jz     Vt52Left
        sui    'H' - 'D'
        jz     Vt52Home
        sui    'J' - 'H'
        jz     Vt52ClearToEndOfScreen
        dcr    a ; K
        jz     Vt52ClearToEndOfLine
        sui    'Y' - 'K'
        jz     Vt52SetPosition

        xra    a
        dcx    d
        stax   d

        jmp    PrintChar3
;        ret

;----------------------------------------------------------------------------

Vt52Up:
        dcx    d
        stax   d
        mvi    a, 19h
        jmp    loc_E78A

;----------------------------------------------------------------------------

Vt52Down:
        dcx    d
        stax   d
        mvi    a, 1Ah
        jmp    loc_E78A

;----------------------------------------------------------------------------

Vt52Right:
        dcx    d
        stax   d
        mvi    a, 18h
        jmp    loc_E78A

;----------------------------------------------------------------------------

Vt52Left:
        dcx    d
        stax   d
        mvi    a, 8
        jmp    loc_E78A

;----------------------------------------------------------------------------

Vt52Home:
        dcx    d
        stax   d
        mvi    a, 0Ch
        jmp    loc_E78A

;----------------------------------------------------------------------------

Vt52None:
        dcx    d
        stax   d
        ret

;----------------------------------------------------------------------------

Vt52SetPosition:
        mvi    a, 5
        jmp    PrintChar4

;----------------------------------------------------------------------------

Vt52ClearToEndOfScreen:
        dcx    d
        stax   d

        call   DrawCursor

        lda    v_screen_mode
        push   psw
        ori    14h
        sta    v_screen_mode
        lhld   v_cursor_position
        push   h

Vt52ClearToEndOfScreen1:
          mvi    c, ' '
          call   PrintChar3
          lda    v_screen_mode
          ani    10h
        jnz   Vt52ClearToEndOfScreen1

        pop    h
        shld   v_cursor_position
        pop    psw
        sta    v_screen_mode
        jmp    DrawCursor

;----------------------------------------------------------------------------

Vt52ClearToEndOfLine:
        dcx    d
        stax   d

        call   DrawCursor

        lda    v_screen_mode
        push   psw
        ori    14h
        sta    v_screen_mode
        lhld   v_cursor_position
        push   h

Vt52ClearToEndOfLine1:
          mvi    c, ' '
          call   PrintChar3
          lda    v_cursor_position + 1
          ora    a
          jz     Vt52ClearToEndOfLine2
          lda    v_screen_mode
          ani    10h
        jnz   Vt52ClearToEndOfLine1
Vt52ClearToEndOfLine2:

        pop    h
        shld   v_cursor_position
        pop    psw
        sta    v_screen_mode
        jmp    DrawCursor

;----------------------------------------------------------------------------

#endif

