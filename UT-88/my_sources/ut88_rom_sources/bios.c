#include "common.h"

extern uint8_t outputFileBegin = 0xF600;
extern uint8_t outputFileEnd = 0x10000;

// Константы

const int screenWidth        = 64;
const int screenHeight       = 25;
const int screenAddr         = 0xE800;
const int screenAddrEnd2     = 0xF000;
const int lastRamAddr        = 0xDFFF;
const int initalStackAddr    = 0xF7AF;
const int tapeSpeedInitValue = 0x1D2A;
const int tapeSyncByte       = 0xE6;

// Системные переменные

const int systemVariablesBegin = 0xF7B0;
const int systemVariablesEnd   = 0xF7FF;

extern uint8_t  vCursorX            = 0xF7B0;
extern uint8_t  vCursorY            = 0xF7B1;
extern uint16_t vCursor             = 0xF7B2;
extern uint8_t  vCursorH            = 0xF7B3;
extern uint16_t vBreakSavedPc       = 0xF7B4;
extern uint8_t  vBreakSavedHl       = 0xF7B6;
extern uint8_t  vBreakRegs          = 0xF7B8;
extern uint8_t  vInitalStackAddr    = 0xF7BC;
extern uint16_t vBreakSavedPsw      = 0xF7BE;
extern uint16_t vSp                 = 0xF7C0;
extern uint8_t  vBreakAddr          = 0xF7C3;
extern uint8_t  vBreakPrevCmd       = 0xF7C5;
extern uint8_t  vJmp                = 0xF7C6;
extern uint16_t vCmdArg1            = 0xF7C7;
extern uint16_t vCmdArg2            = 0xF7C9;
extern uint16_t vCmdArg3            = 0xF7CB;
extern uint8_t  vCmdArg2Able        = 0xF7CD;
extern uint8_t  vTapeInverted       = 0xF7CE;
extern uint8_t  vTapeSpeedRd        = 0xF7CF;
extern uint8_t  vTapeSpeedWr        = 0xF7D0;
extern uint16_t vLastRamAddr        = 0xF7D1;
extern uint8_t  vLineBuffer         = 0xF7D3; // Максимальная длина строки 31 байт без учета завершающего символа.
extern uint8_t  vLineBufferLastByte = 0xF7F2;
extern uint8_t  vKeyDelay           = 0xF7F3;
extern uint8_t  vKeyPrevCode        = 0xF7F4;
extern uint8_t  vPutchEscMode       = 0xF7F8;
extern uint8_t  vRus                = 0xF7FA; // Состояние кнопки РУС/ЛАТ
extern uint8_t  vGetch              = 0xF7FB; // Состояние кнопки РУС/ЛАТ

// Коды команд КР580ВМ80А

const int opcodeJmp = 0xC3;
const int opcodeRst6 = 0xF7;

// Коды символов для putch, getch и inkey

const int charCodeBeep        = 0x07;
const int charCodeLeft        = 0x08;
const int charCodeNextLine    = 0x0A;
const int charCodeHome        = 0x0C;
const int charCodeEnter       = 0x0D;
const int charCodeRight       = 0x18;
const int charCodeUp          = 0x19;
const int charCodeDown        = 0x1A;
const int charCodeEsc         = 0x1B;
const int charCodeClearScreen = 0x1F;
const int charCodeSpace       = 0x20;
const int charCodeBackspace   = 0x7F;
const int charCodeRusLat      = 0xFE;

// Меню

#org 0xF600

void menu()
{
    // Если при запуске меню нажат Enter, то игнорируем его.
    init(hl = &menuInitRet);
menuInitRet:

    // Скрываем курсор (перемещаем курсор на 29 линию, которая на отображается).
    vCursorH = a = [(screenAddr + screenWidth * 29) >> 8];

    // Вывод меню на экран
    de = [screenAddr + screenWidth * 2 + 2];
    hl = romFiles;
    b = 0;
    while()
    {
        swap(hl, de);
        readRomByte(a, de, c);
        swap(hl, de);
        if (a == 0) break;
        if (a == 10)
        {
            b++;
            e = (((a = e) &= 0xC0) += [screenWidth + 2]);
            d = ((a +@= d) -= e);
            continue;
        }
        *de = a;
        de++;
    }

    // Сохраняем адрес описателей файлов в ПЗУ и восстаналиваем адрес меню на экране
    hl += (de = -4);
    push(hl);

    // Выбор элемента стрелкой
    hl = [screenAddr + screenWidth * 2];
    c = 0;
    while()
    {
        *hl = 14;
        getch();
        *hl = 0;
        if (a == charCodeEnter) break;
        if (a == charCodeUp)
        {
            if ((a = c) == 0) continue;
            c--;
            swap(*sp, hl); hl += (de = -4); // Адрес дескриптора
            de = [-screenWidth];
        }
        else
        {
            if (a != charCodeDown) continue;
            if ((a = c) == b) continue;
            c++;
            swap(*sp, hl);
            hl += (de = 4);
            de = screenWidth;
        }
        swap(*sp, hl);
        hl += de;
    }

    // Очистка экрана и вывод *ЮТ/88*
    push(bc)
    {
        puts(hl = &aClearUt88); 
    }

    // Первый пункт это выход в Монитор
    if ((a = c) == 0) return monitor();

    // Чтение дескриптора
    pop(de);
    readRomByte(de); h = a; // de = начало в ПЗУ
    readRomByte(de); l = a;
    readRomByte(de); b = a; // bc = начало в ОЗУ
    readRomByte(de); c = a;
    swap(hl, de);

    // Распаковка и запуск
    push(bc);
    noreturn; // unmlz(de, bc);
}

#include "unmlz.h"

// Точки входа

#org 0xF800

void entryPoints()
{
    return reboot();
    return getch();
    return tapeInput(a);
    return putch(c);
    return tapeOutput(c);
    return putch(c);
    return isAnyKeyPressed();
    return put8(a);
    return puts(hl);
    return inkey();
    return getCursor();
    return getCursorChar();
    return tapeInputFile(hl);
    return tapeOutputFile(hl, de, bc);
    return calcSum(hl, de);
    return; rst(0x38); rst(0x38); // Нет функции
    return getLastRamAddr();
    return setLastRamAddr(hl);    
    noreturn;
}

// Инициализация. Выполняется после перезагрузки или пользовательской программой.
// Параметры: нет. Функция никогда не завершается.

void reboot()
{
    return init(hl = &monitor);
    noreturn;
}

// Инициализация.
// Параметры: нет. Функция возвращается по адресу HL.

