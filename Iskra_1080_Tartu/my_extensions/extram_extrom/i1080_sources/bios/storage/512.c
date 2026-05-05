/*
 * Iskra 1080 Tartu CP/M
 * Changing a 128-byte block in a 512-byte sector on a drive
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
#include "first.h"
#include "floppy.h"
#include "memory.h"
#include "../tools/compare_hl_pde.h"
#include "../tools/shift_hl_right.h"
#include "../../memory_layout.h"

uint16_t common_sector_512;

uint8_t storage_buffer_changed;
uint8_t storage_buffer_storage = -1;
uint16_t storage_buffer_track;
uint16_t storage_buffer_sector_512;
uint8_t storage_buffer[512];

static void Storage512Check(/*a = buffer_storage*/) {
    a = storage_buffer_storage;
    hl = &common_storage;
    if (a != *hl)
        return;

    CompareHlPde(hl = common_track, de = &storage_buffer_track);
    if (flag_nz)
        return;

    CompareHlPde(hl = common_sector_512, de = &storage_buffer_sector_512);
}

void Storage512(/* bc = STORAGE_512_ */) {
    hl = common_sector_128;

    if ((a = common_storage) == 0)
        return StorageMemory(hl, b);

    /* Вычисление номера реального 512 байтного сектора */
    ShiftHlRight(hl);
    ShiftHlRight(hl);
    common_sector_512 = hl;

    /* Если в буфере не тот накопитель, дорожка, сектор, то сохранение буфера и загрузка нового сектора */
    Storage512Check();
    if (flag_nz) {
        /* Если в буфере нет измененных данных, пропуск сохранения */
        hl = &storage_buffer_changed;
        a = *hl;
        if (a != 0) {
            *hl = 0;

            push_pop(bc) {
                FloppyWrite();
            }

            /* Выход, если A содержит код ошибки */
            if (a != 0)
                return;
        }

        /* Информация о секторе в буфере */
        storage_buffer_changed = (a ^= a);
        storage_buffer_storage = a = common_storage;
        storage_buffer_track = hl = common_track;
        storage_buffer_sector_512 = hl = common_sector_512;

        /* Если чтение разрешено, то чтение сектора с накопителя в буфер */
        c--;
        if (flag_z) {
            push_pop(bc) {
                FloppyRead();
            }
            if (a != 0) {
                d = a;
                storage_buffer_storage = a = -1; /* Установка признака - буфер не содержит полезных данных */
                return;
            }
        }
    }

    /* Вычисление адреса 128 байтного сектора в буфере в HL */
    a = common_sector_128;
    a &= 3;
    h = a;
    l = 0;
    ShiftHlRight(hl);
    hl += (de = storage_buffer);

    /* Чтение или запись 128 байтного сектора */
    de = common_buffer;
    a = b; /* 0 - запись, 1 - чтение */
    a--;
    if (flag_nz) {
        storage_buffer_changed = a;
        swap(hl, de);
    }
    c = CPM_SECTOR_SIZE;
    do {
        *de = a = *hl;
        hl++;
        de++;
    } while (flag_nz(c--));

    /* Если CP/M не требует сохранить буфер сейчас, то выход */
    d = c;                  /* Возвращаемый код ошибки 0 */
    a = storage_write_mode; /* == 1 значит нужно записать все данные на дискету сейчас */
    a--;
    if (flag_nz)
        return;

    storage_buffer_changed = a; /* Тут a = 0 */
    FloppyWrite();
    d = a; /* Возвращает код ошибки в D */
}
