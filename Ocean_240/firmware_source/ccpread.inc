; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Новая функция READ для CCP

CcpRead:
        ; Опустошение буфера клавиатуры
loc_DD1C: call   BiosConst
          ora    a
          jz     loc_DD29
          call   BiosConin
        jmp    loc_DD1C
loc_DD29:

        ; ?
        call   CPM_CCP + 0B8h
        call   CPM_CCP + 98h

        ; Ожидание паузы между блоками данных на магнитной ленте
        mvi    a, 100
        call   WaitTapePause
        ora    a
        jnz    CcpRead_KeyPressed

        ; Чтение заголовка
        mvi    e, 8
CcpRead_ReadHeader:
          lxi    h, v_cpm_sector_buffer
          call   TapeReadBlock
          cpi    4
          jz     CcpRead_KeyPressed
          ora    a
          jz     loc_DD50
          dcr    e
        jnz    CcpRead_ReadHeader

        ; Вывод ошибки WHAT? через 8 попыток
        jmp    CcpRead_What

;----------------------------------------------------------------------------

loc_DD50:
        ; Идентификатор блока должен быть 8000h
        mov    a, b
        cpi    80h
        jnz    CcpRead_ReadHeader
        mov    a, c
        ora    a
        jnz    CcpRead_ReadHeader

        ; Терминатор строки
        xra    a
        sta    v_cpm_sector_buffer + 12

        ; Копирование имени
        lxi    d, v_cpm_sector_buffer
        lxi    h, CPM_CCP + 8
        shld   ccp_ram_B200 + 88h
loc_DD68: ldax   d
          ora    a
          jz     loc_DD73
          mov    m, a
          inx    h
          inx    d
        jmp    loc_DD68
loc_DD73:

        ; Терминатор строки
        mvi    m, 0

        ; ?
        call   ccp_ram_B200 + 25Eh
        jnz    ccp_ram_B200 + 209h

        ; Вывод имени файла на экран
        lxi    h, v_ccp_command_line_buffer
        mvi    b, 11
loc_DD80: mov    a, m
          ani    7Fh
          mov    c, a
          call   BiosConout
          inx    h
          dcr    b
        jnz    loc_DD80

        ; Вывод 3-х пробелов
        mvi    c, ' '
        call   BiosConout
        call   BiosConout
        call   BiosConout

        ; ?
        call   ccp_ram_B200 + 0D0h
        jz     loc_DDAD

        ; Вывод "*EX*   "
        lxi    h, a_ex
        call   PrintString3

        ; ?
        lxi    h, v_ccp_command_line_buffer + 8
        mvi    a, 24h ; '$'
        mov    m, a
        inx    h
        mov    m, a
        inx    h
        mov    m, a

loc_DDAD:
        ; ?
        lxi    d, v_ccp_command_line_buffer - 1
        push   d
        call   ccp_ram_B200 + 0EFh
        pop    d        
        call   ccp_ram_B200 + 109h
        jz     ccp_ram_B200 + 5FBh

        ; ?
        xra    a
        sta    v_ccp_command_line_buffer + 31

        ; Индентификатор загружаемого блока
        lxi    d, 1

CcpRead_ReadNextBlock:
        lxi    h, v_cpm_sector_buffer
        push   d

loc_DDC6:
        call   TapeReadBlock
        cpi    4
        jz     CcpRead_KeyPressed2
        ora    a
        jz     loc_DDDA

        ; ?
        lda    v_ccp_command_line_buffer + 31
        ani    7Fh
        jnz    CcpRead_Cs
loc_DDDA:

        ; Повторяем загрузку, если идентификатор 0
        mov    a, c
        ora    b
        jz     loc_DDC6

        ; Если идентификатор 0FFFFh, значит загружен последний блок файла
        mov    a, c
        ana    b
        cpi    0FFh
        jz     loc_DE36

        ; Если идентификатор не равен DE
        mov    a, c
        cmp    e
        jnz    CcpRead_Sq
        mov    a, b
        cmp    d
        jnz    CcpRead_Sq

        ; ?
        lxi    d, 80h
        call   ccp_ram_B200 + 1D8h
        lxi    d, ccp_ram_B200 + 7CDh
        call   ccp_ram_B200 + 104h

        ; ?
        pop    d
        jnz    loc_DEAD

        ; Перейти к загрузке следующего блока
        inx    d
        jmp    CcpRead_ReadNextBlock

;----------------------------------------------------------------------------

CcpRead_What:
        ; Вывод "WHAT?" и гудок
        lxi    h, a_what
        call   PrintString3

        ; Перезапуск функции
        jmp    CcpRead_Restart

;----------------------------------------------------------------------------

CcpRead_Cs:
        pop    b

        ; Вывод "<CS "
        lxi    h, a_cs
        call   PrintString3

        ; Вывод числа
        call   PrintNumber

        jmp    loc_DE24

;----------------------------------------------------------------------------

CcpRead_Sq:
        pop    b

        ; Вывод "<SQ "
        lxi    h, a_sq
        call   PrintString3

        ; Вывод числа
        call    PrintNumber

loc_DE24:
        ; Вывод ">" и гудок
        lxi    h, a_lt
        call   PrintString3

CcpRead_Restart:
        ; ?
        lxi    d,  ccp_ram_B200 + 7CDh
        call   ccp_ram_B200 + 0EFh
        call   ccp_ram_B200 + 1D5h

        ; Перезапуск
        jmp    CcpRead

;----------------------------------------------------------------------------

loc_DE36:
        ; ?
        lxi    d, v_ccp_command_line_buffer - 1
        call   ccp_ram_B200 + 0DAh
        inr    a
        jz     loc_DEAD

        ; ?
        call   ccp_ram_B200 + 1D5h

        ; Перезапуск
        jmp    CcpRead

;----------------------------------------------------------------------------

CcpRead_KeyPressed2:
        pop    d

        ; ?
        push   b
        lxi    d,  ccp_ram_B200 + 7CDh
        call   ccp_ram_B200 + 0EFh
        pop    b

        ; Если нажат ESC или CTRL+C
        mov    a, c
        ani    7Fh
        cpi    3
        jz     loc_DE78
        cpi    1Bh
        jz     loc_DE78

        ; Вывод "*BREAK*"
        lxi    h, a_ccp_read_break
        call   PrintString3

        ; Перезапуск
        jmp    CcpRead

;----------------------------------------------------------------------------

CcpRead_KeyPressed:
        ; Если нажат ESC или CTRL+C
        mov    a, c
        ani    7Fh
        cpi    3
        jz     CcpRead_CtrlC
        cpi    1Bh
        jnz    CcpRead

CcpRead_CtrlC:
        ; ?
        call   ccp_ram_B200 + 1D5h
        jmp    ccp_ram_B200 + 786h

;----------------------------------------------------------------------------

loc_DE78:
        ; ?
        call   ccp_ram_B200 + 98h

        jmp    CcpRead_CtrlC

; ---------------------------------------------------------------------------

a_what:           .db "WHAT?", 7, 0
a_cs:             .db "<CS ", 0
a_sq:             .db "<SQ ", 0
a_ccp_read_break: .db "*BREAK*", 0
a_ex:             .db "*EX*   ", 0
a_lt:             .db '>', 7, 0
