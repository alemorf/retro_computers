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

CHECK_MEMORY_ENABLED = 1

BIOS_INIT                      = 0F836h
BIOS_INIT_SP                   = 0F800h
BIOS_REBOOT                    = 0F800h
BIOS_READ_KEY                  = 0F803h
BIOS_CHECK_KEY                 = 0F812h
BIOS_PRINT_CHAR                = 0F809h
BIOS_ESC_STATE                 = 0F75Fh
BIOS_CURSOR                    = 0F75Ah
BIOS_COLOR                     = 0F759h
BIOS_CURSOR_VISIBLE            = 0F75Eh
BIOS_KEY_BUFFER                = 0F756h

NC_STATE                       = 0F700h
NC_DONT_EXEC                   = 0F740h
NC_USERNO                      = 0F741h
NC_END                         = NC_USERNO

PORT_ROM                       = 0FFh
PORT_ROM__ENABLE_ROM           = 0
PORT_ROM__FLOPPY_B             = 1 << 0
PORT_ROM__FLOPPY_SIDE          = 1 << 1
PORT_ROM__ENABLE_RAM           = 1 << 2
PORT_ROM__ROM_A15              = 1 << 3

PORT_VG93_COMMAND              = 0E0h
PORT_VG93_TRACK                = 0E1h
PORT_VG93_SECTOR               = 0E2h
PORT_VG93_DATA                 = 0E3h
PORT_FLOPPY_WAIT               = 0ECh
PORT_FLOPPY_MOTOR              = 0F8h

PORT_UART_DATA                 = 0E8h
PORT_UART_CONTROL              = 0E9h
PORT_UART_CONTROL__TX_ENABLE   = 1 << 0
PORT_UART_CONTROL__DTR         = 1 << 1
PORT_UART_CONTROL__RX_ENABLE   = 1 << 2
PORT_UART_CONTROL__TXD_LOW     = 1 << 3
PORT_UART_CONTROL__ERROR_RESET = 1 << 4
PORT_UART_CONTROL__RTS         = 1 << 5
PORT_UART_CONTROL__RESET       = 1 << 6
PORT_UART_CONTROL__ENTER_HUNT  = 1 << 7
PORT_UART_CONFIG__SYNC         = 0 << 0
PORT_UART_CONFIG__SPEED_1      = 1 << 0
PORT_UART_CONFIG__SPEED_16     = 2 << 0
PORT_UART_CONFIG__SPEED_64     = 3 << 0
PORT_UART_CONFIG__BITS_5       = 0 << 2
PORT_UART_CONFIG__BITS_6       = 1 << 2
PORT_UART_CONFIG__BITS_7       = 2 << 2
PORT_UART_CONFIG__BITS_8       = 3 << 2
PORT_UART_CONFIG__PARITY_ODD   = 1 << 5
PORT_UART_CONFIG__PARITY_EVEN  = 3 << 5
PORT_UART_CONFIG__STOP_1       = 1 << 6
PORT_UART_CONFIG__STOP_1_5     = 2 << 6
PORT_UART_CONFIG__STOP_2       = 3 << 6

SCREEN_ATTRIB_UNDERLINE        = 1 << 7
SCREEN_WIDTH                   = 64
SCREEN_HEIGHT                  = 25

;----------------------------------------------------------------------------

    .org 0

cold_boot:
    di

    .IF CHECK_MEMORY_ENABLED
    ; Проверка верхнего ОЗУ
HIGH_RAM_TEST_START = 8000h
HIGH_RAM_TEST_SIZE = 7800h
RAM_TEST_A = 077h
RAM_TEST_B = RAM_TEST_A ^ 0FFh

    ; Запись RAM_TEST_A в каждую ячейку верхнего ОЗУ
    ld   sp, HIGH_RAM_TEST_START + HIGH_RAM_TEST_SIZE ; Начальный адрес
    ld   de, HIGH_RAM_TEST_SIZE / 2048           ; Циклов. D = 0. E = 31.
ramtest_enter:
    ld   bc, (RAM_TEST_A << 8) | RAM_TEST_A ; Константа для заливки
