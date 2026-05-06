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

#include "interrupt.h"
#include <cmm.h>
#include "keyboard.h"
#include "console.h"
#include "../i1080.h"

uint8_t frame_counter;

void InterruptHandler(void) {
    /* Выход, если не было кадрового прерывания */
    a = in(PORT_FRAME_IRQ_RESET);
    cyclic_rotate_right(a);
    if (flag_c)
        return;

    /* Сброс триггера кадрового прерывания */
    out(PORT_FRAME_IRQ_RESET, a);

    /* Увеличение счетчика кадров */
    hl = &frame_counter;
    (*hl)++;

    /* Периодические функции */
    ConsoleInterrupt();
    KeyboardInterrupt();
}
