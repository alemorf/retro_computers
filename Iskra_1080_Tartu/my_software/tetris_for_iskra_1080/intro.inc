; Интро

LOGO_WIDTH  = 320
LOGO_HEIGHT = 166
LOGO_SIZE   = (LOGO_WIDTH / 8 * LOGO_HEIGHT)
LOGO_DEST   = (VIDEO_PAGE_0 + ((VIDEO_WIDTH - LOGO_WIDTH) / 2 / 8 * 256) - 16)

PLANE_WIDTH      = 19
PLANE_HEIGHT     = 12
PLANE_SIZE_1     = (PLANE_WIDTH * PLANE_HEIGHT * 3)
PLANE_SIZE_2     = ((PLANE_WIDTH + 1) * PLANE_HEIGHT * 3)

PACKED_LOGO_SIZE = 2034

packedLogo2      = 0C000h
PLANE_BUFFER_2   = 0C880h ; 19*12*2 = 456 байт
PLANE_BUFFER     = (PLANE_BUFFER_2 + (19*12*2)) ; 48*12*2 = 1152 байт

Y_MULTIPLIER = 256

;----------------------------------------------------------------------------------------------------------------------
; Интро

intro:
    ; Переносим ресурсы из видеопамяти
    lxi  h, packedLogo
    lxi  d, packedLogo2
    mvi  b, 0
    call memcpyq
    xchg
    lxi  h, packedLogo + 1024
    call memcpyq

    mvi a, 2
    call setTextColor

    ; Гасим экран
    mvi  a, PALETTE_BLACK
    out  IO_PALETTE_0
    out  IO_PALETTE_1
    out  IO_PALETTE_2
    out  IO_PALETTE_3

    ; Очистка первой плоскости видеопамяти
    call clearScreen

    ; Вывод текста
    lxi  h, introText
    call drawText

    ; Показываем текст
    call paletteOn

    ;jmp fly

    ; Ждем нажатия на любую клавиашу
    call pressAnyKey

    ; При повторном вызове этой функции данные уже будут уничтожены, так как они находятся в видеопамяти
introExit:
    nop
    mvi  a, OPCODE_RET
    sta  introExit

    ; Гасим экран
introOff:
    call paletteOff

    call clearScreen

    ; Распаковываем лого
    lxi  d, packedLogo2
    lxi  b, LOGO_DEST
    call unmlz

    ; Разворачиваем логотип из 320x166 в 320x256
    lxi  d, LOGO_DEST + LOGO_SIZE
    lxi  h, LOGO_DEST + (LOGO_WIDTH / 8 * VIDEO_HEIGHT)
    mvi  b, 40
intro_1:
    mvi  c, LOGO_HEIGHT
intro_2:
    dcx  d
    ldax d
    dcx  h
    mov  m, a
    dcr  c
    jnz  intro_2
    mvi  c, VIDEO_HEIGHT - LOGO_HEIGHT
    xra  a
intro_3:
    dcx  h
    mov  m, a
    dcr  c
    jnz  intro_3
    dcr  b
    jnz  intro_1

    ; Показываем лого
    call paletteOn

    ; Вывод текста
    lxi  h, introText2
intro_4:
    call inkey_FC12
    cpi  0FFh
    jnz  paletteOff
    lxi  d, 2000h
    call delay
    mov  a, m
    cpi  '!'
    jz   intro_5
    call drawText2
    jnz  intro_4

    ; Летащий самолетик
fly:
    ; Копируем новый блок с экарана в буфер
    call copyImageFromScreen
    lxi  h, 0D090h
    lxi  b, 48 * 256 + PLANE_HEIGHT ; width * 256 + height
    lxi  d, PLANE_BUFFER ; to
    call copyImage
    call copyImageToScreen

fly_0:
    ; Адрес вывода самолетика - за левым крем экрана
    lxi  h, 0D090h - ((PLANE_WIDTH - 1) * Y_MULTIPLIER)
    shld fly_a1

    ; Теневой буфер
    lxi  h, PLANE_BUFFER - ((PLANE_WIDTH - 1) * PLANE_HEIGHT * 2)
    shld fly_a2

    ; Цикл движения от левого края экрана до правого края экрана. Шаг 8 пикселей или 1 байт
fly_1:
    ; Вывод первой фазы
    mvi  b, 8
fly_2:
    push b

    ; Сдвиг
    lxi  h, plane
    call shiftImage

    ; Накладываем на буфер 2 изображение с маской
    lxi  h, plane
