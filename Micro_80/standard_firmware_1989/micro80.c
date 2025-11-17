// Firmware for Micro 80 computer from Radio magazine 1989
// Reverse engneering 1-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

#include "cmm.h"
#include <c8080/codepage/koi7.h>

asm(" .org 0xF800");

// Экран
const int SCREEN_ATTRIB_BEGIN = 0xE000;
const int SCREEN_BEGIN = 0xE800;
const int SCREEN_SIZE = 0x800;
const int SCREEN_END = SCREEN_BEGIN + SCREEN_SIZE;
const int SCREEN_WIDTH = 64;
const int SCREEN_HEIGHT = 32;

// Порты ввода-вывода
const int PORT_TAPE = 0x01;
const int PORT_TAPE_BIT = 0x01;
const int PORT_KEYBOARD_MODE = 0x04;
const int PORT_KEYBOARD_COLUMN = 0x07;
const int PORT_KEYBOARD_ROW = 0x06;
const int PORT_KEYBOARD_MODS = 0x05;
const int PORT_EXT_DATA = 0xA0;
const int PORT_EXT_ADDR_LOW = 0xA1;
const int PORT_EXT_ADDR_HIGH = 0xA2;
const int PORT_EXT_MODE = 0xA3;

// Клавиатура
const int KEYBOARD_ROW_MASK = 0x7F;
const int KEYBOARD_MODS_MASK = 0x07;
const int KEYBOARD_RUS_MOD = 1 << 0;
const int KEYBOARD_US_MOD = 1 << 1;
const int KEYBOARD_SHIFT_MOD = 1 << 2;
const int KEYBOARD_COLUMN_COUNT = 8;
const int KEYBOARD_ROW_COUNT = 7;

// Константы магнитофона
const int READ_TAPE_FIRST_BYTE = 0xFF;
const int READ_TAPE_NEXT_BYTE = 8;
const int TAPE_START = 0xE6;
const int TAPE_SPEED = 0x3854;

// Опкоды процессора КР580ВМ80А
const int OPCODE_JMP = 0xC3;
const int OPCODE_RST_30 = 0xF7;
const int OPCODE_RST_38 = 0xFF;

// Прочие константы
const int STACK_TOP = 0xF800;

// Вектора перываний
extern uint8_t rst30Opcode __address(0x30);
extern uint16_t rst30Address __address(0x31);
extern uint8_t rst38Opcode __address(0x38);
extern uint16_t rst38Address __address(0x39);

// Прототипы
void Reboot(...);
void EntryF86C_Monitor(...);
void Reboot2(...);
void Monitor(...);
void Monitor2();
void ReadStringBackspace(...);
void ReadString(...);
void ReadStringBegin(...);
void ReadStringLoop(...);
void ReadStringExit(...);
void PrintString(...);
void ParseParams(...);
void ParseWord(...);
void ParseWordReturnCf(...);
void CompareHlDe(...);
void LoopWithBreak(...);
void Loop(...);
void PopRet();
void IncHl(...);
void CtrlC(...);
void PrintCrLfTab();
void PrintHexByteFromHlSpace(...);
void PrintHexByteSpace(...);
void CmdR(...);
void GetRamTop(...);
void SetRamTop(...);
void CmdA(...);
void CmdD(...);
void PrintSpacesTo(...);
void PrintSpace();
void CmdC(...);
void CmdF(...);
void CmdS(...);
void CmdW(...);
void CmdT(...);
void CmdM(...);
void CmdG(...);
void BreakPointHandler(...);
void CmdX(...);
void GetCursor();
void GetCursorChar();
void CmdH(...);
void CmdI(...);
void MonitorError();
void ReadTapeFile(...);
void ReadTapeWordNext();
void ReadTapeWord(...);
void ReadTapeBlock(...);
void CalculateCheckSum(...);
void CmdO(...);
void WriteTapeFile(...);
void PrintCrLfTabHexWordSpace(...);
void PrintHexWordSpace(...);
void WriteTapeBlock(...);
void WriteTapeWord(...);
void ReadTapeByte(...);
void ReadTapeByteInternal(...);
void ReadTapeByteTimeout(...);
void WriteTapeByte(...);
void PrintHexByte(...);
void PrintHexNibble(...);
void PrintCharA(...);
void PrintChar(...);
void PrintCharSetEscState(...);
void PrintCharSaveCursor(...);
void PrintCharExit(...);
void DrawCursor(...);
void PrintCharEscY2(...);
void PrintCharResetEscState(...);
void PrintCharEsc(...);
void SetCursorVisible(...);
void PrintCharNoEsc(...);
void PrintChar4(...);
void ClearScreen(...);
void MoveCursorHome(...);
void PrintChar3(...);
void PrintCharBeep(...);
void MoveCursorCr(...);
void MoveCursorRight(...);
void MoveCursorBoundary(...);
void MoveCursorLeft(...);
void MoveCursorLf(...);
void MoveCursorUp(...);
void MoveCursor(...);
void MoveCursorDown(...);
void PrintCrLf();
void IsAnyKeyPressed();
void ReadKey();
void ReadKeyInternal(...);
void ScanKey();
void ScanKey2(...);
void ScanKeyExit(...);
void ScanKeyControl(...);
void ScanKeyShift(...);
void ScanKeySpecial(...);
void TranslateCodePageDefault(...);
void TryScrollUp(...);

