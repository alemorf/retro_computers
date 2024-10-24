; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Закрасить контур
; Вход: v_arg_0 - x, v_arg_1 - y, v_arg_2 - цвет в, v_arg_3 - цвет из

Paint:  ; Сохранение старого стека
        lxi    h, 0
        dad    sp
        shld   v_tmp_saved_sp

        ; Переход на новый стек
        lxi    h, v_safe_stack_2
        sphl

        ; Сохранение текущего цвета
        lhld   v_color
        shld   v_tmp_saved_color

        ; Установка цвета из v_arg_2
        lda    v_arg_2
        dcr    a
        call   ColorSetInt

        ; Цвет, который будет заменен
        lda    v_arg_3
        dcr    a
        sta    v_tmp_compare_color

        ; Начальные координаты из (v_arg_0, v_arg_1) в (L, H)
        lda    v_arg_0
        mov    l, a
        lda    v_arg_1
        mov    h, a

        ; Отдельно сохраняем Y
        sta    v_tmp_paint_y

        lda    v_arg_4
        dcr    a
        sta    v_arg_0  ; Если 0, то полноценная заливка, иначе быстрая

        mvi    a, 2
        sta    byte_BFC9

        ; Вычисление адреса в видеопамяти
        ; Выход: hl - адрес, b - смещение внутри байта.
        xchg
        call   CalcPixelAddress
        shld   v_arg_1 ; Далее в v_arg_1 адрес в видеопамяти

        ; Вычисление маски в b и v_arg_3
        mvi    a, 80h
loc_EC57: rlc
          dcr    b
        jp     loc_EC57
        mov    b, a
        sta    v_arg_3

        ; Ищем левую границу. Координата X в D.
        lda    v_tmp_compare_color
        mov    c, a
        mov    d, e
        call   PaintFindLeft

        ; Ищем правую границу. Координата X в E.
        lhld   v_arg_1 ; адрес
        lda    v_arg_3 ; маска
        mov    b, a
        call   PaintFindRight

        ; Сохраняем в стек 0, 0
        lxi    h, 0
        push   h
        push   h

        ; Тип заливки
        lda    v_arg_0
        ora    a
        jz     loc_EC8B
          ; Сохраняем задачу: (X1, BFC9 - 1, X0, Y)
          lda    byte_BFC9
          dcr    a
          mov    h, a
          mov    l, e
          push   h

          lda    v_tmp_paint_y
          mov    h, a
          mov    l, d
          push   h
loc_EC8B:
        ; Сохраняем задачу: (X1, BFC9, X0, Y)
        lda    byte_BFC9
        mov    h, a
        mov    l, e
        push   h

        lda    v_tmp_paint_y
        mov    h, a
        mov    l, d
        push   h
        jmp    loc_EE67

; ---------------------------------------------------------------------------

loc_EC9A:
        lda    v_tmp_compare_color
        mov    c, a

        ; Если 0, то полноценная заливка, иначе быстрая
        lda    v_arg_0
        ora    a
        jnz    loc_ECD7

        mvi    a, 2
        sta    byte_BFCB

        lda    v_tmp_mode
        cpi    2
        jz     loc_ECB5
        jmp    loc_ECBD

; ---------------------------------------------------------------------------

loc_ECB5:
        mvi    a, 1
        sta    byte_BFC9
        jmp    loc_ECE5

; ---------------------------------------------------------------------------

loc_ECBD:
        mvi    a, 2
        sta    byte_BFC9
        jmp    loc_ED3D

; ---------------------------------------------------------------------------

loc_ECC5:
        lda    byte_BFCB
        ora    a
        jz     loc_EE67

        lda    v_tmp_mode
        cpi    2
        jz     loc_ECBD
        jmp    loc_ECB5

; ---------------------------------------------------------------------------

loc_ECD7:
        lda    v_tmp_mode
        sta    byte_BFC9
        cpi    1
        jz     loc_ECE5
        jmp    loc_ED3D

; ---------------------------------------------------------------------------

loc_ECE5:
        lda    v_tmp_x
        mov    d, a

        lda    v_tmp_x1
        mov    e, a

        ; Адрес и маска
        lhld   v_arg_1
        lda    v_arg_3
        mov    b, a

        lda    v_tmp_y
        dcr    a
        jz     loc_ED2C

        sta    v_tmp_paint_y
        inr    l
        call   PaintFindNextRight
        jz     loc_ED2C
        lhld   v_arg_4
        lda    v_arg_6
        mov    b, a
        inr    l
        call   PaintFindNextLeft
        jz     loc_ED2C

        lda    v_arg_0
        ora    a
        jnz    loc_ED1D
        jmp    loc_EDBD

; ---------------------------------------------------------------------------

loc_ED1D:
        lda    byte_BFC9
        mov    h, a
        mov    l, e
        push   h

        lda    v_tmp_paint_y
        mov    h, a
        mov    l, d
        push   h

        jmp    loc_EE67

; ---------------------------------------------------------------------------

