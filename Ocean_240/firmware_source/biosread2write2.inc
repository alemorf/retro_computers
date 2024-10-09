; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функции CP/M BIOS

;----------------------------------------------------------------------------
; Прочитать 128 байтный сектор с диска
; Вход: v_disk, v_track, v_sector, v_dma
; Выход: a - код ошибки

BiosRead2:
        ; Для физических дисководов используется другая функция
        lda    v_disk
        ora    a
#ifndef CONFIG_OPTIMIZE_SLICER_CALL
        jnz    BiosRead3
#else
        jnz    SlicerRead
#endif
        ; DE = v_track * 16 + v_sector_128, HL = v_dma
        call   CalcRamDiskAddress

        ; Прочитать с RAM-диска
#ifndef CONFIG_FIX_RAMDISK
        call   RamDiskRead
        xra    a
        ret
#else
        jmp    RamDiskRead
#endif

;----------------------------------------------------------------------------
; Записать 128 байтный сектор на диск
; Вход: v_disk, v_track, v_sector, v_dma
; Выход: a - код ошибки

BiosWrite2:
        ; Для физических дисководов используется другая функция
        lda    v_disk
        ora    a
#ifndef CONFIG_OPTIMIZE_SLICER_CALL
        jnz    BiosWrite3
#else
        jnz    SlicerWrite
#endif
        ; DE = v_track * 16 + v_sector_128, HL = v_dma
        call   CalcRamDiskAddress

        ; Записать на RAM-диск
#ifndef CONFIG_FIX_RAMDISK
        call   RamDiskWrite
        xra    a
        ret
#else
        jmp    RamDiskWrite
#endif

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

#ifndef CONFIG_OPTIMIZE_SLICER_CALL
BiosRead3:
        call    SlicerRead
        ret
#endif

;----------------------------------------------------------------------------

#ifndef CONFIG_OPTIMIZE_SLICER_CALL
BiosWrite3:
        call    SlicerWrite
        ret
#endif
