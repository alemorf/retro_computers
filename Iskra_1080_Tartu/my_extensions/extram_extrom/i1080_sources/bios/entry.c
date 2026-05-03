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
#include "keyboard.h"

/* Точки входа */

asm(" org 0");

void EntryReboot(void) {
    main();
}

void EntryCpmInterrupt() {
    InterruptHandler();
}

void EntryCpmWBoot() {
    CpmWBoot();
}

void EntryCpmConst(void) {
    return CpmConst();
}

void EntryCpmConin(void) {
    CpmConin();
}

void EntryCpmConout(/*c*/) {
    CpmConout(c);
}

void EntryCpmList(void) {
    CpmList();
}

void EntryCpmPunch(/*c*/) {
    CpmPunch(c);
}

void EntryCpmReader(void) {
    CpmReader();
}

void EntryCpmSelDsk(/*c*/) {
    CpmSelDsk(c);
}

void EntryCpmRead(void) {
    CpmRead();
}

void EntryCpmWrite(/*c*/) {
    CpmWrite(c);
}

void EntryCpmPrSta(void) {
    CpmPrSta();
}

asm(" org 0x38");

void EntryInterrupt(void) {
    push_pop(a, bc, de, hl) {
        InterruptHandler();
    }
    enable_interrupts();
}

/* Буфер должен располагаться в одной 256-байтной странице */

uint8_t key_buffer[KEY_BUFFER_SIZE];

/* Далее находится стек до 100h */

asm(" org 0x100");
