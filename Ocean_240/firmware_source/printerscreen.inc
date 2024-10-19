; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Печать экрана на принтере

PrinterScreen:
        ; Выход, если не установлен цветной видеорежим
        lda    v_screen_mode
        ani    3
        rnz

        ; Печать колонки 255
        ; Функция PrinterColumn печатает сразу 2 соседние колонки.
        ; Что бы предотвратить печать колонки 0, функции передается маска 030h.
        lxi    d, 30FFh
        call   PrinterColumn

        ; Печать колонок от 255 до 1
        dcr    e
        mvi    d, 0F0h  ; Без маски
loc_E220: ; Выход, если нажата клавиша ESC
          call   KeyCheck
          ora    a
          jz     loc_E22D
            call   KeyRead
            cpi    1Bh
            rz
loc_E22D: call   PrinterColumn
          dcr    e
        jnz    loc_E220

        ; Печать колонок 0 и 1. Маска 0E0h.
        mvi    d, 0E0h
        call   PrinterColumn

        ret

;----------------------------------------------------------------------------
; Печать колонки пикселей
; Вход: d = маска, e - X
; Выход: de - сохраняется

PrinterColumn:
        lxi    h, a_esc_x_0_0
        call   PrinterString

        lxi    h, 4
        shld   v_tmp_printer_x

        ; Координата Y от 0 до 236
        mvi    b, 0
loc_E248:
          ; Печать первой плоскости
          mvi    c, 0
          call   PrinterGetPoints
          ana    d
          cnz    PrinterDots
          lhld   v_tmp_printer_x
          inx    h
          shld   v_tmp_printer_x

          ; Печать второй плоскости
          mvi    c, 1
          call   PrinterGetPoints
          ana    d
          cnz    PrinterDots
          lhld   v_tmp_printer_x
          inx    h
          shld   v_tmp_printer_x

          inr    b
          mov    a, b
          cpi    236      ; Пропуск 20 точек
        jc     loc_E248

        lxi    h, a_esc_z2
        call   PrinterString

        ret

;----------------------------------------------------------------------------

PrinterString:
        push    b
loc_E277: mov    a, m
          cpi    1Ah
          jz     loc_E285
          mov    c, a
          call   PrinterWrite
          inx    h
        jmp    loc_E277
loc_E285:
        pop    b
        ret

;----------------------------------------------------------------------------
; Напечатать 4 точки
; Выход: а - 00/30/C0/F0

PrinterDots:
        push   psw

        lxi    h, a_esc_x
        call   PrinterString

        lhld   v_tmp_printer_x
        mov    c, h
        call   PrinterWrite
        mov    c, l
        call   PrinterWrite

        lxi    h, a_esc_o
        call   PrinterString

        pop    psw

        mov    c, a
        call   PrinterWrite
        ret

;----------------------------------------------------------------------------

a_esc_z2:    .db 1Bh, 'Z', 2, 1Ah
a_esc_x_0_0: .db 1Bh, 'X', 0, 0, 1Ah
a_esc_x:     .db 1Bh, 'X', 1Ah
a_esc_o:     .db 1Bh, 'O', 1Ah

;----------------------------------------------------------------------------
; Получить четыре точки для печати
; Вход: b - Y-19, e - X, с - плоскость
; Выход: а - 4 точки в виде 00/30/C0/F0, bc - сохраняется, de - сохраняется

PrinterGetPoints:
        ; Вычисление адреса, младший байт
        lda    v_scroll_y
        add    b
        adi    19  ; Пропуск 20 точек
        mov    l, a

        ; Функция сохраняет BC и DE
        push   d
        push   b

        ; Вычисление номера бита
        mov    a, e
        ani    7
        mov    b, a

        ; Вычисление адреса, старший байт
        mov    a, e
        rar
        rar
        rar
        ani    1Fh
        add    a
        adi    40h
        mov    h, a

        ; Выбор плоскости
        mov    a, c
        ani    1
        add    h
        mov    h, a

        ; Подключение видеопамяти
        mvi    a, 1
        out    PORT_MAPPER

        ; Читение 16 точек из видеопамяти
        mov    e, m
        inr    h
        inr    h
        mov    d, m

        ; Отключение видеопамять
        mvi    a, 0
        out    PORT_MAPPER

        ; Получение точек (сдвиг слова)
loc_E2DC:
          dcr    b
          jm    loc_E2E9
          mov    a, d
          rar
          mov    d, a
          mov    a, e
          rar
          mov    e, a
        jmp    loc_E2DC
loc_E2E9:

        ; Дублирование двух точек в четыре точки
        mov    a, e
        mvi    d, 0
        rar
        jnc    loc_E2F2
          mvi    d, 30h
loc_E2F2:
        rar
        jnc    loc_E2FA
          mov    a, d
          ori    0C0h
          mov    d, a
loc_E2FA:
        mov    a, d

        ; Функция сохраняет BC и DE
        pop    b
        pop    d
        ret
