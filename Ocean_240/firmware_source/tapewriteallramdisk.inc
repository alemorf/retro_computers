; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Записать RAM-диск на ленту

TapeWriteAllRamDisk:
        ; Очистка буфера
        lxi    h, v_buffer_128
        mvi    c, 128
loc_FA3B: mvi    m, 0
          inx    h
          dcr    c
        jnz    loc_FA3B

        ; Запись нулевого блока на ленту с идентификатором 0FFFFh
        lxi     h, v_buffer_128
        lxi     d, 0FFFFh  ; Идентификатор
        call    WriteTapeBlock3
        call    Delay250

        ; Запись нулевого блока на ленту с идентификатором 0
        lxi     d, 0  ; Идентификатор
        call    WriteTapeBlock3
        call    Delay250

        ; Запись страниц дополнительной памяти
        lxi    b, RAM_DISK_SIZE_KB * (RAM_DISK_BLOCK_SIZE / 128)
        lxi    d, 0
loc_FA5D: push   b

          lxi    h, v_buffer_128
          call   RamDiskRead2

          inx    d ; Идентификатор, начиная с 1
          call   WriteTapeBlock3
          call   Delay250

          pop    b

          dcx    b
          mov    a, b
          ora    c
        jnz    loc_FA5D

        ret

;----------------------------------------------------------------------------

Delay250:
        lxi    b, 250
loc_FA76: dcx    b
          mov    a, b
          ora    c
        jnz    loc_FA76
        ret
