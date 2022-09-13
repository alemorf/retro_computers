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

#include <unistd.h>
#include <c8080/delay.h>

#ifndef C8080_SECOND_DELAY
#define C8080_SECOND_DELAY 5000
#endif

unsigned sleep(unsigned seconds) {
    while (seconds != 0) {
        seconds--;
        Delay(C8080_SECOND_DELAY);
    }
    return 0;
}