fly_a2 = $+1
    lxi  b, PLANE_BUFFER
    lxi  d, PLANE_BUFFER_2
    mvi  a, PLANE_WIDTH * PLANE_HEIGHT
    call copyMaskedImageToBuffer

    ; Выводим изображение 2 на экран
    lxi  b, PLANE_WIDTH * 256 + PLANE_HEIGHT ; width * 256 + height
    lxi  d, PLANE_BUFFER_2 ; to
fly_a1 = $+1
    lxi  h, 0D090h ; from
    call copyImageSafe

    pop b

    ; Выход по нажатию клавиши
    call inkey_FC12
    cpi  0FFh
    jnz  paletteOff

    dcr b
    jnz fly_2

    ; Сброс изображения
    lxi  h, plane + (PLANE_HEIGHT * 3)
    lxi  d, plane
    mvi  b, PLANE_SIZE_1 / 4
    call memcpyq

    ; Новое место вывода
    lhld fly_a2
    lxi  d, PLANE_HEIGHT * 2
    dad  d
    shld fly_a2

    ; Новое место вывода
    lhld fly_a1
    inr  h
    shld fly_a1

    ; Если недостигли конца экрана
    mov  a, h
    ora  a
    jnz  fly_1

    ; Если достигли конца экрана
    jmp  fly_0

;----------------------------------------------------------------------------------------------------------------------

memcpyq:
    ; Сохранение SP
    push h
    lxi  h, 2
    dad  sp
    shld memcpyq_2
    pop  h
    sphl
    xchg
memcpyq_1:
    pop  d
    mov  m, e
    inx  h
    mov  m, d
    inx  h
    pop  d
    mov  m, e
    inx  h
    mov  m, d
    inx  h
    dcr  b
    jnz  memcpyq_1
memcpyq_2 = $+1
    lxi  sp, 0
    ret

;----------------------------------------------------------------------------------------------------------------------
; Наложение самолетика на буфер

copyMaskedImageToBuffer:
copyImage91_1:
    push psw
    ; Плоскость 1
    ldax b
    inx  b
    ana  m
    inx  h
    ora  m
    dcx  h
    stax d
    inx  d
    ; Плоскость 2
    ldax b
    inx  b
    ana  m
    inx  h
    inx  h
    ora  m
    inx  h
    stax d
    inx  d
    ; Конец цикла
    pop  psw
    dcr  a
    jnz  copyImage91_1
    ret

;----------------------------------------------------------------------------------------------------------------------
; Сдвиг изображения самолетика на один пискель вправо
; d - на сколько

shiftImage:
    mvi  e, PLANE_HEIGHT * 3 ; всего строк и плоскостей
shiftImage_1:
    push h
    lxi  b, (PLANE_WIDTH - 1) * PLANE_HEIGHT * 3 ; шаг в 12 пикселей
    dad  b
    mov  a, m
    ral
    pop  h

    lxi  b, PLANE_HEIGHT * 3 ; шаг
    mvi  d, PLANE_WIDTH / 2 ; всего столбцов
    push h
intro_34:
    ; Сдвиг
    mov  a, m
    ral
    mov  m, a
    ; Следующий пиксель
    sbb  a
    dad  b
    rrc
    ; Сдвиг
    mov  a, m
    ral
    mov  m, a
    ; Следующий пиксель
    sbb  a
    dad  b
    rrc
    ; Конец цикла
    dcr  d
    jnz  intro_34
    ; Сдвиг
    mov  a, m
    ral
    mov  m, a

    pop  h
    inx  h
    dcr  e
    jnz  shiftImage_1
    ret

;----------------------------------------------------------------------------------------------------------------------
; Прокрутка текста вверх. Она медленная, но так и задумывалось

intro_5:
    ; Сохраняем указатель на текст
    push h
    ; Цикл повторов, прокрутка вверх на 14 пикселей
    mvi  b, 14 
intro_6:
    push b
    ; Адрес в видеопамяти для прокрутки
    lxi  d, 0BFFFh - (15*14) - (6*256) - 3
    push d
    pop  h
    ; Цикл по горизонтали, 36 столбцов
    mvi  b, 36
scroll_0:
    push d
    push h
    ; Цикл по вертикали, 26 линий
    mvi  c, 26
scroll_1:
    dcx  h
    mov  a, m
    stax d
    dcx  d
    dcr  c
    jnz  scroll_1
    pop  h
    pop  d
    ; Следующий столбец
    dcr  h
    dcr  d
    ; Конец цикла по горизонтали
    dcr  b
    jnz  scroll_0
    pop  b
    ; Конец цикла повторов
    dcr  b
    jnz  intro_6
    ; Адрес для вывода следующего символа
    lxi  h, 0FFFFh - (17*14) - (6*256)
    shld drawCharAddr
    ; Восстаналиваем указатель на текст
    pop  h    
    ; Следующий символ
    inx  h
    jmp  intro_4

