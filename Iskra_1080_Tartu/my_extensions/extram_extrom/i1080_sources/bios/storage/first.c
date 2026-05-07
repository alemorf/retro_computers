/*
 * Iskra 1080 Extension card firmware
 * Calculating the additional attribute "block does not contain
 * useful data" when writing
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
#include "512.h"
#include "../tools/compare_hl_pde.h"
#include "../../common.h"

uint8_t storage_write_mode;

static uint8_t storage_first_counter;
static uint8_t storage_first_storage;
static uint16_t storage_first_track;
static uint16_t storage_first_sector_128;

static void CpmWriteNormal(void);
static void CpmReadWrite(/* bc - STORAGE_512_ */);

void CpmSelDsk(/* c - накопитель */) {
    d = 0; /* Без ошибок */
}

void CpmWrite(/* c - write mode */) {
    storage_write_mode = a = c;

    /* Если это запись в блок файловой системы, который до этого не */
    /* использовался, то взводится счетчик блокирующий чтение с дискеты */
    if (a == 2) {
        /* Получение block mask. 7 => 1k, 0Fh => 2k, 1Fh => 4k... */
        hl = common_dpb;
        hl++;
        hl++;
        hl++;
        storage_first_counter = a = *hl;
        storage_first_storage = a = common_storage;
        storage_first_track = hl = common_track;
        hl = common_sector_128;
    } else {
        /* Если счетчик равен нулю, то читаем как обычно */
        a = storage_first_counter;
        if (a == 0)
            return CpmWriteNormal();

        /* С каждой записью уменьшается счетчик */
        a--;
        storage_first_counter = a;

        /* Если изменился диск, дорожка или сектор, то счетчик сбрасывается */
        a = storage_first_storage;
        hl = &common_storage;
        if (a != *hl)
            return CpmWriteNormal();

        CompareHlPde(hl = storage_first_track, de = &common_track);
        if (flag_nz)
            return CpmWriteNormal();

        hl = storage_first_sector_128;
        CompareHlPde(hl, de = &common_sector_128);
        if (flag_nz)
            return CpmWriteNormal();
    }

    /* С каждой записью увеличивается номер сектора */
    hl++;

    /* Получение кол-ва дорожек на дискете в DE */
    swap(hl, de);
    hl = common_dpb;
    swap(hl, de);

    /* Переход на следующую дорожку */
    CompareHlPde(hl, de);
    if (flag_z) {
        hl = storage_first_track;
        hl++;
        storage_first_track = hl;
        hl = 0;
    }
    storage_first_sector_128 = hl;

    Storage512(bc = STORAGE_512_FIRST_WRITE);
}

static void CpmWriteNormal(void) {
    CpmReadWrite(bc = STORAGE_512_WRITE);
}

void CpmRead(void) {
    storage_write_mode = a = 2; /* Отключение сохранения */
    CpmReadWrite(bc = STORAGE_512_READ);
}

static void CpmReadWrite(/* bc - STORAGE_512_ */) {
    storage_first_counter = (a ^= a);
    Storage512(bc);
}
