#include "bios.h"
#include "keyboard.h"

asm(" org 0");

void Reboot() {
    return main();
}

/* Тут сохраняется размер прошивки */

extern uint16_t file_end;
uint16_t sector_count = (&file_end + 127) / 128;

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
    return CpmWrite(); // TODO: Оптимизировать
}

void EntryCpmPrSta() {
    return CpmPrSta();
}

asm(" org 0x38");

void EntryInterrupt() {
    push_pop(a, bc, de, hl)
        InterruptHandler();
    EnableInterrupts();
}

/* Буфер должен распологаться в одной 256-байтной странице */

uint8_t key_buffer[KEY_BUFFER_SIZE];

/* Далее находится стек */

asm(" org 0x100");
