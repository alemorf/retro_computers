// Improved firmware for Micro 80 computer from Radio magazine 1989
// Reverse engneering 1-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// Improvements 25-05-2025 Alexey Morozov
// License: Apache License Version 2.0

#include "cmm.h"
#include <c8080/codepage/micro80.h>

//#define BEEP_ENABLED
//#define CMD_R_ENABLED

asm(" .org 0xF800");

// Экран
const int SCREEN_ATTRIB_BEGIN = 0xE000;
const int SCREEN_BEGIN = 0xE800;
const int SCREEN_SIZE = 0x800;
const int SCREEN_END = SCREEN_BEGIN + SCREEN_SIZE;
const int SCREEN_WIDTH = 64;
const int SCREEN_HEIGHT = 25;
const int SCREEN_ATTRIB_DEFAULT = 0x07;
const int SCREEN_ATTRIB_BLANK = 0x07;
const int SCREEN_ATTRIB_UNDERLINE = 1 << 7;

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
const int KEYBOARD_MODE_RUS = 1 << 0;
const int KEYBOARD_MODE_CAP = 1 << 1;
const int SCAN_RUS = 54;
const int KEY_RUS = 254;
const int KEY_BACKSPACE = 0x7F;

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
void Monitor(...);
void Monitor2();
void ReadString(...);
void PrintString(...);
void ParseParams(...);
void ParseWord(...);
void CompareHlDe(...);
void LoopWithBreak(...);
void Loop(...);
void PopRet();
void IncHl(...);
void CtrlC(...);
void PrintCrLfTab();
void PrintHexByteFromHlSpace(...);
void PrintHexByteSpace(...);
#ifdef CMD_R_ENABLED
void CmdR(...);
#endif
void GetRamTop(...);
void SetRamTop(...);
#ifdef CMD_A_ENABLED
void CmdA(...);
#endif
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
void IsAnyKeyPressed();
void IsAnyKeyPressed2();
void ReadKey();
void ReadKeyInternal(...);
void ScanKey();
void ScanKey2(...);
void ScanKey3(...);
void ScanKeyExit(...);
void ScanKeyControl(...);
void ScanKeySpecial(...);
#ifdef CMD_A_ENABLED
void TranslateCodePageDefault(...);
#endif
void TryScrollUp(...);
void PrintKeyStatusInt(...);
void PrintKeyStatus();

// Переменные Монитора

extern uint8_t keyBuffer __address(0xF756);
extern uint8_t keyCode __address(0xF757);
extern uint8_t keyboardMode __address(0xF758);
extern uint8_t color __address(0xF759);
extern uint16_t cursor __address(0xF75A);
extern uint8_t tapeReadSpeed __address(0xF75C);
extern uint8_t tapeWriteSpeed __address(0xF75D);
extern uint8_t cursorVisible __address(0xF75E);
extern uint8_t escState __address(0xF75F);
extern uint16_t keyDelay __address(0xF760);
extern uint16_t keyLast __address(0xF761);
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
#ifdef CMD_A_ENABLED
extern uint8_t translateCodeEnabled __address(0xF77D);
extern uint8_t translateCodePageJump __address(0xF77E);
extern uint16_t translateCodePageAddress __address(0xF77F);
#endif
extern uint16_t ramTop __address(0xF781);
extern uint8_t inputBuffer[32] __address(0xF783);

#define firstVariableAddress (&keyBuffer)
#define lastVariableAddress (&inputBuffer[sizeof(inputBuffer) - 1])

extern uint8_t specialKeyTable[9];
extern uint8_t aPrompt[6];
extern uint8_t aCrLfTab[6];
extern uint8_t aRegisters[37];
extern uint8_t aBackspace[4];
extern uint8_t aHello[12];

// Для удобства

void JmpParam1() __address(0xF774);
#ifdef CMD_A_ENABLED
void TranslateCodePage() __address(0xF77E);
#endif

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
#ifdef CMD_A_ENABLED
    TranslateCodePage(c);
#else
    return;
    return;
    return;
#endif
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

void EntryF836_InitMonitor(...) {
    // Очистка памяти
    hl = firstVariableAddress;
    de = lastVariableAddress;
    c = 0;
    CmdF();

    color = a = SCREEN_ATTRIB_DEFAULT;
#ifdef CMD_A_ENABLED
    translateCodePageJump = a = OPCODE_JMP;
#endif

    PrintString(hl = aHello);

    ramTop = hl = SCREEN_ATTRIB_BEGIN - 1;
    tapeReadSpeed = hl = TAPE_SPEED;
#ifdef CMD_A_ENABLED
    translateCodePageAddress = hl = &TranslateCodePageDefault;
#endif
    regSP = hl = STACK_TOP - 2;
    
    out(PORT_KEYBOARD_MODE, a = 0x83);
}