// Переменные Монитора

extern uint16_t cursor __address(0xF75A);
extern uint8_t tapeReadSpeed __address(0xF75C);
extern uint8_t tapeWriteSpeed __address(0xF75D);
extern uint8_t cursorVisible __address(0xF75E);
extern uint8_t escState __address(0xF75F);
extern uint16_t keyDelay __address(0xF760);
extern uint16_t regPC __address(0xF762);
extern uint16_t regHL __address(0xF764);
extern uint16_t regBC __address(0xF766);
extern uint16_t regDE __address(0xF768);
extern uint16_t regSP __address(0xF76A);
extern uint16_t regAF __address(0xF76C);
extern uint16_t breakPointAddress __address(0xF771);
extern uint8_t breakPointValue __address(0xF773);
extern uint8_t jmpParam1Opcode __address(0xF774);
extern uint16_t param1 __address(0xF775);
extern uint16_t param2 __address(0xF777);
extern uint16_t param3 __address(0xF779);
extern uint8_t param2Exists __address(0xF77B);
extern uint8_t tapePolarity __address(0xF77C);
extern uint8_t translateCodeEnabled __address(0xF77D);
extern uint8_t translateCodePageJump __address(0xF77E);
extern uint16_t translateCodePageAddress __address(0xF77F);
extern uint16_t ramTop __address(0xF781);
extern uint8_t inputBuffer[32] __address(0xF783);

#define firstVariableAddress (&tapeWriteSpeed)
#define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])

extern uint8_t specialKeyTable[8];
extern uint8_t aPrompt[6];
extern uint8_t aCrLfTab[6];
extern uint8_t aRegisters[37];
extern uint8_t aBackspace[4];
extern uint8_t aHello[9];

// Для удобства

void JmpParam1() __address(0xF774);
void TranslateCodePage() __address(0xF77E);

// Точки входа

void EntryF800_Reboot() {
    Reboot();
}

void EntryF803_ReadKey() {
    ReadKey();
}

void EntryF806_ReadTapeByte(...) {
    ReadTapeByte(a);
}

void EntryF809_PrintChar(...) {
    PrintChar(c);
}

void EntryF80C_WriteTapeByte(...) {
    WriteTapeByte(c);
}

void EntryF80F_TranslateCodePage(...) {
    TranslateCodePage(c);
}

void EntryF812_IsAnyKeyPressed() {
    IsAnyKeyPressed();
}

void EntryF815_PrintHexByte(...) {
    PrintHexByte(a);
}

void EntryF818_PrintString(...) {
    PrintString(hl);
}

void EntryF81B_ScanKey() {
    ScanKey();
}

void EntryF81E_GetCursor() {
    GetCursor();
}

void EntryF821_GetCursorChar() {
    GetCursorChar();
}

void EntryF824_ReadTapeFile(...) {
    ReadTapeFile(hl);
}

void EntryF827_WriteTapeFile(...) {
    WriteTapeFile(bc, de, hl);
}

void EntryF82A_CalculateCheckSum(...) {
    CalculateCheckSum(hl, de);
}

void EntryF82D_EnableScreen() {
    return;
    return;
    return;
}

void EntryF830_GetRamTop() {
    GetRamTop();
}

void EntryF833_SetRamTop(...) {
    SetRamTop(hl);
}

// Инициализация. Выполняется после перезагрузки или пользовательской программой.
// Параметры: нет. Функция никогда не завершается.

void Reboot(...) {
    sp = STACK_TOP;

    // Очистка памяти
    hl = firstVariableAddress;
    de = lastVariableAddress;
    bc = 0;
    CmdF();

    translateCodePageJump = a = OPCODE_JMP;

    PrintString(hl = aHello);

    // Проверка ОЗУ
    hl = 0;
    for (;;) {
        c = *hl;
        a = 0x55;
        *hl = a;
        a ^= *hl;
        b = a;
        a = 0xAA;
        *hl = a;
        a ^= *hl;
        a |= b;
        if (flag_nz)
            return Reboot2();
        *hl = c;
        hl++;
        if ((a = h) == SCREEN_ATTRIB_BEGIN >> 8)
            return Reboot2();
    }

    Reboot2();
}

asm(" .org 0xF86C");

void EntryF86C_Monitor() {
    Monitor();
}

void Reboot2(...) {
    hl--;
    ramTop = hl;
    PrintHexWordSpace(hl);
    tapeReadSpeed = hl = TAPE_SPEED;
    translateCodePageAddress = hl = &TranslateCodePageDefault;
    regSP = hl = 0xF7FE;
    Monitor();
}

void Monitor() {
    out(PORT_KEYBOARD_MODE, a = 0x83);
    cursorVisible = a;
    jmpParam1Opcode = a = OPCODE_JMP;
    Monitor2();
}