void init(hl)
{
    sp = initalStackAddr;
    push(hl);
    out(ioUserConfig, a = ioUserConfigValue);
    cmdF(hl = systemVariablesBegin, de = systemVariablesEnd, c = 0);
    vInitalStackAddr = hl = initalStackAddr;
    vPutchEscMode = hl = &putchEscMode0;
    puts(hl = &aClearUt88); // Очистка экрана и вывод *ЮТ/88*
    vLastRamAddr = hl = lastRamAddr;
    vTapeSpeedRd = hl = tapeSpeedInitValue;
    vJmp = a = opcodeJmp;
}

// Ввод команды пользователем и её выполнение. Выполнение любой команды возвращается к этой точке.
// Параметры: нет. Функция никогда не завершается.

void monitor()
{
    // Возвращаем стек на место
    sp = initalStackAddr;

    // Перевод строки и вывод на экран =>
    puts(hl = &aCrLfPrompt);

    // Ввод строки в vLineBuffer
    getLine();

    // После этого любая команда может вернуться в монитор выполнив ret
    hl = &monitor;
    push(hl);

    // Код введеной команды
    hl = &vLineBuffer;
    a = *hl;

    // У команды может быть от 0 до 3-х параметров, 16-ричных чисел разделенных запятой
    push(a)
    {
        // Зануление переменных vCmdArg*
        vCmdArg3 = hl = 0;
        vCmdArg2Able = (a = h);

        // Указатель на введенную команду. Первый байт это код команды, мы его пропускаем.
        de = [&vLineBuffer + 1];

        // Преобразование 1 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
        parseHexNumber16(de);
        vCmdArg1 = hl;
        vCmdArg2 = hl;

        // В строке больше нет параметров
        if (flag_nc)
        {
            // Преобразование 2 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
            vCmdArg2Able = a = 0xFF;
            parseHexNumber16(de);
            vCmdArg2 = hl;

            // В строке больше нет параметров
            if (flag_nc)
            {
                // Преобразование 3 параметра из строки в число. В случае ошибки функция переходит на error, а затем на monitor.
                parseHexNumber16(de);
                vCmdArg3 = hl;

                // Вывод ошибки, если в строке еще что то осталось. Эта функция переходит на monitor.
                if (flag_nc) return error();
            }
        }

        hl = vCmdArg3; c = l; b = h;
        hl = vCmdArg2; swap(hl, de);
        hl = vCmdArg1;
    }

    // Разбор команд
    if (a == 'X') return cmdX();
    if (a == 'D') return cmdD(hl, de);
    if (a == 'C') return cmdC(hl, de, bc);
    if (a == 'F') return cmdF(hl, de, c);
    if (a == 'S') return cmdS(hl, de, c);
    if (a == 'T') return cmdT(hl, de, bc);
    if (a == 'M') return cmdM(hl);
    if (a == 'G') return cmdG(hl, de);
    if (a == 'I') return cmdI(hl);
    if (a == 'O') return cmdO(hl, de);
    if (a == 'L') return cmdL(hl, de);
    if (a == 'R') return cmdR(hl, de, bc);
    if (a == 'V') return cmdV();
    if (a == 'K') return cmdK(hl, de);
    return error();
    noreturn;
}

// Ввод строки с клавиатуры.
// Строка сохраняется по адресам vLineBuffer .. vLineBufferLastByte.
// Параметры: нет. Результат de = адрес vLineBuffer, cf - если строка не пустая

void getLine()
{
    hl = &vLineBuffer;
    b = 0; // Признак пустой строки.
    while ()
    {
        getch();
        if (a == charCodeLeft)
            goto getLineBackspace;
        if (a == charCodeBackspace)
        {
getLineBackspace:
            if ((a = &vLineBuffer) == l)
                continue;
            swap(hl, de);
            puts(hl = &aBsSpBs); // Сохраняются: bc, de.
            swap(hl, de);
            hl--;
            if ((a = &vLineBuffer) != l)
                continue;
            b = 0; // Признак пустой строки.
            continue;
        }
        if (a != charCodeEnter)
            if (a < charCodeSpace)
                continue;
        putchA(a); // В оригинальном коде было это лишее условие, но оно всегда выполняется.
        *hl = a;
        if (a == charCodeEnter) break;
        if (a == '.') return monitor();
        b = 0xFF;
        if ((a = &vLineBufferLastByte) == l)
            return error();
        hl++;
    }
    (a = b) <<@= 1; // Признак пустой строки. 7-ой бит помещаем во флаг CF.

    // Результат
    de = &vLineBuffer;
}

// Функция для пользовательской программы. Вывод строки на экран.
// Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.

void puts(hl)
{
    while ()
    {
        a = *hl;
        if (a == 0) return;
        putchA(a);
        hl++;
    }
    noreturn;
}

// Преобразовать строку содержащую 16 ричное 16 битное число в число.
// Параметры: de - адрес стороки. Результат: hl - число, cf - если в строке больше ничего нет.

void parseHexNumber16(de)
{
    bc = &error; // Далее ret переходит на error()
    push(bc)
    {
        hl = 0;
        while ()
        {
            a = *de; de++;
            if (a == charCodeEnter) break; // Конец строки
            if (a == ',') goto parseHexNumber16ret; // выход с флагами z nc. //! Не проверяются лишние пробелы
            if (a == ' ') continue;
            a -= '0';
            if (a >= 10)
            {
                if (a < ['A' - '0']) return;
                if (a >= ['F' - '0' + 1]) return;
                a -= ['A' - '0' - 10];
            }
            hl += hl; if (flag_c) return;
            hl += hl; if (flag_c) return;
            hl += hl; if (flag_c) return;
            hl += hl; if (flag_c) return;
            c = a;
            b = 0;
            hl += bc;
        }
        setFlagC();  // выход с флагами z c
parseHexNumber16ret:
    }
}

// Сравить hl и de.
// Параметры: hl, de - числа. Результат: флаги. Сохраняет: bc, hl, de.

void cmpHlDe(hl, de)
{
    if ((a = h) != d) return;
    (a = l) ? e;
}

// Если hl = de или пользователь нажал СТОП, то выйти из вызывающей функции.
// Параметры: hl, de - числа. Результат: hl на 1 больше. Сохраняет: bc, de.

void ifHlEqDeThenRetElseIncHlCanStop(hl, de)
{
    stopByUser();
    noreturn; // Продолжение в ifHlEqDeThenRetElseIncHl
}

// Если hl = de, то выйти из вызывающей функции.
// Параметры: hl, de - числа. Результат: нет на 1 больше. Сохраняет: bc, de.

