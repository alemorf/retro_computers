#include "bios.h"
#include "storage.h"
#include "mulu16.h"

uint8_t drive_number = 0;
uint16_t drive_track = 0;
uint8_t drive_sector = 0;
uint16_t drive_dpb = &cpm_dph_a;

void WaitSd() {
    do {
        a = in(PORT_SD_RESULT);
        // TODO: Timeout
    } while(a == SD_RESULT_BUSY);
}

void CpmSelDsk() {
    /* Чтение нулевого сектора */
    WaitSd();
    out(PORT_SD_SIZE, a = SD_COMMAND_READ_SIZE);
    out(PORT_SD_DATA, a = SD_COMMAND_READ);
    a = c;
    a++;
    a++;
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a ^= a);
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a);
    WaitSd();
    if (flag_nz(a |= a)) {
        d = a; /* Error code */
        return;
    }

    /* Адрес параметров диска A: или B: */
    a = c;
    hl = *(&cpm_dph_a + 10);
    if (a == 1)
        hl = *(&cpm_dph_b + 10);

    /* Обновляем локальные переменные */
    drive_number = a;
    drive_dpb = hl;
    /* Сохраняем параметры */
    b = 15;
    do {
        *hl = a = in(PORT_SD_DATA);
        hl++;
    } while(flag_nz(b--));
    /* Без ошибок */
    d = 0;
}

void CpmSetTrk() {
    drive_track = hl = bc;
}

void CpmSetSec() {
    drive_sector = a = c;
}

void ReadWriteSd(...) {
    /* Send command */
    WaitSd();
    out(PORT_SD_SIZE, a = b);
    out(PORT_SD_DATA, a = c);
    a = drive_number;
    a++;
    a++;
    out(PORT_SD_DATA, a);

    /* de:hl = sector_per_track * drive_track + drive_sector */
    hl = drive_dpb;
    e = *hl;
    hl++;
    d = *hl;
    hl = drive_track;
    MulU16(hl, de);
    b = 0;
    c = a = drive_sector;
    hl += bc;
    if (flag_c)
        de++;

    /* Send offset */
    out(PORT_SD_DATA, a = l);
    out(PORT_SD_DATA, a = h);
    out(PORT_SD_DATA, a = e);
    out(PORT_SD_DATA, a = d);
}

void CpmRead() {
    ReadWriteSd(bc = (SD_COMMAND_READ_SIZE << 8) | SD_COMMAND_READ);
    WaitSd();
    if (flag_nz(a |= a)) {
        d = a; /* Error code */
        return;
    }
    hl = &cpm_dma_buffer;
    do {
        *hl = a = in(PORT_SD_DATA);
        l++;
    } while(flag_nz);
    d = 0; /* Error code - No error */
}

void CpmWrite() {
    ReadWriteSd(bc = (SD_COMMAND_WRITE_SIZE << 8) | SD_COMMAND_WRITE);
    hl = &cpm_dma_buffer;
    do {
        out(PORT_SD_DATA, a = *hl);
        l++;
    } while(flag_nz);
    WaitSd();
    d = a; /* Error code */
}

void ReadWriteConfig(...) {
    WaitSd();
    out(PORT_SD_SIZE, a = b);
    out(PORT_SD_DATA, a = c);
    a = 1;
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a ^= a);
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a);
    out(PORT_SD_DATA, a);
}

/* Прочитать настройки
 * Вход:
 *     hl - укзатель на настройки
 *     с - длина настроек от 1 до 127 байт
 * Выход:
 *     a - код ошибки, если 0, то ошибок нет.
 *     zf - устанвлен, елси ошибок нет
 */

void ReadConfig(...) {
    b = ((a = 128) -= c);
    if (flag_c) {
        a = 1; /* Превышена мксимальная длина настроек */
        return;
    }
    push_pop(hl, bc) {
        ReadWriteConfig(bc = (SD_COMMAND_READ_SIZE << 8) | SD_COMMAND_READ);
        WaitSd();
    }
    if (flag_nz(a |= a))
        return; /* a - error code, flag NZ */
    do {
        *hl = a = in(PORT_SD_DATA);
        hl++;
    } while(flag_nz(c--));
    do {
        a = in(PORT_SD_DATA);
    } while(flag_nz(b--));
    a ^= a; /* Error code - No error, flag Z */
}

/* Сохранить настройки
 * Вход:
 *     hl - укзатель на настройки
 *     с - длина настроек от 1 до 127 байт
 * Выход:
 *     a - код ошибки, если 0, то ошибок нет.
 */

void WriteConfig(...) {
    b = ((a = 128) -= c);
    push_pop(hl, bc) {
        ReadWriteConfig(bc = (SD_COMMAND_WRITE_SIZE << 8) | SD_COMMAND_WRITE);
    }
    do {
        out(PORT_SD_DATA, a = *hl);
        hl++;
    } while(flag_nz(c--));
    a ^= a;
    do {
        out(PORT_SD_DATA, a);
    } while(flag_nz(b--));
    WaitSd();
    a |= a; /* Для флага Z */
    /* a - error code */
}
