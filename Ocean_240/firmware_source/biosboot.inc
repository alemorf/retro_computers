; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Функция CP/M BIOS: Холодная перезагрузка

BiosBoot2:
        ; Если по смещению 6 находится адрес входа в CCP, то не очишаем RAM-диск
        lhld   6
        lxi    d, -0BA06h
        dad    d
        mov    a, h
        ora    l
        jz     BiosWBoot3

        ; Если по смещению 40h находится константа MAGIC_40, то не очишаем RAM-диск
        lhld   40h
        lxi    d, -MAGIC_40
        dad    d
        mov    a, h
        ora    l
        jz     BiosWBoot3

        ; Очистка RAM-диска

.include "ramdiskinit.inc"

        ; Выбора диска A:
        xra    a
        sta    v_current_disk

        ; Инициализация области памяти 40h
        call   InitBiosWorkArea

BiosWBoot3:
        ; Стек по умолчанию
        lxi    sp, 100h

        ; Инициализация видео и вывод приветствия
        lxi    h, a_hello
        call   PrintString2

        ; Переход в командный процессор
        jmp    BiosWBoot2

;----------------------------------------------------------------------------

InitBiosWorkArea:
        ; Инициализация области памяти 40h
        lxi    h, 40h
        lxi    d, rom_40
        mvi    c, 13
        call   MemcpyHlDeC

        ; Переменная содержащая кол-во дорожек на дисководе C:
        lda    cfg_disk_c_tracks
        sta    v_disk_1_tracks
        ret
