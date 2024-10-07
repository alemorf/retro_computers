; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Установить период и длительность стандартного звуковгой сигнала
; Вход: v_arg_0 - период, v_arg_1 - длительность

BeepSet:
        lxi    d, v_arg_0
        ldax   d
        mov    h, a
        inx    d
        ldax   d
        mov    l, a
        shld   v_beep_period
        inx    d
        ldax   d
        mov    h, a
        inx    d
        ldax   d
        mov    l, a
        shld   v_beep_duration
        ret