// Инициализация. Выполняется после перезагрузки или пользовательской программой.
// Параметры: нет. Функция никогда не завершается.

void Reboot(...) {
    disable_interrupts();
    sp = STACK_TOP;
    EntryF836_InitMonitor();
    asm(" nop");
    asm(" nop");
}

asm(" .org 0xF86C");

void EntryF86C_Monitor() {
    Monitor();
}

void Monitor() {
    out(PORT_KEYBOARD_MODE, a = 0x83);
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
    a &= 0x7F;

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
#ifdef CMD_A_ENABLED
    if (a == 'A')
        return CmdA();
#endif
    if (a == 'H')
        return CmdH();
#ifdef CMD_R_ENABLED
    if (a == 'R')
        return CmdR();
#endif
    MonitorError();
}

void ReadString() {
    de = inputBuffer;
    h = d;
    l = e;
    for (;;) {
        ReadKey();
        if (a == KEY_BACKSPACE) {
            if ((a = e) == l)
                continue;
            hl--;
            push_pop(hl) {
                PrintString(hl = aBackspace);
            }
            continue;
        }
        *hl = a;
        if (a == 13) {
            if ((a = e) != l)
                set_flag_c();
            return;
        }
        if (a == '.')
            return Monitor2();
        if (a < 32)
            a = '.';
        PrintCharA(a);
        if ((a = inputBuffer + sizeof(inputBuffer) - 1) == l)
            return MonitorError();
        hl++;
    }
}

// Функция для пользовательской программы.
// Вывод строки на экран.
// Параметры: hl - адрес стороки. Результат: hl - следующий адрес за терминатором строки. Сохраняются: b, de.

