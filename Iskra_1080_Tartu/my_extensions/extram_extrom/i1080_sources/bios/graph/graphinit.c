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
#include "graphinit.h"
#include "clearscreen.h"
#include "scrollup.h"
#include "graph.h"
#include "../../i1080.h"

void GraphInit(/* a - text screen width, b - GRAPH_INIT_?_BITPLANE, hl - DrawCursorAddress */) {
    text_screen_width = a;
    draw_cursor = hl;

    ClearScreenInit(b);
    ScrollUpInit(b);

    if (flag_nz(b--)) { /* b == GRAPH_INIT_1_BITPLANE */
        out(PORT_VIDEO_MODE_0_LOW, a);
        out(PORT_VIDEO_MODE_1_HIGH, a);
        return;
    }

    out(PORT_VIDEO_MODE_0_HIGH, a);
    out(PORT_VIDEO_MODE_1_LOW, a);
}
