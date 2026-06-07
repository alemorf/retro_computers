/* Load, run and save a standard Basic and binary programs for Iskra 1080 Tartu
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com
 * aleksey.f.morozov@yandex.ru
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

#include "callstd.h"
#include "copytostd.h"
#include <cpm.h>
#include <stdio.h>
#include <string.h>

extern struct FCB fcb[2] __address(0x5C);  // TODO

enum { I1080_BIN = 0xD0, I1080_BAS = 0xD3 };

struct I1080FileHeaderBin {
    uint16_t start;
    uint16_t todo1;  // TODO
    uint16_t todo2;  // TODO
};

static const char I1080_FILE_MAGIC[9] = "ISKRA1080";

struct I1080FileHeader {
    unsigned char id[9]; /* I1080_FILE_MAGIC */
    unsigned char type;  /* I1080_BIN, I1080_BAS */
    unsigned char name[6];
    struct I1080FileHeaderBin binary[0];
};

int main(int argc, char **) {
    if (argc != 2) {
        puts(
            "LOAD, RUN AND SAVE A STANDARD BASIC AND BINARY PROGRAMS\n"
            "FOR ISKRA 1080 TARTU\n"
            "(C) 2026 ALEMORF ALEKSEY.F.MOROZOV@GMAIL.COM\n"
            "USAGE: STD FILENAME");
        return 1;
    }

    if (CpmOpen(fcb) == 0xFF) {
        puts("CAN'T OPEN FILE");
        return 1;
    }

    if (CpmRead(fcb) != 0) {
        puts("CAN'T READ FILE");
        return 1;
    }

    static struct I1080FileHeader *const h = (void *)DEFAULT_DMA;

    if (0 != memcmp(h->id, I1080_FILE_MAGIC, sizeof(h->id))) {
        puts("INCORRECT FILE");
        return 1;
    }

    CopyToStdPrepare();
    unsigned pos;

    static const size_t BAS_HEADER = sizeof(struct I1080FileHeader);
    static const size_t BIN_HEADER = sizeof(struct I1080FileHeader) + sizeof(struct I1080FileHeaderBin);

    const uint8_t type = h->type;
    switch (type) {
        case I1080_BAS:
            pos = CopyToStd(BASIC_PROGRAMM_ADDRESS, DEFAULT_DMA + BAS_HEADER, CPM_128_BLOCK - BAS_HEADER);
            break;
        case I1080_BIN:
            // TODO: Переключиться в чб. Программа может загружаться в видеопамять.
            pos = CopyToStd(h->binary->start, DEFAULT_DMA + BIN_HEADER, CPM_128_BLOCK - BIN_HEADER);
            break;
        default:
            puts("INCORRECT FILE");
            return 1;
    }

    unsigned char result;
    for (;;) {
        result = CpmRead(fcb);
        if (result != 0)
            break;
        pos = CopyToStd(pos, DEFAULT_DMA, CPM_128_BLOCK);
    }

    if (result != CPM_READ_EOF) {
        puts("CAN'T READ FILE");
        return 1;
    }

    CallStd(type);
    return 0;
}
