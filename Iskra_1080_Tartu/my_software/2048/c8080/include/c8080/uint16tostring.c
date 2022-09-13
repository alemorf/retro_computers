/*
 * i8080 stdlib
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

#include "uint16tostring.h"
#include <c8080/div16mod.h>

char* Uint16ToString(char* outputBuffer, uint16_t value) {
    outputBuffer += UINT16_TO_STRING_SIZE - 1;
    *outputBuffer = 0;
    do {
        value /= 10;
        --outputBuffer;
        *outputBuffer = (uint8_t)__div_16_mod + '0';
    } while (value != 0);
    return outputBuffer;
}

