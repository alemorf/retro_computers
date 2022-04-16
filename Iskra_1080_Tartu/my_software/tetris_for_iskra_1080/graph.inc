; Вся графика исключая игровое поле

SYS_BACKUP_FROM = 0C800h
SYS_BACKUP_SIZE = 80h
SYS_BACKUP_TO   = 3h

NEW_BACKUP_FROM = 0C000h
SCO_BACKUP_FROM = 0C000h + (7 * 48 * 2)

;----------------------------------------------------------------------------
; Очистка экрана

clearScreen:
    call clearScreen1

;-V-V-V----------------------------------------------------------------------
; Очистка второй плоскости экрана (9000-BFFF)

clearScreen2:
    lxi  h, VIDEO_PAGE_1
    mvi  a, 0C0h

;-V-V-V----------------------------------------------------------------------
; Очистка памяти

clearMem:
    mvi  m, 0
    inx  h
    cmp  h
    jnz  clearMem
    ret

;-------------------------------------------------------------------------------
; Очистка первой плоскости экрана (В000-FFFF)

clearScreen1:
    lxi  h, VIDEO_PAGE_0
    xra  a
    jmp  clearMem

;-------------------------------------------------------------------------------
; Перерисовать фон

drawBackgrond:
    ; Сохраняем системные переменные
    lxi  d, SYS_BACKUP_FROM + SYS_BACKUP_SIZE - 1
    lxi  h, SYS_BACKUP_TO + SYS_BACKUP_SIZE - 1
    lxi  b, SYS_BACKUP_SIZE
    call memcpy8back

    ; Гасим экран
    mvi  b, 8
    call setPaletteEx
    call delay8000
    mvi  a, PALETTE_BLACK
    out  IO_PALETTE_0
    out  IO_PALETTE_1
    out  IO_PALETTE_2
    out  IO_PALETTE_3

    ; Получаем указатель на изображение уровня
    lda  level
    mov  d, a
    add  a ;*2
    add  a ;*4
    add  d ;*5
    mvi  d, 0
    mov  e, a
    lxi  h, levels
    dad  d
    mov  e, m
    inx  h
    mov  d, m
    inx  h
    mov  a, m ; Цвет фигуры и текста
    sta  redrawNewFigure1_1
    inx  h
    shld palette ; Палитра

    push d
    call setTextColor
    pop  d

    ; Распаковываем
    lxi  b, VIDEO_PAGE_1
    call unmlz

    ; Переносим вторую плоскость
    lxi  h, 0FFFFh
    lxi  d, 0EFFFh
    lxi  b, 03000h
    call memcpy8back
    ;pop  h

    ; Восстанавливаем системные переменные
    lxi  d, SYS_BACKUP_TO + SYS_BACKUP_SIZE - 1
    lxi  h, SYS_BACKUP_FROM + SYS_BACKUP_SIZE - 1
    lxi  b, SYS_BACKUP_SIZE
    call memcpy8back

    call copyImageFromScreen
    call copyNewFigureBackground
    call copyScoreBackground
    call copyImageToScreen

    ret

;----------------------------------------------------------------------------------------------------------------------

paletteShow:
    mvi  b, 8
    call setPaletteEx
    call delay8000
    mvi  b, 0
setPaletteEx:
palette = $+1
    lxi  h, 0
    xra  a
    ora  l
    rz
    ;inx  h
    mvi  a, 15
    ora  b
    out  IO_PALETTE_0
    ;inx  h
    mov  a, m
    ora  b
    out  IO_PALETTE_1
    inx  h
    mov  a, m
    ora  b
    out  IO_PALETTE_2
    ;inx  h
    mov  a, b
    out  IO_PALETTE_3
    ret

;-------------------------------------------------------------------------------
; Перерисовать текущий счет

redrawScore:
    call copyScoreBackground

    lxi  h, 0FFFFh-24-(45*256)
    shld drawCharAddr
    lhld score
    call drawNumber

    lxi  h, 0FFFFh-40-(45*256)
    shld drawCharAddr
    lhld bestScore
    jmp  drawNumber

;-------------------------------------------------------------------------------
; Вывести число

drawNumber:
    xchg
redrawScore_1:
    ; Разделить ВУ на 10
    lxi  h, 10
    call div16
    ; Остаток от деления вывести на экран
    push h
    mov  a, e
    adi  '0'
    call drawChar
    inr  m
    pop  d
    ; Если DE=0 выходим
    mov  a, d
    ora  e
    jnz redrawScore_1
    ret

;-------------------------------------------------------------------------------
; Прерисовать новую фигуру

redrawNewFigure:
    ; Залить цветом 1 место где выводится новая фигура
    call copyNewFigureBackground

    ; Нарисовать новую фигуру
    ; decodeFigure(nextO, redrawNewFigure1);
    lda  nextO
    lxi  h, redrawNewFigure1
    call decodeFigureEx
    ret

;-------------------------------------------------------------------------------

copyScoreBackground:
    lxi  b, 5 * 256 + 40
    lxi  d, SCO_BACKUP_FROM
    lxi  h, 0FFFFh-40-(45*256)
    jmp  copyImage

;-------------------------------------------------------------------------------

copyImageFromScreen:
    ; Модификация функции
    lxi  h, OPCODE_MOV_A_M + (256 * OPCODE_STAX_D)
copyImageTo:
    shld copyImage_o1
    shld copyImage_o2
    ret

;-------------------------------------------------------------------------------
; Включить вывод изображения

copyImageToScreen:
    lxi  h, OPCODE_LDAX_D + (256 * OPCODE_MOV_M_A)
    jmp  copyImageTo

;-------------------------------------------------------------------------------
; Ввод/вывод изображения, где выводится новая фигура

copyNewFigureBackground:
    lxi  b, 7 * 256 + 48
    lxi  d, NEW_BACKUP_FROM
    lxi  h, 0F8F8h - 48

;-------------------------------------------------------------------------------
; Ввод/вывод изображний без мерцания

copyImage:
    ; Цикл по горизонтали
    mov  a, h
    sta  copyImage_h1
    sui  040h
    sta  copyImage_h2
    push h
    push b
    ; Цикл по вертикали
copyImage_4:
    ; Плоскость 1
copyImage_h1 = $+1
    mvi  h, 0D0h
copyImage_o1:
    mov  a, m
    stax d
    inx  d
    ; Плоскость 2
copyImage_h2 = $+1
    mvi  h, 90h
copyImage_o2:
    mov  a, m
    stax d
    inx  d
    ; Следующая строка
    inr  l
    ; Конец цикла
    dcr  c
    jnz  copyImage_4
    pop  b
    pop  h
    ; Следующий стобец
    inr  h
    ; Конец цикла
    dcr  b
    jnz  copyImage
    ret

;-------------------------------------------------------------------------------
; Нарисовать клетку новой фигуры

redrawNewFigure1:
    push h
    push d
    push b

    ; Расчет координаты Y
    mov  a, e
    add  a
    add  a
    mov  e, a
    add  a
    add  e
    mov  e, a
    mvi  a, 0F7h
    sub  e
    mov  c, a

    ; Расчет координаты X
    mov  a, d
    adi  10
    mov  b, a

    ; Рисование клетки черным цветом
redrawNewFigure1_1 = $+1
    mvi  a, 0
    call drawCell

    pop  b
    pop  d
    pop  h

    ; Продолжить рисование
    xra  a
    ret
