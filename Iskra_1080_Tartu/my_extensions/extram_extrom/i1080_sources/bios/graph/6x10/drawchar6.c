/*
 * Iskra 1080 Extension card firmware
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include <cmm.h>
#include "../graphinit.h"
#include "../../tools/opcodes_8080.h"

extern uint8_t font[256 * 10];

asm("font: incbin \"bios/graph/6x10/font.bin\"");

/* Прототипы */
static void DrawChar60(/* hl - chargen, de - video */);
static void DrawChar66(/* hl - chargen, de - video */);
static void DrawChar64(/* hl - chargen, de - video */);
static void DrawChar62(/* hl - chargen, de - video */);
static void DrawCursor6();

/* Полиморфизм */
extern uint8_t draw_char_6_1;
extern uint8_t draw_char_6_2;
extern uint8_t draw_char_6_3;
extern uint8_t draw_char_6_4;
extern uint16_t draw_char_6_and_1;
extern uint16_t draw_char_6_and_2;
extern uint16_t draw_char_6_and_3;
extern uint16_t draw_char_6_and_4;
extern uint16_t draw_char_6_and_5;
extern uint16_t draw_char_6_and_6;
extern uint16_t draw_char_6_and_7;
extern uint16_t draw_char_6_and_8;
extern uint16_t draw_char_6_and_9;
extern uint16_t draw_char_6_and_10;
extern uint16_t draw_char_6_and_11;
extern uint16_t draw_char_6_and_12;
extern uint16_t draw_char_6_xor_1;
extern uint16_t draw_char_6_xor_2;
extern uint16_t draw_char_6_xor_3;
extern uint16_t draw_char_6_xor_4;
extern uint16_t draw_char_6_xor_5;
extern uint16_t draw_char_6_xor_6;
extern uint16_t draw_char_6_xor_7;
extern uint16_t draw_char_6_xor_8;
extern uint16_t draw_char_6_xor_9;
extern uint16_t draw_char_6_xor_10;
extern uint16_t draw_char_6_xor_11;
extern uint16_t draw_char_6_xor_12;

static void DrawChar6(/* hl - coords, a - char */) {
    b = a;

    /* Вычисление адреса в видеопамяти в DE */
    a = l;
    a *= 4;
    a += l;
    a += a;
    invert(a);
    e = a;

    a = h;
    a += a;
    a += h;
    c = a;
    carry_rotate_right(a);
    carry_rotate_right(a);
    a &= 0x3F;
    invert(a);
    d = a;

    /* Вычисление адреса в знакогенераторе в HL */
    a = b;
    a += font;
    l = a;
    carry_add(a, (uintptr_t)font >> 8);
    a -= l;
    h = a;

    /* Выбор функции */
    a = c;
    a &= 3;
    if (flag_z)
        return DrawChar60(hl, de);
    a--;
    if (flag_z)
        return DrawChar62(hl, de);
    a--;
    if (flag_z)
        return DrawChar64(hl, de);
    DrawChar66(hl, de);
}

/* Draw char ......XX XXXX.... */

static void DrawChar66(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        cyclic_rotate_right(a, 4);
        push_pop(a) {
            a &= 0x03;
            b = a;
            a = *de;
        draw_char_6_and_3:
            a &= 0xFC; /* Замена: a |= 0xFF ^ 0xFC; */
        draw_char_6_xor_3:
            a ^= b; /* Замена: nop(); */
            *de = a;
        }
        d--;
        a &= 0xF0;
        b = a;
        a = *de;
    draw_char_6_and_5:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
    draw_char_6_xor_4:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
        h++;
        e--;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_6_2:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        e++;
        h--;
        a = *hl;
        cyclic_rotate_right(a, 4);
        push_pop(a) {
            a &= 0x03;
            b = a;
            a = *de;
        draw_char_6_and_4:
            a &= 0xFC; /* Замена: a |= 0xFF ^ 0xFC; */
        draw_char_6_xor_5:
            a ^= b; /* Замена: nop(); */
            *de = a;
        }
        d--;
        a &= 0xF0;
        b = a;
        a = *de;
    draw_char_6_and_6:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
    draw_char_6_xor_6:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
    } while (flag_nz(c--));
}

/* Draw char XXXXXX.. */

static void DrawChar60(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        b = (a += a += a);
        a = *de;
    draw_char_6_and_1:
        a &= 0x03; /* Замена: a |= 0xFF ^ 0x03; */
    draw_char_6_xor_1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_6_1:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        b = (a += a += a);
        a = *de;
    draw_char_6_and_2:
        a &= 0x03; /* Замена: a |= 0xFF ^ 0x03; */
    draw_char_6_xor_2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while (flag_nz(c--));
}

/* Draw char ..XXXXXX */

static void DrawChar62(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        b = *hl;
        a = *de;
    draw_char_6_and_11:
        a &= 0xC0; /* Замена: a |= 0xFF ^ 0xC0; */
    draw_char_6_xor_11:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_6_3:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    /* Bit plane 1 */
    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        b = *hl;
        a = *de;
    draw_char_6_and_12:
        a &= 0xC0; /* Замена: a |= 0xFF ^ 0xC0; */
    draw_char_6_xor_12:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while (flag_nz(c--));
}

