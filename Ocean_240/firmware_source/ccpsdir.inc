; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Новая команда SDIR для CCP

CcpSdir:
        ; ?
        call   CPM_CCP + 25Eh
        call   CPM_CCP + 454h

        ; Если не указано имя, то записать в командную строку 11 знаков вопроса
        lxi    h, v_ccp_command_line_buffer
        mov    a, m
        cpi    ' '
        jnz    loc_DB7A
        mvi    b, 11
loc_DB73: mvi    m, '?'
          inx    h
          dcr    b
        jnz    loc_DB73
loc_DB7A:

        ; ?
        call   ccp_ram_B200 + 0E9h
        jnz    loc_DB86
          call   ccp_ram_B200 + 3EAh
          jmp    ccp_ram_B200 + 786h
loc_DB86:
        call    ccp_ram_B200 + 98h

        ; Счетчик общего объема файлов
        lxi    h, 0
        shld   v_tmp_sdir_total

        ; Номер файла
        mvi    e, 0

loc_DB91:
        ; ?
        push   d
        call   ccp_ram_B200 + 0E9h
        pop    d
        push   d

        ; Поиск файла с номером E
loc_DB97: dcr    e
          jm     loc_DBA6
          push   d
          call   ccp_ram_B200 + 0E4h
          pop    d

          ; Переход, если файлы закончились
          jz     loc_DC3E
        jmp    loc_DB97
loc_DBA6:

        ; ?
        lda    v_ccp_command_line_buffer + 32
        rrc
        rrc
        rrc
        ani    60h
        mov    c, a

        ; ?
        push   b
        call   ccp_ram_B200 + 98h
        call   ccp_ram_B200 + 1D0h
        inr    a
        sta    v_cpm_sector_buffer
        pop    b

        ; ?
        mvi    b, 0
        lxi    h, v_cpm_sector_buffer + 1
        mov    e, l
        mov    d, h
        dad    b

        ; Копирование имени и вывод имени файла на экран
        mvi    b, 1
loc_DBC5: mov    a, m
          stax   d
          mov    c, a
          call   BiosConout
          inx    h
          inx    d
          inr    b
          mov    a, b
          cpi    12
        jc    loc_DBC5

        ; Заполнение конца буфера нулями
loc_DBD4: xra    a
          stax   d
          inr    b
          mov    a, b
          cpi    24h
        jc     loc_DBD4

        ; Получение размера файла с именем v_cpm_sector_buffer
        lxi    d, v_cpm_sector_buffer
        call   GetFileSize
        lhld   v_cpm_sector_buffer + 33 ; Размер в 128 байтных блоках

        ; Получение размера блока диска
        lda    v_cpm_disk
        ora    a
        jnz    loc_DBF2
          mvi    b, 3  ; Размер блока на диске A:
          jmp    loc_DBF4
loc_DBF2:
          mvi    b, 4  ; Размер блока на дисках B: и C:
loc_DBF4:

        ; Преобразование размера в 128 блоках в размер в блока файловой системы

        ; hl >>= b
        mov    c, l
loc_DBF5: xra    a
          mov    a, h
          rar
          mov    h, a
          mov    a, l
          rar
          mov    l, a
          dcr    b
        jnz    loc_DBF5

        ; Округление в большую сторону
        lda    v_cpm_disk
        ora    a
        jnz    loc_DC0C
          mvi    a, ~(~0 << 3)  ; Размер блока на диске A:
          jmp    loc_DC0E
loc_DC0C:
          mvi    a, ~(~0 << 4)  ; Размер блока на дисках B: и C:
loc_DC0E:
        ana    c
        jz    loc_DC13
          inx    h
loc_DC13:

        ; Преобразование блоков в килобайты
        ; У дисковода A: размер блока 1 кБ, у дисководов B: размер блока 2 кБ.
        lda    v_cpm_disk
        ora    a
        jz     loc_DC1B
          dad    h
