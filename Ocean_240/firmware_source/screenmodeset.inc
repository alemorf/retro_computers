; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Установить режим экрана, скрыть или показать курсор
; Вход: a = 0 .. 8 - режим экрана, a = 9 - скрыть курсор, a = 10 - показать курсор

ScreenModeSet:
        ; Адрес для сохранения режима экрана
        lxi    h, v_screen_mode

        ; Значение палитры нужно для обновления порта ввода-вывода
        lda    v_palette
        mov    b, a

        ; Значения >= 11 игнорируются
        lda    v_arg_0
        ani    0Fh
        cpi    11
        rnc

        ; Значение 9 скрывает курсор
        cpi    9
        jz     HideCursor

        ; Значение 10 отображает курсор
        cpi    10
        jz     ShowCursor

        ; Сохраняем новый режим экрана
        mov    m, a

#ifndef CONFIG_SCREEN_SET_MODE_SIZE_OPTIMIZATION
        ; Мертвый код
        cpi    4
        jz     loc_E90F
#endif

        ; Включаем или выключаем цвет
        ani    3
        mvi    a, 0
        jnz    loc_E911
loc_E90F:
        mvi    a, 40h
loc_E911:
        ora    b
        out    PORT_COLOR

        ; Очистка экрана
        lxi    h, v_cursor_position
        call   ClearScreen

        ; Восстанавливаем курсор
loc_E91A:
#ifndef CONFIG_SCREEN_SET_MODE_SIZE_OPTIMIZATION
        call   DrawCursor
        ret
#else
        jmp    DrawCursor
#endif

;----------------------------------------------------------------------------

HideCursor:
        ; Видеорежим со скрытым курсором
        mov    a, m
        ori    SCREEN_MODE_CURSOR_MASK
        mov    m, a

        lxi    h, v_cursor_position
        jmp    loc_E91A

;----------------------------------------------------------------------------

ShowCursor:
        ; Видеорежим с видимым курсором
        mov    a, m
        ani    ~SCREEN_MODE_CURSOR_MASK
        mov    m, a
        jmp    loc_E91A