void ifHlEqDeThenRetElseIncHl(hl, de)
{
    cmpHlDe(hl, de);
    if (flag_z)
    {
        sp++;
        sp++;
        return;
    }
    hl++;
}

// Возможность прерывания длительной функции пользователем.
// Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.

void stopByUser()
{
    // Если не нажата клавиша РУС/ЛАТ, выходим
    a = in(ioSysC);
    a >>r= 1;
    if (flag_c) return;    

    // Выводим ошибку на экран и возвращаемся в Монитор.
    return error();
    noreturn;
}

// Вывод на экран: перевод строки, отступ на 4 символа
// Параметры: нет. Результат: нет. Сохраняет: a, bc, de, hl.

void putCrLfTab()
{
    push(hl)
    {
        puts(hl = &aCrLfTab);
    }
}

// Вывод на экран: 8 битное число из памяти по адресу HL, пробел.
// Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.

void putMSp(hl)
{
    a = *hl;
    noreturn;
}

// Вывод на экран: 8 битное число из регистра А, пробел.
// Параметры: нет. Результат: нет. Сохраняет: bc, de, hl.

void put8Sp(a)
{
    push(bc)
    {
        put8(a);
        putchA(a = ' ');
    }
}

// Команда D <начальный адрес> <конечный адрес>
// Вывод блока данных из адресного пространства на экран в 16-ричном виде

void cmdD(hl, de)
{
    putCrLfTabHlSp(hl);
    while ()
    {
        putMSp(hl);
        ifHlEqDeThenRetElseIncHlCanStop(hl, de);
        if (flag_z (a = l) &= 0x0F) goto cmdD;
    }
    noreturn;
}

// Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
// Сравнить два блока адресного пространство

void cmdC(hl, de, bc)
{
    while ()
    {
        a = *bc;
        if (a != *hl)
        {
            putCrLfTabHlSp(hl);
            putMSp(hl);
            put8Sp(a = *bc);
        }
        bc++;
        ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    }
    noreturn;
}

// Команда F <начальный адрес> <конечный адрес> <байт>
// Заполнить блок в адресном пространстве одним байтом

void cmdF(hl, de, c)
{
    while ()
    {
        *hl = c;
        ifHlEqDeThenRetElseIncHl(hl, de);
    }
    noreturn;
}

// Команда S <начальный адрес> <конечный адрес> <байт>
// Найти байт (8 битное значение) в адресном пространстве

void cmdS(hl, de, c)
{
    while ()
    {
        if ((a = c) == *hl)
            putCrLfTabHlSp(hl);
        ifHlEqDeThenRetElseIncHlCanStop(hl, de);
    }
    noreturn;
}

// Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
// Копировать блок в адресном пространстве

void cmdT(hl, de, bc)
{
    while ()
    {
        *bc = a = *hl;
        bc++;
        ifHlEqDeThenRetElseIncHl(hl, de);
    }
    noreturn;
}

// Команда L <начальный адрес> <конечный адрес>
// Вывести на экран адресное пространство в виде текста

void cmdL(hl, de)
{
    // Вывод адреса
    putCrLfTabHlSp(hl);

    while ()
    {
        a = *hl;
        if (flag_m a |= a) goto cmdL1;
        if (a < ' ')
        {
cmdL1:      a = '.';
        }
        putchA(a);
        ifHlEqDeThenRetElseIncHlCanStop(hl, de);
        if (flag_z (a = l) &= 0xF) goto cmdL;
    }
    noreturn;
}

// Команда M <начальный адрес>
// Вывести на экран адресное пространство побайтно с возможностью изменения

void cmdM(hl)
{
    while ()
    {
        // Вывод адреса
        putCrLfTabHlSp(hl);

        // Вывод значения по этому адресу
        putMSp(hl);

        // Ввод строки пользователем
        push(hl)
        {
            getLine();
        }

        // Если пользователь ввел строку, то преобразуем её в число и записываем его в память
        if (flag_c)
        {
            push(hl)
            {
                parseHexNumber16();
                a = l;
            }
            *hl = a;
        }

        // Следующий цикл
        hl++;
    }
    noreturn;
}

// Команда G <начальный адрес> <конечный адрес>
// Запуск программы и возможным указанием точки останова.

void cmdG(hl, de)
{
    // Нужна точка останова?
    cmpHlDe();
    if (flag_nz)
    {
        swap(hl, de);
        vBreakAddr = hl;
        vBreakPrevCmd = a = *hl;
        *hl = opcodeRst6;
        *0x30 = a = opcodeJmp;
        *0x31 = hl = &breakHandler;
    }

    // Восстановление регистров
    sp = &vBreakRegs;
    pop(a, hl, de, bc);
    sp = hl;
    hl = vBreakSavedHl;

    // Запуск
    return vJmp();
    noreturn;
}

// Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
// Скопировать блок из внешнего ПЗУ в адресное пространство процессора

void cmdR(hl, de, bc)
{
    out(ioUserC, a = h);
    while ()
    {
        out(ioUserB, a = l);
        *bc = a = in(ioUserA);
        bc++;
        ifHlEqDeThenRetElseIncHl(hl, de);
    }
    noreturn;
}

// Функция для пользовательской программы. Получить координаты курсора.
// Параметры: нет. Результат: hl - координаты курсора. Сохраняет регистры: bc, de, hl.

void getCursor()
{
    hl = vCursorX;
}

// Функция для пользовательской программы. Получить символ под курсором
// Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.

void getCursorChar()
{
    push(hl)
    {
        hl = vCursor;
        a = *hl;
    }
}

// Команда I <смещение> <скорость>
// Загрузить файл с магнитной ленты

void cmdI(hl, de)
{
    // Если скорость указана, то сохраняем её в системную переменную.
    if ((a = vCmdArg2Able) != 0)
    {
        vTapeSpeedRd = a = e;
    }

    // Загрузить файл с магнитной ленты
    tapeInputFile(hl);

    // Вывод адреса первого и последнего байта
    putCrLfTabHlSp(hl);
    swap(de, hl);
    putCrLfTabHlSp(hl);
    swap(de, hl);

    // Расчет и вывод контрольной суммы
    push(bc);
    calcSum(hl, de);
    hl = bc;
    putCrLfTabHlSp(hl);
    pop(de);

    // Если прочитанная из файла и вычисленная контрольная суммы совпадают, то возвращаемся в монитор.
    cmpHlDe();
    if (flag_z) return;

    // В случае ошибки выводим 4-ое число - ожидаемую контрольную сумму и текст ошибки
    swap(de, hl);
    putCrLfTabHlSp(hl);

    noreturn; // Продолжение на error
}

// Вывести сообщение об ошибке на экран и перейти в Монитор

