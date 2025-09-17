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

#include <stdio.h>
#include <stdint.h>

#ifdef ARCH_ISKRA_1080_TARTU
int __fastcall getchar() {
    asm {
        call 0C7F3h
        ld l, a
        ld h, 0
    }
}
#endif

#ifdef ARCH_CPM
#include <cpmbios.h>

int getchar() {
    return cpmBiosConIn();
}
#endif
