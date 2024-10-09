; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Записать 128 байтный сектор на RAM-диск
; Вход: de - номер сектора, hl - адрес буфера
; Выход: a - код ошибки, de - сохраняется, hl - сохраняется

RamDiskWrite2:
        ; Проверка номера сектора на максимальное значение
        ; Нужно для работы с ПЗУ. Выдаст ошибку при попытке записи в ПЗУ.
#ifdef CONFIG_RAMDISK_FIX_512K
        mvi    a, ((RAM_DISK_SIZE_KB) / 32) - 1
        cmp    d
        mvi    a, 2  ; TODO: Не работает
        rc
#endif
        ; Функция сохраняет HL и DE
        push    h
        push    d

        ; Вычисление номера страницы ДОЗУ в B
        mov    a, d
#ifndef CONFIG_RAMDISK_FIX_512K
        ani    7  ; Эта проверка не даст использовать 512 кБ ОЗУ
#endif
        adi    RAM_DISK_FIRST_PAGE
#ifndef CONFIG_OPTIMIZE_RAMDISK
        ori    0  ; Мертвый код
#endif
        mov    b, a

        ; Вычисление смещения в DE
        xra    a
        mov    a, e
        rar
        mov    d, a
        mvi    a, 0
        rar
        mov    e, a

        ; Копирование из ДОЗУ в ОЗУ
loc_FB7F:
#ifndef CONFIG_OPTIMIZE_RAMDISK
         mvi    a, 0
         out    PORT_MAPPER
#endif
         mov    c, m

         mov    a, b
         out    PORT_MAPPER

         mov    a, c
         stax   d

#ifdef CONFIG_OPTIMIZE_RAMDISK
         xra a
         out    PORT_MAPPER
#endif
         inx    h
         inx    d
         mov    a, e
         add    a
        jnz    loc_FB7F ; Пока E не равно 0 или 128.

#ifndef CONFIG_OPTIMIZE_RAMDISK
        mvi    a, 0
        out    PORT_MAPPER
#endif
        ; Функция сохраняет HL и DE
        pop    d
        pop    h
        ret
