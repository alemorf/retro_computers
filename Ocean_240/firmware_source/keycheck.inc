; ПЗУ Океан 240.2 REV 8 / Реверсинжиниринг aleksey.f.morozov@gmail.com / Лицензия GPL
; Проверка наличия данных в буфере клавиатуры
; Выход: a = 0 если буфер клавиатуры пуст.

KeyCheck:
        in    PORT_INT

#ifndef NO_DEAD_CODE
        nop
#endif

        ani   KEY_INT_MASK

#ifndef NO_DEAD_CODE
        mvi   a, 0
#endif

        rz
        cma
        ret

;----------------------------------------------------------------------------
; Переход по нажатию клавиши

; in     PORT_INT
; ani    KEY_INT_MASK
; jnz    LABEL

#define JUMP_IF_KEYBOARD(LABEL) .db 0DBh, PORT_INT, 0E6h, KEY_INT_MASK, 0C2h, (LABEL) & 0FFh, (LABEL) >> 8