void Monitor2() {
    sp = STACK_TOP;
    PrintString(hl = aPrompt);
    ReadString();

    push(hl = &EntryF86C_Monitor);

    hl = inputBuffer;
    a = *hl;

    if (a == 'X')
        return CmdX();

    push_pop(a) {
        ParseParams();
        hl = param3;
        c = l;
        b = h;
        hl = param2;
        swap(hl, de);
        hl = param1;
    }

    if (a == 'D')
        return CmdD();
    if (a == 'C')
        return CmdC();
    if (a == 'F')
        return CmdF();
    if (a == 'S')
        return CmdS();
    if (a == 'T')
        return CmdT();
    if (a == 'M')
        return CmdM();
    if (a == 'G')
        return CmdG();
    if (a == 'I')
        return CmdI();
    if (a == 'O')
        return CmdO();
    if (a == 'W')
        return CmdW();
    if (a == 'A')
        return CmdA();
    if (a == 'H')
        return CmdH();
    if (a == 'R')
        return CmdR();
    MonitorError();
}

void ReadStringBackspace(...) {
    if ((a = inputBuffer) == l)
        return ReadStringBegin(hl);
    push_pop(hl) {
        PrintString(hl = aBackspace);
    }
    hl--;
    ReadStringLoop(b, hl);
}

void ReadString() {
    hl = inputBuffer;
    ReadStringBegin(hl);
}

void ReadStringBegin(...) {
    b = 0;
    ReadStringLoop(b, hl);
}

void ReadStringLoop(...) {
    for (;;) {
        ReadKey();
        if (a == 127)
            return ReadStringBackspace();
        if (a == 8)
            return ReadStringBackspace();
        if (flag_nz)
            PrintCharA(a);
        *hl = a;
        if (a == 13)
            return ReadStringExit(b);
        if (a == '.')
            return Monitor2();
        b = 255;
        if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
            return MonitorError();
        hl++;
    }
}

void ReadStringExit(...) {
    a = b;
    carry_rotate_left(a, 1);
    de = inputBuffer;
    b = 0;
}

// Функция для пользовательской программы.
// Вывод строки на экран.
// Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.

void PrintString(...) {
    for (;;) {
        a = *hl;
        if (flag_z(a &= a))
            return;
        PrintCharA(a);
        hl++;
    }
}

void ParseParams(...) {
    hl = &param1;
    de = &param2Exists;
    c = 0;
    CmdF();

    de = inputBuffer + 1;

    ParseWord();
    param1 = hl;
    param2 = hl;
    if (flag_c)
        return;

    param2Exists = a = 0xFF;
    ParseWord();
    param2 = hl;
    if (flag_c)
        return;

    ParseWord();
    param3 = hl;
    if (flag_c)
        return;

    MonitorError();
}

void ParseWord(...) {
    hl = 0;
    for (;;) {
        a = *de;
        de++;
        if (a == 13)
            return ParseWordReturnCf(hl);
        if (a == ',')
            return;
        if (a == ' ')
            continue;
        a -= '0';
        if (flag_m)
            return MonitorError();
        if (flag_p(compare(a, 10))) {
            if (flag_m(compare(a, 17)))
                return MonitorError();
            if (flag_p(compare(a, 23)))
                return MonitorError();
            a -= 7;
        }
        c = a;
        hl += hl;
        hl += hl;
        hl += hl;
        hl += hl;
        if (flag_c)
            return MonitorError();
        hl += bc;
    }
}

void ParseWordReturnCf(...) {
    set_flag_c();
}

void CompareHlDe(...) {
    if ((a = h) != d)
        return;
    compare(a = l, e);
}

void LoopWithBreak(...) {
    CtrlC();
    Loop(hl, de);
}

void Loop(...) {
    CompareHlDe(hl, de);
    if (flag_nz)
        return IncHl(hl);
    PopRet();
}

void PopRet() {
    sp++;
    sp++;
}

void IncHl(...) {
    hl++;
}

void CtrlC() {
    ScanKey();
    if (a != 3)  // УПР + C
        return;
    MonitorError();
}

void PrintCrLfTab() {
    push_pop(hl) {
        PrintString(hl = aCrLfTab);
    }
}

void PrintHexByteFromHlSpace(...) {
    PrintHexByteSpace(a = *hl);
}

void PrintHexByteSpace(...) {
    push_pop(bc) {
        PrintHexByte(a);
        PrintSpace();
    }
}

// Команда R <начальный адрес ПЗУ> <конечный адрес ПЗУ> <начальный адрес назаначения>
// Скопировать блок из внешнего ПЗУ в адресное пространство процессора

void CmdR(...) {
    out(PORT_EXT_MODE, a = 0x90);
    for (;;) {
        out(PORT_EXT_ADDR_LOW, a = l);
        out(PORT_EXT_ADDR_HIGH, a = h);
        *bc = a = in(PORT_EXT_DATA);
        bc++;
        Loop();
    }
}

// Функция для пользовательской программы.
// Получить адрес последнего доступного байта оперативной памяти.
// Параметры: нет. Результат: hl - адрес. Сохраняет: a, bc, de.

void GetRamTop(...) {
    hl = ramTop;
}

// Функция для пользовательской программы.
// Установить адрес последнего доступного байта оперативной памяти.
// Параметры: hl - адрес. Результат: нет. Сохраняет: a, bc, de, hl.

void SetRamTop(...) {
    ramTop = hl;
}

// Команда A <адрес>
// Установить программу преобразования кодировки символов выводимых на экран