ramtest_0:
    push bc
    push bc
    push bc
    push bc
    dec  d
    jp   nz, ramtest_0
    dec  e
    jp   nz, ramtest_0

    ; Проверка записанного RAM_TEST_A, замена его на RAM_TEST_B и еще раз проверка
    ld   b, RAM_TEST_B
ramtest_1:
    ld   d, HIGH_RAM_TEST_SIZE / 256
    ld   hl, HIGH_RAM_TEST_START
ramtest_2:
    ld   a, (hl)
    cp   c
    jp   nz, ram_test_error
    ld   (hl), b
    inc  l
    ld   a, (hl)
    cp   c
    jp   nz, ram_test_error
    ld   (hl), b
    inc  l
    jp   nz, ramtest_2
    inc  h
    dec  d
    jp   nz, ramtest_2
    ld   a, b
    cp   c
    ld   c, b
    jp   nz, ramtest_1
    .ENDIF

    ; Инициализация BIOS
    ld   sp, BIOS_INIT_SP
    call BIOS_INIT

    ; Инициализация состояния NC
    ld   bc, NC_END - NC_STATE + 1
    ld   hl, NC_STATE
cold_boot_0:
    ld   (hl), b
    inc  hl
    dec  c
    jp   nz, cold_boot_0

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

    ; Инициализация КР580ВВ51
    xor  a
    out  (PORT_UART_CONTROL), a
    out  (PORT_UART_CONTROL), a
    out  (PORT_UART_CONTROL), a
    ld   a, PORT_UART_CONTROL__RESET
    out  (PORT_UART_CONTROL), a
    ld   a, PORT_UART_CONFIG__SPEED_16 | PORT_UART_CONFIG__BITS_8 | PORT_UART_CONFIG__STOP_1
    out  (PORT_UART_CONTROL), a
    ld   a, PORT_UART_CONTROL__TX_ENABLE | PORT_UART_CONTROL__DTR | PORT_UART_CONTROL__RX_ENABLE | PORT_UART_CONTROL__RTS
    out  (PORT_UART_CONTROL), a

    ; Продолжение запуска в ОЗУ
    jp   boot

;----------------------------------------------------------------------------

    .IF CHECK_MEMORY_ENABLED
ram_test_error:
    ld   b, a
low_ram_test_error_2:
    ld   c, d
    ex   hl, de

    ; Очистка цветного экрана
    ld   sp, 0E00Ah
    ld   hl, 04F4Fh
    push hl
    push hl
    push hl
    push hl
    push hl

    ; Адрес вывода
    ld   sp, 0E80Ah

    ; Вывод записанного байта
    ld   hl, $ + 3
    ld   a, b
    jp   ram_test_print_low
    ld   a, b
    jp   ram_test_print_high
    xor  a
    jp   ram_test_print_char

    ; Вывод прочитанного адреса
    ld   a, c
    jp   ram_test_print_low
    ld   a, c
    jp   ram_test_print_low
    xor  a
    jp   ram_test_print_char

    ; Вывод адреса сбойного байта
    ld   a, e
    jp   ram_test_print_low
    ld   a, e
    jp   ram_test_print_high
    ld   a, d
    jp   ram_test_print_low
    ld   a, d
    jp   ram_test_print_high
    jp $

;----------------------------------------------------------------------------

ram_test_print_high:
    rrca
    rrca
    rrca
    rrca
ram_test_print_low:
    and  0Fh
    add  '0'
    cp   '9' + 1
    jp   c, ram_test_print_char
    add  'A' - '0' - 10
ram_test_print_char:
    push af
    inc  sp
    inc  hl
    inc  hl
    inc  hl
    inc  hl
    jp   (hl)
    .ENDIF

;----------------------------------------------------------------------------

    .org 0100h

cpm_in_rom:

    .org 0C100h
begin:

STKAREA = 0F800h

STORAGE_COUNT = 3

ROM_STORAGE_ADDRESS = 2000h
ROM_STORAGE_SIZE = 10000h - ROM_STORAGE_ADDRESS

