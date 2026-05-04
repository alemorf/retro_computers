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
#include "start_basic.h"
#include "tools/memcpy8.h"
#include "../i1080.h"

extern void StartBasic0(void) __address(0);
extern void StartBasic4000(void) __address(0x4000);

static void StartBasic2(void) {
    out(PORT_WINDOW(0), a = 1);
    out(PORT_ROM_0000, a ^= a);
    StartBasic0();
}

void StartBasic(void) {
    disable_interrupts();
    out(PORT_WINDOW(1), a = PAGE_STD);
    out(PORT_WINDOW(2), a);
    out(PORT_WINDOW(3), a);
    MEMCPY8(StartBasic4000, StartBasic2, (uintptr_t)StartBasic - (uintptr_t)StartBasic2);
    StartBasic4000();
}