/* Draw char ....XXXX XX...... */

static void DrawChar64(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        cyclic_rotate_right(a, 2);
        a &= 0x0F;
        b = a;
        a = *de;
    draw_char_6_and_7:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
    draw_char_6_xor_7:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d--;
        a = *hl;
        cyclic_rotate_right(a, 2);
        a &= 0xC0;
        b = a;
        a = *de;
    draw_char_6_and_9:
        a &= 0x3F; /* Замена: a |= 0xFF ^ 0x3F; */
    draw_char_6_xor_8:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
        e--;
        h++;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_6_4:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        cyclic_rotate_right(a, 2);
        a &= 0x0F;
        b = a;
        a = *de;
    draw_char_6_and_8:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
    draw_char_6_xor_9:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d--;
        a = *hl;
        cyclic_rotate_right(a, 2);
        a &= 0xC0;
        b = a;
        a = *de;
    draw_char_6_and_10:
        a &= 0x3F; /* Замена: a |= 0xFF ^ 0x3F; */
    draw_char_6_xor_10:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
    } while (flag_nz(c--));
}

static void SetColor6(/* a - foreground and background color */) {
    /* Как очищать основную битовую плоскость? Заливка 0 или 1. */
    c = a;
    a &= 4;
    b = a;
    if (flag_z) {
        hl = OPCODE_AND_CONST | (0x03 << 8);
        draw_char_6_and_1 = hl;
        draw_char_6_and_2 = hl;
        h = 0xFC;
        draw_char_6_and_3 = hl;
        h = 0x0F;
        draw_char_6_and_5 = hl;
        h = 0xF0;
        draw_char_6_and_7 = hl;
        h = 0x3F;
        draw_char_6_and_9 = hl;
        h = 0xC0;
        draw_char_6_and_11 = hl;
    } else {
        hl = OPCODE_OR_CONST | ((0xFF ^ 0x03) << 8);
        draw_char_6_and_1 = hl;
        draw_char_6_and_2 = hl;
        h = 0xFF ^ 0xFC;
        draw_char_6_and_3 = hl;
        h = 0xFF ^ 0x0F;
        draw_char_6_and_5 = hl;
        h = 0xFF ^ 0xF0;
        draw_char_6_and_7 = hl;
        h = 0xFF ^ 0x3F;
        draw_char_6_and_9 = hl;
        h = 0xFF ^ 0xC0;
        draw_char_6_and_11 = hl;
    }

    /* Рисовать символ XOR-ом в нулевой плоскости или не изменять плоскость? */
    a = c;
    a *= 4;
    a &= 4;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    draw_char_6_xor_1 = a;
    draw_char_6_xor_3 = a;
    draw_char_6_xor_4 = a;
    draw_char_6_xor_7 = a;
    draw_char_6_xor_8 = a;
    draw_char_6_xor_11 = a;

    /* Как очищать дополнительную битовую плоскость? Заливка 0 или 1. */
    a = c;
    a &= 8;
    b = a;
    if (flag_z) {
        hl = OPCODE_AND_CONST | (0x03 << 8);
        draw_char_6_and_2 = hl;
        h = 0xFC;
        draw_char_6_and_4 = hl;
        h = 0x0F;
        draw_char_6_and_6 = hl;
        h = 0xF0;
        draw_char_6_and_8 = hl;
        h = 0x3F;
        draw_char_6_and_10 = hl;
        h = 0xC0;
        draw_char_6_and_12 = hl;
    } else {
        hl = OPCODE_OR_CONST | ((0xFF ^ 3) << 8);
        draw_char_6_and_2 = hl;
        h = 0xFF ^ 0xFC;
        draw_char_6_and_4 = hl;
        h = 0xFF ^ 0x0F;
        draw_char_6_and_6 = hl;
        h = 0xFF ^ 0xF0;
        draw_char_6_and_8 = hl;
        h = 0xFF ^ 0x3F;
        draw_char_6_and_10 = hl;
        h = 0xFF ^ 0xC0;
        draw_char_6_and_12 = hl;
    }

    /* Рисовать символ XOR-ом в дополнительной плоскости или не изменять плоскость? */
    a = c;
    a *= 4;
    a &= 8;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    draw_char_6_xor_2 = a;
    draw_char_6_xor_5 = a;
    draw_char_6_xor_6 = a;
    draw_char_6_xor_9 = a;
    draw_char_6_xor_10 = a;
    draw_char_6_xor_12 = a;
}

void DrawChar6Init(/* a - DRAW_CHAR_6_BW_INIT/DRAW_CHAR_6_COLOR_INIT */) {
    /* Используется ли дополнительная битовая плоскость? */
    draw_char_6_1 = a;
    draw_char_6_2 = a;
    draw_char_6_3 = a;
    draw_char_6_4 = a;

    draw_char = hl = &DrawChar6;
    set_color = hl = &SetColor6;
}
