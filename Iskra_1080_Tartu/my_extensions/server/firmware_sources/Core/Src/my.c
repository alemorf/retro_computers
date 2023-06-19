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

#include "my.h"
#include "main.h"
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <assert.h>
#include "network.h"
#include "dwt.h"
#include "fatfs.h"

static const char* g_file_name = "1:/disk0.cpm";

static FIL g_file;
static uint16_t g_sectors_per_track;

void DebugOutput(const char format[], ...) {
    va_list args;
    va_start(args, format);
    char buf[128u];
    int result = vsnprintf(buf, sizeof(buf), format, args);
    assert(result >= 0);
    va_end(args);
    HAL_StatusTypeDef result2 = HAL_UART_Transmit(&huart1, (uint8_t*)buf, strlen(buf), HAL_MAX_DELAY);
    assert(result2 == HAL_OK);
}

static void OpenFile() {
    FRESULT result = f_mount(&USERFatFS, USERPath, 0);
    if (result != FR_OK) {
        DebugOutput("Failed to mount sdcard, error %u\r\n", (unsigned)result);
        Error_Handler();
        return;
    }

    result = f_open(&g_file, g_file_name, FA_OPEN_EXISTING | FA_READ | FA_WRITE);
    if (result != FR_OK) {
        DebugOutput("Failed to open file \"%s\", error %u\r\n", g_file_name, (unsigned)result);
        Error_Handler();
    }

    uint8_t sectors_per_track[2u];
    unsigned read_result = 0u;
    result = f_read(&g_file, &sectors_per_track, sizeof(sectors_per_track), &read_result);
    if (result != FR_OK || read_result != sizeof(sectors_per_track)) {
        DebugOutput("Failed to read file, file_name \"%s\", result %u %u\r\n", g_file_name, (unsigned)result);
        Error_Handler();
    }
    g_sectors_per_track = sectors_per_track[0u] | (sectors_per_track[1u] << 8u);
}

void MyMain() {
    DWT_Init();

    DebugOutput(
        "\r\nIskra 1080 Tartu floppy interface\r\n"
        "20 Mar 2022 (c) Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru\r\n");

    OpenFile();

    NetworkLoop();
}

uint8_t NetworkProcessReadWrite(iskra_read_write_packet_t *packet) {
    assert(packet != NULL);

    const uint16_t track = packet->header.track_l | ((uint16_t)packet->header.track_h << 8u);

    /* Debug info */
    const bool read = packet->header.command_result == ISKRA_PACKET_COMMAND_READ;
    DebugOutput("%s device %u track %u sector %u\r\n",
                read ? "Read" : "Write", (unsigned)packet->header.device,
                (unsigned)track, (unsigned)packet->header.sector);

    /* Calculate and check a file offset */
    uint32_t offset;
    if (__builtin_mul_overflow(track, g_sectors_per_track, &offset) ||
        __builtin_add_overflow(offset, packet->header.sector, &offset) ||
        __builtin_mul_overflow(offset, sizeof(packet->data), &offset) ||
        f_size(&g_file) < sizeof(packet->data) ||
        offset > f_size(&g_file) - sizeof(packet->data)) {
        DebugOutput("Incorrect position in the network packet\r\n");
        return ISKRA_PACKET_RESULT_ERROR;
    }

    /* Set file offset */
    FRESULT result = f_lseek(&g_file, offset);
    if (result != FR_OK) {
        DebugOutput("Failed to set file pointer, file_name \"%s\", offset %u, result %u\r\n", g_file_name,
                    (unsigned)offset, (unsigned)result);
        return ISKRA_PACKET_RESULT_ERROR;
    }

    /* Read/write file */
    unsigned result_size = 0u;
    if (read)
        result = f_read(&g_file, packet->data, sizeof(packet->data), &result_size);
    else
        result = f_write(&g_file, packet->data, sizeof(packet->data), &result_size);
    if (result != FR_OK || result_size != sizeof(packet->data)) {
        DebugOutput("Failed to %s file, file_name \"%s\", result %u %u\r\n", read ? "read" : "write", g_file_name,
                    (unsigned)result, (unsigned)result_size);
        return ISKRA_PACKET_RESULT_ERROR;
    }

    return ISKRA_PACKET_RESULT_DONE;
}
