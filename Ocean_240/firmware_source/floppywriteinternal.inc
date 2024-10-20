; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Отправка команды в К1818ВГ93, отправка блока данных в К1818ВГ93
; Вход: c - код команды, hl - буфер
; Выход: a - код ошибки, cf - если была ошибка

FloppyWriteInternal:
        ; Передача кода команды в К1818ВГ93
        mov    a, c
        out    PORT_VG93_COMMAND

        ; Цикл отправки данных в К1818ВГ93
loc_FF29: ; Остановка процессора до появления сигналов INTRQ или DRQ от К1818ВГ93
          in     PORT_FLOPPY_WAIT
          rrc

          ; Передача байта в К1818ВГ93
          mov    a, m
          out    PORT_VG93_DATA
          inx    h

          ; Цикл длится, пока нет INTRQ от контроллера
        jc     loc_FF29

        ; Получение кода ошибки от К1818ВГ93 и выход
#ifndef CONFIG_FLOPPY_SIZE_OPTIMIZATION
        call   FloppyCheckError
        ret
#else
        jmp    FloppyCheckError
#endif
