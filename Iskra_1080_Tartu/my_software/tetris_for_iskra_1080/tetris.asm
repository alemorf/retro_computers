; 2-04-2018 Aleksey Morozov aka Alemorf
; aleksey.f.morozov@gmail.com

; TETRIS WAS INVENTED BY A 30-YEAR-OLD SOVIET RESEARCHER NAMED ALEXEY PAZHITNOV
; WHO CURRENTLY WORKS AT THE COMPUTER CENTRE(ACADEMY SOFT) OF THE USSR ACADEMY
; OF SCIENCES IN MOSCOW. THE ORIGINAL PROGRAMMER WAS 18-YO VADIM GERASIMOV. A
; STUDENT STUDYING COMPUTER INFORMATICS AT MOSCOW UNIVERSITY. NOW YOU CAN ENJOY
; TETRIS BECAUSE OF THE JOINT EFFORTS OF ACADEMY SOFT, MOSCOW, ANDROMEDA
; SOFTWARE LTD, LONDON, ALEMORF, SPB AND SPECTRUM HOLOBYTE, USA.

; VERSION            PROGRAMMER
; ISKRA 1080 TARTU   ALEKSEY MOROZOV
; IBM CGA            ENG AN JIO
; RAM RESIDENT       ERICK JAP
; TANDY              BILLY SUTYONO
; IBM EGA            ARYANTO WIDODO
; GRAPHICS           DAN GUERRA
; PRODUCT MANAGER    R. ANTON WIDJAJA
; PRODUCER           SEAN B. BARGER

; igrab - 1406, 592
; 

.i8080
.include "opcodes.inc"

; Карта памяти после загрузки
; 0100h - 8C00h Код игры
; 8С00h - 93FEh Сжатая заставка интро заехала в видеопамять
; 9000h - BFFFh (Видеопамять)
; C800h - C87Fh (Системные переменные)
; C880h - C900h (Стек)
; D000h - FFFFh (Видеопамять)

; Карта памяти после переноса
; 0003h - 00CAh Кеш игового поля (10x20), временное место хранения системных переменных (80h)
; 00CBh - 00FFh (Стек)
; 0100h - 8C00h Код игры
; 9000h - BFFFh (Видеопамять)
; С000h - C7FFh Сжатая заставка интро, изображения для игры
; C800h - C87Fh (Системные переменные)
; C880h - CFFFh Изображения для интро
; D000h - FFFFh (Видеопамять)

;----------------------------------------------------------------------------------------------------------------------

org 234
fileStart:
.db 4ch, 56h, 4fh, 56h, 2fh, 32h, 2eh, 30h, 2fh, 0d0h, "TETRIS"
.dw entry
.dw end1
.dw entry

;----------------------------------------------------------------------------------------------------------------------

entry:
    ; Инициализируем стек
    lxi sp, 100h

    ; Включение цвета
    out 0F8h
    out 0B9h

    ; Вступление
    call intro

    ; Что бы не было видно мусора с неинициализированного экрана
    xra  a
    sta  palette

    ; Игра
restartGame:
    call tetris

    ; Очистить прямоугольник
    lxi  h, OPCODE_MVI_M
    call copyImageTo
    lxi  h, 0FFFFh - 135 - (32 * 256)
    lxi  b, 18 * 256 + 30 ; width * 256 + height
    lxi  d, 0
    call copyImage

    ; Выводим надпись "GAME OVER"
    mvi  a, 2
    call setTextColor
    lxi  h, gameOverText
    call drawText

    ; Ждем нажатия Enter
entry_1:
    call rand
    call inkey_FC12
    cpi  13
    jnz  entry_1

    ;
    jmp  restartGame

;----------------------------------------------------------------------------------------------------------------------

gameOverText:
    db 9,20,"GAME OVER",0

;----------------------------------------------------------------------------------------------------------------------

pressAnyKey:
    ; Ждем пока пользователь отпустит клавишу
pressAnyKey_1:
    call inkey_FC12
    cpi  0FFh
    jnz  pressAnyKey_1
pressAnyKey_2:
    call rand
    call inkey_FC12
    cpi  0FFh
    jz   pressAnyKey_2
    ret

;----------------------------------------------------------------------------------------------------------------------

.include "fn.inc"
.include "text.inc"
.include "tetris.inc"
.include "bios.inc"
.include "graph.inc"
.include "playfieldgraph.inc"
.include "rand.inc"
.include "unmlz.inc"

;----------------------------------------------------------------------------------------------------------------------

LEVELS_COUNT = 6

levels dw level1
       db PALETTE_WHITE, PALETTE_RED, PALETTE_CYAN
       dw level2
       db PALETTE_WHITE, PALETTE_MAGENTA, PALETTE_CYAN
       dw level3
       db PALETTE_WHITE, PALETTE_RED, PALETTE_GREEN
       dw level4
       db PALETTE_WHITE, PALETTE_RED, PALETTE_CYAN
       dw level5
       db PALETTE_WHITE, PALETTE_RED, PALETTE_CYAN
       dw level6
       db PALETTE_RED, PALETTE_RED, PALETTE_CYAN

level1:
.include "graph/level1.inc"
level2:
.include "graph/level2.inc"
level3:
.include "graph/level3.inc"
level4:
.include "graph/level4.inc"
level5:
.include "graph/level5.inc"
level6:
.include "graph/level6.inc"
font:
.include "graph/font.inc"

;----------------------------------------------------------------------------------------------------------------------

.include "intro.inc"
plane:
.include "graph/plane.inc"
igrab:
.include "graph/igrab.inc"
packedLogo:
.include "graph/logo.inc"
plane_end:

;----------------------------------------------------------------------------------------------------------------------

end1:
make_binary_file "tetris.lvt", fileStart, end1
.end
