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

/* ВНИМАНИЕ! Вызывающая функция должна выполнить enable_interrupts(). */

void FloppyReadWrite(/* c - FLOPPY_READ/FLOPPY_WRITE */) {
    /* Вычисление номера дисковода и адреса переменной содержащий дорожку дисковода */
    d = PORT_FLOPPY__SEL_A | PORT_FLOPPY__NEG_TST;
    hl = floppy_current_tracks;
    a = storage_buffer_storage;
    a--;
    if (flag_nz) { /* Накопитель C: */
        d = PORT_FLOPPY__SEL_B | PORT_FLOPPY__NEG_TST;
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

    /* Остановка прерываний */
    disable_interrupts();

    /* Запуск двигателя */
    a |= PORT_FLOPPY__NEG_HALT;
    out(PORT_FLOPPY, a);

    /* Ожидаение готовности дисковода */
    push_pop(hl) {
        FloppyWaitReady();
    }
    if (flag_nz)
        return;

    /* Если нужно выбрать нулевую дорожку, то всегда выполяем команду 0 - Восстановление */
    a = b;
    if (a == 0)
        goto FloppyReadWrite1;

    /* Если нужная дорожка выбрана, то пропускам команду перемещения головки */
    a = *hl;
    out(PORT_VG93_TRACK, a);
    if (a != b) {
        /* Выполяем команду 10 - Поиск, максимальная скорость */
        a = b;
        out(PORT_VG93_DATA, a);
        a = 0x10;
    FloppyReadWrite1:
        out(PORT_VG93_COMMAND, a);
        *hl = -1; /* Если произойдет ошибка позиционирования, то искать заново */
        push_pop(hl) {
            FloppyWaitReady(); /* Не изменяет BC */
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
            a = in(PORT_FLOPPY_WAIT);
            *hl = a = in(PORT_VG93_DATA);
            hl++;
            c--;
            a = in(PORT_FLOPPY_WAIT);
            *hl = a = in(PORT_VG93_DATA);
            hl++;
        } while (flag_nz);
    } else {
        /* Цикл отправки данных в К1818ВГ93 */
        do {
            a = in(PORT_FLOPPY_WAIT);
            out(PORT_VG93_DATA, a = *hl);
            hl++;
            c--;
            a = in(PORT_FLOPPY_WAIT);
            out(PORT_VG93_DATA, a = *hl);
            hl++;
        } while (flag_nz);
    }

    /* Ожидание завершения команды К1818ВГ93 и получение кода ошибки в L и флаге Z */
    FloppyWaitReady();

    /* Выключение светодиода на дисководе (снятие PORT_FLOPPY__SEL_A или _B)*/
    out(PORT_FLOPPY, a = PORT_FLOPPY__NEG_TST);

    /* Анализ ошибки */
    a = l;
    if (flag_nz)                  /* Таймаут */
        return;                   /* Тут a = 0xFF */
    a &= 2 + 4 + 8 + 0x10 + 0x40; /* Запрос данных, потеря данных, CRC, сектор не найден, защищено от записи */
}