void error()
{
    puts(hl = &aError);
    return monitor();
    noreturn;
}

uint8_t aError[] = { "\r\no{ibka" };

// Функция для пользовательской программы. Загрузить файл с магнитной ленты.
// Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки

void tapeInputFile(hl)
{
    // Тут мы будем выводить статистику загрузки
    putCrLfTab();

    // Ожидание начала блока данных на магнитной ленте и чтение первых 16 бит, это начальный адрес.
    tapeInputSyncBc(a = 0xFF);

    // Прибавляем смещение загрузки de = bc + hl
    de = hl;                                            // 10 = MOV + MOV
    hl += bc;                                           //  4 = DAD
    swap(hl, de);                                       //  4 = XCHG

    // Чтение с магнитной ленты следующих 16 бит, это конечный адрес
    tapeInputBc();

    // Прибавляем смещение загрузки к конечному адресу, он теперь в de, а начальный адрес в hl
    hl += bc;                                           // 4 = DAD
    swap(hl, de);                                       // 4 = XCHG

    // Выводим на экран конечный адрес.
    push(hl)                                            // 11 = PUSH
    {
        hl = vCursor; bc = hl; hl++; hl++;              // 36 = LHLD + MOV + MOV + INX + INX = 16 + 5 + 5 + 5 + 5

        // Вывод /
        *hl = '/'; hl++;                                // 16 = MVI M + INX = 11 + 5

        // Вывод цифры
        (((a = d) >>@= 4) &= 0xF) += '0';               // 35 = MOV + 4xSHIFT + ANI + ADD = 5 + 4*4 + 7 + 7
        if (a >= ['9' + 1]) a += ['A' - '0' - 10];      // 24 = CPI + JMP + ADI = 7 + 10 + 7
        *hl = a; hl++;                                  // 12 = MOV A M + INX = 7 + 5

        // Вывод цифры
        ((a = d) &= 0xF) += '0';                        // 19 = MOV + ANI + ADD = 5 + 7 + 7
        if (a >= ['9' + 1]) a += ['A' - '0' - 10];      // 24 = CPI + JMP + ADI = 7 + 10 + 7
        *hl = a;                                        // 7  = MOV A M
    }                                                   // 10 = POP

    // Сохраняем адрес загрузки, так как его необходимо вернуть вызывающей функции
    push(hl)                                            // 11 = PUSH
    {
        do
        {
            // Загрузка байта.
            // Перед загрузкой первого байта задержка 4 + 4 + 11 + 36 + 16 + 35 + 24 + 12 + 19 + 24 + 7 + 10 + 11 + 7 = 220 тактов
            // Перед загрузкой следующий байт задержка 7 + 7 + 5 + 35 + 24 + 12 + 19 + 24 + 12 + 19 + 19 = 183 такта
            tapeInput(a = 8);                           // 7 = MVI
            *hl = a;                                    // 7 = MOV A M
            hl++;                                       // 5 = INX

            // Вывод первой цифры загруженного байта
            (((a = h) >>@= 4) &= 0xF) += '0';           // 35 = MOV + 4xRLA + ANI + ADD = 5 + 4*4 + 7 + 7
            if (a >= ['9' + 1]) a += ['A' - '0' - 10];  // 24 = CPI + JMP + ADI = 7 + 10 + 7
            *bc = a; bc++;                              // 12 = STAX + INX = 7 + 5

            // Вывод второй цифры загруженного байта
            ((a = h) &= 0xF) += '0';                    // 19 = MOV + ANI + ADD = 5 + 7 + 7
            if (a >= ['9' + 1]) a += ['A' - '0' - 10];  // 24 = CPI + JMP + ADI = 7 + 10 + 7
            *bc = a; bc--;                              // 12 = STAX + DCX = 7 + 5

            // Цикл
            if ((a = h) != d) continue;                 // 19 = MOV, CMP, JNZ = 5 + 4 + 10
        } while ((a = l) != e);                         // 19 = MOV, CMP, JNZ = 5 + 4 + 10

        // Ожидание начала блока данных на магнитной ленте и чтение 16 бит, это контрольная сумма.
        tapeInputSyncBc(a = 0xFF);
    }
}

// Используется при перезагрузке. Очистка экрана и вывод текста *ЮТ/88*.

uint8_t aClearUt88[] = { "\x1F*`t/88*\n" };

// Загрузка 16 битного числа с магнитной ленты без синхронизации
// Параметры: нет. Результат: bc - значение. Сохраяет: de, hl

void tapeInputBc()
{
    a = 8;
    noreturn;
}

// Загрузка 16 битного числа с магнитной ленты с синхронизацией
// Параметры: a = 0xFF. Результат: bc - значение. Сохраяет: de, hl

void tapeInputSyncBc(a)
{
    tapeInput(a);
    b = a;
    tapeInput(a = 8);
    c = a;
}

// Функция для пользовательской программы. Вычистить 16-битную сумму всех байт по адресам hl..de.
// Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.

void calcSum(de, hl)
{
    bc = 0;
    while ()
    {
        c = ((a = *hl) += c);
        if (flag_c) b++;
        ifHlEqDeThenRetElseIncHl(hl, de);
    }
    noreturn;
}

// Команда O <начальный адрес> <конечный адрес> <скорость>
// Сохранить блок данных на магнитную ленту

void cmdO(c)
{
    // Если скорость указана, то сохраняем её в системную переменную.
    if ((a = c) != 0)
    {
        vTapeSpeedWr = a;
    }

    // Расчет контрольной суммы в bc
    push(hl)
    {
        calcSum(hl, de);
    }

    // Вывод на экран начального адреса, конечного адреса и контрольной суммы
    putCrLfTabHlSp(hl);
    swap(de, hl);
    putCrLfTabHlSp(hl);
    swap(de, hl);
    push(hl)
    {
        putCrLfTabHlSp(hl = bc);
    }

    // Продолжение в tapeOutputFile
    noreturn;
}

// Функция для пользовательской программы. Запись файла на магнитную ленту.
// Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.

