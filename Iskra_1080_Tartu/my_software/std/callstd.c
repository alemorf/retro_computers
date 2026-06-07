/* Load, run and save a standard Basic and binary programs for Iskra 1080 Tartu
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com
 * aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "callstd.h"

/* Запуск стандартного Бейсика или Монитора с сохранением загруженной */
/* во встроенную память программы */
/* Если type = 0xD3, то запускается Бейсик, иначе Монитор */

void CallStd(uint8_t type) {
    asm {
__a_1_callstd = 0
        ld (stdcall3), a ; type

        ; Подключение встроенного ОЗУ в окна 1, 2, 3. Окно 0 остается.
        di
        ld   a, 1
        out  (07Ch), a
        out  (0BCh), a
        out  (0FCh), a

        ; Копирование кода во встроенное ОЗУ
        ld   de, stdcall2
STD_CALL_LO = stdcall2
        ld   c,  stdcallend - stdcall2
STD_CALL_HI = 08F00h ; TODO: Найти другой адрес
STD_CALL_REL = STD_CALL_HI - STD_CALL_LO
        ld   hl, STD_CALL_HI
stdcall1:
        ld   a, (de)
        inc  de
        ld   (hl), a
        inc  hl
        dec  c
        jp   nz, stdcall1

        ; Переход во встроенное ОЗУ
        jp  stdcall2 + STD_CALL_REL
stdcall2:

        ; Включение встроенного ОЗУ в окно 0. Во всех окнах встроенное ОЗУ.
        ld   a, 1
        out  (3Ch), a

        ; Инициализация BIOS. Код из ПЗУ по адресу 0F454h.
        ld   sp, 0C900h
        call 0F360h
        ld   hl, 3412h
        ld   (0C825h), hl
        call 0F32Eh

        ; Запуск Монитора
stdcall3 = $ + 1
        ld   a, 0
        cp   0D3h
        jp   nz, 0F429h

        ; Сохранение первых 2 байт бейсик программы. Они будут уничтожены при инициализации.
        ld   hl, (301h)
        ld   (stdcall4  + STD_CALL_REL), hl

        ; Инициализация Бейсика. Код из ПЗУ по адресу 0EAC4h.
        call 0F9A0h      ; Очистка основного экрана
        call 0E800h      ; Очистка цветного экрана
        ld   hl, 0
        ld   (202h), hl
        ld   hl, 1
        ld   (200h), hl
        xor  a
        ld   (300h), a
        call 0EB09h
        ld   bc, 0EB50h
        ld   de, 0EB7Bh
        ld   hl, 026Eh
        call 0FA11h      ; memcpy_hl_bc
        ld   a, 2Ch
        ld   (100h), a
        ld   hl, 0C752h
        ld   (252h), hl
        ld   hl, 804Fh
        ld   (254h), hl
        call 0D24Bh

        ; Восстановление первых 2 байт бейсик программы
stdcall4 = $ + 1
        ld   hl, 0
        ld   (301h), hl

        ; Вычисление длины бейсик программы
        ld   hl, 301h
stdcall5:
        ld   c, 3
stdcall6:
        ld   a, (hl)
        inc  hl
        or   a
        jp   nz, stdcall5 + STD_CALL_REL
        dec  c
        jp   nz, stdcall6 + STD_CALL_REL
        ld   (236h), hl
        ld   (238h), hl
        ld   (23Ah), hl

        ; Запуск Бейсика
        jp    0E7A6h
stdcallend:
    }
}
