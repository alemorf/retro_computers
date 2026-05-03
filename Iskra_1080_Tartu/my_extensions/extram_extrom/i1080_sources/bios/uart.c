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
#include "bios.h"

/* Write the character in C to the "paper tape punch" - or whatever the current auxiliary device is. */
/* If the device isn't ready, wait until it is. */
/* This function is called PUNCH in CP/M 2.x, AUXOUT in CP/M 3. */

void CpmPunch(/* c - byte */) {
    /* TODO */
}

/* Read a character from the "paper tape reader" - or whatever the current auxiliary device is. */
/* If the device isn't ready, wait until it is. The character will be returned in D. */
/* If this device isn't implemented, return character 26 (^Z). */
/* This function is called READER in CP/M 2.x, AUXIN in CP/M 3. */

void CpmReader(void) {
    /* TODO */
    d = 0;
}