void CmdA(...) {
    translateCodePageAddress = hl;
}

// Команда D <начальный адрес> <конечный адрес>
// Вывод блока данных из адресного пространства на экран в 16-ричном виде

void CmdD(...) {
    for (;;) {
        PrintCrLf();
        PrintHexWordSpace(hl);
        push_pop(hl) {
            c = ((a = l) &= 0x0F);
            carry_rotate_right(a, 1);
            b = (((a += c) += c) += 5);
            PrintSpacesTo();
            do {
                PrintHexByte(a = *hl);
                CompareHlDe(hl, de);
                hl++;
                if (flag_z)
                    break;
                (a = l) &= 0x0F;
                push_pop(a) {
                    a &= 1;
                    if (flag_z)
                        PrintSpace();
                }
            } while (flag_nz);
        }

        b = (((a = l) &= 0x0F) += 46);
        PrintSpacesTo(b);

        do {
            a = *hl;
            if (a < 127)
                if (a >= 32)
                    goto loc_fa49;
            a = '.';
        loc_fa49:
            PrintCharA(a);
            CompareHlDe(hl, de);
            if (flag_z)
                return;
            hl++;
            (a = l) &= 0x0F;
        } while (flag_nz);
    }
}

void PrintSpacesTo(...) {
    for (;;) {
        if (((a = cursor) &= (SCREEN_WIDTH - 1)) >= b)
            return;
        PrintSpace();
    }
}

void PrintSpace() {
    PrintCharA(a = ' ');
}

// Команда С <начальный адрес 1> <конечный адрес 1> <начальный адрес 2>
// Сравнить два блока адресного пространство

void CmdC(...) {
    for (;;) {
        if ((a = *bc) != *hl) {
            PrintCrLfTabHexWordSpace(hl);
            PrintHexByteFromHlSpace(hl);
            PrintHexByteSpace(a = *bc);
        }
        bc++;
        LoopWithBreak();
    }
}

// Команда F <начальный адрес> <конечный адрес> <байт>
// Заполнить блок в адресном пространстве одним байтом

void CmdF(...) {
    for (;;) {
        *hl = c;
        Loop();
    }
}

// Команда S <начальный адрес> <конечный адрес> <байт>
// Найти байт (8 битное значение) в адресном пространстве

void CmdS(...) {
    for (;;) {
        if ((a = c) == *hl)
            PrintCrLfTabHexWordSpace(hl);
        LoopWithBreak();
    }
}

// Команда W <начальный адрес> <конечный адрес> <слово>
// Найти слово (16 битное значение) в адресном пространстве

void CmdW(...) {
    for (;;) {
        if ((a = *hl) == c) {
            hl++;
            compare((a = *hl), b);
            hl--;
            if (flag_z)
                PrintCrLfTabHexWordSpace(hl);
        }
        LoopWithBreak();
    }
}

// Команда T <начальный адрес источника> <конечный адрес источника> <начальный адрес назначения>
// Копировать блок в адресном пространстве

void CmdT(...) {
    for (;;) {
        *bc = a = *hl;
        bc++;
        Loop();
    }
}

// Команда M <начальный адрес>
// Вывести на экран адресное пространство побайтно с возможностью изменения

void CmdM(...) {
    for (;;) {
        PrintCrLfTabHexWordSpace(hl);
        PrintHexByteFromHlSpace();
        push_pop(hl) {
            ReadString();
        }
        if (flag_c) {
            push_pop(hl) {
                ParseWord();
                a = l;
            }
            *hl = a;
        }
        hl++;
    }
}

// Команда G <начальный адрес> <конечный адрес>
// Запуск программы и возможным указанием точки останова.

void CmdG(...) {
    CompareHlDe(hl, de);
    if (flag_nz) {
        swap(hl, de);
        breakPointAddress = hl;
        breakPointValue = a = *hl;
        *hl = OPCODE_RST_30;
        rst30Opcode = a = OPCODE_JMP;
        rst30Address = hl = &BreakPointHandler;
    }
    sp = &regBC;
    pop(bc);
    pop(de);
    pop(hl);
    pop(a);
    sp = hl;
    hl = regHL;
    JmpParam1();
}

void BreakPointHandler(...) {
    regHL = hl;
    push(a);
    pop(hl);
    regAF = hl;
    pop(hl);
    hl--;
    regPC = hl;
    (hl = 0) += sp;
    sp = &regAF;
    push(hl);
    push(de);
    push(bc);
    sp = STACK_TOP;
    hl = regPC;
    swap(hl, de);
    hl = breakPointAddress;
    CompareHlDe(hl, de);
    if (flag_nz)
        return CmdX();
    *hl = a = breakPointValue;
    CmdX();
}

// Команда X
// Вывод на экран содержимого регистров микропроцессора с возможностью их изменения.

void CmdX(...) {
    PrintString(hl = aRegisters);
    hl = &regPC;
    b = 6;
    do {
        e = *hl;
        hl++;
        d = *hl;
        push(bc);
        push(hl);
        swap(hl, de);
        PrintCrLfTabHexWordSpace(hl);
        ReadString();
        if (flag_c) {
            ParseWord();
            pop(de);
            push(de);
            swap(hl, de);
            *hl = d;
            hl--;
            *hl = e;
        }
        pop(hl);
        pop(bc);
        b--;
        hl++;
    } while (flag_nz);
    EntryF86C_Monitor();
}

