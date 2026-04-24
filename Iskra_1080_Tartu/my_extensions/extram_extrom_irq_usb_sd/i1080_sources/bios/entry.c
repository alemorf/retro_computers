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

#include "bios.h"
#include "keyboard.h"

asm(" org 0");

void Reboot() {
    return main();
}

/* Тут сохраняется размер прошивки */

extern uint16_t file_end;
uint16_t sector_count = ((uintptr_t)&file_end + 127) / 128;

/* Точки входа */

void CpmInterrupt() {
    return InterruptHandler();
}

void EntryCpmWBoot() {
    return CpmWBoot();
}

void EntryCpmConst() {
    return CpmConst();
}

void EntryCpmConin() {
    return CpmConin();
}

void EntryCpmConout() {
    return CpmConout();
}

void EntryCpmList() {
    return CpmList();
}

void EntryCpmPunch() {
    return CpmPunch();
}

void EntryCpmReader() {
    return CpmReader();
}

void EntryCpmSelDsk() {
    return CpmSelDsk();
}

void EntryCpmSetTrk() {
    return CpmSetTrk();
}

void EntryCpmSetSec() {
    return CpmSetSec();
}

void EntryCpmRead() {
    return CpmRead();
}

void EntryCpmWrite() {
    return CpmWrite();  // TODO: Оптимизировать
}

void EntryCpmPrSta() {
    return CpmPrSta();
}

asm(" org 0x38");

void EntryInterrupt() {
    push_pop(a, bc, de, hl) {
        InterruptHandler();
    }
    enable_interrupts();
}

/* Буфер должен распологаться в одной 256-байтной странице */

uint8_t key_buffer[KEY_BUFFER_SIZE];

/* Далее находится стек */

asm(" org 0x100");
