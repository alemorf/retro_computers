; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Прочитать 128 байтный сектор с RAM-диска
; Вход: de - номер сектора, hl - адрес буфера
; Выход: a - код ошибки, de - сохраняется, hl - сохраняется

#define RAM_DISK_FIRST_PAGE 2

RamDiskRead2:
        ; Функция сохраняет HL и DE
        push   h
        push   d

#ifdef CONFIG_ROM_DISK
        ; Младшие страницы это ОЗУ. Размер страницы 32 кБ.
        mov    a, d
        sui    (RAM_DISK_SIZE_KB) / 32
        jc     RamDiskRead3
        mov    d, a

        ; Вычисление кода для маппера в B и адреса в памяти в DE
        ;    D        E           B        D         E
        ; 76543210 76543210 -> 76543210 76543210 76543210
        ;       BA страница -> Aс       11траниц а
        mov    a, d
        rar
        mov    a, e
        rar
        mov    d, a
        mvi    a, 0
        rar
        mov    e, a
        mov    a, d
        ani    0C0h
        adi    040h
        mov    b, a
        mov    a, d
        ori    0C0h
        mov    d, a

        ; Запись программы чтения ПЗУ в ОЗУ
        push   h
        lxi    h, 0C1D3h          ; D3 C1  out PORT_MAPPER
        shld   v_buffer_128
        lxi    h, 0AF4Eh          ; 4E     mov c, m
        shld   v_buffer_128 + 2   ; AF     xra a
        lxi    h, 0C1D3h          ; D3 C1  out PORT_MAPPER
        shld   v_buffer_128 + 4
        mvi    a, 0C9h            ; C9     ret
        sta    v_buffer_128 + 6
        pop    h

        ; Копирование из других страниц ПЗУ в ОЗУ
        xchg
loc_FB50: mov    a, b
          call   v_buffer_128
          mov    a, c
          stax   d
          inx    h
          inx    d
          mov    a, l
          add    a
        jnz    loc_FB50 ; Пока L не равно 0 или 128

        jmp    RamDiskReadExit
RamDiskRead3:
#endif

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

        ; Копирование из ОЗУ в ДОЗУ
loc_FB55: mov    a, b
          out    PORT_MAPPER
          ldax   d
          mov    c, a
#ifndef CONFIG_OPTIMIZE_RAMDISK
          mvi    a, 0
#else
          xra    a
#endif
          out    PORT_MAPPER
          mov    m, c
          inx    h
          inx    d
          mov    a, e
          add    a
        jnz    loc_FB55 ; Пока E не равно 0 или 128

RamDiskReadExit:
#ifndef CONFIG_OPTIMIZE_RAMDISK
        mvi    a, 0          ; Мертвый код
        out    PORT_MAPPER   ; Мертвый код
#endif
        pop    d
        pop    h
        ret
