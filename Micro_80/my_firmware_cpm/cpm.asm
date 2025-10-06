; Micro 80 CP/M BIOS
; Copyright (c) 2025 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
;
; ONLY THIS FILE!
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

BIOS_INIT = 0F836h
BIOS_INIT_SP = 0F800h
BIOS_REBOOT = 0F800h
BIOS_READ_KEY = 0F803h
BIOS_CHECK_KEY = 0F812h
BIOS_PRINT_CHAR = 0F809h

PORT_ROM = 0FFh
PORT_ROM__ENABLE_ROM = 0
PORT_ROM__FLOPPY_B = 1 << 0
PORT_ROM__FLOPPY_SIDE = 1 << 1
PORT_ROM__ENABLE_RAM = 1 << 2
PORT_ROM__ROM_A15 = 1 << 3

;----------------------------------------------------------------------------

    .org 0

cold_boot:
    ; Инициализация BIOS
    di
    ld   sp, BIOS_INIT_SP
    call BIOS_INIT

    ; По умолчанию накопитель A:
    ld   c, 0

warm_boot:
    ; Копирование CP/M из ПЗУ в ОЗУ
    ld   de, cpm_in_rom
    ld   hl, begin
copy_loop:
    ld   a, (de)
    inc  de
    ld   (hl), a
    inc  hl
    ld   a, h
    cp   (end >> 8) + 1
    jp   c, copy_loop

    ; Продолжение запуска в ОЗУ
    jp   boot

cpm_in_rom:

;----------------------------------------------------------------------------

    .org 0C400h
begin:

STORAGE_COUNT = 1

ROM_STORAGE_ADDRESS = 1C00h
ROM_STORAGE_SIZE = 10000h - ROM_STORAGE_ADDRESS

A_BLOCK_SIZE = 1024
A_DIRECTORY_BLOCKS = 1
A_BLOCK_COUNT = ROM_STORAGE_SIZE / A_BLOCK_SIZE

    .include "cpm22.inc"

;----------------------------------------------------------------------------

boot:
    ; Включение ОЗУ
    ld   a, PORT_ROM__ENABLE_RAM
    out  (PORT_ROM), a

    jp   RUNCPM

;----------------------------------------------------------------------------

BIOS_BOOT:
    ; Выключение прерываний
    di

    ; Включение ПЗУ
    ld   a, PORT_ROM__ENABLE_ROM
    out  (PORT_ROM), a

    ; Перезагрузка всего компьютера
    jp   cold_boot

;----------------------------------------------------------------------------

BIOS_WBOOT:
    ; Выключение прерываний
    di

    ; Сохранение выбранного диска
    ld   a, (TDRIVE)
    ld   c, a

    ; Включение ПЗУ
    ld   a, PORT_ROM__ENABLE_ROM
    out  (PORT_ROM), a

    ; Перезагрузка CP/M
    jp   warm_boot

;----------------------------------------------------------------------------

BIOS_CONST:
    jp   BIOS_CHECK_KEY

;----------------------------------------------------------------------------

BIOS_CONOUT:
    ; Кодировка ASCII -> Микро80
    push af
    ld   a, c
    cp   060h
    call nc, CODEPAGE
    ld   c, a
    pop  af
    jp   BIOS_PRINT_CHAR

;----------------------------------------------------------------------------

BIOS_CONIN:
    call BIOS_READ_KEY

    ; Кодировка ASCII -> Микро80
    cp   060h
    ret  c

;----------------------------------------------------------------------------

CODEPAGE:
    cp   7Fh
    jp   z, CODEPAGE_2
    jp   nc, CODEPAGE_1
    add  060h
    ret
CODEPAGE_1:
    cp   0C0h
    ret  c
    cp   0E0h
    ret  nc
    sub  060h
    ret
CODEPAGE_2:
    ld   a, 8
    ret

;----------------------------------------------------------------------------

BIOS_PRSTAT:
    xor  a ; Принтер не готов
    ret

;----------------------------------------------------------------------------

BIOS_LIST:
    ret ; Принтер

;----------------------------------------------------------------------------

BIOS_PUNCH:
    ret ; RS232

;----------------------------------------------------------------------------

BIOS_READER:
    ld  a, 26
    ret ; RS232

;----------------------------------------------------------------------------

BIOS_READ_512:
    ; Вычисление номера сектора
    ld   hl, (BUFFER_SECTOR)
    ld   de, ROM_STORAGE_ADDRESS / 512
    add  hl, de
    ld   b, l

    ; Выбор страницы ПЗУ
    add  hl, hl
    add  hl, hl
    ld   a, h
    add  a
    add  a
    add  a
    out  (PORT_ROM), a

    ; Вычисление адреса сектора в памяти
    ld   a, b
    and  3Fh
    add  a
    ld   h, a
    ld   l, 0

    ; Скопировать туда
    ld   de, BUFFER

    ; Копирование сектора из ПЗУ в ОЗУ
    ld   c, 0
BIOS_READ_1:
    ld   a, (hl)
    ld   (de), a
    inc  hl
    inc  de
    ld   a, (hl)
    ld   (de), a
    inc  hl
    inc  de
    dec  c
    jp   nz, BIOS_READ_1

    ; Выключение ПЗУ
    ld   a, PORT_ROM__ENABLE_RAM
    out  (PORT_ROM), a

    ; Код ошибки - Нет ошибки
    xor  a
    ret

;----------------------------------------------------------------------------

BIOS_WRITE_512:
    ; Код ошибки - Все полохо
    ld   a, 1
    ret

;----------------------------------------------------------------------------

    .IF $ >= 0E000h
    CPM_ADDRESS too big
    .ENDIF

end:
    .end
