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

#include "drawtext.h"
#include "../font.h"

static uint8_t textColor = 0xFF;

static void SetTextColorInternal(uint8_t plane, uint8_t text, uint8_t background) {
    asm {
        ; Background color
        or a
        jp nz, PrintColor_2
            ld hl, 003E6h  // E6 = AND
            push hl
            ld h, 0FCh
            push hl
            ld h, 00Fh
            push hl
            ld h, 0F0h
            push hl
            ld h, 03Fh
            push hl
            ld h, 0C0h
            ld bc, 000A8h  // NOP + XOR B
            jp PrintColor_3
PrintColor_2:
            ld hl, 0FCF6h  // F6 = OR
            push hl
            ld h, 003h
            push hl
            ld h, 0F0h
            push hl
            ld h, 00Fh
            push hl
            ld h, 0C0h
            push hl
            ld h, 03Fh
            ld bc, 0A800h  // NOP + XOR B
PrintColor_3:
        ; Text color
        ld a, (SetTextColorInternal_2_a)
        or a
        jp z, PrintColor_4
            ld b, c
PrintColor_4:
        ld a, (SetTextColorInternal_1_a)
        or a
        ld a, b
        jp nz, PrintColor_5
            ld (print_m1 + 2), a
            ld (print_m3 + 2), a
            ld (print_m5 + 2), a
            ld (print_m7 + 2), a
            ld (print_m9 + 2), a
            ld (print_m11 + 2), a
            ld (print_m11), hl
            pop hl
            ld (print_m9), hl
            pop hl
            ld (print_m7), hl
            pop hl
            ld (print_m5), hl
            pop hl
            ld (print_m3), hl
            pop hl
            ld (print_m1), hl
            jp PrintColor_6
PrintColor_5:
            ld (print_m2 + 2), a
            ld (print_m4 + 2), a
            ld (print_m6 + 2), a
            ld (print_m8 + 2), a
            ld (print_m10 + 2), a
            ld (print_m12 + 2), a
            ld (print_m12), hl
            pop hl
            ld (print_m10), hl
            pop hl
            ld (print_m8), hl
            pop hl
            ld (print_m6), hl
            pop hl
            ld (print_m4), hl
            pop hl
            ld (print_m2), hl
PrintColor_6:
    }
}

void SetTextColor(uint8_t color) {
    if (textColor == color) return;
    textColor = color;
    SetTextColorInternal(0, color & 1, color & 4);
    SetTextColorInternal(1, color & 2, color & 8);
}

static uint8_t DrawChar(uint8_t offset, const uint8_t* source, uint8_t* destination) {
    asm {
        push bc
        ex de, hl
        ld hl, (DrawChar_2_a)
        ex de, hl
        ld c, 8
        ld a, (DrawChar_1_a)
        dec a
        jp z, print_o1
        dec a
        jp z, print_o2
        dec a
        jp z, print_o3

        ; OFFSET 0
print_o0:
        ld a, (de) ; Read
        add a
        add a
        ld b, a
        ld a, (hl) ; Copy
print_m1:
        and 3
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl) ; Copy
print_m2:
        and 3
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        inc de ; Next
        dec l
        dec c
        jp nz, print_o0
        pop bc
        ld a, 1
        ret

        ; OFFSET 1
print_o1:
        ld a, (de) ; Read
        add a
        adc a
        adc a
        adc a
        push af ; Left side
        adc a
        and 00000011b
        ld b, a
        ld a, (hl) ; Copy
print_m3:
        and 0FCh
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl) ; Copy
print_m4:
        and 0FCh
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        pop af ; Right side
        dec h
        and 011110000b
        ld b, a
        ld a, (hl) ; Copy
print_m5:
        and 00Fh
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl) ; Copy
print_m6:
        and 00Fh
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        inc h ; Next
        inc de
        dec l
        dec c
        jp nz, print_o1
        pop bc
        ld a, 2
        ret

        ; OFFSET 2
print_o2:
        ld a, (de) ; Read
        rra
        rra
        and 00001111b
        ld b, a
        ld a, (hl) ; Copy
print_m7:
        and 0F0h
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl) ; Copy
print_m8:
        and 0F0h
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        dec h ; Right side
        ld a, (de)
        rra
        rra
        rra
        and 11000000b
        ld b, a
        ld a, (hl)  ; Copy
print_m9:
        and 03Fh
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl)  ; Copy
print_m10:
        and 03Fh
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        inc h ; Next
        inc de
        dec l
        dec c
        jp nz, print_o2
        pop bc
        ld a, 3
        ret

        ; OFFSET 3
print_o3:
        ld a, (de) ; Read
        and 03Fh
        ld b, a
        ld a, (hl) ; Copy
print_m11:
        and 0C0h
        xor b
        ld (hl), a
        ld a, h ; Plane 2
        xor 40h
        ld h, a
        ld a, (hl) ; Copy
print_m12:
        and 0C0h
        xor b
        ld (hl), a
        ld a, h ; Plane 1
        xor 40h
        ld h, a
        inc de ; Next
        dec l
        dec c
        jp nz, print_o3
        pop bc
        xor a
    }
}

void DrawText1(uint8_t* d, uint8_t st, uint8_t n, const char* text) {
    uint8_t insertSpaces = n & 0x80;
    n &= 0x7F;
    while (n != 0) {
        uint8_t c = *text;
        if (c != 0) {
            ++text;
        } else if (!insertSpaces) {
            return;
        }
        st = DrawChar(st, font_bin + c * 8, d);
        if (st != 1) d -= 0x100;
        --n;
    }
}

void DrawText(uint8_t x, uint8_t y, uint8_t n, const char* text) {
    DrawText1(DRAWTEXTARGS(x, y), n, text);
}