void tapeOutputFile(de, hl, bc)
{
    // Сохраняем в стеке контрольную сумму
    push(bc);

    // Запись пилот тона
    bc = 0;
    do
    {
        tapeOutput(c);
    } while (flag_nz b--);               // Добавляет 15 тактов, DCR + JZ = 5 + 10

    // Запись стартового байта
    tapeOutput(c = tapeSyncByte);        // Добавляет 7 тактов, MVI

    // Запись адреса первого байта
    tapeOutputHl(hl);                    // Функция добавляет 27 тактов

    // Запись адреса последнего байта
    swap(hl, de);                        // Добавляет 37 тактов, XCHG + XCHG + tapeOutputHl = 10 + 27
    tapeOutputHl(hl);
    swap(hl, de);

    // Запись данных
    tapeOutputBlock(hl, de);             // Добавляет 50-57 тактов для разных длин

    // Запись пилот тона
    tapeOutputHl(hl = 0);                // Добавляет 37 тактов, LXI + tapeOutputHl = 10 + 27

    // Запись стартового байта
    tapeOutput(c = tapeSyncByte);        // Добавляет 7 тактов, MVI

    // Запись контрольной суммы
    pop(hl);                             // Добавляет 37 тактов, POP + tapeOutputHl = 10 + 27
    return tapeOutputHl(hl);
    noreturn;
}

// Вывод на экран: перевод строки, отступ на 4 символа, 16 битное число, пробел.
// Параметры: hl - число. Результат: нет. Сохраняет: bc

void putCrLfTabHlSp(hl)
{
    push(bc)
    {
        putCrLfTab();
        put8(a = h);
        put8Sp(a = l);
    }
}

// Запись блока на магнитную ленту.
// Параметры: de - начальный адрес, hl - конечный адрес.

// К первому    биту добавляется 17 + 7 + 9 + 9 + 5 + 10      = 57 такта
// К 1-6        биту добавляется      7 + 9 + 9 + 5 + 10      = 40 такта
// К последнему биту добавляется      7 + 9 + 9 + 5 + 10 + 10 = 50 тактов

void tapeOutputBlock(hl, de)           // 17 тактов, CALL
{
    do
    {
        tapeOutput(c = *hl);           // 7 тактов, MOV C M

        // Цикл длится, пока HL != DE
        (a = l) -= e;                  // 9 тактов, MOV + SUB = 5 + 4 = 9
        (a = h) -@= d;                 // 9 тактов, MOV + SBC = 5 + 4 = 9
        hl++;                          // 5 тактов, INX
    } while(flag_nz);                  // 10 тактов, JNZ
}                                      // 10 тактов, RET

// Запись 16 битного числа на магнитную ленту.
// Параметры: hl - число.

void tapeOutputHl(hl)           // 17 = CALL = Функция добавляет 27 тактов
{
    tapeOutput(c = h);          //  5 = MOV
    return tapeOutput(c = l);   //  5 = MOV
    noreturn;
}

// Загрузка байта с магнитной ленты.
// Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации. Результат: a = прочитанный байт.

const int tapeMask  = 0x08;
const int tapeShift = 3;

// Тактов после входа до первого измерения = 17 + 33 + 5 + 7 + 10 + 12 + 14 + 7 + 4 + 10 = 122 такта
// Тактов после последнего измерения до выхода = 10 + 7 + 14 + 12 + 9 + 5 + 13 + 17 + 5 + 10 + 12 + 19 + 15 + 13 + 4 + 33 + 10 = 208 тактов
// Всего тактов 122 + 208 = 330.
// Т.е. задержку при загрузке последнего бита можно уменьшить на 330 / 25 = 13

const int tapeInputCor = 13;

void tapeInput(a)                         // 17 = CALL
{
    push(bc, de, hl)                      // 33 = PUSH = 3 * 11
    {
        // Режим работы
        d = a;                            //  5 = MOV

        //
        c = 0;                            //  7 = MVI
        a = in(ioSysC);                   // 10 = IN
        e = (a &= tapeMask);              // 12 = MOV + ANI = 5 + 7

        do
        {
            // Сдвиг бита.
            c = ((a = c) += a);           // 14 = MOV + ADD + MOV = 5 + 4 + 5

            // Ждем изменения уровня на входе магнитофона.
            h = 0;                        //  7 = MVI
            do
            {
                // Если прошло слишком много времени
                h--;                      //  4 = DCR
                if (flag_z)               // 10 = JNZ
                {
                    // Сброс загруженного байта. Это предотвращает некорректную синхронизацию
                    c = h;
                    // Если мы загружали данные, то выводим на экран ошибку и возвращаемся в Монитор.
                    if (flag_p (a = d) |= a) return error();
                    // Иначе позволяем пользователю превать загрузку и ждем дальше.
                    stopByUser();
                }

                // Проверка изменения.

                // Синхронизация осуществляется с точностью 7 + 14 + 4 + 10 + 10 = 0 ... 45 тактов.

                a = in(ioSysC);            // 10 = IN
                a &= tapeMask;             // 7 = ANI
            } while (a == e);              // 14 = CMP + JNZ = 4 + 10

            // Сохраняем загруженный бит
            a >>r= tapeShift;              // 12 = RLC + RLC + RLC = 4 * 3
            c = (a |= c);                  // 9  = MOV + ORA = 5 + 4

            // Задержка. Во время этой задержки может измениться уровень, а может и нет.
            d--;                           //  5 = DCR
            a = vTapeSpeedRd;              // 13 = LDA
            if (flag_z) a -= tapeInputCor; // 10 = JZ  или для последнего 17 = JZ + SUI = 10 + 7
            do
            {
                a = a; a = a;              // 10 = MOV + MOV
            } while (flag_nz a--);         // 15 = DCR + JNZ = 5 + 10
            d++;                           //  5 = INR

            // Минимум пропущенных тактов с момента изменения бита = 10 + 7 + 14 + 12 + 9 + 5 + 13 + 10 + 5 = 85 + 25 * N
            // Очень хорошо, что эта длительность всего на 1 такт отличается от алгоритма записи

            // Запоминаем уровень для следующего цикла
            a = in(ioSysC);                // 10 = IN
            e = (a &= tapeMask);           // 12 = MOV + ANI = 5 + 7

            // Режим ожидания синхробайта
            if (flag_m (a = d) |= a)       // 19 = MOV + ORA + JP = 5 + 4 + 10
            {
                if ((a = c) == tapeSyncByte)
                {
                    a ^= a;
                }
                else
                {
                    if (a != [0xFF ^ tapeSyncByte]) continue;
                    a = 0xFF;
                }
                vTapeInverted = a;
                d = 9;
            }
        } while (flag_nz d--);             // 15 = DCR + JNZ = 5 + 10

        a = vTapeInverted;                 // 13 = LDA
        a ^= c;                            // 4 = XRA
    }                                      // 33 = POP = 3 * 10
}                                          // 10 = RET

// Функция для пользовательской программы. Запись байта на магнитную ленту.
// Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.

// Уменьшение длительности последнего бита, что бы скомпенсировать задержку при входе
// и выходе из функции, а так же задержку в функции tapeOutputBlock.