;----------------------------------------------------------------------------------------------------------------------
; Правное появление графики

paletteOn:
    call paletteLoadDark
    call delay8000
    mvi  a, PALETTE_CYAN
    lxi  b, PALETTE_RED * 256 + PALETTE_WHITE
    jmp paletteLoad

;----------------------------------------------------------------------------------------------------------------------
; Плавное исчезнование графики

paletteOff:
    call paletteLoadDark
    call delay8000
    mvi  a, PALETTE_BLACK
    lxi  b, PALETTE_BLACK * 256 + PALETTE_BLACK
    jmp paletteLoad

;----------------------------------------------------------------------------------------------------------------------
; Установить темную палитру

paletteLoadDark:
    mvi  a, PALETTE_DARK_CYAN
    lxi  b, PALETTE_DARK_RED * 256 + PALETTE_DARK_GRAY
paletteLoad:
    out  IO_PALETTE_1
    mov  a, b
    out  IO_PALETTE_2
    mov  a, c
    out  IO_PALETTE_3
    ret

;----------------------------------------------------------------------------------------------------------------------
; Вывод изображения на экран с контролем выхода за пределы экрана

copyImageSafe:
    ; Выход за левую границу. Адрес вывода меньше 0D000h
    mov  a, h
    sui  0D0h
    jc   copyImageSafe_2
    
    ; Выход за правую границу. Если последний адрес вывода больше 0FFFFh
    ; a = addr + width;
    ; if(a < 0D0h) {
    mov  a, h
    add  b
    dcr  a
    cpi  0D0h
    jnc  copyImage
    ; a++; if(a >= width) return; width -= a;
    inr  a
    push d
    mov  d, a
    mov  a, b
    sub  d
    mov  b, a
    pop  d
    rz
    rc
    jmp  copyImage

;----------------------------------------------------------------------------------------------------------------------
; Выход за левую границу. Адрес вывода меньше 0D000h

copyImageSafe_2:
    ; de += c * 2 ; de - это адрес изображения ; с - это высота изображения
    push b
    xchg
    mvi  b, 0
    dad  b
    dad  b
    xchg
    pop  b
    ; b--; ; b - это ширина
    dcr  b
    ; hl += 0x100 ; hl - это адрес вывода
    inr  h
    ; Повторяем цикл
    jmp  copyImageSafe

;----------------------------------------------------------------------------------------------------------------------

introText2:
    db 33,"TETRIS WAS INVENTED BY A 30-YEAR-OLD"
    db 33,"SOVIET RESEARCHER NAMED ALEXEY"
    db 33,"PAZHITNOV WHO CURRENTLY WORKS AT"
    db 33,"THE COMPUTER CENTRE(ACADEMY SOFT) OF"
    db 33,"THE USSR ACADEMY OF SCIENCES IN"
    db 33,"MOSCOW. THE ORIGINAL PROGRAMMER WAS"
    db 33,"18-YO VADIM GERASIMOV. A STUDENT"
    db 33,"STUDYING COMPUTER INFORMATICS AT"
    db 33,"MOSCOW UNIVERSITY. NOW YOU CAN ENJOY"
    db 33,"TETRIS BECAUSE OF THE JOINT EFFORTS"
    db 33,"OF ACADEMY SOFT, MOSCOW, ANDROMEDA"
    db 33,"SOFTWARE LTD, LONDON, ALEMORF, SPB"
    db 33,"AND SPECTRUM HOLOBYTE, USA."
    db 0

;----------------------------------------------------------------------------------------------------------------------

introText:
    db  4-2,19-8,"SPECTRUM HOLOBYTE PRESENTS"
    db  6-2,26-8,"T E T R I S"
    db  8-2,15-8,"VERSION"
    db  8-2,33-8,"PROGRAMMER"
    db 10-2,15-8,"ISKRA 1080 TARTU"
    db 10-2,33-8,"ALEKSEY MOROZOV"
    db 12-2,15-8,"IBM CGA"
    db 12-2,33-8,"ENG AN JIO"
    db 13-2,15-8,"RAM RESIDENT"
    db 13-2,33-8,"ERICK JAP"
    db 14-2,15-8,"TANDY"
    db 14-2,33-8,"BILLY SUTYONO"
    db 15-2,15-8,"IBM EGA"
    db 15-2,33-8,"ARYANTO WIDODO"
    db 17-2,15-8,"GRAPHICS"
    db 17-2,33-8,"DAN GUERRA"
    db 18-2,15-8,"PRODUCT MANAGER"
    db 18-2,33-8,"R. ANTON WIDJAJA"
    db 19-2,15-8,"PRODUCER"
    db 19-2,33-8,"SEAN B. BARGER"
    db 0
