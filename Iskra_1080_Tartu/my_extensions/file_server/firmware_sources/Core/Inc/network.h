/*
 * Iskra 1080 Tartu floppy interface
 * Copyright (c) 2023 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include <stdint.h>
#include <stdbool.h>

/* Network packet */

#pragma pack(push, 1)

typedef struct {
    uint8_t packet_size;
    uint8_t from;
    uint8_t address;
    uint8_t command_result;
    uint8_t device;
    uint8_t track_l;
    uint8_t track_h;
    uint8_t sector;
} iskra_packet_header_t;

typedef struct {
    iskra_packet_header_t header;
    uint8_t data[128u];
} iskra_read_write_packet_t;

#pragma pack(pop)

/* For iskra_packet_header_t.from */
static const uint8_t ISKRA_PACKET_FROM_CLIENT = 0u;
static const uint8_t ISKRA_PACKET_FROM_SERVER = 1u;

/* For iskra_packet_header_t.command_result when from is CLIENT */
static const uint8_t ISKRA_PACKET_COMMAND_READ = 0u;
static const uint8_t ISKRA_PACKET_COMMAND_WRITE = 1u;

/* For iskra_packet_header_t.command_result when from is SERVER */
static const uint8_t ISKRA_PACKET_RESULT_DONE = 0u;
static const uint8_t ISKRA_PACKET_RESULT_ERROR = 1u;

void NetworkLoop();
uint8_t NetworkProcessReadWrite(iskra_read_write_packet_t *packet);