// Вход и выход из функции = 17 + 44 + 7 + 40 + 10 = 118 тактов
// Остальные функции добавлвяеют задержку 7 .. 52 такта
// Следовательно, лучшая задежка это 6 = 25 * 6 = 150 тактов

// Для константы 29 скорость получается = 16000000 / 9 / ((25 * 29 + 86) * 2) = 1096 бит в секунду
// Для константы 10 скорость получается = 16000000 / 9 / ((25 * 10 + 86) * 2) = 2645 бит в секунду
// Для константы 7  скорость получается = 16000000 / 9 / ((25 *  7 + 86) * 2) = 3405 бит в секунду

const int tapeOutCor = 6; // 1 единица равна 25 тактам.

void tapeOutput(c)                       // 17 = CALL
{
    push(a, hl, bc, de)                  // 44 = PUSH = 4 * 11
    {
        d = 8;                           //  7 = MVI
        do
        {
            // Следующий бит
            c = ((a = c) <<r= 1);        // 14 = MOV + MOV + RLC = 5 + 5 + 4

            // Передача бита
            a &= 1;                      //  7 = ANI
            a ^= ioSysConfigTape1;       //  7 = XRI
            out(ioSysConfig, a);         // 10 = OUT

            // Первый полупериод 13 + 30  + 14 + 5 + 7 + 7 + 10 + (10 + 15) * N = 86 + 25 * N

            // Задержка
            a = vTapeSpeedWr;            // 13 = LDA
            a++;                         // 30 = INR + цикл 25 тактов
            do
            {
                a = a; a = a;            // 10 = MOV + MOV
            } while (flag_nz a--);       // 15 = DCR + JZ = 5 + 10
            a = a; a = a; nop();         // 14 = MOV + MOV + NOP = 5 + 5 + 4

            // Передача бита
            a = c;                       //  5 = MOV
            a &= 1;                      //  7 = ANI
            a ^= ioSysConfigTape0;       //  7 = XRI
            out(ioSysConfig, a);         // 10 = OUT

            // Второй полупериод 5 + 13 + 10   + 5 + 15 +  14 + 7 + 7 + 10 + (10 + 15) * N = 86 + 25 * N

            // Задержка
            d--;                         //  5 = DCR
            a = vTapeSpeedWr;            // 13 = LDA
            if (flag_z) a -= tapeOutCor; // 10 = JZ  или для последнего 17 = JZ + SUI = 10 + 7
            do
            {
                a = a; a = a;            // 10 = MOV + MOV
            } while (flag_nz a--);       // 15 = DCR + JZ = 5 + 10
            d++;                         // 5  = DCR

        } while (flag_nz d--);           // 15 = DCR + JZ = 5 + 10
    }                                    // 40 = POP = 4 * 10
}                                        // 10 = RET

// Функция для пользовательской программы. Вывод 8 битного числа на экран.
// Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.

void put8(a)
{
    push(a)
    {
        a >>r= 4;
        put4();
    }

    noreturn;
}

// Вывод 4 битного числа на экран.
// Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.

void put4(a)
{
    a &= 0x0F;
    if (a >= 10) a += 7;
    a += '0';
    noreturn;
}

// Вывод символа на экран.
// Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.

void putchA(a)
{
    c = a;
    noreturn;
}

// Функция для пользовательской программы. Вывод символа на экран.
// Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.

void putch(c)
{
    push(hl, bc, de, a);

    de = &putchRet;
    push(de);

    hl = vPutchEscMode;
    goto hl;
}

void putchRet(hl)
{
    // Сохраняем новое положение курсора
    vCursor = hl;

    // Вычисляем координаты курсора.
    vCursorX = ((a = l) &= 63);
    hl += hl += hl;
    vCursorY = ((a = h) &= 31);

    pop(hl, bc, de, a);
}

void putchEscMode0(c)
{
    hl = vCursor;
    a = c;
    if (a < ' ')
    {
        de = &putchEscMode1; // Для putchEsc
        if (a == charCodeEsc        ) return putchSetEsc(hl, de);
        if (a == charCodeClearScreen) return putchClearScreen(hl);
        if (a == charCodeLeft       ) return putchLeft(hl);
        if (a == charCodeRight      ) return putchRight(hl);
        if (a == charCodeUp         ) return putchUp(hl);
        if (a == charCodeDown       ) return putchDown(hl);
        if (a == charCodeNextLine   ) return putchNextLine(hl);
        if (a == charCodeEnter      ) return putchEnter(hl);
        if (a == charCodeHome       ) return putchHome(hl);
        if (a == charCodeBeep       ) return beep();
    }

    // Записываем символ в видеопамять
    *hl = c;

    // Перемещаем курсор
    hl++;

    // Прокручиваем экран, если нужно
    noreturn; // checkScroll(hl);
}

void checkScroll(hl)
{
    // Если курсор не вышел за пределы экрана, то выходим
    cmpHlDe(hl, de = [screenAddr + screenWidth * screenHeight]);
    if (flag_c) return;

    // Перемещаем курсор выше
    hl += (de = [-screenWidth]);

    // Продолжаем в scrollUp
    noreturn;
}

// Сместить экран на одну строку вверх.
// Параметры: нет. Результат: нет. Сохраняет: bc, hl

void scrollUp()
{
    push(hl)
    {
        hl = [screenAddr + screenWidth];
        de = screenAddr;

        // Сдвиг экрана вверх
        do
        {
            *de = a = *hl;
            de++;
            hl++;
        } while ((a = h) != [(screenAddr + screenWidth * screenHeight - 1 + 255) >> 8]); //!!! Поправить

        // Очистка нижней строки
        hl = [screenAddr + screenWidth * (screenHeight - 1)];
        b = screenWidth;
        a = ' ';
        do
        {
            *hl = a;
            l++;
        } while (flag_nz b--);
    }
}

void putchEscMode1(c, hl)
{
    // Поддерживается только ESC-код Y
    if ((a = c) == 'Y')
    {
        return putchSetEsc(hl = screenAddr, de = &putchEscMode2);
    }

    // Это способ вывода любого символа на экран
    hl = vCursor;
    *hl = a;
    hl++;
    return putchSetEsc0(hl);
    noreturn;
}

void putchEscMode2(c)
{
    // Координата X в DE
    d = 0;
    e = ((a = vCursor) &= 0x3F);

    // Координата Y в HL
    (a = c) -= 0x20;
    if (a >= screenHeight) a = [screenHeight - 1];
    h = 0;
    l = a;

    // Вычисляем коондинату
    hl += hl += hl += hl += hl += hl += hl;
    hl += de;
    hl += (de = screenAddr);

    // Далее принимаем Y    
    return putchSetEsc(de = &putchEscMode3);
    noreturn;
}

