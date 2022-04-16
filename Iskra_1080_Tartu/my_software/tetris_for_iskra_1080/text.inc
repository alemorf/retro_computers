; Вывод текста на экран

FONT_HEIGHT      = 12
FONT_LINE_HEIGHT = 14

;----------------------------------------------------------------------------------------------------------------------

drawText:
    call drawText2
    jnz  drawText
    ret

drawText2:
    mov  a, m
    ora  a
    rz
    inx  h
    cpi  32
    jnc  drawText_1
    mov  e, a
    add  a ; *2
    add  e ; *3
    add  a ; *6
    add  e ; *7
    add  a ; *14
    cma
    sta  drawCharAddr
    mvi  a, 0FFh
    sub  m
    inx  h
    sta  drawCharAddr+1
    mov  a, m
    inx  h
drawText_1:
    push h
    call drawChar
    dcr  m
    pop  h
    xra  a ; return nz
    inr  a
    ret

;----------------------------------------------------------------------------------------------------------------------

drawChar:
    ; Адрес символа в знакогенераторе
    ; de = font + a * 12
    mov  l, a
    mvi  h, 0
    dad  h ; *2
    dad  h ; *4
    mov  d, h
    mov  e, l
    dad  h ; *8
    dad  d ; *12
    lxi  d, font - (' ' * 12)
    dad  d
    xchg

    ; Адрес в видеопамяти
drawCharAddr = $+1
    lxi  h, 0D000h

    ; Цикл
    mvi  c, FONT_HEIGHT
drawChar_1:
    push b

    ; Первая плоскость, сразу результат не записываем, а сохраняем в C
    mov  b, m
    ldax d
drawChar_cma1:
    cma    ; nop
    ana  b ; ora b
    mov  c, a

    ; Сохраняем адрес первой плоскости и вычисялем адрес второй плоскости
    push h
    mov  a, h
    sbi  40h
    mov  h, a

    ; Вторая плоскость
    mov  b, m
    ldax d
drawChar_cma2:
    cma    ; nop
    ana  b ; ora b

    ; Записываем в память значения почти одновременно
    mov  m, a
    pop  h
    mov  m, c

    ; Следующий пиксель, следующий байт шрифта
    inx  h
    inx  d

    ; Цикл
    pop  b
    dcr  c
    jnz  drawChar_1

    ; Перемещаем курсор на следующий символ
    lxi h, drawCharAddr+1
    ret

;----------------------------------------------------------------------------------------------------------------------

setTextColor:
    lxi  h, OPCODE_CMA + (OPCODE_ANA_B * 256)
    lxi  d, OPCODE_NOP + (OPCODE_ORA_B * 256)
setTextColor1:
    rrc
    jnc  setTextColor_1
    xchg
    cma
setTextColor_1:
    shld drawChar_cma1
    rrc
    jnc  setTextColor_2
    xchg
setTextColor_2:
    shld drawChar_cma2
    ret

;----------------------------------------------------------------------------------------------------------------------
