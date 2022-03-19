#include "common.h"

extern uint8_t outputFileBegin = &romTestF;

#org &romTestF

void entryPoints()
{
    return main();
    return ramTestDone();
    return ramTestError(a, c, hl);
    noreturn;
}

testHighRamStart:

asm("    incbin \"test0.bin\"");

testHighRamEnd:

const int ramTestA     = 0x55;
const int ramTestB     = ramTestA ^ 0xFF;
const int ramTestStart = 0x0000;
const int ramTestSize  = 0xC000;

uint8_t aProverka[] = { "prowerka" };
uint8_t aPzu[] = { "pzu" };

void main()
{
    // Настройка системного порта
    out(ioSysConfig, a = ioSysConfigValue);

    // Подключение ПЗУ к адресам 00000h..0FFFFh
    out(ioSysC, a = 0x7F);

    // Инициализация клавиатуры
    out(ioSysA, a = 0xFF);

    // Вывод сообщения на экран
    printString(hl = &ret1, de = &aProverka); ret1:

    // *** Тест ПЗУ ***

    sp = 0; // Начальный адрес
    de = [65536 / 2048]; // Циклов.
    hl = 0;
    do
    {
        do // В этом цикле мы суммируем 2048 байта
        {
            pop(bc);
            hl += bc;
            pop(bc);
            hl += bc;
            pop(bc);
            hl += bc;
            pop(bc);
            hl += bc;
        } while(flag_nz d--);
    } while(flag_nz e--);

    if (flag_nz (a = h) |= l)
    {
        printString(hl = &ret2, de = &aPzu); ret2:
        while () { }
    }

    // *** Тест нижней части ОЗУ ***

    // Подключение ОЗУ к адресам 0..0EFFFh, подключение ПЗУ к адресам 0D000h..0FFFFh
    out(ioSysC, a = 0xFF);

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

    // *** Тест верхней части ОЗУ ***

    // Копируем тест верхней части ОЗУ в ОЗУ
    hl = &testHighRamStart;
    de = &testHighRamEnd;
    bc = &ramTest0;
    do
    {
        *bc = a = *hl;
        bc++;
        hl++;
        if ((a = l) != e) continue;
    } while((a = h) != d);

    // Подключаем ОЗУ
    out(ioSysConfig, a = ioSysConfigEnableRam);

    // Запускаем тест верхней части ОЗУ.
    return ramTest0HighRamTest();
    noreturn;
}

void printString(hl, de)
{
    // Очистка экрана
    sp = &ramVideoEnd;
    b = c = (a ^= a);
    do
    {
        push(bc, bc, bc, bc);
    } while(flag_nz a--);

    bc = &ramVideo;
    do
    {
        *bc = a = *de;
        bc++;
        de++;
    } while(a != 0);
    goto hl;
    noreturn;
}

void ramTestError(a, c, hl)
{
    b = a;
    swap(hl, de);

    // Очистка экрана
    sp = &ramVideoEnd;
    h = l = (a ^= a);
    do
    {
        push(hl, hl, hl, hl);
    } while(flag_nz a--);

    // Вывод чисел: прочитали записали адрес
    sp = 0xE809;
    return printNum(a = c,  hl = &num9); num9:
    return printChr(a ^= a, hl = &num8); num8:
    return printNum(a = b,  hl = &num7); num7:
    return printHig(a = b,  hl = &num6); num6:
    return printChr(a ^= a, hl = &num5); num5:
    return printNum(a = e,  hl = &num4); num4:
    return printHig(a = e,  hl = &num3); num3:
    return printNum(a = d,  hl = &num2); num2:
    return printHig(a = d,  hl = &num1); num1:

    // Бесконечный цикл
    while ()
    {
    }

    noreturn;
}

void printHig(a, hl)
{
    a >>r= 4;
    noreturn;
}

void printNum(a, hl)
{
    a &= 0x0F;
    a += '0';
    if (a >= ['9' + 1])
        a += ['A' - '0' - 10];
    noreturn;
}

void printChr(a, hl)
{
    push(a);
    sp++;
    goto hl;
    noreturn;
}

// Проверка памяти завершена

void ramTestDone()
{
    // Отключаем ОЗУ
    out(ioSysConfig, a = ioSysConfigDisableRam);

    // Копируем Монитор из ПЗУ в ОЗУ
    hl = romMonitorStart;
    de = [romMonitorStart + romMonitorSize];
    bc = &ramMonitorStart;
    do
    {
        *bc = a = *hl;
        hl++;
        bc++;
        if ((a = l) != e) continue;
    } while((a = h) != d);

    // Возвращаем ОЗУ
    out(ioSysConfig, a = ioSysConfigEnableRam);

    // Запускаем Монитор и Меню
    return ramTest0Start();
    noreturn;
}

// Функция чтения байта из ПЗУ
// Копия этой функции должна присутвовать и в ОЗУ!

#org 0xFFF3

void readRomByte(a, de, c)
{
    // Отключаем ОЗУ
    out(ioSysConfig, a = ioSysConfigDisableRam);
    // Читаем байт
    c = a = *de;
    de++;
    // Возвращаем ОЗУ
    out(ioSysConfig, a = ioSysConfigEnableRam);
    a = c;
}
