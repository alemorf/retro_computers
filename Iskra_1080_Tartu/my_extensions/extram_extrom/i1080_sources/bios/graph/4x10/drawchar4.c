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

/* Полиморфизм */
extern uint8_t draw_char_4_a;
extern uint8_t draw_char_4_b;
extern uint8_t draw_char_4_a_and_1;
extern uint8_t draw_char_4_b_and_1;
extern uint8_t draw_char_4_a_and_2;
extern uint8_t draw_char_4_b_and_2;
extern uint8_t draw_char_4_a_xor_1;
extern uint8_t draw_char_4_b_xor_1;
extern uint8_t draw_char_4_a_xor_2;
extern uint8_t draw_char_4_b_xor_2;

/* Прототипы */
static void DrawChar44(/* hl - chargen, de - video */);
static void DrawChar40(/* hl - chargen, de - video */);

/* Шрифт */
asm("font4: incbin \"bios/graph/4x10/font4.tmp\"");
extern uint8_t font4[256 * 10];

static void DrawChar4(/* hl - coords, a - char */) {
    b = a;

    /* Вычисление адреса в видеопамяти в DE */
    a = l;
    a *= 4;
    a += l;
    a += a;
    invert(a);
    e = a;

    a = h;
    c = a;
    a |= a;
    carry_rotate_right(a);
    invert(a);
    d = a;

    /* Вычисление адреса в знакогенераторе в HL */
    a = b;
    a += font4;
    l = a;
    carry_add(a, (uintptr_t)font4 >> 8);
    a -= l;
    h = a;

    /* Выбор функции */
    if (flag_nz((a = c) &= 1))
        return DrawChar40();
    DrawChar44(hl, de);
}

static void DrawChar44(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        a &= 0xF0;
        b = a;
        a = *de;
    draw_char_4_a_and_1:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
    draw_char_4_a_xor_1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_4_a:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        a &= 0xF0;
        b = a;
        a = *de;
    draw_char_4_a_and_2:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
    draw_char_4_a_xor_2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while (flag_nz(c--));
}

static void DrawChar40(/* hl - chargen, de - video */) {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        a &= 0x0F;
        b = a;
        a = *de;
    draw_char_4_b_and_1:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
    draw_char_4_b_xor_1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while (flag_nz(c--));

    /* Следующая плоскость */
draw_char_4_b:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        a &= 0x0F;
        b = a;
        a = *de;
    draw_char_4_b_and_2:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
    draw_char_4_b_xor_2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while (flag_nz(c--));
}

static void SetColor4(/* a - foreground and background color */) {
    /* Как очищать основную битовую плоскость? Заливка 0 или 1. */
    c = a;
    a &= 4;
    b = a;
    if (flag_z) {
        hl = OPCODE_AND_CONST | (0x0F << 8);
        draw_char_4_a_and_1 = hl;
        h = 0xF0;
        draw_char_4_b_and_1 = hl;
    } else {
        hl = OPCODE_OR_CONST | (0xF0 << 8);
        draw_char_4_a_and_1 = hl;
        h = 0x0F;
        draw_char_4_b_and_1 = hl;
    }

    /* Рисовать символ XOR-ом в нулевой плоскости или не изменять плоскость? */
    a = c;
    a *= 4;
    a &= 4;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    draw_char_4_a_xor_1 = a;
    draw_char_4_b_xor_1 = a;

    /* Как очищать дополнительную битовую плоскость? Заливка 0 или 1. */
    a = c;
    a &= 8;
    b = a;
    if (flag_z) {
        hl = OPCODE_AND_CONST | (0x0F << 8);
        draw_char_4_a_and_2 = hl;
        h = 0xF0;
        draw_char_4_b_and_2 = hl;
    } else {
        hl = OPCODE_OR_CONST | (0xF0 << 8);
        draw_char_4_a_and_2 = hl;
        h = 0x0F;
        draw_char_4_b_and_2 = hl;
    }

    /* Рисовать символ XOR-ом в дополнительной плоскости или не изменять плоскость? */
    a = c;
    a *= 4;
    a &= 8;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    draw_char_4_a_xor_2 = a;
    draw_char_4_b_xor_2 = a;
}

void DrawChar4Init(/* a - DRAW_CHAR_4_BW_INIT/DRAW_CHAR_4_COLOR_INIT */) {
    /* Используется ли дополнительная битовая плоскость? */
    draw_char_4_a = a;
    draw_char_4_b = a;

    draw_char = hl = DrawChar4;
    set_color = hl = SetColor4;
}
