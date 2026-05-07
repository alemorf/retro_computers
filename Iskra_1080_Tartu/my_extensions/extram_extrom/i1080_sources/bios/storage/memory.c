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

#include "memory.h"
#include <cmm.h>
#include "../../i1080.h"
#include "../../common.h"
#include "../../storage.h"

static const uint16_t A_SECTORS_PER_BLOCK = A_BLOCK_SIZE / CPM_SECTOR_SIZE;

static void StorageCopy(/* hl, a, b */);

static void StorageCopyRom(/* de - 128 sector */) {
    /* Смещение файловой системы в ПЗУ */
    out(PORT_WINDOW(2), a = PAGE_PACKED_CPM); /* для storage_offset_in_rom */
    hl = storage_offset_in_rom;
    hl += de;

    /* Расчет значения для выбора страницы ПЗУ */
    hl *= 2;
    a = h;
    a *= 4;
    a ^= PAGE_PACKED_CPM;

    StorageCopy(hl, a, b);
}

static void StorageCopyRam(/* de - 128 sector */) {
    swap(hl, de);

    /* Расчет значения для выбора страницы ОЗУ */
    hl *= 2;
    a = PAGE_RAM_DISK;
    a += h;
    a += a;

    StorageCopy(hl, a, b);
}

static void StorageCopy(/* hl, a, b */) {
    /* Выбор страницы ОЗУ / ПЗУ */
    out(PORT_WINDOW(2), a);

    /* Расчет смещения */
    h = WINDOW_ADDDRESS(2) / (CPM_SECTOR_SIZE / 2) >> 8;
    hl *= CPM_SECTOR_SIZE / 2;

    /* Копирование */
    de = common_buffer;
    b--;
    if (flag_nz)
        swap(hl, de);
    c = CPM_SECTOR_SIZE;
    do {
        *de = a = *hl;
        hl++;
        de++;
    } while (flag_nz(c--));

    d = c; /* Тут c = 0; */
}

void StorageMemoryFormat(void) {
    /* Выбор страницы содержащей common_buffer */
    out(PORT_WINDOW(3), a = PAGE_CPM_3);

    /* Создание образца чистого блока каталога */
    hl = common_buffer;
    do {
        *hl = 0xE5;
    } while (flag_nz(l++));

    /* Копирование образа в каждый блок каталога */
    de = A_RAM_DIRECORY_BLOCKS * A_SECTORS_PER_BLOCK;
    do {
        de--;
        push_pop(de) {
            StorageCopyRam(de, b = 0);
        }
    } while (flag_nz((a = e) |= d));

    /* Выбор страниц содержащих экран (по умолчанию) */
    out(PORT_WINDOW(2), a = PAGE_SCREEN);
    out(PORT_WINDOW(3), a);
}

void StorageMemoryReadWrite(/* hl - sector 128, b - mode */) {
    /* Накопитель содержит одновременно ОЗУ и ПЗУ: */
    /* [ Каталог ROM ] [ Каталог RAM ] [ ROM ]  [ RAM ] */

    swap(hl, de);
    hl = -(A_ROM_DIRECORY_BLOCKS * A_SECTORS_PER_BLOCK);
    hl += de;
    if (flag_nc)
        return StorageCopyRom(de, b);

    swap(hl, de);
    hl = -(A_RAM_DIRECORY_BLOCKS * A_SECTORS_PER_BLOCK);
    hl += de;
    if (flag_nc)
        return StorageCopyRam(de, b);

    hl += (de = A_ROM_DIRECORY_BLOCKS * A_SECTORS_PER_BLOCK);
    swap(hl, de);
    hl = -(A_ROM_BLOCKS * A_SECTORS_PER_BLOCK);
    hl += de;
    if (flag_nc)
        return StorageCopyRom(hl, b);

    hl += (de = A_RAM_DIRECORY_BLOCKS * A_SECTORS_PER_BLOCK);
    swap(hl, de);
    hl = -(A_RAM_BLOCKS * A_SECTORS_PER_BLOCK);
    hl += de;
    if (flag_nc)
        return StorageCopyRam(hl, b);

    d = 1; /* Код ошибки */
}
