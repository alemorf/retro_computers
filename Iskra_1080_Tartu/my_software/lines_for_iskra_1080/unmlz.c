/*
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
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

#include "unmlz.h"

void* __fastcall unmlz(void* destination, const void* source) {
    asm {
        ex   hl, de  // source
        ld   hl, (unmlz_1_a)  // destination
        ld   bc, hl
        ld   a, 0x80
unmlz_0:
        ld   (unmlz_5 + 1), a
        ld   a, (de)
        inc  de
        jp   unmlz_4
unmlz_1:
        ld   a, (hl)
        inc  hl
        ld   (bc), a
        inc  bc
unmlz_2:
        ld   a, (hl)
        inc  hl
        ld   (bc), a
        inc  bc
unmlz_3:
        ld   a, (hl)
unmlz_4:
        ld   (bc), a
        inc  bc
unmlz_5:
        ld   a, 0x80
        add  a
        call z, unmlz_20
        jp   c, unmlz_0
        add  a
        call z, unmlz_20
        jp   c, unmlz_7
        add  a
        call z, unmlz_20
        jp   c, unmlz_6
        ld   hl, 16383
        call unmlz_16
        ld   (unmlz_5 + 1), a
        add  hl, bc
        jp   unmlz_3

unmlz_6:
        ld   (unmlz_5 + 1), a
        ld   a, (de)
        inc  de
        ld   l, a
        ld   h, 255
        add  hl, bc
        jp   unmlz_2

unmlz_7:
        add  a
        call z, unmlz_20
        jp   c, unmlz_8
        call unmlz_18
        add  hl, bc
        jp   unmlz_1

unmlz_8:
        ld   h, 0
unmlz_9:
        inc  h
        add  a
        call z, unmlz_20
        jp   nc, unmlz_9
unmlz_10:
        push af
        ld   a, h
        cp   8
        jp   nc, unmlz_15
        ld   a, 0
unmlz_11:
        rra
        dec  h
        jp   nz, unmlz_11
unmlz_12:
        ld   h, a
        ld   l, 1
        pop  af
        call unmlz_16
        inc  hl
        inc  hl
        push hl
        call unmlz_18
        ex de, hl
        ex   (sp), hl
        ex de, hl
        add  hl, bc
unmlz_13:
        ld   a, (hl)
        inc  hl
        ld   (bc), a
        inc  bc
        dec  e
        jp   nz, unmlz_13
unmlz_14:
        pop  de
        jp   unmlz_5
unmlz_15:
        pop  af
        ex   de, hl
        ret

unmlz_16:
        add  a
        call z, unmlz_20
        jp   c, unmlz_17
        add  hl, hl
        ret  c
        jp unmlz_16
unmlz_17:
        add  hl, hl
        inc  l
        ret  c
        jp   unmlz_16

unmlz_18:
        add  a
        call z, unmlz_20
        jp   c, unmlz_19
        ld   (unmlz_5 + 1), a
        ld   a, (de)
        inc  de
        ld   l, a
        ld   h, 255
        ret

unmlz_19:
        ld   hl, 8191
        call unmlz_16
        ld   (unmlz_5 + 1), a
        ld   h, l
        dec  h
        ld   a, (de)
        inc  de
        ld   l, a
        ret

unmlz_20:
        ld   a, (de)
        inc  de
        rla
    }
}
