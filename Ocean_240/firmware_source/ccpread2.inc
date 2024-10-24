; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Новая функция READ для CCP (продолжение)

loc_DEAD:
        ; ?
        lxi    d, v_ccp_command_line_buffer - 1
        call   ccp_ram_B200 + 0EFh
        jmp    ccp_ram_B200 + 5FBh

