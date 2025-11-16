; Floppy disk format utility for Micro 80
; Version 0.1
; Copyright (c) 2024-2025 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

; Порты ввода-вывода

PORT_ROM = 0FFh
PORT_ROM__ENABLE_ROM = 0
PORT_ROM__FLOPPY_B = 1 << 0
PORT_ROM__FLOPPY_SIDE = 1 << 1
PORT_ROM__ENABLE_RAM = 1 << 2
PORT_ROM__ROM_A15 = 1 << 3

PORT_VG93_COMMAND = 0E0h
PORT_VG93_TRACK   = 0E1h
PORT_VG93_SECTOR  = 0E2h
PORT_VG93_DATA    = 0E3h
PORT_FLOPPY_MOTOR = 0F8h
PORT_FLOPPY_WAIT  = 0ECh

; Адреса операционной системы и BIOS

vCommandLine  = 080h
PrintHexByte  = 0F815h
CheckKeyboard = 0F812h
ReadKeyboard  = 0F803h
PrintChar     = 0F809h

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
        mvi  b, PORT_ROM__ENABLE_RAM
        jz   l02
        cpi  'C'
        mvi  b, PORT_ROM__ENABLE_RAM | PORT_ROM__FLOPPY_B
        jnz  PrintString ; Вывод справки на экран и выход
l02:    mov  a, b
        sta  vRomPort

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
;TODO:        lxi  h, 0
;TODO:        shld vFloppyInited

        ; Выбор дисковода и перезапуск таймера двигателя
        lda  vRomPort
        out  PORT_ROM
        out  PORT_FLOPPY_MOTOR

        ; Ожидаение готовности дисковода или остановки двигателя по таймауту
        call WaitFloppy

        ; Перемещение головки на нулевую дорожку
        xra   a
        out   PORT_VG93_COMMAND
        call  WaitFloppy
;TODO:        in    PORT_VG93_COMMAND
;TODO:        ani   5 ; Биты готовности дисковода и нулевой дорожки
;TODO:        cpi   4 ; Бит нулевой дорожки
;TODO:        jnz   l07

        ; Цикл дорожек
        xra  a
        sta  vTrack
        jmp  trackLoopEntry

trackLoop:
        ; Передача команды перехода на следующую дорожку
        mvi  a, 58h
        out  PORT_VG93_COMMAND
        call  WaitFloppy
        ; TODO: Проверить код ошибки

trackLoopEntry:
        ; Выбор стороны диска и перезапуск таймера двигателя
        lda  vRomPort
        out  PORT_ROM
        out  PORT_FLOPPY_MOTOR

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

        ; Форматирование дорожки. Если произошла ошибка, то возвращается флаг NZ.
        call FormatTrack

        ; Вывод текста ошибки на экран
        ora  a
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
        
WaitFloppy:        
        lxi  h, 0 ; Счетчик таймаута
l06: 	  in   PORT_VG93_COMMAND
	  ani  81h  ; Not ready and Busy
	  rz
          dcx  h
	  mov  a, h
	  ora  l
	jnz  l06 
        lxi  d, aDriveNotReady
	call PrintString
	jp   0

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
        lda  vRomPort
        jz   l08
          ori  PORT_ROM__FLOPPY_SIDE
l08:    out  PORT_ROM
        out  PORT_FLOPPY_MOTOR

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
WriteTrack:        
          in   PORT_FLOPPY_WAIT  ; 10
          mov  a, m              ; 7
          out  PORT_VG93_DATA    ; 10
          inx  h                 ; 5
          in   PORT_VG93_COMMAND ; 10
          rrc                    ; 4
        jc   WriteTrack          ; 10  ; 10 + 7 + 10 + 5 + 10 + 4 + 10 = 56
		
        call WaitFloppy
        in   PORT_VG93_COMMAND
        ani  ~30h ; "Массив не найден", "Тип записи" это нормально
        rnz

        ; Чтение дорожки
        mvi  a, 1
        out  PORT_VG93_SECTOR
        mvi  a, 094h ; TODO: Стороны
        out  PORT_VG93_COMMAND
        lxi  h, (SECTOR_COUNT * SECTOR_SIZE_BYTES) + 1 ; Это еще и задержка
ReadTrack:
          in   PORT_FLOPPY_WAIT
          in   PORT_VG93_DATA
          dcx  h
          in   PORT_VG93_COMMAND
          rrc
        jc   ReadTrack
        
        call WaitFloppy
        in   PORT_VG93_COMMAND
        ani  ~30h ; "Массив не найден", "Тип записи" это нормально
        rnz

        ; Если все сектора удалось прочитать, то выход c кодом ошибки 0
        mov  a, h
        ora  l
        rz

        ; Выход с кодом ошибки 8
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
vRomPort:        .db 0
vBuffer:

        .end
