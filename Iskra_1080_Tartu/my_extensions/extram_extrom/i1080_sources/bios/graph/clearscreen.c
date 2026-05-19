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
#include "clearscreen.h"
#include "graph.h"
#include "../tools/opcodes_8080.h"

extern uint8_t clear_screen_1;
extern uint16_t clear_screen_2;
extern uint16_t clear_screen_3;
extern uint16_t clear_screen_4 __address("clear_screen_3 + 1");

void ClearScreen(void) {
    clear_screen_4 = ((hl = 0) += sp);
    c = SCREEN_WIDTH_BYTES;
    hl = 0;
    do {
        b = SCREEN_HEIGHT_BYTES / 16; /* 16 это кол-во байт push(de...) */
        disable_interrupts();
    color_plane_0_16_:
        de = 0;
        sp = hl;
        do {
            push(de, de, de, de, de, de, de, de);
        } while (flag_nz(b--));
    clear_screen_1:
        a = h; /* Заменяется: goto ClearScreen_3; */
    clear_screen_2:
        a -= BITPLANE_OFFSET >> 8;
        h = a;
        b = SCREEN_HEIGHT_BYTES / 16; /* 16 это кол-во байт push(de...) */
    color_plane_1_16_:
        de = 0;
        sp = hl;
        do {
            push(de, de, de, de, de, de, de, de);
        } while (flag_nz(b--));
        a += BITPLANE_OFFSET >> 8;
        h = a;
    clear_screen_3:
        sp = 0;
        enable_interrupts();
        h--;
    } while (flag_nz(c--));
}

void ClearScreenInit(/* b - GRAPH_INIT_1_BITPLANE/GRAPH_INIT_2_BITPLANES */) {
    b--;
    b++;
    a = OPCODE_JP;
    hl = &clear_screen_3;
    if (flag_nz) { /* b == GRAPH_INIT_2_BITPLANES */
        a = OPCODE_LD_A_H;
        hl = OPCODE_SUB_CONST | (BITPLANE_OFFSET & 0xFF00);
    }
    clear_screen_1 = a;
    clear_screen_2 = hl;
}
