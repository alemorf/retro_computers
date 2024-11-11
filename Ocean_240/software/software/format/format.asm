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

; Биты PORT_FLOPPY на чтение. Все сдвинуто вправо на 1 бит.

PFE_READ_MASK    = PFE_SIDE_SELECT | PFE_MOTOR_0 | PFE_MOTOR_1 | PFE_DRIVE_SELECT

; Порты ввода-вывода

PORT_VG93_COMMAND = 20h
PORT_VG93_TRACK   = 21h
PORT_VG93_SECTOR  = 22h
PORT_VG93_DATA    = 23h
PORT_FLOPPY_WAIT  = 24h
PORT_FLOPPY       = 25h

; Адреса операционной системы и BIOS

CommandLine        = 080h
PrintHexByte       = 0E003h
CheckKeyboard      = 0E006h
ReadKeyboard       = 0E009h
PrintChar          = 0E00Ch
vFloppyInited      = 0BFEFh

; Параметры дискеты

SECTOR_COUNT      = 9
SECTOR_SIZE_CODE  = 2
SECTOR_SIZE_BYTES = 512
TRACK_COUNT       = 80

        .org 100h

main:   ; Вывод текста при выходе из программы. В de должна быть строка.
        lxi  d, PrintString
        push d

        ; В коммандной строк должно быть 2 символа
        lda  CommandLine
        cpi  2
        lxi  d, aUsage
        rnz

        ; Первый символ: пробел
        lda  CommandLine + 1
        cpi  ' '
        rnz

        ; Второй символ: B или C
        lda  CommandLine + 2
        sta  aFormatYND ; Для вывода на экран
        cpi  'B'
        mvi  c, PFE_MOTOR_0 | PFE_DRIVE_SELECT
        jz   l5
        cpi  'C'
        mvi  c, PFE_MOTOR_1
        rnz
l5:     mov  a, c
        sta  vFloppyPort

        ; Опустошение буфера клавиатуры
l0:       call CheckKeyboard
          ora  a
          jz   l1
          call ReadKeyboard
        jmp  l0
l1:
        ; Подтверждение перед форматированием
        lxi  d, aFormatYN
        call PrintString
        call ReadKeyboard
        lxi  d, aEol
        cpi  'y'
        jz   l2
        cpi  'Y'
        rnz
l2:     call PrintString

        ; Сброс состояния BIOS
        lxi  h, 0
        shld vFloppyInited

        ; Выбор дисковода и запуск двигателя
        lda  vFloppyPort
        out  PORT_FLOPPY
        ori  PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Ожидаение готовности дисковода или остановки двигателя по таймауту
        lxi  d, aDriveError
l4:       in   PORT_FLOPPY
          rlc
          rc  ; Тут de = aDriveError
          in   PORT_VG93_COMMAND
          ani  80h ; Ready
        jnz  l4

        ; Перемещение головки на нулевую дорожку
        xra    a
        out    PORT_VG93_COMMAND

        ; Задержка
        nop
        nop

        ; Ожидание пока КР1818ВГ93 занят или не выбрана нулевая дорожка или не наступил таймаут
l3:       in     PORT_FLOPPY
          rlc
          rc ; Тут de = aDriveError
          in     PORT_VG93_COMMAND
          ani    5
          cpi    4
        jnz    l3

        ; На всякий случай
        xra  a
        out  PORT_VG93_TRACK

        ; Цикл дорожек
        xra  a
        sta  vTrack
trackLoop:
        ; Выбор стороны и перезапуск таймера
        lda  vFloppyPort
        out  PORT_FLOPPY
        ori  PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Запись дорожки
        mvi  c, 0 ; Сторона
        call MakeTrack
        call FloppyWriteTrack
        call FloppyReadTrack

        ; Выбор стороны и перезапуск таймера
        lda  vFloppyPort
        out  PORT_FLOPPY
        ori  PFE_SIDE_SELECT | PFE_NEG_INIT
        out  PORT_FLOPPY

        ; Запись дорожки на другой стороне
        mvi  c, 1 ; Сторона
        call MakeTrack
        call FloppyWriteTrack
        call FloppyReadTrack

        ; Остановка с клавиатуры
        call CheckKeyboard
        ora  a
        cnz  ReadKeyboard
        cpi  3 ; CTRL+C
        lxi  d, aBreak
        rz
        cpi  1Bh ; ESC
        rz

        ; Выход, если это была последняя дорожка
        lda  vTrack
        inr  a
        sta  vTrack
        cpi  TRACK_COUNT  ; TODO: В систему может быть установлен 40 дорочный дисковод
        lxi  d, aDone
        rnc

        ; Передаем контроллеру команду перейти на следующую дорожку
        mvi  a, 58h
        out  PORT_VG93_COMMAND
        ; Задержка
        nop
        nop
        ; Остановка процессора до запроса прерывания от К1818ВГ93 или таймаута
        in   PORT_FLOPPY_WAIT  ; TODO: Проверить 0-ой бит

        jmp trackLoop

