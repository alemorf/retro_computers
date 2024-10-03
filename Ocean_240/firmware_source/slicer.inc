; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Чтение и запись 2048 байтных блоков файловой системы 128 байтными логическими
; секторами на 512 байтные реальные сектора.

;----------------------------------------------------------------------------
; Прочитать 128 байтный сектор с дискеты
; Вход: v_disk, v_track, v_sector_128, v_dma
; Выход: a - код ошибки

SlicerRead:
        ; Сброс счетчика блокирующего чтение с дискеты
        xra    a
        sta    v_slicer_uninited_count

        ; Режим чтения
        mvi    a, 1
        sta    v_tmp_slicer_operation ; 0 - запись, 1 - чтение

        ; Разрешение читать данные с дискеты в буфер
        sta    v_tmp_slicer_can_read

        ; Отключение обязательной запись буфера на дискету
        mvi    a, 2
        sta    v_tmp_slicer_flush

        ; Общая функция
        jmp    SlicerReadWriteNext

;----------------------------------------------------------------------------
; Записать 128 байтный сектор на дискету
; Вход: v_disk, v_track, v_sector_128, v_dma
; Выход: a - код ошибки

SlicerWrite:
        ; Режим записи
        xra    a
        sta    v_tmp_slicer_operation

        ; Дополнительная информация от CP/M:
        ; 0 - Запись данных можно отложить
        ; 1 - Нужно записать все данные на дискету сейчас
        ; 2 - Запись в блок файловой системы, который до этого не использовался
        ;     Сообщается только в первом 128 секторе 2048 байтного блока.
        mov    a, c
        sta    v_tmp_slicer_flush

        ; Если это запись в блок файловой системы, который до этого не использовался,
        ; то взводится счетчик блокирующий чтение с дискеты
        cpi    2
        jnz    loc_D842
          mvi    a, 2048 / 128
          sta    v_slicer_uninited_count
          lda    v_disk
          sta    v_slicer_uninited_disk
          lda    v_track
          sta    v_slicer_uninited_track
          lda    v_sector_128
          sta    v_slicer_uninited_sector_128
loc_D842:

        ; С каждой записью уменьшается счетчик
        lda    v_slicer_uninited_count
        ora    a
        jz     SlicerReadWrite
        dcr    a
        sta    v_slicer_uninited_count

        ; Если изменился диск, дорожка или сектор, то счетчик сбарсывается
        lda    v_disk
        lxi    h, v_slicer_uninited_disk
        cmp    m
        jnz    SlicerReadWrite
        lda    v_track
        lxi    h, v_slicer_uninited_track
        cmp    m
        jnz    SlicerReadWrite
        lda    v_sector_128
        lxi    h, v_slicer_uninited_sector_128
        cmp    m
        jnz    SlicerReadWrite

        ; С каждой записью увеличивается номер сектора и возможно дорожки
        inr    m
        mov    a, m
        cpi    36  ; Sector per track
        jc     loc_D87B
          mvi    m, 0
          lda    v_slicer_uninited_track
          inr    a
          sta    v_slicer_uninited_track
loc_D87B:

        ; Запрет читать с дискеты в буфер
        xra    a
        sta    v_tmp_slicer_can_read

        ; Общая функция
        jmp    SlicerReadWriteNext

;----------------------------------------------------------------------------

SlicerReadWrite:
        ; Сброс счетчика блокирующего чтение с дискеты
        xra    a
        sta    v_slicer_uninited_count

        ; Разрешение читать с дискеты в буфер
        inr    a
        sta    v_tmp_slicer_can_read

SlicerReadWriteNext:
        ; Инициализация возвращаемого значения (кода ошибки)
        xra    a
        sta    v_tmp_slicer_result

        ; Вычисление номера реального 512-байтного сектора
        lda    v_sector_128
        ora    a
        rar
        ora    a
        rar
        sta    v_tmp_slicer_real_sector

        ; Если в буфере нет данных, то переходим на загрузку
        lxi    h, v_slicer_has_data
        mov    a, m
        mvi    m, 1
        ora    a
        jz     loc_D8C7

        ; Если в буфере не тот диск, дорожка, буфер, то сохраняем буфер
        ; и загружем другой сектор
        lda    v_disk
        lxi    h, v_slicer_disk
        cmp    m
        jnz    loc_D8C0
        lda    v_track
        lxi    h, v_slicer_track
        cmp    m
        jnz    loc_D8C0
        lda    v_tmp_slicer_real_sector
        lxi    h, v_slicer_real_sector
        cmp    m
        jz     loc_D8E4

loc_D8C0:
        ; Если нужно сохранить буфер, то сохраняем
        lda    v_slicer_need_save
        ora    a
        cnz    SlicerSaveBuffer

loc_D8C7:
        ; Если можно загрузить в буфер, то загружаем
        lda    v_disk
        sta    v_slicer_disk
        lda    v_track
        sta    v_slicer_track
        lda    v_tmp_slicer_real_sector
        sta    v_slicer_real_sector
        lda    v_tmp_slicer_can_read
        ora    a
        cnz    SlicerReadToBuffer
        xra    a
        sta    v_slicer_need_save

loc_D8E4:
        ; Вычисляем адрес 128 байтного сектора в буфере
        lda    v_sector_128
        ani    3
        mov    l, a
        mvi    h, 0
        dad    h
        dad    h
        dad    h
        dad    h
        dad    h
        dad    h
        dad    h
        lxi    d, v_slicer_buffer
        dad    d
        xchg

        ; Буфер для чтения или записи
        lhld   v_dma

        ; Размер сектора
        mvi    c, 128

        ; Читаем или записываем 128 байтный сектор
        lda    v_tmp_slicer_operation ; 0 - запись, 1 - чтение
        ora    a
        jnz    loc_D90A
          mvi    a, 1
          sta    v_slicer_need_save
          xchg
loc_D90A:
        ldax   d
        inx    d
        mov    m, a
        inx    h
        dcr    c
        jnz    loc_D90A

        ; Если CP/M не требует сохранить буфер сейчас, то возвращаем
        ; код ошибки последнего чтения или записи.
        lda    v_tmp_slicer_flush
        cpi    1
        lda    v_tmp_slicer_result
        rnz

        ; Если в процессе чтения или записи дискеты произошла ошибка, то
        ; выходим с кодом ошибки.
        ora    a
        rnz

        ; Сбрасываем флаг необходимости сохранения
        xra    a
        sta    v_slicer_need_save

        ; Записываем сектор на дискету
        call   SlicerSaveBuffer

        ; Выходим с кодом ошибки
        lda    v_tmp_slicer_result
        ret

;---------------------------------------------------------------------------

SlicerSaveBuffer:
        call   SlicerGetFloppyArgs
        mvi    c, 0A6h ; Код команды для К1818ВГ93
        call   WriteFloppy
        sta    v_tmp_slicer_result
        ret

;---------------------------------------------------------------------------

SlicerReadToBuffer:
        call   SlicerGetFloppyArgs
        mvi    c, 86h ; Код команды для К1818ВГ93
        call   ReadFloppy
        sta    v_tmp_slicer_result
        ret

;----------------------------------------------------------------------------

SlicerGetFloppyArgs:
        lxi    h, v_sector_128_interleave_b
        lda    v_slicer_disk
        dcr    a
        jz     loc_D94D
          lxi    h, v_sector_128_interleave_c
loc_D94D:

        lda    v_slicer_real_sector
        add    l
        mov    l, a
        mov    e, m

        lda    v_slicer_track
        mov    d, a

        lxi    h, v_slicer_buffer

        lda    v_slicer_disk
        ret