A_FIXED = 1
A_128_PER_TRACK = 65535
A_BLOCK_SIZE = 1024
A_DIRECTORY_BLOCKS = 1
A_BLOCK_COUNT = ROM_STORAGE_SIZE / A_BLOCK_SIZE

TRACKS_COUNT = 80
SIDE_COUNT = 2
SECTOR_PER_TRACK = 9
SECTOR_SIZE = 512

B_FIXED = 0
B_128_PER_TRACK = SECTOR_PER_TRACK * (SECTOR_SIZE / 128)
B_BLOCK_SIZE = 2048
B_DIRECTORY_BLOCKS = 2
B_BLOCK_COUNT = (SIDE_COUNT * TRACKS_COUNT * SECTOR_PER_TRACK * SECTOR_SIZE) / B_BLOCK_SIZE

C_FIXED = 0
C_128_PER_TRACK = SECTOR_PER_TRACK * (SECTOR_SIZE / 128)
C_BLOCK_SIZE = 2048
C_DIRECTORY_BLOCKS = 2
C_BLOCK_COUNT = (SIDE_COUNT * TRACKS_COUNT * SECTOR_PER_TRACK * SECTOR_SIZE) / C_BLOCK_SIZE

    .include "cpm22.inc"

;----------------------------------------------------------------------------

floppy_a_track: .db -1
floppy_b_track: .db -1

;----------------------------------------------------------------------------

boot:
    ; Включение ОЗУ
    ld   a, PORT_ROM__ENABLE_RAM
    out  (PORT_ROM), a

    .IF CHECK_MEMORY_ENABLED

    ; Проверка ОЗУ
LOW_RAM_TEST_START = 0
LOW_RAM_TEST_SIZE = 8000h

    ; Запись RAM_TEST_A в каждую ячейку ОЗУ
    ld   sp, LOW_RAM_TEST_START + LOW_RAM_TEST_SIZE ; Начальный адрес
    ld   hl, LOW_RAM_TEST_SIZE / 2048               ; Циклов. H = 0. L = 32
    ld   de, (RAM_TEST_A << 8) | RAM_TEST_A ; Константа для заливки
lowramtest_0:
    push de
    push de
    push de
    push de
    dec  h
    jp   nz, lowramtest_0
    dec  l
    jp   nz, lowramtest_0

    ; Проверка записанного RAM_TEST_A, замена его на RAM_TEST_B и еще раз проверка
    ld   e, RAM_TEST_B
lowramtest_1:
    ld   b, LOW_RAM_TEST_SIZE / 256
    ld   hl, LOW_RAM_TEST_START
lowramtest_2:
    ld   a, (hl)
    cp   d
    jp   nz, low_ram_test_error
    ld   (hl), e
    inc  l
    ld   a, (hl)
    cp   d
    jp   nz, low_ram_test_error
    ld   (hl), e
    inc  l
    jp   nz, lowramtest_2
    inc  h
    dec  b
    jp   nz, lowramtest_2

    ld   a, d
    cp   e
    ld   d, e
    jp   nz, lowramtest_1

    .ENDIF

    jp   RUNCPM

;----------------------------------------------------------------------------

    .IF CHECK_MEMORY_ENABLED
low_ram_test_error:
    ld   b, a

    ; Включение ПЗУ
    ld   a, PORT_ROM__ENABLE_ROM
    out  (PORT_ROM), a

    ; Вывод ошибки
    jp   low_ram_test_error_2
    .ENDIF

;----------------------------------------------------------------------------

BIOS_SHELL:
    LD   A, (NC_DONT_EXEC)
    OR   A
    JP   NZ, CRLF

    ; Запустить NC.COM с диска A:
    LD   HL, 4 | ('A' << 8)
    LD   (INBUFF + 1), HL
    LD   HL, ':' | ('N' << 8)
    LD   (INBUFF + 3), HL
    LD   HL, 'C'
    LD   (INBUFF + 5), HL

    ; Сохранение текущего пользоваля/папки
    LD   A, (USERNO)
    OR   0E0h
    LD   (NC_USERNO), A

    ; Выбор нулевого пользоваля/корневой папки
    LD	 A, (TDRIVE)
    AND  0Fh
    LD	 C, A
    JP   RUNCOMMAND

