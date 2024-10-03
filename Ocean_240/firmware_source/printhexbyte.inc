; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL

NibbleToChar:
        ani    0Fh
        adi    90h
        daa
        aci    40h
        daa
        mov    c, a
        ret

;----------------------------------------------------------------------------
; Напечатать две 16-ричные цифры (байт)
; Вход: a - число

PrintHexByte:
        push    psw
        rrc
        rrc
        rrc
        rrc
        call   PrintHexNibble
        pop    psw
PrintHexNibble:
        call   NibbleToChar
        call   PrintChar
        ret
