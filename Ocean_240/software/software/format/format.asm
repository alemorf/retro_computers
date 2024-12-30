; Floppy disk format utility for Ocean 240
; Version 0.1
; Copyright (c) 2024 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, version 3.
;
; This program is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <http://www.gnu.org/licenses/>.

; For compilation you can use:
; TASM Assembler.  Version 3.2 September, 2001. (C) 2001 Squak Valley Software

; Биты PORT_FLOPPY на запись

PFE_MOTOR_0      = 1 << 0
PFE_MOTOR_1      = 1 << 1
PFE_DRIVE_SELECT = 1 << 2
PFE_NEG_INIT     = 1 << 3
PFE_NEG_DDEN     = 1 << 4
PFE_SIDE_SELECT  = 1 << 5

; Биты PORT_FLOPPY на чтение. Все сдвинуто влево на 1 бит.

PFE_READ_MASK = PFE_SIDE_SELECT | PFE_MOTOR_0 | PFE_MOTOR_1 | PFE_DRIVE_SELECT

; Порты ввода-вывода

PORT_VG93_COMMAND = 20h
PORT_VG93_TRACK   = 21h
PORT_VG93_SECTOR  = 22h
PORT_VG93_DATA    = 23h
PORT_FLOPPY_WAIT  = 24h
PORT_FLOPPY       = 25h

; Адреса операционной системы и BIOS

vCommandLine  = 080h
vFloppyInited = 0BFEFh
PrintHexByte  = 0E003h
CheckKeyboard = 0E006h
ReadKeyboard  = 0E009h
PrintChar     = 0E00Ch

; Параметры дискеты

SECTOR_COUNT      = 9
SECTOR_SIZE_CODE  = 2
SECTOR_SIZE_BYTES = 128 << SECTOR_SIZE_CODE
TRACK_COUNT       = 80

;-------------------------------------------------------------------------------

        .org 100h

main:   ; Анализ командной строки
        lxi  h, vCommandLine
        mov  c, m
        inr  c  ; Кол-во символов в командной строке + 1
        inx  h  ; Адрес первого символа

        ; Пропуск пробелов
        lxi  d, aUsage
l00:     mov  a, m
         cpi  ' '
         jnz  l01
         inx  h
         dcr  c
         jz   PrintString ; Вывод справки на экран и выход
        jmp  l00
l01:

        ; Ожидается символ 'B' или 'C'
        dcr  c
        jz   PrintString
        mov  a, m
        sta  aFormatYND ; Для вывода на экран
        cpi  'B'
        mvi  b, PFE_MOTOR_0 | PFE_DRIVE_SELECT
        jz   l02
        cpi  'C'
        mvi  b, PFE_MOTOR_1
        jnz  PrintString ; Вывод справки на экран и выход
l02:     mov  a, b
        sta  vFloppyPort

        ; Выход и вывод справки, если есть еще символы
        dcr  c
        jnz  PrintString

        ; Опустошение буфера клавиатуры
l03:      call CheckKeyboard
          ora  a
          jz   l04
          call ReadKeyboard
        jmp  l03
l04:
        ; Подтверждение перед форматированием
        lxi  d, aFormatYN
        call PrintString
        call ReadKeyboard
        cpi  'y'
        jz   l05
        cpi  'Y'
        rnz
l05:
        ; Перевод строки и вывод размера диска
        lxi  d, aSize
        call PrintString

        ; Сброс BIOS, т.к. головка дисковода и настройки контроллера будут изменены
        lxi  h, 0
        shld vFloppyInited

        ; Выбор дисковода и перезапуск таймера двигателя
        lda  vFloppyPort
        out  PORT_FLOPPY
        ori  PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Ожидаение готовности дисковода или остановки двигателя по таймауту
        lxi  d, aDriveNotReady
l06:      in   PORT_FLOPPY
          rlc
          jc   PrintString ; Вывод ошибки на экран и выход
          in   PORT_VG93_COMMAND
          ani  80h ; Бит готовности дисковода
        jnz  l06

        ; Перемещение головки на нулевую дорожку
        xra   a
        out   PORT_VG93_COMMAND
        nop
        nop