// Функция для пользовательской программы.
// Получить координаты курсора.
// Параметры: нет. Результат: l = x + 8, h = y + 3. Сохраняет регистры: bc, de, hl.

void GetCursor() {
    push_pop(a) {
        hl = cursor;
        h = ((a = h) &= 7);

        // Вычисление X
        a = l;
        a &= (SCREEN_WIDTH - 1);
        a += 8;  // Смещение Радио 86РК

        // Вычисление Y
        hl += hl;
        hl += hl;
        h++;  // Смещение Радио 86РК
        h++;
        h++;

        l = a;
    }
}

// Функция для пользовательской программы.
// Получить символ под курсором.
// Параметры: нет. Результат: a - код символа. Сохраняет регистры: bc, de, hl.

void GetCursorChar() {
    push_pop(hl) {
        hl = cursor;
        a = *hl;
    }
}

// Команда H
// Определить скорости записанной программы.
// Выводит 4 цифры на экран.
// Первые две цифры - константа вывода для команды O
// Последние две цифры - константа вввода для команды I

void CmdH(...) {
    PrintCrLfTab();
    hl = 65408;
    b = 123;

    c = a = in(PORT_TAPE);

    do {
    } while ((a = in(PORT_TAPE)) == c);

    do {
        c = a;
        do {
            hl++;
        } while ((a = in(PORT_TAPE)) == c);
    } while (flag_nz(b--));

    hl += hl;
    a = h;
    hl += hl;
    l = (a += h);

    PrintHexWordSpace();
}

// Команда I <смещение> <скорость>
// Загрузить файл с магнитной ленты

void CmdI(...) {
    if ((a = param2Exists) != 0)
        tapeReadSpeed = a = e;
    ReadTapeFile();
    PrintCrLfTabHexWordSpace(hl);
    swap(hl, de);
    PrintCrLfTabHexWordSpace(hl);
    swap(hl, de);
    push(bc);
    CalculateCheckSum();
    h = b;
    l = c;
    PrintCrLfTabHexWordSpace(hl);
    pop(de);
    CompareHlDe(hl, de);
    if (flag_z)
        return;
    swap(hl, de);
    PrintCrLfTabHexWordSpace(hl);
    MonitorError();
}

void MonitorError() {
    PrintCharA(a = '?');
    Monitor2();
}

// Функция для пользовательской программы.
// Загрузить файл с магнитной ленты.
// Параметры: hl - смещение загрузки. Результат: bc - прочитанная КС, hl - адрес загрузки

void ReadTapeFile(...) {
    ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
    push_pop(hl) {
        hl += bc;
        swap(hl, de);
        ReadTapeWordNext();
    }
    hl += bc;
    swap(hl, de);

    a = in(PORT_KEYBOARD_MODS);
    a &= KEYBOARD_SHIFT_MOD;
    if (flag_z)
        return;

    push_pop(hl) {
        ReadTapeBlock();
        ReadTapeWord(a = READ_TAPE_FIRST_BYTE);
    }
}

void ReadTapeWordNext() {
    ReadTapeWord(a = READ_TAPE_NEXT_BYTE);
}

void ReadTapeWord(...) {
    ReadTapeByte(a);
    b = a;
    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    c = a;
}

void ReadTapeBlock(...) {
    for (;;) {
        ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
        *hl = a;
        Loop();
    }
}

// Функция для пользовательской программы.
// Вычистить 16-битную сумму всех байт по адресам hl..de.
// Параметры: hl - начальный адрес, de - конечный адрес. Результат: bc - сумма. Сохраяет: de.

void CalculateCheckSum(...) {
    bc = 0;
    for (;;) {
        c = ((a = *hl) += c);
        push_pop(a) {
            CompareHlDe(hl, de);
            if (flag_z)
                return PopRet();
        }
        a = b;
        carry_add(a, *hl);
        b = a;
        Loop();
    }
}

// Команда O <начальный адрес> <конечный адрес> <скорость>
// Сохранить блок данных на магнитную ленту

void CmdO(...) {
    if ((a = c) != 0)
        tapeWriteSpeed = a;
    push_pop(hl) {
        CalculateCheckSum(hl, de);
    }
    PrintCrLfTabHexWordSpace(hl);
    swap(hl, de);
    PrintCrLfTabHexWordSpace(hl);
    swap(hl, de);
    push_pop(hl) {
        h = b;
        l = c;
        PrintCrLfTabHexWordSpace(hl);
    }
    WriteTapeFile(hl, de);
}

// Функция для пользовательской программы.
// Запись файла на магнитную ленту.
// Параметры: de - начальный адрес, hl - конечный адрес, bc - контрольная сумма. Результат: нет.

void WriteTapeFile(...) {
    push(bc);
    bc = 0;
    do {
        WriteTapeByte(c);
        b--;
        swap(hl, *sp);
        swap(hl, *sp);
    } while (flag_nz);
    WriteTapeByte(c = TAPE_START);
    WriteTapeWord(hl);
    swap(hl, de);
    WriteTapeWord(hl);
    swap(hl, de);
    WriteTapeBlock(hl, de);
    WriteTapeWord(hl = 0);
    WriteTapeByte(c = TAPE_START);
    pop(hl);
    WriteTapeWord(hl);
    return;
}