;----------------------------------------------------------------------------

BIOS_SET_USER_FOR_PROGRAMM:
    POP  HL
    JP	 NZ,UNKWN0
    PUSH HL
    LD   HL, NC_USERNO
    LD   A, (HL)
    SUB  0F0h
    RET  C
    LD   (HL), A
    LD   (USERNO), A
    RET

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

BIOS_CONST = BIOS_CHECK_KEY

;----------------------------------------------------------------------------

BIOS_CONOUT:
    push af

    ; Если прошлый символ был ESC
    ld    a, (BIOS_ESC_STATE)
    dec   a
    jp    nz, BIOS_CONOUT_1

    ; Обработка ESC последовательностей VT-52
    ld    a, c
    sub   'A'
    jp    z, BIOS_CONOUT_UP
    dec   a ; B
    jp    z, BIOS_CONOUT_DOWN
    dec   a ; C
    jp    z, BIOS_CONOUT_RIGHT
    dec   a ; D
    jp    z, BIOS_CONOUT_LEFT
    sub   'H' - 'D'
    jp    z, BIOS_CONOUT_HOME
    sub   'J' - 'H'
    jp    z, VT52_CLEAR_TO_END_OF_SCREEN
    dec   a ; K
    jp    z, VT52_CLEAR_TO_END_OF_LINE
    sub   'Y' - 'K'
    jp    z, BIOS_CONOUT_1

    ; Вывод неизвестной ESC последовательности
    ld    a, c
    ld    (0EFC0h), a
BIOS_CONOUT_1:

    ; Кодировка ASCII -> Микро80
    ld   a, c
    cp   060h
    call nc, CODEPAGE
    ld   c, a
    pop  af
    jp   BIOS_PRINT_CHAR

;----------------------------------------------------------------------------

BIOS_CONOUT_UP:
    ld    a, 25
    jp    BIOS_CONOUT_STD

;----------------------------------------------------------------------------

BIOS_CONOUT_DOWN:
    ld    a, 26
    jp    BIOS_CONOUT_STD

;----------------------------------------------------------------------------

BIOS_CONOUT_LEFT:
    ld    a, 8
    jp    BIOS_CONOUT_STD

;----------------------------------------------------------------------------

BIOS_CONOUT_RIGHT:
    ld    a, 24
    jp    BIOS_CONOUT_STD

;----------------------------------------------------------------------------

BIOS_CONOUT_HOME:
    ld    a, 12

BIOS_CONOUT_STD:
    push  bc
    ld    c, a
    xor   a
    ld    (BIOS_ESC_STATE), a
    call  BIOS_PRINT_CHAR
    pop   bc
    pop   af
    ret

;----------------------------------------------------------------------------

VT52_CLEAR_TO_END_OF_LINE:
    push  bc
    push  hl

    ld    hl, (BIOS_CURSOR)

    ld    a, l
    and   63
    sub   63
    cpl
    ld    c, a

    ld    b, 1

    jp    VT52_CLEAR_TO_END_OF_SCREEN_0

;----------------------------------------------------------------------------

VT52_CLEAR_TO_END_OF_SCREEN:
    push  bc
    push  hl

    ld    hl, (BIOS_CURSOR)

    ld    a, (0E800h + (SCREEN_HEIGHT * SCREEN_WIDTH)) & 0FFh
    sub   l
    ld    c, a
    ld    a, ((0E800h + (SCREEN_HEIGHT * SCREEN_WIDTH)) >> 8) + 1
    sbc   h
    ld    b, a

VT52_CLEAR_TO_END_OF_SCREEN_0:
    push  de
    ld    a, h
    sub   8
    ld    d, a
    ld    e, l

    call  HIDE_SHOW_CURSOR
    push  de

    dec   c
    inc   c
    jp    z, VT52_CLEAR_TO_END_OF_SCREEN_2
    ld    a, (BIOS_COLOR)
VT52_CLEAR_TO_END_OF_SCREEN_1:
    ld    (de), a
    inc   de
    ld    (hl), 0
    inc   hl
    dec   c
    jp    nz, VT52_CLEAR_TO_END_OF_SCREEN_1
