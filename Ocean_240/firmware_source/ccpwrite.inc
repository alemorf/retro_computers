; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Новая функция WRITE для CCP

sub_DEB6:
        lxi    d, byte_BAB6
        jmp    ccp_ram_B200 + 0F9h

;----------------------------------------------------------------------------

CcpWrite:
        ; ?
        call   ccp_ram_B200 + 25Eh
        call   ccp_ram_B200 + 454h

        ; Если не указано имя, то записать в командную строку 11 знаков вопроса
        lxi    h, v_ccp_command_line_buffer
        mov    a, m
        cpi    ' '
        jnz    loc_DED4

        mvi    b, 11
loc_DECD: mvi    m, '?'
          inx    h
          dcr    b
        jnz    loc_DECD
loc_DED4:

        ; ?
        call   ccp_ram_B200 + 0E9h
        jnz    loc_DEE0
          call   ccp_ram_B200 + 3EAh
          jmp    ccp_ram_B200 + 786h
loc_DEE0:

        ; Счетчик файлов
        mvi    e, 0

        ; Начало цикла записи файлов
loc_DEE2:
        push   d
        call   ccp_ram_B200 + 0E9h
        pop    d        
        push   d

        ; Поиск файла с номером E
loc_DEE8: dcr    e
          jm     loc_DEF7
          push    d
            call    ccp_ram_B200 + 0E4h
          pop    d
          jz    CcpWrite_Ret  ; Больше нет файлов
        jmp    loc_DEE8
loc_DEF7:
        pop    b
        push   b

        mov    a, c
        ora    a
        jz     loc_DF14
        lxi    d, 4B0h

loc_DF01: ; Задержка
          xra    a
loc_DF02:   dcr    a
          jnz    loc_DF02

          push   d
          call   ccp_ram_B200 + 1C2h
          pop    d
          jnz    ccp_ram_B200 + 786h

          dcx    d
          mov    a, d
          ora    e
        jnz    loc_DF01

loc_DF14:
        lda    ccp_ram_B200 + 7EEh
        rrc
        rrc
        rrc
        ani    60h
        mov    c, a

        push   b
        call   ccp_ram_B200 + 98h
        call   ccp_ram_B200 + 1D0h
        inr    a
        sta    byte_BAB6
        pop    b

        mvi    b, 0
        lxi    h, 81h
        dad    b

        ; Копирование имени файла в v_tmp_file_name
        lxi    d, v_tmp_file_name
        mvi    b, 1
loc_DF34: mov    a, m
          stax   d
          inx    h
          inx    d
          inr    b
          mov    a, b
          cpi    12
        jc     loc_DF34

        ; Заполнение конца v_tmp_file_name нулями
loc_DF3F: xra    a
          stax   d
          inx    d
          inr    b
          mov    a, b
          cpi    24h
        jc     loc_DF3F

        ; Вывод v_tmp_file_name на экран
        lxi    h, v_tmp_file_name
        call   PrintString3

        ; Очистка буфера
        lxi    h, v_cpm_sector_buffer
        mvi    b, CPM_SECTOR_BUFFER_SIZE
loc_DF54: mvi    m, 0
          inx    h
          dcr    b
        jnz    loc_DF54

        ; Копирование имени файла в буфер
        lxi    h, v_cpm_sector_buffer
        lxi    d, v_tmp_file_name
        mvi    b, 8
loc_DF63: ldax   d
          cpi    20h
          jz     loc_DF6F
          mov    m, a
          inx    h
          inx    d
        jmp    loc_DF63
loc_DF6F:

        ; Копирование точки в буфер
        mvi    m, 2Eh
        inx    h

        ; ?
        call    ccp_ram_B200 + 24Fh

        ; ?
loc_DF75: ldax   d
          mov    m, a
          ora    a
          jz     loc_DF80
          inx    h
          inx    d
        jmp    loc_DF75
loc_DF80:

        ; ?
        lxi    d, byte_BAB6
        call   ccp_ram_B200 + 0CBh

        ; Запись 128 байтного блока два раза с идентификатором 8000h
        lxi    d, 8000h
        lxi    h, v_cpm_sector_buffer
        call   TapeWriteBlockDelayed
        call   TapeWriteBlockDelayed

        lxi    d, 1
loc_DF95:
          push   d

          call   sub_DEB6
          dcr    a
          jz     loc_DFC1

          lda    byte_BAD6
          ani    7Fh
          cpi    1
          jnz    loc_DFB0
            ; Запись 128 байтного блока с идентификатором 0
            lxi    d, 0
            lxi    h, v_cpm_sector_buffer
            call   TapeWriteBlockDelayed
loc_DFB0:

          ; ?
          call   ccp_ram_B200 + 1C2h
          lxi    h, v_cpm_sector_buffer
          pop    d
          jnz    ccp_ram_B200 + 786h

          ; Запись 128 байтного блока с идентификатором 1+
          call   TapeWriteBlockDelayed
          inx    d
        jmp    loc_DF95
loc_DFC1:

        pop    d
        xchg
        shld    v_cpm_sector_buffer
        xchg

        ; Запись 128 байтного блока дважды с идентификатором 0FFFFh
        lxi    d, 0FFFFh
        call   TapeWriteBlockDelayed
        call   TapeWriteBlockDelayed

        pop    d
        inr    e
        jmp    loc_DEE2

;----------------------------------------------------------------------------

CcpWrite_Ret:
        pop    d
        call   ccp_ram_B200+98h
        jmp    ccp_ram_B200+786h

;----------------------------------------------------------------------------

TapeWriteBlockDelayed:
        ; Задержка
        lxi    b, 3036
loc_DFDF: dcx    b
          mov    a, b
          ora    c
        jnz    loc_DFDF

        ; Запись блока
        jmp    TapeWriteBlock
