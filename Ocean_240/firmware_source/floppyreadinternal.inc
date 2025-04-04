; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Отправка команды в К1818ВГ93, получение блока данных из К1818ВГ93
; Вход: c - код команды для К1818ВГ93, hl - буфер
; Выход: a - код ошибки, nz или cf - если была ошибка

FloppyReadInteral:
        ; Передача кода команды в К1818ВГ93
        mov    a, c
        out    PORT_VG93_COMMAND

        ; Цикл получения данных от К1818ВГ93
        jmp    loc_FF3F
loc_FF3D: ; Сохранение байта в память
          mov    m, a
          inx    h

loc_FF3F: ; Остановка процессора до появления сигналов INTRQ или DRQ от К1818ВГ93
          in     PORT_FLOPPY_WAIT
          rrc

          ; Получение байта прочитанного с дискеты в регистр A
          in     PORT_VG93_DATA

          ; Цикл длится, пока нет INTRQ от контроллера
        jc     loc_FF3D

        ; Получение кода ошибки от К1818ВГ93 и выход
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        call   FloppyCheckError
        ret
#else
        jmp    FloppyCheckError
#endif
