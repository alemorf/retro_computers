; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функции CP/M BIOS

BiosHome2:
        lda    v_disk
        ora    a
        jz     loc_D7B8
          ; Если выбран реальный дисковод и буфер слайсера не нужно
          ; сохранять, то заставляем перечитывать дискету.
          lda    v_slicer_need_save
          ora    a
          jnz    loc_D7B8
            sta    v_slicer_has_data
loc_D7B8:
        mvi    c, 0

BiosSetTrk2:
        lxi    h, v_track
        mov    m, c
        ret