VT52_CLEAR_TO_END_OF_SCREEN_2:
    dec   b
    jp    nz, VT52_CLEAR_TO_END_OF_SCREEN_1

    pop   de
    call  HIDE_SHOW_CURSOR
    pop   de
    pop   hl
    xor   a
    ld    (BIOS_ESC_STATE), a
    pop   bc
    pop   af
    ret

;----------------------------------------------------------------------------

HIDE_SHOW_CURSOR:
    ld   a, (BIOS_CURSOR_VISIBLE)
    or   a
    ret  z
    ld   a, (de)
    xor  SCREEN_ATTRIB_UNDERLINE
    ld   (de), a
    ret

;----------------------------------------------------------------------------

BIOS_CONIN_LEFT:
    ld   a, 'D' + 1
    jp   BIOS_CONIN_ESC

;----------------------------------------------------------------------------

BIOS_CONIN_RIGHT:
    ld   a, 'C' + 1
    jp   BIOS_CONIN_ESC

;----------------------------------------------------------------------------

BIOS_CONIN_UP:
    ld   a, 'A' + 1
    jp   BIOS_CONIN_ESC

;----------------------------------------------------------------------------

BIOS_CONIN_DOWN:
    ld   a, 'B' + 1


;----------------------------------------------------------------------------
BIOS_CONIN_ESC:
    ld   (BIOS_KEY_BUFFER), a
    ld   a, 1Bh
    ret

;----------------------------------------------------------------------------

BIOS_CONIN:
    call BIOS_READ_KEY

    ; Замена кодов клавиш Микро 80 на VT-52
    cp   08h
    jp   z, BIOS_CONIN_LEFT
    cp   18h
    jp   z, BIOS_CONIN_RIGHT
    cp   19h
    jp   z, BIOS_CONIN_UP
    cp   1Ah
    jp   z, BIOS_CONIN_DOWN

    ; Замена кодировки ASCII на Микро80
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
    ; Диск A: это ПЗУ
    ld     a, (BUFFER_DISK)
    or     a
    jp     z, READ_ROM

    ; Запуск чтения с дискеты
    ld     c, 86h ; Код команды для К1818ВГ93
    jp     FLOPPY_READ_WRITE

;----------------------------------------------------------------------------

BIOS_WRITE_512:
    ; Диск A: это ПЗУ
    ld     a, (BUFFER_DISK)
    or     a
    ld     a, 2 ; Код ошибки R/O - не работает
    ret    z

    ; Запуск записи на дискету
    ld     c, 0A6h ; Код команды для К1818ВГ93
    jp     FLOPPY_READ_WRITE

;----------------------------------------------------------------------------

READ_ROM:
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

;-------------------------------------------------------------------------------

FLOPPY_READ_WRITE:
    ; Вычисление номера стороны (D) и номера дорожки (B)
    ld     d, PORT_ROM__ENABLE_RAM ; Сторона 0
    ld     a, (BUFFER_TRACK)
    ld     b, a
    sub    TRACKS_COUNT
    jp     c, FLOPPY_READ_WRITE_0
    ld     b, a
    ld     a, c ; Номер головки в коде команды (C)
    or     8
    ld     c, a
    ld     d, PORT_ROM__ENABLE_RAM | PORT_ROM__FLOPPY_SIDE ; Сторона 1
FLOPPY_READ_WRITE_0:

    ; Вычисление номера дисковода и адреса переменной содержащий дорожку дисковода
    ld     a, (BUFFER_DISK)
    dec    a
    ld     hl, floppy_a_track
    ld     a, d
    jp     z, FLOPPY_READ_WRITE_1
    or     PORT_ROM__FLOPPY_B
    inc    hl
