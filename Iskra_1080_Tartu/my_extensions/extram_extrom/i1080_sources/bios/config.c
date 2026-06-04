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

#include "config.h"
#include "tools/memcpy8.h"
#include "../i1080.h"

static struct Config default_config = {
    1,                 /* screen_mode */
    PALETTE_BLACK,     /* color_0 */
    PALETTE_WHITE,     /* color_1 */
    PALETTE_DARK_BLUE, /* color_2 */
    PALETTE_DARK_CYAN, /* color_3 */
    0,                 /* codepage */
    3,                 /* uart_baud_rate */
    3,                 /* uart_data_bits */
    0,                 /* uart_parity */
    0,                 /* uart_stop */
    0,                 /* uart_flow */
};

void InitConfig(void) {
    /* TODO: Checksum */
    ResetConfig();
}

void ResetConfig(void) {
    MEMCPY8(&config, &default_config, sizeof(config));
}