void putchEscMode3(c)
{
    hl = vCursor;

    // Сохраняем биты координаты Y
    l = ((a = l) &= 0xC0);

    // Координата X
    (a = c) -= 0x20;
    if (a >= screenWidth) a = [screenWidth - 1];

    // Вычисляем адрес
    l = (a |= l);

    noreturn; // Продолжение на putchSetEsc0
}

void putchSetEsc0(hl)
{
    de = &putchEscMode0;
    noreturn; // Продолжение на putchSetEsc(hl, de)
}

void putchSetEsc(hl, de)
{
    swap(hl, de);
    vPutchEscMode = hl;
    swap(hl, de);
}

void putchClearScreen()
{
    clearScreen();
    noreturn; // Продолжение на putchHome
}

void putchHome()
{
    hl = screenAddr;
}

// Очисть экран.
// Параметры: нет. Результат: нет. Сохраняет: bc, de

void clearScreen()
{   
    hl = screenAddr;
    b = 0;
    a = [screenAddrEnd2 >> 8];
    do
    {
        *hl = b;
        hl++;
    } while (a != h);
}

void putchRight(hl)
{
    hl++;
    return putchCheckDown(hl);
}

void putchLeft(hl)
{
    hl--;
    return putchCheckUp(hl);
}

void putchDown(hl)
{
    hl += (de = screenWidth);
    noreturn; // продолжение на putchCheckDown(hl)
}

void putchCheckDown(hl)
{
    cmpHlDe(hl, de = [screenAddr + screenWidth * screenHeight]);
    if (flag_c) return;
    hl += (de = [-screenWidth * screenHeight]);
}

void putchUp(hl)
{
    hl += (de = [-screenWidth]);
    noreturn; // продолжение на putchCheckUp(hl)
}

void putchCheckUp(hl)
{
    if ((a = h) >= [screenAddr >> 8]) return;
    hl += (de = [screenWidth * screenHeight]);
}

void putchEnter(hl)
{
    l = ((a = l) &= 0xC0);
}

void putchNextLine(hl)
{
    // Вычисляем hl = (hl & 63) + 64
    l = (((a = l) &= 0xC0) += screenWidth);
    h = ((a +@= h) -= l);

    // Продолжение на checkScroll
    return checkScroll(hl);
    noreturn;
}

// Функция для пользовательской программы. Получить код нажатой клавиши на клавиатуре.
// В отличии от функции inkey, в этой функции есть задержка повтора и звук при нажатии.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

const int keyDelayA = 128;
const int keyDelayB = 32;
const int keyDelayC = 128;

void getch()
{
    push(hl, de, bc)
    {
        while()
        {
            // Получаем код клавиши сохраненный функцией isAnyKeyPressed
            hl = &vGetch;
            a = *hl;
            if (a != 0xFF)
            {
                *hl = 0xFF;
            }
            else
            {
                // Отображаем курсор
                hl = vCursor;
                a = *hl;
                *hl = '_';
                push(a)
                {
                    // Ждем нажатия клавиши
    getchRetry:
                    e = keyDelayA;
                    while()
                    {
                        inkey();
                        if (a != 0xFF) break;

                        // Если клавиша не нажата keyDelayA циклов, то
                        // сбрасываем код последней нажатой клавиши. Следующая
                        // нажатая клавиша будет возвращена без задежки.
                        e--;
                        if (flag_nz) continue;
                        vKeyPrevCode = (a ^= a);
                        *hl = ((a = *hl) ^= '_');
                    }
                    d = a;

                    // Если прошлый раз была нажата другая клавиша, то
                    // возвращаем эту клавишу без задержки.
                    a = vKeyPrevCode;
                    if (a != d)
                    {
                        vKeyPrevCode = a = d;
                        a = keyDelayC;
                    }
                    else
                    {
                        // Задержка повтора
                        a = vKeyDelay;
                        a -= 1;
                        if (flag_nc)
                        {
                            vKeyDelay = a;
                            b = 0;
                            do { } while(flag_nz b--);
                            goto getchRetry;
                        }
                        a = keyDelayB;
                    }
                    vKeyDelay = a;
                    a = d;
                }

                // Удаляем курсор с экрана
                *hl = a;
                a = d;
            }

            // Нажата клавиша РУС/ЛАТ
            if (a != charCodeRusLat) break;
            a = vRus;
            a -= 1;
            a -@= a;
            vRus = a;
        }
    }
}

// Получить код нажатой клавиши на клавиатуре.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

void inkey()
{
    push(bc, de, hl);

        // Нажата РУС/ЛАТ
        a = in(ioSysC);
        a >>r= 1;
        a = charCodeRusLat;
        if (flag_nc) goto popHlDeBcAndRet;

        // Проверка каждого ряда
        c = 0xFE;
        d = 8;
        do
        {
            // Запись ряда в микросхему и сразу вычисление следующего ряда
            out(ioSysA, a = c);
            a <<r= 1;
            c = a;

            // Чтение строки. Строк всего 7, поэтому накладываем маску.
            a = in(ioSysB);
            invert(a);
            a &= 0x7F;
            if (flag_nz) return inkeyDecode(a, d); // Если клавиша нажата, то преобразуем номер в код.
         } while (flag_nz d--);

         a = 0xFF;
popHlDeBcAndRet:
     pop(bc, de, hl);
}

// Преобразовать номер нажатой клавиши на клавиатуре в код

void inkeyDecode(a, d)
{
    // Прибавляем к B позицию первого нулевого бита в A.
    b = 0;
    while ()
    {
        a >>@= 1;
        if (flag_c) break;
        b++;
    }
    a = 56;
    do
    {
        a -= 7;
    } while (flag_nz d--);
    a += b;

    // Преобразование номера клавиши в код
    if (a < 0x30)
    {
        a += 0x30;
        if (a >= 0x3C)
            if (a < 0x40)
                a &= 0x2F;
        c = a;
    }
    else
    {
        hl = &inkeyDecodeTable;
        c = (a -= 0x30);
        b = 0;
        a = *(hl += bc);
        goto popHlDeBcAndRet;
    }

    // Нажата ли клавиаша РУС, УС или СС ?
    a = in(ioSysC);
    a >>@= 2;
    if (flag_nc)
    {
        a = c;
        a &= 0x1F;
        goto popHlDeBcAndRet;
    }
    a >>@= 1;
    if (flag_nc)
    {
        a = c;
        if (a >= 0x40) goto popHlDeBcAndRet;
        if (a < 0x30)
        {
            a |= 0x10;
            goto popHlDeBcAndRet;
        }
        a &= 0x2F;
        goto popHlDeBcAndRet;
    }

    if ((a = vRus) != 0)
    {
        a = c;
        a |= 0x20;
        goto popHlDeBcAndRet;
    }
    a = c;
    goto popHlDeBcAndRet;
    noreturn;
}

