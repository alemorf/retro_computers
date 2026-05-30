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
#include "../i1080.h"
#include "../common.h"

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

    hl = config.color_0;
    a = l;
    out(PORT_PALETTE(0), a);
    l = (a ^= 15);
    a = h;
    out(PORT_PALETTE(2), a);
    h = (a ^= 15);
    con_color_0 = hl;

    hl = config.color_2;
    a = config.screen_mode;
    if (a != 1)
        if (a != 3)
            hl = config.color_0;

    a = l;
    out(PORT_PALETTE(1), a);
    l = (a ^= 15);
    a = h;
    out(PORT_PALETTE(3), a);
    h = (a ^= 15);
    con_color_2 = hl;

    ConReset();
    SetColor(a = 3);
    DrawText(de = 0, hl = "Искра 1080М");
    con_foreground = a = 9;
    ConUpdateColor();
    cursor_visible = a = 1;

    CpmWBoot(c = 0 /* Storage A: */);
}

void CpmWBoot(/* с - current storage and user */) {
    push_pop(bc) {
        out(PORT_WINDOW(2), a = PAGE_PACKED_CPM);
        out(PORT_WINDOW(3), a = PAGE_CPM_3);
        hl = cpm_offset_in_rom;
        hl += (de = WINDOW_ADDDRESS(2));
        bc = cpm_base;
        UnpackMegaLz8000(hl, bc);
    }
    disable_interrupts();
    CpmEntryPoint(c);
}
