; Графика игрового поля

map2 = 3h ; Тут будет массив размером WIDTH * HEIGHT = 10 * 20 = 200 байт

PLAYFIELD_Y = 8

;-------------------------------------------------------------------------------
; Рисование клетки
; d - x
; e - y
; a - color

cellOff:
    db 240- 0,03Fh,0FFh,000h ; 00111111,11111111,00000000
    db 240- 2,0FFh,0FCh,000h ; 11111111,11111100,00000000
    db 240- 3,003h,0FFh,0F0h ; 00000011,11111111,11110000
    db 240- 5,00Fh,0FFh,0C0h ; 00001111,11111111,11000000
    db 240- 7,03Fh,0FFh,000h ; 00111111,11111111,00000000
    db 240- 9,0FFh,0FCh,000h ; 11111111,11111100,00000000
    db 240-10,003h,0FFh,0F0h ; 00000011,11111111,11110000
    db 240-12,00Fh,0FFh,0C0h ; 00001111,11111111,11000000
    db 240-14,03Fh,0FFh,000h ; 00111111,11111111,00000000
    db 240-16,0FFh,0FCh,000h ; 11111111,11111100,00000000

    db 254- 0,0FFh,0FCh,000h ; 11111111,11111100,00000000
    db 254- 1,003h,0FFh,0F0h ; 00000011,11111111,11110000
    db 254- 3,00Fh,0FFh,0C0h ; 00001111,11111111,11000000
    db 254- 5,03Fh,0FFh,000h ; 00111111,11111111,00000000

drawCell:
    ; Задаем цвет первой плоскости
    rrc
    lxi  h, OPCODE_ORI + (OPCODE_NOP * 256)
    lxi  d, OPCODE_ANI + (OPCODE_CMA * 256)
    jc  drawCell_1
    xchg
    cma
drawCell_1:
    push psw
    mov  a, h
    sta  drawColumn_cma1
    shld drawColumn_op1
    pop psw

    ; Задаем цвет второй плоскости
    rrc
    jc  drawCell_2
    xchg
drawCell_2:
    mov  a, h
    sta  drawColumn_cma2
    shld drawColumn_op2

    ; Адрес в видеопамяти
    ; de = cellOff[b] * 256 + c
    ; hl = адрес битовых масок
    lxi  h, cellOff
    mov  e, b
    mvi  d, 0
    dad  d
    dad  d
    dad  d
    dad  d
    mov  d, m
    mov  e, c

    ; Цикл для трёх колонок
    mvi  b, 3
drawColumn_6:

    ; Следующий байт битовой маски
    inx  h

    push h
    push d

    ; Вычисляем маску для первой плоскости
    mov  a, m
drawColumn_cma1:
    cma
    sta drawColumn_op1 + 1

    ; Вычисляем маску для второй плоскости
    mov  a, m
drawColumn_cma2:
    cma
    sta drawColumn_op2 + 1

    ; Вычисляем адрес второй плоскости в HL
    mov  a, d
    sui  40h
    mov  h, a
    mov  l, e

    ; Цикл для 12 строк
    mvi  c, 12
drawColumn_2:

    ; Первая плоскость
    ldax d
drawColumn_op1 = $
    ani  55h
    stax d
    dcr  e

    ; Вторая плоскость
    mov  a, m
drawColumn_op2 = $
    ani  55h
    mov  m, a
    dcr  l

    ; Конец цикла
    dcr  c
    jnz  drawColumn_2

    pop  d
    pop  h

    ; Следующая запись на 8 пикселе правее
    dcr  d

    ; Конец цикла
    dcr  b
    jnz  drawColumn_6

    ret

;-------------------------------------------------------------------------------
; Перерисовать игровое поле

redrawMap:
    ;var a = START;
    lxi d, map + START ;b
    lxi h, map2

    ;for(var y=0; y<HEIGHT; y++, a++) {
    mvi c, 0FFh - PLAYFIELD_Y ;e
redrawMap_1:

    ; for(var x=0; x<WIDTH; x++, a++) {
    mvi b, 0 ; d
redrawMap_2:

    ; var c = map[a]
    ; ctx.fillStyle = colors[c];
    ; ctx.fillRect(122+x*14, 8+y*12, 14, 12);
    ldax d ; b
    cmp  m
    cnz  redrawMap_4

    inr  b ; d
    inx  d ; b
    inx  h
    mov  a, b ; d
    cpi  WIDTH
    jnz  redrawMap_2

    inx  d ; b
    mov  a, c ; e
    sui  12
    mov  c, a ; e
    cpi  0FFh - PLAYFIELD_Y - (HEIGHT * 12)
    jnz  redrawMap_1
    ret

;-------------------------------------------------------------------------------

redrawMap_4:
    mov  m, a
    push b
    push d
    push h
    call drawCell
    pop  h
    pop  d
    pop  b
    ret

;-------------------------------------------------------------------------------
; Пометить всё игровое поле к перерисовке

invalidatePlayfield:
    lxi  h, map2
    mvi  a, 0FFh
    mvi  c, (WIDTH * HEIGHT)
    jmp  memset8
