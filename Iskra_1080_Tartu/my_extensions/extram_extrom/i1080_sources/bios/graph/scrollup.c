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
#include "scrollup.h"
#include "graph.h"
#include "../tools/opcodes_8080.h"
#include "../../i1080.h"

static const uint16_t NEXT_COLUMN = 0x100;

extern uint8_t scroll_up_2 __address("scroll_up_1 + 1");
extern uint16_t scroll_up_3;
extern uint8_t scroll_up_4;
extern uint8_t scroll_up_5;
extern uint16_t scroll_up_7 __address("scroll_up_6 + 1");
extern uint8_t scroll_up_8;
extern uint8_t scroll_up_9 __address("scroll_up_8 + 1");
extern uint8_t scroll_up_10;
extern uint16_t scroll_up_11 __address("scroll_up_10 + 1");

void ScrollUp(void) {
    /* Сохранение SP */
    (hl = 0) += sp;
    scroll_up_7 = hl;
    scroll_up_11 = hl;

    /* Оптимизация */
    de = -FONT_HEIGHT;

    /* Вертикаль */
    hl = SCREEN_0_ADDRESS + SCREEN_HEIGHT_BYTES; /* =0xD100, но первая запись будет в 0xD0FF */
    do {
        /* Копирование одной строки символов */
        a = SCREEN_WIDTH_BYTES;

        /* Копирование одной строки символов */
        disable_interrupts();
        do {
            /* Копирование одного знакоместа в первой плоскости */
            sp = hl;
            hl += de;
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            push(bc);

            /* Копирование одного знакоместа во второй плоскости */
        scroll_up_1:
            hl = FONT_HEIGHT - BITPLANE_OFFSET; /* Заменяется на hl = FONT_HEIGHT */
        scroll_up_3:
            hl += sp; /* Заменяется на JP scroll_up_5 */
        scroll_up_4:
            sp = hl;
            hl += de;
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            l--;
            push(bc);
            b = *hl;
            l--;
            c = *hl;
            push(bc);
            hl = FONT_HEIGHT + BITPLANE_OFFSET + NEXT_COLUMN;
        scroll_up_5:
            hl += sp;
        } while (flag_nz(a--));

        /* Включение прерываний */
    scroll_up_6:
        sp = 0;
        enable_interrupts();

        /* Следующая строка */
        a = l;
        a -= FONT_HEIGHT;
        l = a;
        h = 0xD0;
    } while (a >= FONT_HEIGHT + 7);

    /* Очистка нижней строки */
    a = SCREEN_WIDTH_BYTES;
    de = 0; /* TODO: Background */
    disable_interrupts();
    sp = (SCREEN_0_ADDRESS + SCREEN_SIZE) - ((TEXT_SCREEN_HEIGHT - 1) * FONT_HEIGHT);
    do {
        push(de, de, de, de, de);
        hl = -NEXT_COLUMN + FONT_HEIGHT;
        hl += sp;
        sp = hl;
    } while (flag_nz(a--));

    /* Вторая плоскость */
scroll_up_8: /* Заменяется: jp ScrollUpSpInstr2 */
    a = SCREEN_WIDTH_BYTES;
    de = 0; /* TODO: Background */
    sp = (SCREEN_1_ADDRESS + SCREEN_SIZE) - ((TEXT_SCREEN_HEIGHT - 1) * FONT_HEIGHT);
    do {
        push(de, de, de, de, de);
        hl = -NEXT_COLUMN + FONT_HEIGHT;
        hl += sp;
        sp = hl;
    } while (flag_nz(a--));

    /* Включение прерываний */
scroll_up_10:
    sp = 0;
    enable_interrupts();
}

void ScrollUpInit(/* b - GRAPH_INIT_1_BITPLANE/GRAPH_INIT_2_BITPLANES */) {
    if ((a = b) == GRAPH_INIT_1_BITPLANE) {
        scroll_up_2 = hl = FONT_HEIGHT + NEXT_COLUMN;
        scroll_up_4 = hl = &scroll_up_5;
        scroll_up_3 = a = OPCODE_JP;
        scroll_up_8 = a;
        scroll_up_9 = hl = &scroll_up_10;
    }

    scroll_up_2 = hl = FONT_HEIGHT - BITPLANE_OFFSET;
    scroll_up_3 = a = OPCODE_ADD_HL_SP;
    scroll_up_4 = hl = OPCODE_MOV_SP_HL | (OPCODE_ADD_HL_DE << 8);
    scroll_up_8 = a = OPCODE_LD_A_CONST;
    scroll_up_9 = hl = 0x30 | (OPCODE_LD_DE_CONST << 8);
}