;-------------------------------------------------------------------------------
; Подготовка данных для записи на дорожку. Удвоенная плотность.

MakeTrack:
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
          mov  m, c           ; Номер стороны
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

        mvi  c, 'F'

;-------------------------------------------------------------------------------

        ; Вывод информации
PrintInfo:
        push b
        lxi  d, aTrack
        call PrintString
        lda  vTrack
        call PrintNumber
        mvi  c, ' '
        call PrintChar
        pop  b
        jmp  PrintChar

;-------------------------------------------------------------------------------

MemsetHlED:
          mov  m, e
          inx  h
          dcr  d
        jnz MemsetHlED
        ret

;-------------------------------------------------------------------------------

PrintString:
        ldaX D
        ORA  A
	RZ
        MOV  C,A
        call PrintChar
        inx  D
        JMP  PrintString

;-------------------------------------------------------------------------------

PrintNumber:
        mov  d, a
        MVI  C, 0
        MVI  B, 8
DV2:	  MOV  A, D
          RLC
          MOV  D, A
          MOV  A, C
          ADC  C
          DAA
          MOV  C, A
          DCR  B
        JNZ  DV2
        JMP PrintHexByte

;-------------------------------------------------------------------------------

FloppyWriteTrack:
        lxi  h, vBuffer

        ; Передача кода команды "запись дорожки" в К1818ВГ93
        mvi   a, 0F4h
        out   PORT_VG93_COMMAND

        ; Задержка
        nop
        nop

        ; Цикл отправки данных в К1818ВГ93
loc_FF29: ; Остановка процессора до появления сигналов INTRQ или DRQ от К1818ВГ93
          in    PORT_FLOPPY_WAIT
          rrc

          ; Передача байта в К1818ВГ93
          mov   a, m
          out   PORT_VG93_DATA
          inx   h

          ; Цикл длится, пока нет INTRQ от контроллера
        jc    loc_FF29

        ; Проверка ошибки
        in   PORT_VG93_COMMAND
        jmp   FloppyCheckError

;-------------------------------------------------------------------------------

FloppyReadTrack:
        ; Вывод информации
        mvi  c, 'V'
        call PrintInfo

        ; Кол-во прочитанных байт
        lxi  h, (SECTOR_COUNT * SECTOR_SIZE_BYTES) + 1

        ; Передача кода команды в К1818ВГ93
        mvi  a, 1
        out  PORT_VG93_SECTOR
        mvi  a, 094h ; TODO: Стороны
        out  PORT_VG93_COMMAND

        ; Задержка
        nop
        nop

        ; Цикл получения данных от К1818ВГ93
loc_FF3D: ; Остановка процессора до появления сигналов INTRQ или DRQ от К1818ВГ93
          in    PORT_FLOPPY_WAIT
          rrc

          ; Получение байта прочитанного с дискеты
          in    PORT_VG93_DATA
          dcx   h

          ; Цикл пока нет INTRQ от контроллера
        jc     loc_FF3D

        ; Код ошибки
        in   PORT_VG93_COMMAND
        ani  ~30h ; "Массив не найден", "Тип записи" это нормально
        jnz  FloppyCheckError

        ; Все ли сектора удалось прочитать?
        mov  a, h
        ora  l
        rz

        ; BAD CRC
        mvi  a, 8

;-------------------------------------------------------------------------------

FloppyCheckError:
        ora  a
        rz

        push psw
        lxi  d, aEol
        call PrintString
        pop  psw

        lxi  d, PrintString
        push d

        CPI  8
        lxi  d, aBadCrc
        rz

        CPI  40h
        lxi  d, aWriteProtect
        rz

        CPI  80h
        lxi  d, aDriveError
        rz

        push psw
        lxi  d, aError
        call PrintString
        pop  psw
        call PrintHexByte
        lxi  d, aEol
        ret

;-------------------------------------------------------------------------------

aBadCrc:       .db "CRC ERROR\r\n", 0
aWriteProtect: .db "WRITE PROTECTED\r\n", 0
aDriveError:   .db "DRIVE NOT READY\r\n", 0
aError:        .db "ERROR ", 0
aUsage:        .db "USAGE: FORMAT B/C", 0
aFormatYN:     .db "DRIVE "
aFormatYND:    .db "?: WILL BE LOST!\r\n"
               .db "PROCEED WITH FORMAT (Y/N)?", 0
aEol:          .db "\r\n", 0
aTrack:        .db "\rTRACK ", 0
aDone:         .db "\rFORMAT COMPLETE\r", 0
aBreak:        .db "\r\nBREAK", 0

vTrack:        .db 0
vFloppyPort:   .db 0
vBuffer:

        .end