void PrintCrLfTabHexWordSpace(...) {
    push_pop(bc) {
        PrintCrLfTab();
        PrintHexWordSpace(hl);
    }
}

void PrintHexWordSpace(...) {
    PrintHexByte(a = h);
    PrintHexByteSpace(a = l);
}

void WriteTapeBlock(...) {
    for (;;) {
        WriteTapeByte(c = *hl);
        Loop();
    }
}

void WriteTapeWord(...) {
    WriteTapeByte(c = h);
    WriteTapeByte(c = l);
}

// Загрузка байта с магнитной ленты.
// Параметры: a = 0xFF с синхронизацией, = 8 без синхронизации.
// Результат: a = прочитанный байт.

void ReadTapeByte(...) {
    push(hl, bc, de);
    d = a;
    ReadTapeByteInternal(d);
}

void ReadTapeByteInternal(...) {
    c = 0;
    e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);
    do {
    retry:  // Сдвиг результата
        (a = c) &= 0x7F;
        cyclic_rotate_left(a, 1);
        c = a;

        // Ожидание изменения бита
        h = 0;
        do {
            h--;
            if (flag_z)
                return ReadTapeByteTimeout(d);
        } while (((a = in(PORT_TAPE)) &= PORT_TAPE_BIT) == e);

        // Сохранение бита
        c = (a |= c);

        // Задержка
        d--;
        a = tapeReadSpeed;
        if (flag_z)
            a -= 18;
        b = a;
        do {
        } while (flag_nz(b--));
        d++;

        // Новое значение бита
        e = ((a = in(PORT_TAPE)) &= PORT_TAPE_BIT);

        // Режим поиска синхробайта
        if (flag_m((a = d) |= a)) {
            if ((a = c) == TAPE_START) {
                tapePolarity = (a ^= a);
            } else {
                if (a != ~TAPE_START)
                    goto retry;
                tapePolarity = a = 255;
            }
            d = 8 + 1;
        }
    } while (flag_nz(d--));
    (a = tapePolarity) ^= c;
    pop(hl, bc, de);
}

void ReadTapeByteTimeout(...) {
    if (flag_p((a = d) |= a))
        return MonitorError();
    CtrlC();
    ReadTapeByteInternal();
}

// Функция для пользовательской программы.
// Запись байта на магнитную ленту.
// Параметры: c = байт. Результат: нет. Сохрнаяет: a, bc, de, hl.

void WriteTapeByte(...) {
    push_pop(bc, de, a) {
        d = 8;
        do {
            // Сдвиг исходного байта
            a = c;
            cyclic_rotate_left(a, 1);
            c = a;

            // Вывод
            (a = PORT_TAPE_BIT) ^= c;
            out(PORT_TAPE, a);

            // Задержка
            b = a = tapeWriteSpeed;
            do {
                b--;
            } while (flag_nz);

            // Вывод
            (a = 0) ^= c;
            out(PORT_TAPE, a);

            // Задержка
            d--;
            a = tapeWriteSpeed;
            if (flag_z)
                a -= 14;
            b = a;
            do {
                b--;
            } while (flag_nz);
            d++;
        } while (flag_nz(d--));
    }
}

// Функция для пользовательской программы.
// Вывод 8 битного числа на экран.
// Параметры: а - число. Результат: нет. Сохраняет: bc, de, hl.

void PrintHexByte(...) {
    push_pop(a) {
        cyclic_rotate_right(a, 4);
        PrintHexNibble(a);
    }
    PrintHexNibble(a);
}

void PrintHexNibble(...) {
    a &= 0x0F;
    if (flag_p(compare(a, 10)))
        a += 'A' - '0' - 10;
    a += '0';
    PrintCharA(a);
}

// Вывод символа на экран.
// Параметры: а - символ. Результат: a и c - символ. Сохраняет: a, b, de, hl.

void PrintCharA(...) {
    PrintChar(c = a);
}

// Функция для пользовательской программы.
// Вывод символа на экран.
// Параметры: c - символ. Результат: нет. Сохраняет: a, b, de, hl.

void PrintChar(...) {
    push(a, bc, de, hl);
    IsAnyKeyPressed();
    DrawCursor(b = 0);
    hl = cursor;
    a = escState;
    a--;
    if (flag_m)
        return PrintCharNoEsc();
    if (flag_z)
        return PrintCharEsc();
    a--;
    if (flag_nz)
        return PrintCharEscY2();

    // Первый параметр ESC Y
    a = c;
    a -= ' ';
    if (flag_m) {
        a ^= a;
    } else {
        if (flag_p(compare(a, SCREEN_HEIGHT)))
            a = SCREEN_HEIGHT - 1;
    }
    cyclic_rotate_right(a, 2);
    c = a;
    b = (a &= 192);
    l = (((a = l) &= 63) |= b);
    b = ((a = c) &= 7);
    h = (((a = h) &= 248) |= b);
    PrintCharSetEscState(hl, a = 3);
}