uint8_t inkeyDecodeTable[] =
{
    charCodeSpace,
    charCodeRight,
    charCodeLeft,
    charCodeUp,
    charCodeDown,
    charCodeEnter,
    charCodeClearScreen,
    charCodeHome
};

// Звуковой сигнал
// Параметры: нет. Результат: нет. Сохраняет: de, hl.

void beep()
{
    c = 0;
    a = ioSysConfigTape0;
    do
    {
        out(ioSysConfig, a);
        a ^= 1; // Замена ioSysConfigTape0 <-> ioSysConfigTape1
        b = 47;
        do
        {
        } while (flag_nz b--);
    } while (flag_nz c--);
}

// Функция для пользовательской программы.
// Нажата ли хотя бы одна клавиша на клавиатуре?
// Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.

void isAnyKeyPressed()
{
    // Некоторые программы, например VOLCANO, сразу после этой функции вызывают GETCH.
    // Что бы такие программы не зависали, мы тут сохраняем код нажатой клавиши, что бы
    // при вызове getch вернуть код нажатой клавиши без зависания.

    inkey();    
    vGetch = a;

    // Возвращаем результат: 0xFF если клавиша нажата, 0 если нет
    invert(a);
    if (flag_z) return;
    if (a == 1) { a = 0xFE; return; } // При нажатии клавиши РУС/ЛАТ возвращается под 0xFE
    a = 0xFF;
}

// Функция для пользовательской программы.
// Получить адрес последнего доступного байта оперативной памяти.
// Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.

void getLastRamAddr()
{
    hl = vLastRamAddr;
}

// Функция для пользовательской программы. Установить адрес последнего доступного байта оперативной памяти.
// Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.

void setLastRamAddr(hl)
{
    vLastRamAddr = hl;
}

// Текстовые строки

uint8_t aCrLfPrompt[] = { "\r\n=>" };

uint8_t aCrLfTab[] = { "\r\n " };

uint8_t aRegs[] = { "\r\n PC-"
                    "\r\n HL-"
                    "\r\n BC-"
                    "\r\n DE-"
                    "\r\n SP-"
                    "\r\n AF-"
                    "\x19\x19\x19\x19\x19\x19" };

uint8_t aBsSpBs[] = { "\x08 \x08" };

// Точка остановки в программе пользователя

void breakHandler()
{
    // Сохраняем HL
    vBreakSavedHl = hl;

    // Сохраняем PSW
    push(a);
    pop(hl);
    vBreakSavedPsw = hl;

    // Сохраняем PC
    pop(hl);
    hl--;
    vBreakSavedPc = hl;

    // Сохраняем SP, BC, DE
    (hl = 0) += sp;
    sp = &vBreakSavedPsw;
    push(hl, de, bc);

    // Вывод на экран адреса остановки
    hl = vBreakSavedPc;
    sp = initalStackAddr;
    putCrLfTabHlSp(hl);

    // Если команда в программе пользователя была заменена на RST, то восстанавливаем команду.
    // И в любом случае возвращаемся в Монитор.
    swap(de, hl);
    hl = vBreakAddr;
    cmpHlDe();
    if (flag_nz) return monitor();
    *hl = a = vBreakPrevCmd;
    return monitor();
    noreturn;
}

// Команда X
// Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.

void cmdX()
{
    // Вывод названий регистров на экран
    puts(hl = &aRegs);

    hl = &vBreakSavedPc; // Адрес первого регистры
    b = 6; // Кол-во регистров
    do
    {
        // Тенкущее значение регистра
        e = *hl;
        hl++;
        d = *hl;

        push(bc, hl)
        {
            swap(hl, de);

            // Вывод текущего значения на экран
            putCrLfTabHlSp(hl);

            // Ввод строки пользователем
            getLine();

            // Если пользователь ввел строку, то преобразуем её в число и сохраняем в памяти
            if (flag_c)
            {
                parseHexNumber16();
                pop(de);
                push(de);
                swap(hl, de);
                *hl = d;
                hl--;
                *hl = e;
            }
        }

        // Следующий цикл
        b--;
        hl++;
    } while (flag_nz);
}

// Команда V
// Измерение константы скорости чтения данных с магнитной ленты

const int cmdV_from   = 33;
const int cmdV_to     = 25;
const int cmdV_result = 128;
const int cmdV_n      = cmdV_result * cmdV_from * 15 / 10 / cmdV_to;

void cmdV()
{
    putCrLfTab();

    // Тут будет общая длительность
    hl = 0;

    // Маска для чтения из порта ввода-вывода b = 1
    // Нужно получить кол-во тактов деленное на 25, а у нас в цикле 33 такта. Компенсиурем это кол-вом измерений.
    bc = [(tapeMask << 8) | cmdV_n];

    // Ожидание изменения уровня на входе магнитной ленты
    a = in(ioSysC);
    a &= b; // тут b = tapeMask
    e = a;
    do
    {
        a = in(ioSysC);
        a &= b; // тут b = tapeMask
    } while (a == e);
    e = a;

    // Изменение длительности
    do
    {
        // Ожидание изменения уровня на входе магнитной ленты
        do
        {
            a = in(ioSysC);   // 10 = IN
            a &= b;           // 4  = AND
            hl++;             // 5  = INX
        } while (a == e);     // 14 = CMP + JNZ = 4 + 10
        e = a;
        // Цикл
    } while (flag_nz c--);

    // Преобразуем вычсиленное значение в константу
    hl += hl;
    hl += (de = 0x80);
    a = h;

    // Сохранение константы
    vTapeSpeedRd = a;

    // Вывод константы на экран
    put8Sp();

    // Возврат в Монитор
    return monitor();
    noreturn;
}

// Команда K <начальный адрес> <конечный адрес>
// Вычисление 16-битной суммы всех байт по адресам hl..de.

void cmdK(hl, de)
{
    // Расчет контрольной суммы
    push(hl)
    {
        calcSum(hl, de); // Результат в bc
    }

    // Вывод: начальный адрес, конечный адрес, контрольная сумма
    putCrLfTabHlSp(hl);
    swap(de, hl);
    putCrLfTabHlSp(hl);
    swap(de, hl);
    push(hl)
    {
        putCrLfTabHlSp(hl = bc);
    }

    // Возврат в Монитор
    return monitor();
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
