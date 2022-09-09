/*
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
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

#include "palette.h"
#include <cmm/delay.h>

static const uint8_t* currentPalette;

static void SetPaletteInternal(uint8_t mask) {
    asm {
        ld b, a
        ld hl, (currentPalette)
        ld a, (hl)
        or b
        out (090h), a
        inc hl
        ld a, (hl)
        or b
        out (091h), a
        inc hl
        ld a, (hl)
        or b
        out (092h), a
        inc hl
        ld a, (hl)
        or b
        out (093h), a
    }
}

void SetBlackPalette() {
    // Установка черной палитры
    SetPaletteInternal(0x0F);

    // Отключение изображения. Процессор работает в 2 раза быстрее.
    asm {
        out (0B8h), a
        out (0B9h), a
    }
}

void SetBlackPaletteSlowly() {
    // Установка темной палитры
    SetPaletteInternal(0x08);

    // Задержка
    Delay(5000);

    // Отключение изображения
    SetBlackPalette();
}

void SetPaletteSlowly(const uint8_t* palette) {
    currentPalette = palette;

    // Установка темной палитры
    SetPaletteInternal(0x08);

    // Включение цветного режима. Процессор работает в 2 раза медленнее.
    asm {
        out (0F8h), a
        out (0B9h), a
    }

    // Задержка
    Delay(5000);

    // Установка нормальной палитры
    SetPaletteInternal(0x00);
}

void SetPalette(const uint8_t* palette) {
    currentPalette = palette;
    SetPaletteInternal(0x00);
}