void PrintCharSetEscState(...) {
    escState = a;
    PrintCharSaveCursor(hl);
}

void PrintCharSaveCursor(...) {
    cursor = hl;
    PrintCharExit();
}

void PrintCharExit(...) {
    DrawCursor(b = 0xFF);
    pop(a, bc, de, hl);
}

void DrawCursor(...) {
    if ((a = cursorVisible) == 0)
        return;
    hl = cursor;
    hl += (de = -SCREEN_SIZE + 1);
    *hl = b;
}

void PrintCharEscY2(...) {
    a = c;
    a -= ' ';
    if (flag_m) {
        a ^= a;
    } else {
        if (flag_p(compare(a, SCREEN_WIDTH)))
            a = SCREEN_WIDTH - 1;
    }
    b = a;
    l = (((a = l) &= 192) |= b);
    PrintCharResetEscState();
}

void PrintCharResetEscState(...) {
    a ^= a;
    PrintCharSetEscState();
}

void PrintCharEsc(...) {
    a = c;
    if (a == 'Y') {
        a = 2;
        return PrintCharSetEscState();
    }
    if (a == 97) {
        a ^= a;
        return SetCursorVisible();
    }
    if (a != 98)
        return PrintCharResetEscState();
    SetCursorVisible();
}

void SetCursorVisible(...) {
    cursorVisible = a;
    PrintCharResetEscState();
}

void PrintCharNoEsc(...) {
    // Остановка вывода нажатием УС + Шифт
    do {
        a = in(PORT_KEYBOARD_MODS);
    } while (flag_z(a &= (KEYBOARD_US_MOD | KEYBOARD_SHIFT_MOD)));

    compare(a = 16, c);
    a = translateCodeEnabled;
    if (flag_z) {
        invert(a);
        translateCodeEnabled = a;
        return PrintCharSaveCursor();
    }
    if (a != 0)
        TranslateCodePage(c);
    a = c;
    if (a == 31)
        return ClearScreen();
    if (flag_m)
        return PrintChar3(a);
    PrintChar4(a);
}

void PrintChar4(...) {
    *hl = a;
    hl++;
    if (flag_m(compare(a = h, SCREEN_END >> 8)))
        return PrintCharSaveCursor(hl);
    PrintCrLf();
    PrintCharExit();
}

void ClearScreen(...) {
    b = ' ';
    a = SCREEN_END >> 8;
    hl = SCREEN_ATTRIB_BEGIN;
    do {
        *hl = b;
        hl++;
        *hl = b;
        hl++;
    } while (a != h);
    MoveCursorHome();
}

void MoveCursorHome(...) {
    PrintCharSaveCursor(hl = SCREEN_BEGIN);
}

void PrintChar3(...) {
    if (a == 12)
        return MoveCursorHome();
    if (a == 13)
        return MoveCursorCr(hl);
    if (a == 10)
        return MoveCursorLf(hl);
    if (a == 8)
        return MoveCursorLeft(hl);
    if (a == 24)
        return MoveCursorRight(hl);
    if (a == 25)
        return MoveCursorUp(hl);
    if (a == 7)
        return PrintCharBeep();
    if (a == 26)
        return MoveCursorDown();
    if (a != 27)
        return PrintChar4(hl, a);
    a = 1;
    PrintCharSetEscState();
}

void PrintCharBeep(...) {
    c = 128;  // Длительность
    e = 32;   // Частота
    do {
        d = e;
        do {
            out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
        } while (flag_nz(e--));
        e = d;
        do {
            out(PORT_KEYBOARD_MODE, a = (7 << 1));
        } while (flag_nz(d--));
    } while (flag_nz(c--));

    PrintCharExit();
}

void MoveCursorCr(...) {
    l = ((a = l) &= ~(SCREEN_WIDTH - 1));
    PrintCharSaveCursor(hl);
}

void MoveCursorRight(...) {
    hl++;
    MoveCursorBoundary(hl);
}

void MoveCursorBoundary(...) {
    a = h;
    a &= 7;
    a |= SCREEN_BEGIN >> 8;
    h = a;
    PrintCharSaveCursor(hl);
}

void MoveCursorLeft(...) {
    hl--;
    MoveCursorBoundary(hl);
}

void MoveCursorLf(...) {
    hl += (bc = SCREEN_WIDTH);
    TryScrollUp(hl);
}

void TryScrollUp(...) {
    if (flag_m(compare(a = h, SCREEN_END >> 8)))
        return PrintCharSaveCursor(hl);

    hl = SCREEN_BEGIN;
    bc = (SCREEN_BEGIN + SCREEN_WIDTH);
    do {
        *hl = a = *bc;
        hl++;
        bc++;
        *hl = a = *bc;
        hl++;
        bc++;
    } while (flag_m(compare(a = b, SCREEN_END >> 8)));
    a = SCREEN_END >> 8;
    c = ' ';
    do {
        *hl = c;
        hl++;
        *hl = c;
        hl++;
    } while (a != h);
    hl = cursor;
    h = ((SCREEN_END >> 8) - 1);
    l = ((a = l) |= 192);
    PrintCharSaveCursor(hl);
}

void MoveCursorUp(...) {
    MoveCursor(hl, bc = -SCREEN_WIDTH);
}

