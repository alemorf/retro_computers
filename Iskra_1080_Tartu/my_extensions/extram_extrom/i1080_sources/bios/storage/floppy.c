/*
 * Iskra 1080 Extension card firmware
 * Floppy drive controller
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

#include "floppy.h"
#include <cmm.h>
#include "512.h"
#include "../../i1080.h"

static const uint8_t FLOPPY_TIMEOUT = 2;
static const uint8_t TRACKS_COUNT = 80; /* TODO: Поддержка 40 дорожечного дисковода */

static uint8_t floppy_current_tracks[2];

/* Ожидание готовности дисковода и завершения команды выполняемой К1818ВГ93 */
/* Регистровая пара BC сохраняется */

static void FloppyWaitReady(void) {
    h = FLOPPY_TIMEOUT;
    do {
        de = 0;
        do {
            /* Выход с флагом Z и регистром A содержащим состояние КР181ВГ93, */
            /* если команда завершена и дисковод готов */
            a = in(PORT_VG93_COMMAND);
            l = a;
            a &= 0x81;
            a = l;
            if (flag_z)
                return;
            de--;
        } while (flag_nz((a = d) |= e));
    } while (flag_nz(h--));
    a--; /* Выход с флагом NZ и A = 0FFh, если таймаут */
}

void FloppyReadWrite(/* c - FLOPPY_READ/FLOPPY_WRITE */) {
    /* Вычисление номера дисковода и адреса переменной содержащий дорожку дисковода */
    d = PORT_FLOPPY__SEL_A;
    hl = floppy_current_tracks;
    a = storage_buffer_storage;
    a--;
    if (flag_nz) {
        d = PORT_FLOPPY__SEL_B;
        hl++;
    }

    /* Вычисление номера стороны (D) и номера дорожки (B) */
    a = storage_buffer_track;
    b = a;
    a -= TRACKS_COUNT;
    if (flag_nc) {
        b = a;
        c = ((a = c) |= 8); /* Номер стороны в коде команды (C) */
        d = ((a = d) |= PORT_FLOPPY__SIDE);
    }

    /* Выбор дисковода, стороны */
    a = d;
    out(PORT_FLOPPY, a);

    /* Запуск двигателя */
    a |= PORT_FLOPPY__HALT;
    out(PORT_FLOPPY, a);

    /* Ожидаение готовности дисковода */
    push_pop(hl) {
        FloppyWaitReady();
    }
    if (flag_nz)
        return;

    /* Если нужная дорожка выбрана, то пропускам команду перемещения головки */
    a = *hl;
    out(PORT_VG93_TRACK, a);
    if (a != b) {
        /* Если нужно выбрать нулевую дорожку, то выполяем команду 0 - Восстановление */
        if ((a = b) != 0) {
            /* Выполяем команду 10 - Поиск, максимальная скорость */
            out(PORT_VG93_DATA, a);
            a = 0x10;
        }

        /* Если произойдет ошибка позиционирования, то искать заново */
        *hl = -1;

        /* Выполнение команды выбора дорожки */
        out(PORT_VG93_COMMAND, a);
        push_pop(hl) {
            FloppyWaitReady();
        }
        if (flag_nz)
            return;
        a &= 8 + 0x10; /* Ошибка поиска + Ошибка CRC */
        if (flag_nz)
            return;

        /* Сохранение дорожки */
        *hl = b;
    }

    /* Передача номера сектора */
    a = storage_buffer_sector_512;
    a++;
    out(PORT_VG93_SECTOR, a);

    /* Выполнение команды чтения или записи */
    hl = storage_buffer; /* Адрес буфера */

    a = c;
    c = 0; /* Счетчик цикла */
    out(PORT_VG93_COMMAND, a);
    a &= 0x20;
    if (flag_z) {
        /* Цикл получения данных от К1818ВГ93 */
        do {
            a = in(PORT_FLOPPY);
            *hl = a = in(PORT_VG93_DATA);
            hl++;
            c--;
            a = in(PORT_FLOPPY);
            *hl = a = in(PORT_VG93_DATA);
            hl++;
        } while (flag_nz);
    } else {
        /* Цикл отправки данных в К1818ВГ93 */
        do {
            a = in(PORT_FLOPPY);
            out(PORT_VG93_DATA, a = *hl);
            hl++;
            c--;
            a = in(PORT_FLOPPY);
            out(PORT_VG93_DATA, a = *hl);
            hl++;
        } while (flag_nz);
    }

    /* Получение кода ошибки от К1818ВГ93 и выход */
    FloppyWaitReady();
    if (flag_nz)
        return;
    a &= 2 + 4 + 8 + 0x10 + 0x40; /* Запрос данных, потеря данных, CRC, сектор не найден, защищено от записи */
}
