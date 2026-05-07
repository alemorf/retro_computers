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
#include "../i1080.h"
#include "../common.h"

void BiosEntry(void) __address(0);

static void Entry8000(void);
static void UnpackMegaLz(/* hl, bc */);
static void UnpackMegaLz_Input();
static void UnpackMegaLz_GetBits();
static void UnpackMegaLz_GetBigD();

asm(" org 08000h");

/* Запуск компьютера */
/* Эти функции скомпилированы для работы из 2 окна, но после перезагрузки эти функции */
/* подключены к нулевому окну и процессор выполняет программу с нулевого адреса. */

void Entry(void) {
    /* Выключение прерываний */
    disable_interrupts();
    /* Включение маппера. Первым настраивается окно из которого выполняется код. */
    out(PORT_WINDOW(0), a = PAGE_PACKED_CPM);
    /* Подключение ПЗУ в 2 окно */
    out(PORT_WINDOW(2), a);
    Entry8000();
}

/* Константы */

uint16_t bios_offset = 0x3412;    /* Будет заменено утилитой создания ПЗУ */
uint16_t cpm_offset = 0x7856;     /* Будет заменено утилитой создания ПЗУ */
uint16_t storage_offset = 0xBC9A; /* Будет заменено утилитой создания ПЗУ */

/* Распаковщик MegaLZ */

/* ВНИМАНИЕ! Распаковщик использует адрес 0xFFFF для хранения временной переменной */
/* В конце PAGE_CPM_3 находится временный буфер CP/M */
extern uint8_t bits __address(0xFFFF);

static void UnpackMegaLz(/* hl, bc */) {
    swap(hl, de);
    a = 0x80;
UNLD:
    bits = a;
    UnpackMegaLz_Input();
    goto UNSTA;
UNST3:
    a = *hl;
    hl++;
    *bc = a;
    bc++;
UNST2:
    a = *hl;
    hl++;
    *bc = a;
    bc++;
UNST1:
    a = *hl;
UNSTA:
    *bc = a;
    bc++;
ULOOP:
    a = bits;
    a += a;
    if (flag_z) {
        UnpackMegaLz_Input();
        carry_rotate_left(a, 1);
    }

    // Несжатый байт
    if (flag_c)
        goto UNLD;

    a += a;
    if (flag_z) {
        UnpackMegaLz_Input();
        carry_rotate_left(a, 1);
    }

    if (flag_nc) {
        a += a;
        if (flag_z) {
            UnpackMegaLz_Input();
            carry_rotate_left(a, 1);
        }

        // Копирование одного байта
        if (flag_nc) {
            UnpackMegaLz_GetBits(a, hl = 0x3FFF);  // 2 бита
            bits = a;
            hl += bc;
            goto UNST1;
        }

        // Копирование двух байт
        bits = a;
        UnpackMegaLz_Input();
        l = a;
        h = 0xFF;
        hl += bc;
        goto UNST2;
    }

    a += a;
    if (flag_z) {
        UnpackMegaLz_Input();
        carry_rotate_left(a, 1);
    }

    // Копирование трёх байт
    if (flag_nc) {
        UnpackMegaLz_GetBigD(a);
        hl += bc;
        goto UNST3;
    }

    h = 0;
    do {
        h++;
        a += a;
        if (flag_z) {
            UnpackMegaLz_Input();
            carry_rotate_left(a, 1);
        }
    } while (flag_nc);

    push_pop(a) {
        a = h;
        if (a >= 8)
            goto UNEXIT;

        a = 0;
        do {
            carry_rotate_right(a, 1);
        } while (flag_nz(h--));
        h = a;
        l = 1;
    }

    UnpackMegaLz_GetBits();
    hl++;
    hl++;

    push(hl);
    UnpackMegaLz_GetBigD();
    swap(hl, de);
    swap(*sp, hl);
    swap(hl, de);
    hl += bc;

    // LDIR
    do {
        a = *hl;
        hl++;
        *bc = a;
        bc++;
    } while (flag_nz(e--));

    pop(de);

    goto ULOOP;

UNEXIT:
    pop(a);
}

static void UnpackMegaLz_GetBits() {
    for (;;) {
        a += a;
        if (flag_z) {
            UnpackMegaLz_Input();
            carry_rotate_left(a, 1);
        }
        if (flag_nc) {
            hl += hl;
            if (flag_c)
                return;
            continue;
        }
        hl += hl;
        l++;
        if (flag_c)
            return;
    }
    UnpackMegaLz_GetBigD();
}

static void UnpackMegaLz_GetBigD() {
    a += a;
    if (flag_z) {
        UnpackMegaLz_Input();
        carry_rotate_left(a, 1);
    }

    if (flag_nc) {
        bits = a;
        UnpackMegaLz_Input();
        l = a;
        h = 0xFF;
        return;
    }

    UnpackMegaLz_GetBits(a, hl = 0x1FFF);  // 7 бит
    bits = a;

    h = l;
    h--;

    UnpackMegaLz_Input();
    l = a;
}

static void UnpackMegaLz_Input(/* de */) {
    a = *de;
    de++;
}

/* Продолжение запуска компьютера */

static void Entry8000(void) {
    /* Выключение видео */
    out(PORT_VIDEO_MODE_0_LOW, a);
    out(PORT_VIDEO_MODE_1_LOW, a);

    /* Настройка палитры */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a);
    out(PORT_PALETTE(2), a);
    out(PORT_PALETTE(3), a);

    /* Включение ОЗУ / ПЗУ */
    out(PORT_WINDOW(0), a = PAGE_BIOS_0);
    out(PORT_WINDOW(1), a = PAGE_BIOS_1);
    out(PORT_WINDOW(3), a = PAGE_CPM_3);

    /* Настройка стека */
    /* В конце PAGE_CPM_3 находится временный буфер CP/M */
    /* Но адрес 0xFFFF используется распаковщиком. */
    sp = 0xFFFE;

    /* Распаковка BIOS */
    hl = bios_offset;
    hl += (de = WINDOW_ADDDRESS(2));
    bc = WINDOW_ADDDRESS(0);
    UnpackMegaLz(hl, bc);

    /* Запуск BIOS */
    BiosEntry();
}

asm(" savebin \"loader.bin\", entry, $ - entry");
