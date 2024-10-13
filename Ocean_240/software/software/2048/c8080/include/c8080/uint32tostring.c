/*
 * c8080 stdlib
 * Copyright (c) 2022 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include "uint32tostring.h"
#include "div32mod.h"

char *Uint32ToString(char *outputBuffer, uint32_t value, uint8_t radix) {
    outputBuffer += UINT32_TO_STRING_SIZE - 1;
    *outputBuffer = 0;
    do {
        value /= radix;
        --outputBuffer;
        char c = (char)__div_32_mod + '0';
        if (c > '9') c += 'A' - '0' - 10;
        *outputBuffer = c;
    } while (value != 0);
    return outputBuffer;
}
