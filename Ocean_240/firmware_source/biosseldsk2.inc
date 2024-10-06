; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция CP/M BIOS

BiosSelDsk2:
        ; Выход с HL=0, если такого диска нет
        lxi    h, 0
        mov    a, c
        cpi    DISK_COUNT
        rnc

        ; Изменение диска
        sta    v_disk

        ; Если это реальный дисковод
        ora    a
        jz     loc_D79B
          ; 0 бит регистра Е установлен если этот диск уже был
          ; выбран со времени последнего сброса дисковой системы.
          mov    a, e
          ani    1
          jnz    loc_D79B
            ; Заставляем перечитывать дискету.
            sta    v_slicer_has_data
            sta    v_slicer_uninited_count
loc_D79B:

        ; Вычисление адреса DPH
        mov    l, c
        mvi    h, 0
        dad    h
        dad    h
        dad    h
        dad    h
        lxi    d, v_dph
        dad    d
        ret
