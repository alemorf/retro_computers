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

#include "drawimage.h"

void DrawImage(uint8_t* destination, uint8_t* source, uint16_t width_height) {
    asm {
        push bc
        ld b, h
        ld c, l
        push bc
        ld hl, (DrawImage_1_a)
        push hl
        ex hl, de
        ld hl, (DrawImage_2_a)
DrawImage_l1:
        push de
        push bc
DrawImage_l2:
        ld a, (hl)
        inc hl
        ld (de), a
        dec de
        dec c
        jp nz, DrawImage_l2
        pop bc
        pop de
        dec d
        dec b
        jp nz, DrawImage_l1
        pop de
        ld a, d ; Plane 2
        sub 40h
        ld d, a
        pop bc
DrawImage_l3:
        push de
        push bc
DrawImage_l4:
        ld a, (hl)
        inc hl
        ld (de), a
        dec de
        dec c
        jp nz, DrawImage_l4
        pop bc
        pop de
        dec d
        dec b
        jp nz, DrawImage_l3
        pop bc
    }
}
