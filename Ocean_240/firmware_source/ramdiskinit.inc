; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Инициализация RAM-диска

        ; Пустой каталог / Буфер заполненный 0E5h
        lxi    h, v_cpm_sector_buffer
        mvi    b, CPM_SECTOR_BUFFER_SIZE
loc_D66A: mvi    m, 0E5h
          inx    h
          dcr    b
        jnz    loc_D66A

#ifdef CONFIG_ROM_DISK
        ; Копируем каталог, 7 секторов размером 128 байт из ПЗУ в начало ДОЗУ.
        ; 8 сектор заполняем байтом 0E5h.
        ; 1 сектор в ПЗУ это начальный загрузчик.
        lxi    h, (RAM_DISK_SIZE_KB + 41) * 8 - 1
        lxi    d, 7
InitRamLoop:
          push   h
          lxi    h, v_cpm_sector_buffer
          call   RamDiskWrite2
          pop    h
          xchg
          push   h
          lxi    h, v_cpm_sector_buffer
          call   RamDiskRead2
          pop    h
          xchg
          dcx    h
          dcx    d
          mov    a, e
          inr    a
        jnz    InitRamLoop
#else
        ; Записываем байт 0E5h во все страницы RAM диска
        lxi    h, v_cpm_sector_buffer
        lxi    d, 0
        mvi    b, RAM_DISK_BLOCK_SIZE / 128
loc_D679: push   b
          call   RamDiskWrite
          pop    b
          inx    d
          dcr    b
        jnz    loc_D679
#endif
