; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Отправка команды в К1818ВГ93, отправка блока данных в К1818ВГ93
; Вход: c - код команды, hl - буфер
; Выход: a - код ошибки, cf - если была ошибка

FloppyWriteInternal:
        ; Отправка команды в К1818ВГ93
        mov    a, c
        out    PORT_VG93_COMMAND

loc_FF29: ; Остановка процессора до появления сигналов INTRQ или DRQ
          ; на выводах К1818ВГ93 или таймаута
          in     PORT_FLOPPY_WAIT
          rrc

          ; Передача данных в К1818ВГ93
          mov    a, m
          out    PORT_VG93_DATA
          inx    h

          ; Цикл длится, пока нет INTRQ от контроллера
        jc     loc_FF29

        ; Возврат кода ошибки
        call   FloppyCheckError
        ret