void PrintString(...) {
    for (;;) {
        a = *hl;
        if (a == 0)
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

    param2Exists = a = d; /* Not 0 */
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
        compare(a, 13);
        set_flag_c();
        if (flag_z)
            return;
        de++;
        if (a == ',')
            return;
        if (a == ' ')
            continue;
        push(bc = &MonitorError);
        a &= 0x7F;
        a -= '0';
        if (flag_c)
            return;
        if (a >= 10) {
            if (a < 17)
                return;
            if (a >= 23)
                return;
            a -= 7;
        }
        hl += hl;
        if (flag_c)
            return;
        hl += hl;
        if (flag_c)
            return;
        hl += hl;
        if (flag_c)
            return;
        hl += hl;
        if (flag_c)
            return;
        b = 0;
        c = a;
        hl += bc;
        pop(bc);
    }
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

#ifdef CMD_R_ENABLED
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
#endif

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

#ifdef CMD_A_ENABLED
// Команда A <адрес>
// Установить программу преобразования кодировки символов выводимых на экран

void CmdA(...) {
    translateCodePageAddress = hl;
}
#endif

// Команда D <начальный адрес> <конечный адрес>
// Вывод блока данных из адресного пространства на экран в 16-ричном виде

void CmdD(...) {
    for (;;) {
        PrintChar(c = 13);
        PrintChar(c = 10);
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
            if (a < 32)
                a = '.';
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
    hl = cursor;
    DrawCursor(hl);
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
    DrawCursor(hl);
    pop(a, bc, de, hl);
}

void DrawCursor(...) {
    if ((a = cursorVisible) == 0)
        return;
    d = ((a = h) -= (SCREEN_SIZE >> 8));
    e = l;
    a = *de;
    a ^= SCREEN_ATTRIB_UNDERLINE;
    *de = a;
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

#ifdef CMD_A_ENABLED
    compare(a = 16, c);
    a = translateCodeEnabled;
    if (flag_z) {
        invert(a);
        translateCodeEnabled = a;
        return PrintCharSaveCursor();
    }
    if (a != 0)
        TranslateCodePage(c);
#endif
    a = c;
    if (a == 31)
        return ClearScreen();
    if (flag_m)
        return PrintChar3(a);
    PrintChar4(a);
}

void PrintChar4(...) {
    *hl = a;
    d = ((a = h) -= (SCREEN_SIZE >> 8));
    e = l;
    *de = a = color;
    hl++;
    TryScrollUp(hl);
}

void ClearScreenInt(...) {
    do {
        do {
            *hl = 0;
            hl++;
            *de = a;
            de++;
        } while (flag_nz(c--));
    } while (flag_nz(b--));
}

void ClearScreen() {
    hl = SCREEN_BEGIN;
    de = SCREEN_ATTRIB_BEGIN;
    bc = 25 * SCREEN_WIDTH + 0x100;  // 25 строк
    a = color;
    ClearScreenInt();
    a = SCREEN_ATTRIB_BLANK;
    bc = 7 * SCREEN_WIDTH + 0x100;  // 7 строк
    ClearScreenInt();
    PrintKeyStatus();
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
#ifdef BEEP_ENABLED
        return PrintCharBeep();
#else
        return PrintCharExit();
#endif
    if (a == 26)
        return MoveCursorDown();
    if (a != 27)
        return PrintChar4(hl, a);
    a = 1;
    PrintCharSetEscState();
}

#ifdef BEEP_ENABLED
void PrintCharBeep(...) {
    bc = (32 << 8) | 128; // Частота, Длительность
    do {
        e = b;
        do {
            out(PORT_KEYBOARD_MODE, a = 1 | (7 << 1));
        } while (flag_nz(e--));
        e = b;
        do {
            out(PORT_KEYBOARD_MODE, a = (7 << 1));
        } while (flag_nz(e--));
    } while (flag_nz(c--));

    PrintCharExit();
}
#endif

void MoveCursorCr(...) {
    l = ((a = l) &= ~(SCREEN_WIDTH - 1));
    PrintCharSaveCursor(hl);
}

void MoveCursorRight(...) {
    hl++;
    MoveCursorBoundary(hl);
}

const int ZERO_LINE = (SCREEN_BEGIN >> 6) & 0xFF;

void MoveCursorBoundary(...) {
    push_pop(hl) {
        hl += hl;
        hl += hl;
        a = h;
    }

    if (a < ZERO_LINE)
        hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);

    if (a >= SCREEN_HEIGHT + ZERO_LINE)
        hl += (de = -SCREEN_WIDTH * SCREEN_HEIGHT);

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
    swap(hl, de);
    hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT);
    hl += de;
    swap(hl, de);
    if (flag_nc)
        return PrintCharSaveCursor(hl);

    push_pop(hl) {
        hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1;
        c = SCREEN_WIDTH;
        do {
            push_pop(hl) {
                de = SCREEN_SIZE - SCREEN_WIDTH;
                b = 0;
                c = a = color;
                do {
                    a = b;
                    b = *hl;
                    *hl = a;
                    h = ((a = h) -= (SCREEN_SIZE >> 8));
                    a = c;
                    c = *hl;
                    *hl = a;
                    hl += de;
                } while ((a = h) != (SCREEN_BEGIN >> 8) - 1);
            }
            l--;
        } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
    }
    MoveCursorUp();
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

// Функция для пользовательской программы.
// 1) Эта функция вызывается из CP/M при выводе каждого символа.
// 2) Эта функция вызывается из игры Zork перед вызовом ReadKey
// Нажата ли хотя бы одна клавиша на клавиатуре?
// Параметры: нет. Результат:  a - 0xFF если клавиша нажата, 0 если нет. Сохраняет: bc, de, hl.

void IsAnyKeyPressed3();

void IsAnyKeyPressed() {
    // Если ли клавиша в буфере
    IsAnyKeyPressed3();
    if (flag_nz)
        return;
    
    // Если при прошлом вызове была нажата клавиша
    a = keyLast;
    a++;
    if (flag_nz) {
        // Если клавиша все еще нажата
        out(PORT_KEYBOARD_COLUMN, a ^= a);
        a = in(PORT_KEYBOARD_ROW);
        invert(a);
        a += a;
        // Выход с кодом 0, если клавиша все еще нажата 
        a = 0;
        if (flag_nz)
            return;
    }
    
    IsAnyKeyPressed2();
}

void IsAnyKeyPressed2() {
    push_pop(bc, de, hl) {
        hl = keyDelay;
        ReadKeyInternal(hl);
        l = 32; // Задержка повтора нажатия клавиши
        if (flag_nz) { // Это было первое нажатие клавиши. Антидребезг.
            l = 2;
            ReadKeyInternal(hl);
            if (flag_nz)
                a = 0xFF;
            l = 128; // Задержка повтора первого нажатия клавиши
        }
        keyDelay = hl;

        if (a == SCAN_RUS) {
            a = in(PORT_KEYBOARD_MODS);
            carry_rotate_right(a, 3); // Shift
            a = KEYBOARD_MODE_CAP;
            carry_sub(a, 0); // KEYBOARD_MODE_CAP -> KEYBOARD_MODE_RUS
            hl = &keyboardMode;
            a ^= *hl;
            *hl = a;
            PrintKeyStatus();
        } else {
            a = c;
            a++;
            keyBuffer = a;
        }
    }
    IsAnyKeyPressed3();
}

void IsAnyKeyPressed3() {
    a = keyBuffer;
    a += 0xFF;
    carry_sub(a, a);
}

void ReadKeyInternal(...) {
    do {
        ScanKey();
        c = a;
        a = keyCode;
        compare(a, h);
        h = a;
        if (flag_nz) // Нажата другая клавиша
            return;
        if (a == 0xFF)
            return; // Ни одна клавиша не нажата
        
        // Задержка
        b = 0;
        do {
            swap(hl, de);
            swap(hl, de);
        } while (flag_nz(b--));
    } while (flag_nz(l--));
}


// Функция для пользовательской программы.
// Получить код нажатой клавиши на клавиатуре.
// В отличии от функции ScanKey, в этой функции есть задержка повтора.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

void ReadKey() {
    push_pop(hl) {
        hl = &keyBuffer;
        for (;;) {
            a = *hl;
            if (a != 0)
                break;
            IsAnyKeyPressed2();
        }
        *hl = 0;
        a--;
    }
}
    
// Функция для пользовательской программы.
// Получить код нажатой клавиши на клавиатуре.
// Параметры: нет. Результат: a. Сохраняет: bc, de, hl.

void ScanKey() {
    push(bc, de, hl);

    bc = 0xFEFE;
    do {
        a = c;
        out(PORT_KEYBOARD_COLUMN, a);
        a = in(PORT_KEYBOARD_ROW);
        invert(a);
        a += a;
        if (flag_nz)
            return ScanKey2(a);
        b = ((a = b) += KEYBOARD_ROW_COUNT);
        a = c;
        cyclic_rotate_left(a, 1);
        c = a;
    } while (flag_c);

    a = in(PORT_KEYBOARD_MODS);
    carry_rotate_right(a, 1);
    b++;
    b++;
    if (flag_nc)
        return ScanKey3(b);
    keyCode = a = 0xFF;
    ScanKeyExit(a);
}

void ScanKey2(...) {
    do {
        b++;
        carry_rotate_right(a, 1);
    } while (flag_nc);
    ScanKey3(b);
}

void ScanKey3(...) {
    // b - key number

    //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
    //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
    // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
    // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
    // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
    // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
    // 48   Space Right Left  Up    Down  Vk    Str   Home

    a = b;
    keyCode = a;
    if (a >= 48)
        return ScanKeySpecial(a);
    a += 48;
    if (a >= 60)
        if (a < 64)
            a &= 47;

    c = a;

    a = keyboardMode;
    carry_rotate_right(a, 1);
    d = a;
    if (flag_c) { // KEYBOARD_MODE_RUS
        a = c;
        a |= 0x20;
        c = a;
    }

    a = in(PORT_KEYBOARD_MODS);
    carry_rotate_right(a, 2);
    if (flag_nc)
        return ScanKeyControl(c);
    carry_rotate_right(a, 1);
    a = c;
    if (flag_nc) {
        a ^= 0x10;
        if (a >= 64)
            a ^= 0x80 | 0x10;
    }
    c = a;
    a = d;
    carry_rotate_right(a, 1);
    if (flag_c) { // KEYBOARD_MODE_CAP
        a = c;
        a &= 0x7F;
        if (a >= 0x60)  // Кириллица
            goto convert;
        if (a >= 'A') {
            if (a < 'Z' + 1) {
convert:        a = c;
                a ^= 0x80;
                c = a;
            }
        }
    }
    a = c;
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

void ScanKeySpecial(...) {
    h = (uintptr_t)specialKeyTable >> 8;
    l = (a += (uintptr_t)specialKeyTable - 48);
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
    KEY_BACKSPACE
};

uint8_t aPrompt[] = "\r\n-->";
uint8_t aCrLfTab[] = "\r\n\x18\x18\x18";
uint8_t aRegisters[] = "\r\nPC-\r\nHL-\r\nBC-\r\nDE-\r\nSP-\r\nAF-\x19\x19\x19\x19\x19\x19";
uint8_t aBackspace[] = "\x08 \x08";
uint8_t aHello[] = "\x1FМИКРО 80\x1BБ";

#ifdef CMD_A_ENABLED
void TranslateCodePageDefault(...) {
}
#endif

uint8_t aZag[3] = "Заг";
uint8_t aStr[3] = "Стр";
uint8_t aLat[3] = "Лат";
uint8_t aRus[3] = "Рус";

void PrintKeyStatus() {
    bc = SCREEN_BEGIN + 56 + 31 * SCREEN_WIDTH;
    a = keyboardMode;
    hl = aLat;
    PrintKeyStatusInt(a, bc, hl);
    bc++;
    l = aZag;
    PrintKeyStatusInt(a, bc, hl);
}

void PrintKeyStatusInt(...) {
    de = sizeof(aZag);
    cyclic_rotate_right(a, 1);
    if (flag_c)
        hl += de;
    d = a;
    do {
        *bc = a = *hl;
        bc++;
        hl++;
    } while (flag_nz(e--));
    a = d;
}

asm(" savebin \"micro80.bin\", 0xF800, 0x10000");
