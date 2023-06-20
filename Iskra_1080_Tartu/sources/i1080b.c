/* Реверс-инженеринг ПЗУ компьютера Искра 1080 Тарту
 * В процессе
 * (c) 25-02-2023 Aleksey Morozov
 */

#include "cmm.h"
#include "i1080.h"
#include "i1080_internal.h"

const int CPM_DMA_ADDRESS = 0x80;
const int CPM_BIOS_ADDRESS = 0xB200;
const int CPM_SECTOR_COUNT = 44;
const int CPM_LOAD_ADDRESS = 0x9C00;
const int NETWORK_HEADER_SIZE = 8;
const int SECTOR_SIZE = 128;

void Rst0(...);
void ReadId62(...);
void DelayC(...);
void SendPacket(...);
void RecvPacket(...);
void DiskRead4(...);
void DiskRead3(...);
void DiskRead2(...);
void DiskReadWrite3(...);
void SendByte(...);

extern uint16_t vEntryPointsForB200[];
extern uint8_t end_copy;

extern uint8_t vBootSector __address(0xB243);

asm(" org 0xC000");

void DiskReadWrite(...) {
    out(PORT_EXT_DATA_OUT, a = 0xFF);
    out(PORT_SET_CU3, a);

    /* Если сеть не подключена, то перезагрузка */
    a = In(PORT_TAPE_AND_IDX2);
    a &= PORT_TAPE_AND_IDX2_ID1_2;
    if (flag_z) return Rst0();

    /* Лишняя команда */
    a ^= a;

    /* Чтение своего адреса */
    a = In(PORT_TAPE_AND_IDX2);
    a &= 0x3C;
    CarryRotateRight(a, 2);

    /* Если свой адрес нулевой, то перезагрузка */
    if (flag_z((a = b) |= b)) return Rst0();

    /* Сохраняем свой адрес в заголовок пакета */
    vPacketAddress = a;

    /* Сохраняем длину пакета */
    d = NETWORK_HEADER_SIZE;
    if ((a = vPacketCommandResult) != 0)
        d = NETWORK_HEADER_SIZE + SECTOR_SIZE;
    *(hl = vPacketSize) = d;

    /* Сохраняем направление = от клиента */
    vPacketDirection = (a ^= a);

    do {
        do {
            ReadId62();
        } while (flag_z);
loc_C836:
        a = In(PORT_EXT_IN_DATA);
    } while(a != b);

    do {
        ReadId62();
    } while(flag_nz);

    out(PORT_SET_CU2, a);
    DelayC(c = 5);
    out(PORT_RESET_CU2, a);
    DelayC(c = 10);
    ReadId62();
    if (flag_nz) goto loc_C836;

    de = &vPacketSize;
    hl = vBiosDma;
    swap(hl, de);
    SendPacket();

    de = &vPacketSize;
    hl = vBiosDma;
    swap(hl, de);
    RecvPacket();

    if (flag_z) {
        a = vPacketAddress;
        if (a == b) {
            a = vPacketDirection;
            if (a == 0) {
                vDiskResult = a = vPacketCommandResult;
                return;
            }
        }
    }
    vDiskResult = a = 0x0F;
}

void ReadId62() {
    a = In(PORT_TAPE_AND_IDX2);
    a &= PORT_TAPE_AND_IDX2_ID6_2;
}

void MemcpyHlBcDe2(...) {
    for (;;) {
        if ((a = c) == e)
            if ((a = b) == d)
                return;
        *hl = a = *bc;
        bc++;
        hl++;
    }
}

void DelayC(...) {
    do {
        c--;
    } while(flag_nz);
}

void CopyEntryPoints(...) {
    bc = &vEntryPointsForB200;
    de = &end_copy;
    hl = CPM_BIOS_ADDRESS;
    MemcpyHlBcDe2();
    vCpmDisk = (a ^= a);
}

void DiskInit2(...) {
    vBiosReadWriteOpcode = a = OPCODE_RET;
    vVideoTextWidth = a = 64;
    vKeyboardLayout = hl = &bKeybaordEnglishLayout;
    *3 = (a ^= a); // TODO
    vKeyboardCapsLock = a;
    vVideoEscCursorState = a;
    vVideoEscState = a;
    vInputOpcode = a = OPCODE_RET;
    vPrintOpcode = a;
    vInputAddress = hl = &RealInput;
    vPrintAddress = hl = &VideoPrint;
}

void DiskInit3(...) {
    vDisk = a = vCpmDisk;
    BiosSetDsk(c = 0);
    BiosHome();
    BiosSetTrk(bc = 0);
    BiosSetSec();
    bc = &vBootSector;
    BiosSetDma();
    DiskRead2();
}

void LoadCpm(...) {
    b = CPM_SECTOR_COUNT;
    c = 0;
    d = 1;
    hl = CPM_LOAD_ADDRESS;
    for (;;) {
        push_pop(bc, de) {
            push(hl);
            c = d;
            b = 0;
            BiosSetSec();
            pop(bc);
            push(bc);
            BiosSetDma();
            DiskRead2();
            if (a != 0) return BiosWarmBoot();
            pop(hl);
            hl += (de = SECTOR_SIZE);
        }

        /* Уменьшаем счетчик оставшихся секторов */
        b--;
        if (flag_z) break;

        /* Следующий сектор */
        d++;

        /* Если это был последний сектор на дорожке, то продолжаем с 0 сектора 1 дорожки */
        if ((a = vBootSector) != d) continue;
        d = 0;
        push_pop(bc) {
            BiosSetTrk(bc = 1);
        }
    }

    vResetOpcode = a = OPCODE_RET;
    vResetAddress = hl = &BiosWarmBoot;
    *5 = a; /* TODO */
    *6 = hl = 0xA406;
    BiosSetDma(bc = CPM_DMA_ADDRESS);
    BiosSetDsk(c = a = vDisk);
    c = a = vCpmDisk;
}

