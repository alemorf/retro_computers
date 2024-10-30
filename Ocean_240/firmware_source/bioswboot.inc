; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция CP/M BIOS: Теплая перезагрузка

BiosWBoot2:
        ; Если по смещению 40h не находится константа AAAAh, то инициализация области памяти 40h
        lhld   40h
        lxi    d, -0AAAAh
        dad    d
        mov    a, h
        ora    l
        cnz    InitBiosWorkArea

        ; Стек по умолчанию
        lxi    sp, 100h

        ; Копирование командного процессора из ПЗУ в ОЗУ
        lxi    h, CPM_CCP
        lxi    d, ccp_rom
        lxi    b, CPM_CCP_SIZE
loc_D6C0: ldax    d
          mov    m, a
          inx    d
          inx    h
          dcx    b
          mov    a, b
          ora    c
        jnz    loc_D6C0

        ; Очистка ОЗУ
        lxi    h, ccp_ram_BA09
        lxi    b, 213
loc_D6D0: mvi    m, 0
          inx    h
          dcx    b
          mov    a, b
          ora    c
        jnz    loc_D6D0

        ; ?
        mvi    a, 0E5h
        sta    byte_BA46

        ; ?
        mvi    a, 80h
        sta    word_BA4B

        ; Копирование DPH и еще чего то в ОЗУ
        lxi    h, v_dph
        lxi    d, dph
        lxi    b, DPH_SIZE * DISK_COUNT + REAL_SECTOR_PER_TRACK
loc_D6EC: ldax    d
          mov    m, a
          inx    h
          inx    d
          dcx    b
          mov    a, b
          ora    c
        jnz    loc_D6EC

        ; Стандартная подготовка к запуску CP/M
        lxi    b, v_cpm_sector_buffer
        call   BiosSetDma
        mvi    a, 0C3h
        sta    0
        lxi    h, BiosWBoot
        shld   1
        sta    byte_5
        lxi    h, CPM_CCP + 806h
        shld   6

        ; Инициализация DPB A: в зависимости от cfg_disk_a_size
        lxi    h, v_dpb_a
        mvi    c, DPB_SIZE
        lxi    d, dpb_192
        lda    cfg_disk_a_size + 1 ; Очень странно
        ora    a
        jz     loc_D722
        lxi    d, dpb_ff
loc_D722:
        call   MemcpyHlDeC

        ; Инициализация DPB B: в зависимости от cfg_disk_b_size
        lxi    h, v_dpb_b
        mvi    c, DPB_SIZE
        lxi    d, dpb_360
        lda    cfg_disk_b_size + 1 ; Очень странно
        cpi    1
        jz     loc_D738
        lxi    d, dpb_720
loc_D738:
        call    MemcpyHlDeC

        ; Инициализация DPB C: в зависимости от cfg_disk_c_size
        lxi    h, v_dpb_c
        mvi    c, DPB_SIZE
        lda    cfg_disk_c_size + 1 ; Очень странно
        cpi    2
        jz     loc_D758
          lxi    d, dpb_360
          lda    v_c_360_720 ; Позволяет без перепрошивки ПЗУ менять тип дисковода C:
          ora    a
          jnz    loc_D765
          lxi    d, dpb_720
        jmp    loc_D765
loc_D758:  lxi    d, dpb_720
           lda    v_c_360_720 ; Позволяет без перепрошивки ПЗУ менять тип дисковода C:
           ora    a
           jnz    loc_D765
           lxi    d, dpb_360
loc_D765:
        call    MemcpyHlDeC

        ; Сброс слайсера (забыть данные)
        xra    a
        sta    v_slicer_has_data
        sta    v_slicer_uninited_count

        ; Запуск CCP
        lda    v_current_disk
        mov    c, a
        jmp    CPM_CCP