l07:      in    PORT_FLOPPY
          rlc
          jc   PrintString ; Вывод ошибки на экран и выход
          in    PORT_VG93_COMMAND
          ani   5 ; Биты готовности дисковода и нулевой дорожки
          cpi   4 ; Бит нулевой дорожки
        jnz   l07

        ; На всякий случай
        xra  a
        out  PORT_VG93_TRACK

        ; Цикл дорожек
        xra  a
        sta  vTrack
        jmp  trackLoopEntry

trackLoop:
        ; Передача команды перехода на следующую дорожку
        mvi  a, 58h
        out  PORT_VG93_COMMAND
        nop
        nop
        in   PORT_FLOPPY_WAIT
        ; TODO: Проверить код ошибки

trackLoopEntry:
        ; Выбор стороны диска и перезапуск таймера двигателя
        lda  vFloppyPort
        out  PORT_FLOPPY
        ori  PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Цикл сторон
        xra  a
        sta  vSide
headLoop:
        ; Вывод информации на экран
        lda  vTrack
        call ToNumber
        shld aProgressTrack

        lda  vSide
        adi  '0'
        sta  aProgressHead

        lxi  d, aProgress
        call PrintString

        ; Остановка с клавиатуры
        call CheckKeyboard
        ora  a
        cnz  ReadKeyboard
        cpi  3 ; CTRL+C
        lxi  d, aBreak
        jz   PrintString
        cpi  1Bh ; ESC
        jz   PrintString

        ; Форматирование дорожки. Если произошла ошибка, то возвращается флаг NZ.
        call FormatTrack

        ; Вывод текста ошибки на экран
        cnz  FloppyCheckError

        ; Конец цикла сторон
        lda  vSide
        inr  a
        sta  vSide
        dcr  a
        jz   headLoop

        ; Конец цикла дорожек
        lda  vTrack
        inr  a
        sta  vTrack
        cpi  TRACK_COUNT  ; TODO: В систему может быть установлен 40 дорочный дисковод. Прочитать в настройках BIOS.
        jc   trackLoop

        ; Выход
        lxi  d, aDone
        jmp  PrintString

;-------------------------------------------------------------------------------

FloppyCheckError:
        mov  b, a
        ani  80h
        lxi  d, aDriveNotReady
        jnz  PrintStringEol

        mov  a, b
        ani  40h
        lxi  d, aWriteProtected
        jnz  PrintStringEol

        mov  a, b
        ani  8
        lxi  d, aBadSector
        jnz  PrintStringEol

        lxi  d, aError
        call PrintString

        mov  a, b
        call PrintHexByte

        jmp  PrintEol

;-------------------------------------------------------------------------------

PrintStringEol:
        call PrintString
PrintEol:
        lxi  d, aEol
PrintString:
        ldax d
        ora  a
        rz
        mov  c, a
        call PrintChar
        inx  d
        jmp  PrintString

;-------------------------------------------------------------------------------

ToNumber:
        mvi  l, '0' - 1
ToNumber_0:
          sui  10
          inr  l
        jnc  ToNumber_0
        adi  10 + '0'
        mov  h, a
        ret

;-------------------------------------------------------------------------------
; Форматирование дорожки

FormatTrack:
        ; Выбор стороны диска и перезапуск таймера двигателя
        lda  vSide
        ora  a
        lda  vFloppyPort
        jz   l08
          ori  PFE_SIDE_SELECT
l08:    out  PORT_FLOPPY
        ori  PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Подготовка данных для записи
        lxi  h, vBuffer
        lxi  d, 504Eh         ; Пробел после индексного импульса
        call MemsetHlED
        lxi  d, 0C00h
        call MemsetHlED
        lxi  d, 03F6h         ; Запись кода С2
        call MemsetHlED
        mvi  m, 0FCh          ; Индексная метка перед первым индексным массивом
        inx  h
        lxi  d, 324Eh         ; Пробел
        call MemsetHlED

        mvi  b, 1
