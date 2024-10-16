; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Установить положение курсора
; Вход: v_arg_0 = x + ' ', v_arg_1 = y + ' '

CursorPositionSet:
        ; Скрыть курсор
        call   DrawCursor

        ; Получение первого аргумента
        lxi    d, v_arg_0
        lxi    h, v_cursor_position + 1
        inx    d
        ldax   d
        sui    ' '
        mov    b, a

        lda    v_screen_mode
        cpi    3
        jz     CursorPositionSet80
        cpi    7
        jz     CursorPositionSet80
        ora    a
        jz     CursorPositionSet40
        cpi    4
        jz     CursorPositionSet40
        mov    a, b
        cpi    64
        jm     CursorPositionSetY
        mvi    a, 64
        jmp    CursorPositionSetY

;----------------------------------------------------------------------------

CursorPositionSet40:
        mov    a, b
        cpi    40
        jm     CursorPositionSetY
        mvi    a, 40
        jmp    CursorPositionSetY

;----------------------------------------------------------------------------

CursorPositionSet80:
        mov    a, b
        cpi    80
        jm     CursorPositionSetY
          mvi    a, 80

CursorPositionSetY:
        ; Сохранение столбца
        mov    m, a

        ; Получение второго аргумента
        dcx    d
        dcx    h
        ldax   d
        sui    ' '

        ; Предотвращение установки курсора за пределы экрана
        cpi    TEXT_LINES - 1
        jc     loc_E8DF
          mvi    a, TEXT_LINES - 1
loc_E8DF:

        ; Вычисление графической строки
        mov    b, a
        add    a
        add    a
        add    b
        add    a

        ; Сохранение графической строки
        mov    m, a

        ; Отобразить кусрор
        call   DrawCursor
        ret