void BiosList2(...) {
    /* Инвертировать A */
    Invert(a);

    push_pop(a) {
        /* Сбросить CU4 */
        out(PORT_RESET_CU4, a);

        /* Ждем, пока ID13 = 0 */
        do {
            a = In(PORT_TAPE_AND_IDX2);
            a &= PORT_TAPE_AND_IDX2_ID3_2;
        } while(flag_z);
    }

    /* Записываем данные */
    out	(PORT_EXT_DATA_OUT, a);

    /* Установить CU4 */
    out (PORT_SET_CU4, a);

    /* Ждем, пока ID13 = 1 */
    do {
        a = In(PORT_TAPE_AND_IDX2);
        a &= PORT_TAPE_AND_IDX2_ID3_2;
    } while(flag_nz);

    /* Сбросить CU4 */
    out(PORT_RESET_CU4, a);
}

void DiskRead2(...) {
    a = 8;
    do {
        vDiskTries = a;
        DiskRead3();
        if (flag_z(a |= a)) return;
        a = vDiskTries;
    } while(flag_nz(a--));
    a = 1;
}

void MemcpyHlBcDe1(...) {
    for(;;) {
        if ((a = c) == e)
            if ((a = b) == d)
                return;
        *hl = a = *bc;
        bc++;
        hl++;
    }
}

void DiskRead3() {
    return DiskReadWrite3(a = 0);
}

void DiskWrite3() {
    return DiskReadWrite3(a = 1);
}

void DiskReadWrite3() {
    vPacketCommandResult = a;
    DiskReadWrite();
    a = vDiskResult;
}

uint16_t vEntryPointsForB200[] = {
    &BiosBoot,
    &BiosWarmBoot,
    &BiosConst,
    &BiosWaitKey,
    &BiosPutch,
    &BiosList,
    &BiosAuxOut,
    &BiosAuxIn,
    &BiosHome,
    &BiosSetDsk,
    &BiosSetTrk,
    &BiosSetSec,
    &BiosSetDma,
    &BiosRead,
    &BiosWrite,
    &BiosListSt,
    &BiosSectTran
};

uint8_t dph0[] =  {
    0, 0, 0, 0, 0, 0, 0, 0, 
    0xC3, 0xB2, 
    0x43, 0xB2, 
    0x43, 0xB3,
    0x64, 0xB3
};

uint8_t dpb0[] = {
    0, // sectors per track
    0,
    3,
    7,
    0,
    0,
    0,
    0x3F,
    0,
    0xC0,
    0,
    0x10,
    0,
    2,
    0
};

uint8_t end_copy;

void SendPacket(...) {
    push_pop(hl, de, bc) {
        /* Единица на CU3 */
        Out(PORT_SET_CU3, a);
        /* Отправка пакета */
        swap(de, hl);
        c = a = *de; /* Первый байт пакета содержит длину */
        b = 0; /* Контрольная сумма */
        for (;;) {
            SendByte(a = *de);
            c--;
            a = c;
            if (flag_z) break;
            if (a != SECTOR_SIZE) continue;
            swap(de, hl);
        }
        /* Отправка контрольной суммы */
        SendByte(a = b);
    }
    /* Ноль на CU3 */
    out(PORT_RESET_CU3, a);
    /* FF на выход данных */
    out(PORT_EXT_DATA_OUT, a = 0xFF);
}

void SendByte(...) {
    /* Отправка данных */
    Invert(a);
    Out(PORT_EXT_DATA_OUT, a);
    /* Единица на CU4 */
    Out(PORT_SET_CU4, a);
    Invert(a);
    b = (a ^= b);
    swap(*sp, hl); /* Задержка */
    swap(*sp, hl); /* Задержка */
    /* Ноль на CU4 */
    Out(PORT_RESET_CU4, a);
    de++;
    swap(*sp, hl); /* Задержка */
    swap(*sp, hl); /* Задержка */
    push(bc); /* Задержка */
    pop(bc); /* Задержка */
    a = a; /* Задержка */
}

void RecvByteAndCalcCrc() {
    /* Ожидание единицы на ID2-7 */
    do {
        a = In(PORT_TAPE_AND_IDX2);
        a &= PORT_TAPE_AND_IDX2_ID7_2;
    } while(flag_z);
    /* Получение данных */
    a = In(PORT_EXT_IN_DATA);
    push_pop(a) {
        /* Расчет контрольной суммы */
        b = (a ^= b);
        /* Ожидание нуля на ID2-7 */
        do {
            a = In(PORT_TAPE_AND_IDX2);
            a &= PORT_TAPE_AND_IDX2_ID7_2;
        } while(flag_nz);
    }
}

void RecvPacket(...) {
    push_pop(hl, de, bc) {
        /* Единица на CU3 */
        Out(PORT_SET_CU3, a);
        b = 0;
        Swap(hl, de);
        /* Получение байта с длиной */
        RecvByteAndCalcCrc();
        *de = a;
        de++;
        /* Получение остальных байт */
        a--;
        c = a;
        for (;;) {
            RecvByteAndCalcCrc();
            *de = a;
            de++;
            c--;
            a = c;
            if (flag_z) break;
            if (a != SECTOR_SIZE) continue;
            swap(hl, de);
        }
        /* Получение контрольной суммы */
        RecvByteAndCalcCrc();
        (a = b) |= a;
    }
    /* Ноль на CU3 */
    Out(PORT_RESET_CU3, a);
}

asm(" savebin \"i1080.c.bin\", 0xC000, 0xD000");