MakeTrack_1:
          lxi  d, 0C00h
          call MemsetHlED
          lxi  d, 03F5h       ; Запись кода А1, начало вычисления контрольного кода
          call MemsetHlED
          mvi  m, 0FEh        ; Метка заголовка
          inx  h
          lda  vTrack
          mov  m, a           ; Номер дорожки
          inx  h
          lda  vSide
          mov  m, a           ; Номер стороны
          inx  h
          mov  m, b           ; Номер сектора
          inx  h
          mvi  m, SECTOR_SIZE_CODE  ; Длина сектора
          inx  h
          mvi  m, 0F7h        ; Запись двух байт контрольной суммы
          inx  h
          lxi  d, 164Eh       ; Пробел после заголовка
          call MemsetHlED
          lxi  d, 0C00h
          call MemsetHlED
          lxi  d, 03F5h       ; Запись А1, начало вычисления контрольного кода
          call MemsetHlED
          mvi  m, 0FBh        ; Адресная метка данных
          inx  h
          lxi  d, 00E5h       ; 512 байт данных
          call MemsetHlED
          call MemsetHlED
          mvi  m, 0F7h        ; Запись двух байт контрольной суммы
          inx  h
          lxi  d, 364Eh       ; Пробел перед следующим сектором
          call MemsetHlED

          ; Повторяем цикл для каждого сектора
          inr  b
          mov  a, b
          cpi  SECTOR_COUNT + 1
        jc  MakeTrack_1

        lxi  d, 0004Eh        ; Пробел в конце дорожки
        call MemsetHlED
        call MemsetHlED
        call MemsetHlED

        ; TODO: Вывести реальную длину

        ; Запись дорожки
        lxi  h, vBuffer
        mvi  a, 0F4h
        out  PORT_VG93_COMMAND
        nop
        nop
loc_FF29: in    PORT_FLOPPY_WAIT
          rrc
          mov  a, m
          out  PORT_VG93_DATA
          inx  h
        jc    loc_FF29
        in   PORT_VG93_COMMAND
        ani  ~30h ; "Массив не найден", "Тип записи" это нормально
        rnz

        ; Чтение дорожки
        lxi  h, (SECTOR_COUNT * SECTOR_SIZE_BYTES) + 1
        mvi  a, 1
        out  PORT_VG93_SECTOR
        mvi  a, 094h ; TODO: Стороны
        out  PORT_VG93_COMMAND
        nop
        nop
loc_FF3D: in   PORT_FLOPPY_WAIT
          rrc
          in   PORT_VG93_DATA
          dcx  h ; TODO: Остановиться
        jc     loc_FF3D
        in   PORT_VG93_COMMAND
        ani  ~30h ; "Массив не найден", "Тип записи" это нормально
        rnz

        ; Если все сектора удалось прочитать, то выход с флагом Z
        mov  a, h
        ora  l
        rz

        ; Выход с флагом NZ и кодом 8
        mvi  a, 8
        ret

;-------------------------------------------------------------------------------

MemsetHlED:
          mov  m, e
          inx  h
          dcr  d
        jnz MemsetHlED
        ret

;-------------------------------------------------------------------------------

aUsage:          .db "USAGE: FORMAT B/C", 0

aFormatYN:       .db "WARNING, ALL DATA ON DISK\r\n"
                 .db "DRIVE "
aFormatYND:      .db "?: WILL BE LOST!\r\n\r\n"
                 .db "PROCEED WITH FORMAT (Y/N)?", 0

aSize:           .db "\r\nFORMAT 720K\r\n", 0

aProgress:       .db "\rTRACK "
aProgressTrack:  .db "?? HEAD "
aProgressHead:   .db "? ", 0  ; Пробел в конце для вывода текста ошибки

aDone:           .db "\rFORMAT COMPLETE", 0

aBadSector:      .db "BAD SECTOR",0
aWriteProtected: .db "WRITE PROTECTED", 0
aDriveNotReady:  .db "DRIVE NOT READY", 0
aError:          .db "ERROR ", 0
aBreak:          .db "BREAK", 0

aEol:            .db "\r\n", 0

vTrack:          .db 0
vSide:           .db 0
vFloppyPort:     .db 0
vBuffer:

        .end