void MoveCursor(...) {
    hl += bc;
    MoveCursorBoundary(hl);
}

void MoveCursorDown(...) {
    MoveCursor(hl, bc = SCREEN_WIDTH);
}

void PrintCrLf() {
    PrintChar(c = 13);
    PrintChar(c = 10);
}

// Функция для пользовательской программы.
// Нажата ли хотя бы одна клавиша на клавиатуре?
// Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.

void IsAnyKeyPressed() {
    out(PORT_KEYBOARD_COLUMN, a ^= a);
    a = in(PORT_KEYBOARD_ROW);
    a &= KEYBOARD_ROW_MASK;
    if (a == KEYBOARD_ROW_MASK) {
        a ^= a;
        return;
    }
    a = 0xFF;
}

// Функция для пользовательской программы.
// Получить код нажатой клавиши на клавиатуре.
// В отличии от функции ScanKey, в этой функции есть задержка повтора.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

void ReadKey() {
    push_pop(hl) {
        hl = keyDelay;
        ReadKeyInternal(hl);
        l = 32;         // Задержка повтора нажатия клавиши
        if (flag_nz) {  // Не таймаут
            do {
                do {
                    l = 2;
                    ReadKeyInternal(hl);
                } while (flag_nz);  // Цикл длится, пока не наступит таймаут
            } while (a >= 128);     // Цикл длится, пока не нажата клавиша
            l = 128;                // Задержка повтора первого нажатия клавиши
        }
        keyDelay = hl;
    }
}

void ReadKeyInternal(...) {
    do {
        ScanKey();
        if (a != h)
            break;

        // Задержка
        push_pop(a) {
            a ^= a;
            do {
                swap(hl, de);
                swap(hl, de);
            } while (flag_nz(a--));
        }
    } while (flag_nz(l--));
    h = a;
}

// Функция для пользовательской программы.
// Получить код нажатой клавиши на клавиатуре.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

void ScanKey() {
    push(bc, de, hl);

    bc = 0x00FE;
    d = KEYBOARD_COLUMN_COUNT;
    do {
        a = c;
        out(PORT_KEYBOARD_COLUMN, a);
        cyclic_rotate_left(a, 1);
        c = a;
        a = in(PORT_KEYBOARD_ROW);
        a &= KEYBOARD_ROW_MASK;
        if (a != KEYBOARD_ROW_MASK)
            return ScanKey2(a);
        b = ((a = b) += KEYBOARD_ROW_COUNT);
    } while (flag_nz(d--));

    a = in(PORT_KEYBOARD_MODS);
    carry_rotate_right(a, 1);
    a = 0xFF;  // Клавиша не нажата
    if (flag_c)
        return ScanKeyExit(a);
    a--;  // Рус/Лат
    ScanKeyExit(a);
}

void ScanKey2(...) {
    for (;;) {
        carry_rotate_right(a, 1);
        if (flag_nc)
            break;
        b++;
    }

    /* b - key number */

    /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
     *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
     * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
     * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
     * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
     * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
     * 48   Space Right Left  Up    Down  Vk    Str   Home */

    a = b;
    if (a >= 48)
        return ScanKeySpecial(a);
    a += 48;
    if (a >= 60)
        if (a < 64)
            a &= 47;

    if (a == 95)
        a = 127;

    c = a;
    a = in(PORT_KEYBOARD_MODS);
    a &= KEYBOARD_MODS_MASK;
    compare(a, KEYBOARD_MODS_MASK);
    b = a;
    a = c;
    if (flag_z)
        return ScanKeyExit(a);
    a = b;
    carry_rotate_right(a, 2);
    if (flag_nc)
        return ScanKeyControl(c);
    carry_rotate_right(a, 1);
    if (flag_nc)
        return ScanKeyShift();
    (a = c) |= 0x20;
    ScanKeyExit(a);
}

void ScanKeyExit(...) {
    pop(bc, de, hl);
}

void ScanKeyControl(...) {
    a = c;
    a &= 0x1F;
    ScanKeyExit(a);
}

void ScanKeyShift(...) {
    a = c;
    if (a == 127)
        a = 95;
    if (a >= 64)
        return ScanKeyExit(a);
    if (a < 48) {
        a |= 16;
        return ScanKeyExit(a);
    }
    a &= 47;
    ScanKeyExit();
}

void ScanKeySpecial(...) {
    hl = specialKeyTable;
    c = (a -= 48);
    b = 0;
    hl += bc;
    a = *hl;
    ScanKeyExit(a);
}

uint8_t specialKeyTable[] = {
    0x20,  // Space
    0x18,  // Right
    0x08,  // Left
    0x19,  // Up
    0x1A,  // Down
    0x0D,  // Enter
    0x1F,  // Clear
    0x0C,  // Home
};

uint8_t aPrompt[] = "\r\n-->";
uint8_t aCrLfTab[] = "\r\n\x18\x18\x18";
uint8_t aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
uint8_t aBackspace[] = "\x08 \x08";
uint8_t aHello[] = "\x1F\nМ/80К ";

void TranslateCodePageDefault(...) {
}

uint8_t padding[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
                     0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
                     0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

asm(" savebin \"micro80.bin\", 0xF800, 0x10000");
