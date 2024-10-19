; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Ожидание паузы между блоками данных на магнитной ленте
; Вход: а - сколько тактов должна длиться тишина

TapeWaitPause:
        ; Выход, если начальное значение счетчик равно нулю
        ora    a
        rz

        ; Функция сохраняет DE
        push   d

        ; Перемещаем начальное значение счетчика в B
        mov    b, a
loc_FD5C:
        ; Инициализация счетчика
        mov    c, b

        ; Сохранение уровеня на входе с магнитофона в E
        in     PORT_TAPE_IN
        ani    4
        mov    e, a

loc_FD62:
        ; Перезапуск таймера
        mvi    a, 36h
        out    PORT_TIMER_CONTROL
        xra    a
        out    PORT_TIMER_0
        mvi    a, 12
        out    PORT_TIMER_0

loc_FD6D:
#ifdef KEY_DRIVER_TERMINAL
          ; Выход, если нажата клавиша на клавиатуре
          in     PORT_INT
          ani    2
          jnz    loc_FD8D
#endif
          ; Если сработал таймер, то уменьшаем счетчик.
          ; Если счетчик достиг нуля, то выходим, иначе
          ; перезапускаем таймер и продолжаем
          in     PORT_INT
          ani    10h
          jz     loc_FD86

          ; Считаем сначала, Если уровень на входе с магнитофона изменился
          in     PORT_TAPE_IN
          ani    4
          cmp    e
          jnz    loc_FD5C
        jmp    loc_FD6D

;----------------------------------------------------------------------------

loc_FD86:
        dcr    c
        jnz    loc_FD62

        xra    a  ; Отсутствие ошибки
        pop    d
        ret

;----------------------------------------------------------------------------

#ifdef KEY_DRIVER_TERMINAL
loc_FD8D:
        call   KeyRead
        mov    c, a  ; Код нажатой клавиши
        mvi    a, 4  ; Код ошибки
        pop    d
        ret
#endif
