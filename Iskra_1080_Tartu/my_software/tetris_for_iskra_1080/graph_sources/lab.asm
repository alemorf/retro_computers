; Заголовок LVT файла. Это надо для загрузки в эмулятор

.org 234
.db 4ch, 56h, 4fh, 56h, 2fh, 32h, 2eh, 30h, 2fh, 0d0h, 6ch, 61h, 62h, 20h, 20h, 20h
.dw entry
.dw end
.dw entry

; Используемые точки входа в ПЗУ (BIOS)

setCursorY_F7DC   = 0F7DCh
setCursorX_F7BE   = 0F7BEh
printString_F137  = 0F137h
waitKey_FDAC      = 0FDACh
drawChar1_F7FB    = 0F7FBh
drawChar2_F8B0    = 0F8B0h
cursorUp_FA93     = 0FA93h
cursorDown_FA9A   = 0FA9Ah
cursorLeft_FAB3   = 0FAB3h
cursorRight_FACE  = 0FACEh
clearScreen1_F9A0 = 0F9A0h
drawText_F12F     = 0F12Fh
inkey_FC12        = 0FC12h
inkey_FB94        = 0FB94h

; Переменные BIOS

videoMode_C802    = 0C802h
fontType_C803     = 0C803h
cursorX_C807      = 0C807h
cursorY_C808      = 0C808h
cursorAddr_C80A   = 0C80Ah
font_C819         = 0C819h

; Точка входа

entry:
        ; Это похоже на место для отладочной команды JMP
;        nop
;        nop
;        nop
        
        ; Сброс    рекордов. Переменную bestScore сбрасывать не обязательно, 
        ; она будет перезаписана ниже.
;        lxi  h, 0
;        shld bestScore   ; 
;        shld bestScoreForLevel1;
;        shld bestScoreForLevel2
;        shld bestScoreForLevel3
        
        ; Инициализация стека
        lxi  sp, 0100h
        
        ; Установка палитры для каждого из 4-х цветов.
        mvi  a, 15 ; black
        out  90h
        mvi  a, 3 ; red
        out  91h
        mvi  a, 4 ; cyan
        out  92h
        mvi  a, 0 ; white
        out  93h

        lxi d, img
        lxi b, 09000h
        call unmlz

        lxi h, 0FFFFh
        lxi d, 0EFFFh
        lxi b, 03000h
        call copy
        jmp $

;------------------------

copy:
        ldax d
        mov m, a
        dcx d
        dcx h
        dcx b
        mov a, c
        ora b
        jnz copy
        ret

.include "unmlz.inc"

img:

.include "test2.h"

.db 1,2,3

end:

.end entry