loc_DC1B:

        ; Прибавление размера файла к v_tmp_sdir_total
        xchg        
        lhld   v_tmp_sdir_total
        dad    d
        shld   v_tmp_sdir_total

        ; Вывод размера файла
        mvi    c, ' '
        call   BiosConout
        call   BiosConout
        call   PrintNumber
        mvi    c, 'K'
        call   BiosConout

        ; ?
        call   ccp_ram_B200 + 1C2h
        jnz    ccp_ram_B200 + 786h

        ; Следующий файл
        pop    d
        inr    e
        jmp    loc_DB91

;----------------------------------------------------------------------------

loc_DC3E:
        pop    d

        ; Вывод текста "\r\nFREE SPACE   "
        lxi    h, a_free_space
        call   PrintString3

        ; Получение размера диска в HL
        lda    v_cpm_disk
        ora    a
        jnz    loc_DC52
        lhld   cfg_disk_a_size
        jmp    loc_DC72

;----------------------------------------------------------------------------

loc_DC52:
        dcr    a
        lhld   cfg_disk_b_size
        jz     loc_DC72

        lhld   cfg_disk_c_size
        lda    v_c_360_720
        ora    a
        jnz    loc_DC72

        mov    a, h
        cpi    1
        jz     loc_DC6F
        lxi    h, 360
        jmp    loc_DC72

; ---------------------------------------------------------------------------

loc_DC6F:
        lxi    h, 720
loc_DC72:

        xchg
        lhld    v_tmp_sdir_total

        ; Вычитание HL из DE
        mov    a, e
        sub    l
        mov    e, a
        mov    a, d
        sbb    h
        mov    d, a

        ; Вывод числа на экран
        call   PrintNumber
        mvi    c, 'K'
        call   BiosConout

        ; ?
        call   ccp_ram_B200+98h
        jmp    ccp_ram_B200+786h

;----------------------------------------------------------------------------

a_free_space: .db 0Dh, 0Ah, "FREE SPACE   ", 0

;----------------------------------------------------------------------------

PrintNumber:
        mov    a, d
        ani    0E0h
        jz     loc_DCAF

        mvi    c, '*'
        call   BiosConout
        call   BiosConout
        call   BiosConout
        call   BiosConout
        ret

; ---------------------------------------------------------------------------

loc_DCAF:
        lxi    h, 0
        mov    b, d
        mov    c, e
        lxi    d, 1
        mvi    a, 0Dh

loc_DCB9:
        push   psw
        push   h
        mov    a, b
        rar
        mov    b, a
        mov    a, c
        rar
        mov    c, a
        jnc    loc_DCC9
          pop    h
          call    Daa16
          push    h
loc_DCC9:
        mov    l, e
        mov    h, d
        call   Daa16
        xchg
        pop    h
        pop    psw
        dcr    a
        jnz    loc_DCB9
        mvi    d, 4
        mvi    b, 0

loc_DCD9:
        mvi    e, 4
loc_DCDB:
        mov    a, l
        ral
        mov    l, a
        mov    a, h
        ral
        mov    h, a
        mov    a, c
        ral
        mov    c, a
        dcr    e
        jnz    loc_DCDB
        mov    a, c
        ani    0Fh
        adi    30h ; '0'
        cpi    30h ; '0'
        jnz    loc_DD03
        dcr    b
        inr    b
        jnz    loc_DD05
        mov    a, d
        dcr    a
        jz    loc_DD01
        mvi    a, 20h ; ' '
        jmp    loc_DD05

;----------------------------------------------------------------------------

loc_DD01:
        mvi    a, '0'
loc_DD03:
        mvi    b, 1
loc_DD05:
        mov    c, a
        call   BiosConout
        dcr    d
        jnz    loc_DCD9
        ret

;----------------------------------------------------------------------------

Daa16:  mov    a, l
        add    e
        daa
        mov    l, a
        mov    a, h
        adc    d
        daa
        mov    h, a
        ret

;----------------------------------------------------------------------------

GetFileSize:
        mvi    c, 23h  ; Вычислить размер файла
        jmp    byte_5
