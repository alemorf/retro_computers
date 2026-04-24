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
#include "mulu16.h"

void MulU16(...) {
    b = h;
    c = l;
    hl = 0;
    a = 17;
    for (;;) {
        a--;
        if (flag_z)
            return;
        hl += hl;
        swap(hl, de);
        if (flag_c) {
            hl += hl;
            hl++;
        } else {
            hl += hl;
        }
        swap(hl, de);
        if (flag_nc)
            continue;
        hl += bc;
        if (flag_nc)
            continue;
        de++;
    }
}
