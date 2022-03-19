#include "common.h"

extern uint8_t outputFileBegin = 0;

#org 0

void startMonitor()
{
    // Отключение ПЗУ
    out(ioSysConfig, a = ioSysConfigDisableRom);

    // Запуск
    return ramMonitorStart();
    noreturn;
}

const int ramTestA     = 0x55;
const int ramTestB     = ramTestA ^ 0xFF;
const int ramTestStart = 0xC000;
const int ramTestSize  = 0x4000;

#org 7

void highRamTest()
{
    // Отключение ПЗУ
    out(ioSysConfig, a = ioSysConfigDisableRom);

    // Запись A в каждую ячейку памяти
    sp = [ramTestStart + ramTestSize]; // Начальный адрес
    bc = [(ramTestA << 8) | ramTestA]; // Константа для заливки
    de = [ramTestSize / 2048]; // Циклов. D = 0. E = 28.
    do
    {
        do // В этом цикле вы заполним 2048 байта
        {
            push(bc);
            push(bc);
            push(bc);
            push(bc);
        } while(flag_nz d--);
    } while(flag_nz e--);

    // Проверка записанного A и замена его на B
    d = [ramTestSize / 256];
    bc = [(ramTestB << 8) | ramTestA]; // Константы для проверки и изменения
    hl = ramTestStart;
    do
    {
        do
        {
            a = *hl;
            if (a != c) return ramTestError(a, c, hl);
            *hl = b;
            l++;
            a = *hl;
            if (a != c) return ramTestError(a, c, hl);
            *hl = b;
        } while(flag_nz l++);
        h++;
    } while(flag_nz d--);

    // Проверка записанного B
    d = [ramTestSize / 256];
    hl = ramTestStart;
    c = b; // Используется в функции ramTestError
    do
    {
        do
        {
            a = *hl;
            if (a != c) return ramTestError(a, c, hl);
            l++;
            a = *hl;
            if (a != c) return ramTestError(a, c, hl);
        } while(flag_nz l++);
        h++;
    } while(flag_nz d--);

    // Включение ПЗУ
    out(ioSysConfig, a = ioSysConfigEnableRom);

    // Продолжение загрузки
    return romTestFDone();
    noreturn;
}

void ramTestError(a, c, hl)
{
    // Включение ПЗУ
    b = a;
    out(ioSysConfig, a = ioSysConfigEnableRom);
    a = b;

    // Вывод ошибки
    return romTestFError(a, c, hl);
    noreturn;
}
