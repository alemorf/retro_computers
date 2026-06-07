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

#include "copytostd.h"
#include <stdint.h>
#include <string.h>

static unsigned CopyToStdLow(unsigned dest, const void *src, size_t size) __address(0x4000);

static void CopyToStdLowInt(void) {
    asm {
COPY_TO_STD_LOW_REL = copytostdlow - copytostdlowint
__a_3_copytostdlow=0
        ld   b, h
        ld   c, l
        di
        in   a, (03Ch)
        ld   (copytostdlow4 + COPY_TO_STD_LOW_REL + 1), a
__a_2_copytostdlow=$ + 1 + COPY_TO_STD_LOW_REL
        ld   de, 0
__a_1_copytostdlow=$ + 1 + COPY_TO_STD_LOW_REL
        ld   hl, 0
copytostdlow2:
        ld   a, (de)
        inc  de
        ld   (copytostdlow3 + COPY_TO_STD_LOW_REL + 1), a
        ld   a, 1
        out  (03Ch), a
copytostdlow3:
        ld   (hl), 0
copytostdlow4:
        ld   a, 0
        out  (03Ch), a
        inc  hl
        dec  bc
        ld   a, b
        or   c
        jp   nz, copytostdlow2 + COPY_TO_STD_LOW_REL
        ei
        ; Функция возвращает dest + size, который сейчас в hl
copytostdlowend = $+1 ; +1 для return
    }
}

/* Необходимо вызвать до CopyToStd. Эта функция размещает в верхних адресах */
/* внутренюю функцию */

void CopyToStdPrepare(void) {
    extern uint8_t copytostdlowend[];
    memcpy(CopyToStdLow, CopyToStdLowInt, copytostdlowend - CopyToStdLowInt);
}

/* Копирование данных во встроенную память */
/* ВНИМАНИЕ! Буфер src должен полностью находиться в нулевом окне (0..3FFFh) */
/* Функция возвращает dest + size */

unsigned CopyToStd(unsigned dest, const void *src, size_t size) {
    if (size == 0)
        return dest;

    if (dest < 0x4000) {
        size_t size0 = 0x4000 - dest;
        if (size0 > size)
            size0 = size;
        dest = CopyToStdLow(dest, src, size0);
        size -= size0;
        if (size == 0)
            return dest;
    }

    asm {
        ; Подключение встроенного ОЗУ в окна 1, 2, 3. Окно 0 остается.
        di
        in   a, (07Ch)
        ld   (copytostd_w0), a
        in   a, (0BCh)
        ld   (copytostd_w1), a
        in   a, (0FCh)
        ld   (copytostd_w2), a
        ld   a, 1
        out  (07Ch), a
        out  (0BCh), a
        out  (0FCh), a

        ; Копирование данных
        ld   hl, (__a_3_copytostd) ; size
        ex   hl, de
__a_1_copytostd = $+1
        ld   hl, 0 ; dest
__a_2_copytostd = $+1
        ld   bc, 0 ; src
copytostd1:
        ld   a, (bc)
        inc  bc
        ld   (hl), a
        inc  hl
        dec  de
        ld   a, d
        or   e
        jp   nz, copytostd1

        ; Восстановление окон 1, 2, 3
copytostd_w0 = $+1
        ld   a, 1
        out  (07Ch), a
copytostd_w1 = $+1
        ld   a, 1
        out  (0BCh), a
copytostd_w2 = $+1
        ld   a, 1
        out  (0FCh), a
        ei

        ; Функция возвращает dest + size, который сейчас в hl
    }
}
