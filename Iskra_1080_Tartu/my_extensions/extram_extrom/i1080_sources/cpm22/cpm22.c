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
#include "../bios/tools/opcodes_8080.h"
#include "../memory_layout.h"
#include "dpb.h"

/*** Настройка накопителей ***/

#define STORAGE_COUNT 3

static const uint8_t A_FIXED = 1;
static const uint16_t A_128_PER_TRACK = 0xFFFF; /* Max */
static const uint16_t A_BLOCK_SIZE = 1024;
static const uint8_t A_DIRECTORY_BLOCKS = 1;
static const uint32_t A_ROM_SIZE = 0x10000;
static const uint32_t A_RAM_SIZE = 0x8000;
static const uint32_t A_BLOCK_COUNT = (A_ROM_SIZE / A_BLOCK_SIZE + A_RAM_SIZE / A_BLOCK_SIZE - A_DIRECTORY_BLOCKS);

static const uint8_t B_TRACKS_COUNT = 80;
static const uint8_t B_SIDE_COUNT = 2;
static const uint8_t B_SECTOR_PER_TRACK = 9;
static const uint16_t B_SECTOR_SIZE = 512;
static const uint8_t B_FIXED = 0;
static const uint16_t B_128_PER_TRACK = (B_SECTOR_PER_TRACK * (B_SECTOR_SIZE / 128));
static const uint16_t B_BLOCK_SIZE = 2048;
static const uint8_t B_DIRECTORY_BLOCKS = 2;
static const uint32_t B_BLOCK_COUNT =
    ((B_SIDE_COUNT * B_TRACKS_COUNT * B_SECTOR_PER_TRACK * B_SECTOR_SIZE) / B_BLOCK_SIZE);

static const uint8_t C_TRACKS_COUNT = 80;
static const uint8_t C_SIDE_COUNT = 2;
static const uint8_t C_SECTOR_PER_TRACK = 9;
static const uint16_t C_SECTOR_SIZE = 512;
static const uint8_t C_FIXED = 0;
static const uint16_t C_128_PER_TRACK = (C_SECTOR_PER_TRACK * (C_SECTOR_SIZE / 128));
static const uint16_t C_BLOCK_SIZE = 2048;
static const uint8_t C_DIRECTORY_BLOCKS = 2;
static const uint32_t C_BLOCK_COUNT =
    ((C_SIDE_COUNT * C_TRACKS_COUNT * C_SECTOR_PER_TRACK * C_SECTOR_SIZE) / C_BLOCK_SIZE);

/*** CP/M ***/

asm(" .org cpm_base");  // TODO: Const from layout
asm(" .include \"cpm22/cpm22.inc\"");

extern uint8_t CCPSTACK[0] __address("CCPSTACK");
extern uint8_t INBUFF[0] __address("INBUFF");
extern uint16_t INPOINT __address("INPOINT");
extern uint8_t TDRIVE __address("TDRIVE");
extern uint16_t TBUFF __address("TBUFF");
extern uint8_t IOBYTE __address("IOBYTE");
extern uint8_t USERNO __address("USERNO");

void WBOOT() __address("WBOOT");
void FBASE() __address("FBASE");
void COMMAND() __address("COMMAND");

/*** Описание накопителей для CP/M и буферы ***/

static struct DPB a_dpb = MAKE_DPB(A_128_PER_TRACK, A_BLOCK_SIZE, A_BLOCK_COUNT, A_DIRECTORY_BLOCKS, A_FIXED);
static uint8_t a_csv[CSV_SIZE(A_FIXED, A_BLOCK_SIZE, A_DIRECTORY_BLOCKS)];
static uint8_t a_alv[ALV_SIZE(A_BLOCK_COUNT)];

#if STORAGE_COUNT >= 2
static struct DPB b_dpb = MAKE_DPB(B_128_PER_TRACK, B_BLOCK_SIZE, B_BLOCK_COUNT, B_DIRECTORY_BLOCKS, B_FIXED);
static uint8_t b_csv[CSV_SIZE(B_FIXED, B_BLOCK_SIZE, B_DIRECTORY_BLOCKS)];
static uint8_t b_alv[ALV_SIZE(B_BLOCK_COUNT)];
#endif

