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

#include "fillrect.h"

void __fastcall SetFillRectColor(uint8_t color) {
    asm {
        ld de, 0B200h  // OR A + NOP
        rra
        jp c, SetFillRectColor_0
        ld de, 0A22Fh  // AND D + CMA
SetFillRectColor_0:
        ld hl, FillRectCmd0
        ld (hl), e
        ld hl, FillRectCmd1
        ld (hl), d

        ld de, 0B200h  // OR A + NOP
        rra
        jp c, SetFillRectColor_1
        ld de, 0A22Fh  // AND D + CMA
SetFillRectColor_1:
        ld hl, FillRectCmd2
        ld (hl), e
        ld hl, FillRectCmd3
        ld (hl), d
    }
}

static void __fastcall FillRectInternal(uint8_t height, uint8_t mask, uint8_t* graphAddress) {
    asm {
        push hl
        ld a, (FillRectInternal_2_a)
FillRectCmd0:
        nop  // CMA = 2F, NOP = 00
        ld d, a
        ld a, (FillRectInternal_1_a)
        ld e, a
FillRectInternal_0:
        ld a, (hl)
FillRectCmd1:
        or d  // XRA D = AA, ANA D = A2, ORA D = B2
        ld (hl), a
        dec l
        dec e
        jp nz, FillRectInternal_0
        pop hl

        ld a, h
        sub 40h
        ld h, a

        ld a, (FillRectInternal_2_a)
FillRectCmd2:
        nop  // CMA = 2F, NOP = 00
        ld d, a

        ld a, (FillRectInternal_1_a)
        ld e, a
FillRectInternal_1:
        ld a, (hl)
FillRectCmd3:
        or d  // XRA D = AA, ANA D = A2, ORA D = B2
        ld (hl), a
        dec l
        dec e
        jp nz, FillRectInternal_1
    }
}

void FillRect1(uint8_t* graphAddress, uint16_t width, uint8_t left, uint8_t right, uint8_t height) {
    if (width == 0) {
        FillRectInternal(height, left & right, graphAddress);
        return;
    }
    FillRectInternal(height, left, graphAddress);
    graphAddress -= 0x100;
    --width;
    for (; width != 0; --width) {
        FillRectInternal(height, 0xFF, graphAddress);
        graphAddress -= 0x100;
    }
    FillRectInternal(height, right, graphAddress);
}

void FillRect(uint16_t x0, uint8_t y0, uint16_t x1, uint8_t y1) {
    FillRect1(FILLRECTARGS(x0, y0, x1, y1));
}
