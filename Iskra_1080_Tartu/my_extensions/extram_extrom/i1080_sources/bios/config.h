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

#pragma once

#include <cmm.h>
#include <stdint.h>

struct Config {
    uint8_t screen_mode;
    uint8_t color_0;
    uint8_t color_1;
    uint8_t color_2;
    uint8_t color_3;
    uint8_t codepage;
    uint8_t uart_baud_rate;
    uint8_t uart_data_bits;
    uint8_t uart_parity;
    uint8_t uart_stop;
    uint8_t uart_flow;
    /* TODO: Checksum */
};

static const uint16_t config_address = 0x8000 - sizeof(struct Config); /* End of BIOS RAM */

extern struct Config config __address(config_address);

void InitConfig(void);