#if STORAGE_COUNT >= 3
static struct DPB c_dpb = MAKE_DPB(C_128_PER_TRACK, C_BLOCK_SIZE, C_BLOCK_COUNT, C_DIRECTORY_BLOCKS, C_FIXED);
static uint8_t c_csv[CSV_SIZE(C_FIXED, C_BLOCK_SIZE, C_DIRECTORY_BLOCKS)];
static uint8_t c_alv[ALV_SIZE(C_BLOCK_COUNT)];
#endif

#if STORAGE_COUNT >= 4
static struct DPB d_dpb = MAKE_DPB(D_128_PER_TRACK, D_BLOCK_SIZE, D_BLOCK_COUNT, D_DIRECTORY_BLOCKS, D_FIXED);
static uint8_t d_csv[CSV_SIZE(D_FIXED, D_BLOCK_SIZE, D_DIRECTORY_BLOCKS)];
static uint8_t d_alv[ALV_SIZE(D_BLOCK_COUNT)];
#endif

#if STORAGE_COUNT < 1 || STORAGE_COUNT > 4
#error Incorrect STORAGE_COUNT
#endif

static uint8_t dirbuf[CPM_SECTOR_SIZE];

struct DPH dphlist[STORAGE_COUNT] = {
    {0, 0, dirbuf, &a_dpb, sizeof(a_csv) ? a_csv : 0, a_alv},
#if STORAGE_COUNT >= 2
    {0, 0, dirbuf, &b_dpb, sizeof(b_csv) ? b_csv : 0, b_alv},
#endif
#if STORAGE_COUNT >= 3
    {0, 0, dirbuf, &c_dpb, sizeof(c_csv) ? c_csv : 0, c_alv},
#endif
#if STORAGE_COUNT >= 4
    {0, 0, dirbuf, &d_dpb, sizeof(d_csv) ? d_csv : 0, d_alv},
#endif
};

/*** Запуск CP/M ***/

static void InterruptHandler(void);
static void BiosCall(/* de - entry point, bc - optional value */);
static void RunCommand(/* c  - текущий диск  */);

extern uint16_t arg_dma;

void BiosRun(/* c - текущий диск */) {
    // Выбрать сраницы ОЗУ для CP/M
    disable_interrupts();
    out(PORT_WINDOW(0), a = PAGE_CPM_0);
    out(PORT_WINDOW(1), a = PAGE_CPM_1);
    out(PORT_WINDOW(2), a = PAGE_CPM_2);
    /* Окно 3 уже выбрано */

    /* Установка обработчика прерываний */
    *0x38 = a = OPCODE_JP;          // TODO заменить на константу
    *0x39 = hl = InterruptHandler;  // TODO заменить на константу
    sp = CCPSTACK;
    enable_interrupts();

    /* Запуск с очищенной командной строкой */
    INBUFF[1] = (a ^= a);

    RunCommand(c);
}

/* Точка входа для выполнения команды указанной в ком. строке */

static void RunCommand(/* c  - текущий диск  */) {
    /* Восстановление стандартных переменных CP/M */
    INPOINT = hl = INBUFF + 2;
    TDRIVE = a = c;
    *0 = a = OPCODE_JP;  // TODO заменить на константу
    *1 = hl = WBOOT;     // TODO заменить на константу
    *5 = a;              // TODO заменить на константу
    *6 = hl = FBASE;     // TODO заменить на константу
    arg_dma = hl = TBUFF;
    IOBYTE = a = 0x81;
    COMMAND();
}

/*** Обработчик прерывания ***/

extern uint8_t interrupt_handler_sp[0];

static void InterruptHandler(void) {
    /* Save CPU state, switch stack and memory page */
    push_pop(a, hl) {
        interrupt_handler_sp[1] = ((hl = 0) += sp);
        sp = BIOS_STACK;

        out(PORT_WINDOW(0), a = PAGE_BIOS_0);
        out(PORT_WINDOW(1), a = PAGE_BIOS_1);

        push_pop(bc, de) {
            BiosEntryInterrupt();
        }

        out(PORT_WINDOW(0), a = PAGE_CPM_0);
        out(PORT_WINDOW(1), a = PAGE_CPM_1);

    interrupt_handler_sp:
        sp = 0;
    }

    enable_interrupts();
}

/*** Передача вызовов из CP/M в BIOS ***/

void CallHl(/* hl */) {
    return hl();
}

static void BiosCall(/* de - entry point, bc - optional value */);