FLOPPY_READ_WRITE_1:

    ; Выбор дисковода и стороны
    out    (PORT_ROM), a

    ; Запуск двигателя
    out    (PORT_FLOPPY_MOTOR), a

    ; Ожидаение готовности дисковода
    call   FLOPPY_WAIT_READY
    ret    nz

    ; Если нужная дорожка выбрана, то пропускам команду перемещения головки.
    ld     a, (hl)
    out    (PORT_VG93_TRACK), a
    cp     b
    jp     z, FLOPPY_READ_WRITE_4

    ; Если нужно выбрать нулевую дорожку, то выполяем команду 0 - Восстановление
    ld     a, b
    or     a
    jp     z, FLOPPY_READ_WRITE_2

    ; Выполяем команду 10 - Поиск, максимальная скорость
    out    (PORT_VG93_DATA), a
    ld     a, 10h

FLOPPY_READ_WRITE_2:
    ; Если произойдет ошибка позиционирования, то искать заново
    ld     (hl), -1

    ; Выполнение команды выбора дорожки
    out    (PORT_FLOPPY_MOTOR), a
    out    (PORT_VG93_COMMAND), a
    call   FLOPPY_WAIT_READY
    ret    nz
    and    8 + 10h ; Ошибка поиска + Ошибка CRC
    ret    nz

    ; Сохранение дорожки
    ld     (hl), b

FLOPPY_READ_WRITE_4:
    ; Передача номера сектора
    ld     a, (BUFFER_SECTOR)
    inc    a
    out    (PORT_VG93_SECTOR), a

    ; Выполнение команды чтения или записи
    ld     a, c
    and    20h
    ld     a, c
    ld     c, 0 ; Счетчик цикла
    ld     hl, BUFFER ; Адрес буфера
    out    (PORT_FLOPPY_MOTOR), a
    out    (PORT_VG93_COMMAND), a

    ; Чтение или запись?
    jp     nz, FLOPPY_READ_WRITE_6

    ; Цикл получения данных от К1818ВГ93
FLOPPY_READ_WRITE_5:
    in     a, (PORT_FLOPPY_WAIT)
    in     a, (PORT_VG93_DATA)
    ld     (hl), a
    inc    hl
    dec    c
    in     a, (PORT_FLOPPY_WAIT)
    in     a, (PORT_VG93_DATA)
    ld     (hl), a
    inc    hl
    jp     nz,  FLOPPY_READ_WRITE_5
    jp     FLOPPY_READ_WRITE_8

    ; Цикл отправки данных в К1818ВГ93
FLOPPY_READ_WRITE_6:
FLOPPY_READ_WRITE_7:
    in     a, (PORT_FLOPPY_WAIT)
    ld     a, (hl)
    out    (PORT_VG93_DATA), a
    inc    hl
    dec    c
    in     a, (PORT_FLOPPY_WAIT)
    ld     a, (hl)
    out    (PORT_VG93_DATA), a
    inc    hl
    jp     nz, FLOPPY_READ_WRITE_7

FLOPPY_READ_WRITE_8:
    ; Получение кода ошибки от К1818ВГ93 и выход
    call   FLOPPY_WAIT_READY
    ret    nz
    and    2 + 4 + 8 + 10h + 40h ; Запрос данных, потеря данных, CRC,
    ret                          ; сектор не найден, защищено от записи

;----------------------------------------------------------------------------
; Ожидание готовности дисковода и завершения команды выполняемой К1818ВГ93
; Регистровые пары BC, HL сохраняется

FLOPPY_TIMEOUT = 2

FLOPPY_WAIT_READY:
    push   hl

    ; Цикл
    ld     h, FLOPPY_TIMEOUT
    ld     de, 0
FLOPPY_WAIT_READY_1:

    ; Выход с флагом Z и A содержащим состояние КР181ВГ93,
    ; если команда завершена и дисковод готов
    in     a, (PORT_VG93_COMMAND)
    ld     l, a
    and    81h
    ld     a, l
    jp     z, FLOPPY_WAIT_READY_2

    ; Цикл
    dec    de
    ld     a, d
    or     e
    jp     nz, FLOPPY_WAIT_READY_1
    dec    h
    jp     nz, FLOPPY_WAIT_READY_1

    ; Выход с флагом NZ и A = 0FFh, если таймаут
    dec    a
FLOPPY_WAIT_READY_2:
    pop    hl
    ret

;---------------------------------------------------------------------------

    .IF $ > 0E000h
    CPM_ADDRESS too big
    .ENDIF

end:
    .end
