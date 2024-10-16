; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Прочитать RAM-диск с ленты

TapeReadAllRamDisk:
        ; Ожидание тишины на входе с магнитофона
        mvi    a, 100 ; Время в течении которого должна быть тишина
        call   TapeWaitPause
        ora    a
        jnz    TapeBreak

        ; Повторяем загрузку 128 байтного блока с ленты,
        ; пока не загрузим блок с идентификатором 0
        mvi    e, 6
loc_FA88:
          dcr    e
          jz     TapeErrorNoStartRecord

          ; Прочитать блок с ленты
          lxi    h, v_buffer_128
          call   ReadTapeBlock3
          cpi    4
          jz     TapeBreak
          ora    a
          jnz    loc_FA88

          ; Это должен быть нулевой блок
          mov    a, b
          ora    c
        jnz    loc_FA88

        lxi    b, RAM_DISK_SIZE_KB * (RAM_DISK_BLOCK_SIZE / 128)
        lxi    d, 0

loc_FAA6:
          push    b

          ; Загрузка 128 байтого блока с ленты
          call   ReadTapeBlock3
          ora    a
          jnz    TapeError

          ; Уменьшаем загруженный идентификатор на 1
          dcx    b

          ; Проверка идентификатора
          mov    a, b
          cmp    d
          jnz    TapeErrorSequence
          mov    a, c
          cmp    e
          jnz    TapeErrorSequence

          ; Сохранение загруженного блока
          call   RamDiskWrite2
          inx    d

          pop    b

          ; Цикл
          dcx    b
          mov    a, b
          ora    c
        jnz    loc_FAA6
        ret

;----------------------------------------------------------------------------

TapeErrorNoStartRecord:
        lxi    h, a_no_start_record
        call   PrintString
        ret

;----------------------------------------------------------------------------

TapeError:
        cpi    2
        jz     TapeErrorIbg
        cpi    4
        jz     TapeBreakWithPop
        lxi    h, a_checksum
        call   PrintString
        call   PrintHexWord
        pop    b
        ret
ads
;----------------------------------------------------------------------------

TapeErrorSequence:
        lxi    h, a_sequence
        call   PrintString
        inx    b
        call   PrintHexWord
        pop    b
        ret

;----------------------------------------------------------------------------

TapeErrorIbg:
        lxi    h, a_ibg
        call   PrintString
        pop    b
        ret

;----------------------------------------------------------------------------

TapeBreakWithPop:
        pop    b
TapeBreak:
        lxi    h, a_break
        call   PrintString
        ret

;----------------------------------------------------------------------------

PrintHexWord:
        push   b
        mov    a, b
        call   PrintHexByte
        pop    b
        mov    a, c
        call   PrintHexByte
        ret

; ---------------------------------------------------------------------------

a_no_start_record: .db "NO START RECORD", 0
a_checksum:        .db "CHECKSUM ", 0
a_sequence:        .db "SEQUENCE ", 0
a_ibg:             .db "IBG", 0
a_break:           .db "BREAK", 0