uint16_t arg_dma;

void BiosBoot(void) {
    disable_interrupts();
    out(PORT_WINDOW(0), a = 0xFF);
    0();  // TODO заменить на константу
}

void BiosWBoot(void) {
    BiosCall(de = BiosEntryWBoot, c = a = TDRIVE);
}

void BiosConst(void) {
    push(de);
    BiosCall(de = BiosEntryConSt);
}

void BiosConin(void) {
    push(de);
    BiosCall(de = BiosEntryConIn);
}

void BiosConOut(void) {
    push(de);
    BiosCall(de = BiosEntryConOut, c);
}

void BiosList(void) {
    push(de);
    BiosCall(de = BiosEntryList, c);
}

void BiosPunch(void) {
    push(de);
    BiosCall(de = BiosEntryPunch, c);
}

void BiosReader(void) {
    push(de);
    BiosCall(de = BiosEntryReader);
}

void BiosHome(void) {
    push_pop(hl) {
        common_track = hl = 0;
    }
}

void BiosSelDsk(/* c - storage */) {
    a = c;
    hl = 0; /* Return value for incorrect storage number */
    if (a >= STORAGE_COUNT)
        return;

    common_storage = a;

    /* Calculate DPH address */
    l = a;
    hl *= sizeof(struct DPH);
    push_pop(de) {
        hl += (de = dphlist);
        push_pop(hl) {
            hl += (de = 10); /* 10 == offsetof(struct DPH, dpb) */
            e = *hl;
            hl++;
            d = *hl;
            swap(hl, de);
            common_dpb = hl;

            h = a;
            a = USERNO;
            a <<= 4;
            a += h;
            TDRIVE = a;
        }
    }
}

void BiosSetTrk(/* bc - track number */) {
    push_pop(hl) {
        h = b;
        l = c;
        common_track = hl;
    }
}

void BiosSetSec(/* bc - sector number */) {
    push_pop(hl) {
        h = b;
        l = c;
        common_sector_128 = hl;
    }
}

void BiosSetDma(/* bc - i/o buffer address */) {
    push_pop(hl) {
        h = b;
        l = c;
        arg_dma = hl;
    }
}

static void BiosRead2(void) {
    push(de);
    BiosCall(de = BiosEntryRead);
}

void BiosRead(void) {
    BiosRead2();

    /* Check error */
    if (a != 0)
        return;

    /* Copy data from the common memory */
    push_pop(de, hl) {
        de = common_buffer;
        hl = arg_dma;
        do {
            *hl = a = *de;
            hl++;
            e++;
        } while (flag_nz);
    }

    /* No error */
    a ^= a;
}

void BiosWrite(/* c - write mode */) {
    push(de);

    /* Copy data to the common memory */
    push_pop(hl) {
        de = common_buffer;
        hl = arg_dma;
        do {
            *de = a = *hl;
            hl++;
            e++;
        } while (flag_nz);
    }

    /* System call */
    BiosCall(de = BiosEntryWrite);
}

void BiosPrStat(void) {
    push(de);
    BiosCall(de = BiosEntryPrStat);
}

extern uint8_t bios_call_sp[0];

static void BiosCall(/* de - entry point, bc - optional value */) {
    push_pop(hl) {
        /* Save stack pointer */
        bios_call_sp[1] = ((hl = 0) += sp);

        /* Switch RAM and stack pointer */
        disable_interrupts();
        sp = BIOS_STACK;
        out(PORT_WINDOW(0), a = PAGE_BIOS_0);
        out(PORT_WINDOW(1), a = PAGE_BIOS_1);
        enable_interrupts();

        /* System call */
        swap(hl, de);
        push_pop(bc) {
            CallHl(hl);
        }

        /* Switch RAM and stack pointer */
        disable_interrupts();
        out(PORT_WINDOW(0), a = PAGE_CPM_0);
        out(PORT_WINDOW(1), a = PAGE_CPM_1);
    bios_call_sp:
        sp = 0;
        enable_interrupts();

        /* Return value */
        a = d;
    }
    pop(de);
}

// TODO: static_assert

asm {
    .if $ + 0x100 <= common
      Incorrect cpm_base
    .endif
    .if $ > common
      Incorrect cpm_base
    .endif
    savebin "cpm22.bin", CBASE, $ - CBASE
}
