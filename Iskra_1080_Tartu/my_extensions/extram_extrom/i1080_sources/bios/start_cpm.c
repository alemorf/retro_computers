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
#include "start_cpm.h"
#include "console.h"
#include "config.h"
#include "graph/graph.h"
#include "unmlz.h"
#include "../i1080.h"
#include "../memory_layout.h"

void CpmEntryPoint(/* c */) __address("cpm_base + 01633h");

void StartCpm(void) {
    ConSetXlat(a = config.codepage);

    a = config.screen_mode;
    if (a == 0)
        SetGraphModeBw6x10();
    else if (flag_z(a--))
        SetGraphModeColor6x10();
    else if (flag_z(a--))
        SetGraphModeBw4x10();
    else
        SetGraphModeColor4x10();

    SetColor(a = 3);

    ClearScreen();

    a = config.color_0;
    out(PORT_PALETTE(0), a);
    con_color_0 = ((a ^= 7) &= 7);
    a = config.color_1;
    out(PORT_PALETTE(1), a);
    con_color_1 = ((a ^= 7) &= 7);
    a = config.color_2;
    out(PORT_PALETTE(2), a);
    con_color_2 = ((a ^= 7) &= 7);
    a = config.color_3;
    out(PORT_PALETTE(3), a);
    con_color_3 = ((a ^= 7) &= 7);

    DrawText(de = 0, hl = "Искра 1080М");
    ConUpdateColor();
    cursor_visible = a = 1;

    CpmWBoot(c = 0 /* Storage A: */);
}

void CpmWBoot(/* с - current storage and user */) {
    disable_interrupts();
    push_pop(bc) {
        out(PORT_WINDOW(2), a = PAGE_PACKED_CPM);
        out(PORT_WINDOW(3), a = PAGE_CPM_3);
        Unmlz(hl = cpm_offset_in_rom, bc = cpm_base);
    }
    CpmEntryPoint(c);
}