loc_ED2C:
        lda    v_arg_0
        ora    a
        jnz    loc_EE67

        lda    byte_BFCB
        dcr    a
        sta    byte_BFCB

        jmp    loc_ECC5

; ---------------------------------------------------------------------------

loc_ED3D:
        lda    v_tmp_x
        mov    d, a
        lda    v_tmp_x1
        mov    e, a
        lhld   v_arg_1
        lda    v_arg_3
        mov    b, a
        lda    v_tmp_y
        inr    a
        cpi    0FFh
        jz     loc_ED2C
        sta    v_tmp_paint_y
        dcr    l
        call   PaintFindNextRight
        jz     loc_ED2C
        lhld   v_arg_4
        lda    v_arg_6
        mov    b, a
        dcr    l
        call   PaintFindNextLeft
        jz     loc_ED2C
        lda    v_arg_0
        ora    a
        jnz    loc_ED1D
        jmp    loc_EDBD

;----------------------------------------------------------------------------

PaintFindNextRight:
        call   GetPointColor
        jnz    loc_ED84

        call   PaintFindLeft

        mvi    a, 0FFh
        ora    a
        ret  ; Выход с NZ

;----------------------------------------------------------------------------

loc_ED84:
        ; Если X = E, то выход, иначе X увеличиваем на 1
        mov    a, d
        cmp    e
        rz  ; Выход с Z
        inr    d

        ; Маска и адрес вправо
        mov    a, b
        rlc
        mov    b, a
        jnc    loc_ED90
          inr    h
          inr    h
loc_ED90:

        ; Продолжаем, пока цвет точки отличается идентичен
        call   GetPointColor
        jnz    loc_ED84

        mvi    a, 0FFh
        ora    a
        ret  ; Выход с NZ

;----------------------------------------------------------------------------

PaintFindNextLeft:
        call   GetPointColor
        jnz    loc_EDA7

        ; Ищем правую границу. Координата X в E.
        call   PaintFindRight

        mvi    a, 0FFh
        ora    a
        ret  ; Выход с NZ

;----------------------------------------------------------------------------

loc_EDA7:
        ; Если X = E, то выход, иначе X уменьшаем на 1
        mov    a, e
        cmp    d
        rz  ; Выход с Z
        dcr    e

        ; Пиксель влево
        mov    a, b
        rrc
        mov    b, a
        jnc    loc_EDB3
          dcr    h
          dcr    h
loc_EDB3:
        call   GetPointColor
        jnz    loc_EDA7

        mvi    a, 0FFh
        ora    a
        ret  ; Выход с NZ

; ---------------------------------------------------------------------------

loc_EDBD:
        mov    a, d
        sta    v_tmp_right_mask
        lda    byte_BFC9
        mov    d, a
        push   d
        lda    v_tmp_right_mask
        cmp    e
        jnz    loc_EDD6
        mov    l, a
        lda    v_tmp_paint_y
        mov    h, a
        push   h
        jmp    loc_EDFA

; ---------------------------------------------------------------------------

loc_EDD6:
        mov    d, e
        call   PaintFindLeft
        mov    e, d
        lda    v_tmp_paint_y
        mov    d, a
        push   d
        lda    v_tmp_right_mask
        mov    d, a
        cmp    e
        jz     loc_EDFA

loc_EDE8:
        ; Влево
        dcr    e

        ; Маска и адрес влево
        mov    a, b
        rrc
        mov    b, a
        jnc    loc_EDF1
          dcr    h
          dcr    h
loc_EDF1:

        ; Продолжаем, пока цвет точки идентичен
        call   GetPointColor
        jnz    loc_EDE8

        jmp    loc_EDBD

;----------------------------------------------------------------------------

loc_EDFA:                ; CODE XREF: RAM:EDD3j    RAM:EDE5j
        jmp    loc_ED2C

;----------------------------------------------------------------------------

PaintFindRight:
        ; Выходим, если это правый край экрана, иначе увеличиваем X на единицу.
        mov    a, e
        cpi    0FFh
        rz
        inr    e

        ; Сдвигаем маску и адрес вправо
        mov    a, b
        rlc
        mov    b, a
        jnc    loc_EE0A
          inr    h
          inr    h
loc_EE0A:

        ; Цикл, пока цвет точки нужный
        call   GetPointColor
        jz     PaintFindRight

        ; Сдвигаем маску и адрес влево
        dcr    e
        mov    a, b
        rrc
        mov    b, a
        rnc
        dcr    h
        dcr    h
        ret

;----------------------------------------------------------------------------

PaintFindLeft:
        ; Если X = 0, то выходим, иначе уменьшаем X на 1
        mov    a, d
        ora    a
        rz
        dcr    d

        ; Маска и адрес влево
        mov    a, b
        rrc
        mov    b, a
        jnc    loc_EE24
          dcr    h
          dcr    h
loc_EE24:

        ; Повторяем, пока цвет точки нужный
        call   GetPointColor
        jz     PaintFindLeft

        ; Маска и адрес вправо
        inr    d
        mov    a, b
        rlc
        mov    b, a
        rnc
        inr    h
        inr    h
        ret
