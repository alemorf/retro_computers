; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функции CP/M BIOS

BiosRead2:
        ; Для физических дисководов используется другая функция
        lda    v_disk
        ora    a
        jnz    BiosRead3

        ; DE = v_track * 16 + v_sector_128, HL = v_dma
        call   CalcRamDiskAddress

        ; Скопировать из DE в HL
        call   ReadRamDisk

        ; Нет ошибки
        xra    a
        ret

;----------------------------------------------------------------------------

BiosWrite2:
        ; Для физических дисководов используется другая функция
        lda    v_disk
        ora    a
        jnz    BiosWrite3

        ; DE = v_track * 16 + v_sector_128, HL = v_dma
        call   CalcRamDiskAddress

        ; Скопировать из DE в HL
        call   WriteRamDisk

        ; Нет ошибки
        xra    a
        ret

;----------------------------------------------------------------------------
; DE = v_track * 16 + v_sector_128, HL = v_dma

CalcRamDiskAddress:
        ; hl = v_track * 16
        lxi    h, v_track
        mov    l, m
        mvi    h, 0
        dad    h
        dad    h
        dad    h
        dad    h
        xchg

        ; de = hl + v_sector_128
        lxi    h, v_sector_128
        mov    l, m
        mvi    h, 0
        dad    d
        xchg

        ; hl = v_dma
        lhld   v_dma
        ret

;----------------------------------------------------------------------------

BiosRead3:
        call    SlicerRead
        ret

;----------------------------------------------------------------------------

BiosWrite3:
        call    SlicerWrite
        ret
