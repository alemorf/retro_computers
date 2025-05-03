// Прошивка компьютера Микро 80 из журнала Радио за 1983 год
// Реверc-инженеринг 3-05-2025 Алексей Морозов aleksey.f.morozov@gmail.com

#include "cmm.h"

asm(" .org 0xF800");

// Экран
const int SCREEN_ATTRIB_BEGIN = 0xE000;
const int SCREEN_BEGIN = 0xE800;
const int SCREEN_SIZE = 0x800;
const int SCREEN_END = SCREEN_BEGIN + SCREEN_SIZE;
const int SCREEN_WIDTH = 64;
const int SCREEN_HEIGHT = 32;
const int SCREEN_ATTRIB_DEFAULT = 0;
const int SCREEN_ATTRIB_UNDERLINE = 1 << 7;

// Порты ввода-вывода
const int PORT_TAPE = 0x01;
const int PORT_TAPE_BIT = 0x01;
const int PORT_KEYBOARD_MODE = 0x04;
const int PORT_KEYBOARD_COLUMN = 0x07;
const int PORT_KEYBOARD_ROW = 0x06;
const int PORT_KEYBOARD_MODS = 0x05;

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

// Опкоды процессора КР580ВМ80А
const int OPCODE_JMP = 0xC3;
const int OPCODE_RST_38 = 0xFF;

// Вектора перываний
extern uint8_t rst38Opcode __address(0x38);
extern uint16_t rst38Address __address(0x39);

// Прототипы
void Reboot();
void ReadKey();
void ReadKey0();
void ReadKey1(...);
void ReadKey2(...);
void ReadKeyDelay();
void ReadTapeByte(...);
void PrintChar(...);
void WriteTapeByte(...);
void PrintChar(...);
void IsAnyKeyPressed();
void PrintHexByte(...);
void PrintString(...);
void Monitor();
void MonitorExecute();
void PrintCharA(...);
void ReadString();
void MonitorError();
void ReadStringLoop(...);
void CommonBs(...);
void PrintSpace(...);
void InputBs(...);
void InputEndSpace(...);
void PopWordReturn(...);
void InputLoop(...);
void InputInit(...);
void ParseWord(...);
void CompareHlDe(...);
void ParseWordReturnCf(...);
void PrintHex(...);
void PrintParam1Space();
void PrintHexWordSpace(...);
void IncWord(...);
void PrintRegs();
void CmdXS(...);
void FindRegister(...);
void ReadKey(...);
void PrintRegMinus(...);
void InitRst38();
void BreakPoint(...);
void BreakPointAt2(...);
void BreakpointAt3(...);
void Run();
void ContinueBreakpoint(...);
void CmdQResult(...);
void CmdIEnd(...);
void ReadTapeDelay(...);
void PrintCharInt(...);
void WriteTapeDelay(...);
void TapeDelay(...);
void ClearScreen();
void MoveCursorLeft(...);
void MoveCursorRight(...);
void MoveCursorUp(...);
void MoveCursorDown(...);
void MoveCursorNextLine(...);
void MoveCursorHome();
void ClearScreenInt();
void MoveCursor(...);
void MoveCursorNextLine1(...);
void ReadStringBs(...);
void ReadStringCr(...);

extern uint8_t aPrompt[22];
extern uint8_t monitorCommands;
extern uint8_t regList[19];
extern uint8_t aLf[2];
extern uint8_t keyTable[8];

// Переменные монитора
void jumpParam1(void) __address(0xF750);
extern uint8_t jumpOpcode __address(0xF750);
extern uint16_t param1 __address(0xF751);
extern uint8_t param1h __address(0xF752);
extern uint16_t param2 __address(0xF753);
extern uint8_t param2h __address(0xF754);
extern uint16_t param3 __address(0xF755);
extern uint8_t param3h __address(0xF756);
extern uint8_t tapePolarity __address(0xF757);
// Unused 0xF758
// Unused 0xF759
extern uint16_t cursor __address(0xF75A);
extern uint8_t readDelay __address(0xF75C);
extern uint8_t writeDelay __address(0xF75D);
extern uint8_t tapeStartL __address(0xF75E);
extern uint8_t tapeStartH __address(0xF75F);
extern uint8_t tapeStopL __address(0xF760);
extern uint8_t tapeStopH __address(0xF761);
// Unused 0xF762
// Unused 0xF763
extern uint8_t keyLast __address(0xF764);
extern uint16_t regs __address(0xF765);
extern uint16_t regSP __address(0xF765);
extern uint8_t regSPH __address(0xF766);
extern uint16_t regF __address(0xF767);
extern uint16_t regA __address(0xF768);
extern uint16_t regC __address(0xF769);
extern uint16_t regB __address(0xF76A);
extern uint16_t regE __address(0xF76B);
extern uint16_t regD __address(0xF76C);
extern uint16_t regL __address(0xF76D);
extern uint16_t regHL __address(0xF76D);
extern uint16_t regH __address(0xF76E);
extern uint16_t lastBreakAddress __address(0xF76F);
extern uint8_t lastBreakAddressHigh __address(0xF770);
extern uint8_t breakCounter __address(0xF771);
extern uint16_t breakAddress __address(0xF772);
extern uint8_t breakPrevByte __address(0xF774);
extern uint16_t breakAddress2 __address(0xF775);
extern uint8_t breakPrevByte2 __address(0xF777);
extern uint16_t breakAddress3 __address(0xF778);
extern uint8_t breakPrevByte3 __address(0xF77A);
extern uint8_t cmdBuffer __address(0xF77B);
extern uint8_t cmdBuffer1 __address(0xF77B + 1);
extern uint8_t cmdBufferEnd __address(0xF77B + 32);

const int USER_STACK_TOP = 0xF7C0;
const int STACK_TOP = 0xF7FF;

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
    PrintChar(c);
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

// Инициализация. Выполняется после перезагрузки или пользовательской программой.
// Параметры: нет. Функция никогда не завершается.

void Reboot() {
    regSP = hl = USER_STACK_TOP;
    sp = STACK_TOP;
    PrintCharA(a = 0x1F);  // Clear screen
    Monitor();
}

void Monitor() {
    out(PORT_KEYBOARD_MODE, a = 0x8B);
    sp = STACK_TOP;
    PrintString(hl = &aPrompt);
    ReadString();
    push(hl = &Monitor);
    MonitorExecute();
}

void MonitorExecute() {
    hl = &cmdBuffer;
    b = *hl;
    hl = &monitorCommands;

    for (;;) {
        a = *hl;
        if (flag_z(a &= a))
            return MonitorError();
        if (a == b)
            break;
        hl++;
        hl++;
        hl++;
    }

    hl++;
    sp = hl;
    pop(hl);
    sp = STACK_TOP - 2;
    return hl();
}

void ReadString() {
    return ReadStringLoop(hl = &cmdBuffer);
}

void ReadStringLoop(...) {
    do {
        ReadKey();
        if (a == 8)
            return ReadStringBs();
        if (flag_nz)
            PrintCharA();
        *hl = a;
        if (a == 0x0D)
            return ReadStringCr(hl);
        a = &cmdBufferEnd - 1;
        compare(a, l);
        hl++;
    } while (flag_nz);
    MonitorError();
}

void MonitorError() {
    PrintCharA(a = '?');
    Monitor();
}

void ReadStringCr(...) {
    *hl = 0x0D;
}

void ReadStringBs(...) {
    CommonBs();
    ReadStringLoop();
}

void CommonBs(...) {
    if ((a = &cmdBuffer) == l)
        return;
    PrintCharA(a = 8);
    hl--;
}

void Input(...) {
    PrintSpace();
    InputInit(hl = &cmdBuffer);
}

void InputInit(...) {
    InputLoop(b = 0);
}

void InputLoop(...) {
    for (;;) {
        ReadKey();
        if (a == 8)
            return InputBs();
        if (flag_nz)
            PrintCharA();
        *hl = a;
        if (a == ' ')
            return InputEndSpace();
        if (a == 0x0D)
            return PopWordReturn();
        b = 0xFF;
        if ((a = &cmdBufferEnd - 1) == l)
            return MonitorError();
        hl++;
    }
}

void InputEndSpace(...) {
    *hl = 0x0D;
    a = b;
    carry_rotate_left(a, 1);
    de = &cmdBuffer;
    b = 0;
}

void InputBs(...) {
    CommonBs();
    if (flag_z)
        return InputInit();
    InputLoop();
}

void PopWordReturn(...) {
    sp++;
    sp++;
}

void PrintLf(...) {
    PrintString(hl = &aLf);
}

void PrintString(...) {
    for (;;) {
        a = *hl;
        if (flag_z(a &= a))
            return;
        PrintCharA(a);
        hl++;
    }
}

void ParseParams() {
    hl = &param1;
    b = 6;
    a ^= a;
    do {
        *hl = a;
    } while (flag_nz(b--));

    de = &cmdBuffer + 1;
    ParseWord();
    param1 = hl;
    param2 = hl;
    if (flag_c)
        return;

    ParseWord();
    param2 = hl;
    push_pop(a, de) {
        swap(hl, de);
        hl = param1;
        swap(hl, de);
        CompareHlDe();
        if (flag_c)
            return MonitorError();
    }
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

void PrintByteFromParam1(...) {
    hl = param1;
    PrintHexByte(a = *hl);
}

void PrintHexByte(...) {
    b = a;
    a = b;
    cyclic_rotate_right(a, 4);
    PrintHex(a);
    PrintHex(a = b);
}

void PrintHex(...) {
    a &= 0x0F;
    if (flag_p(compare(a, 10)))
        a += 'A' - '0' - 10;
    a += '0';
    PrintCharA(a);
}

void PrintLfParam1(...) {
    PrintLf();
    PrintParam1Space();
}

void PrintParam1Space() {
    PrintHexWordSpace(hl = &param1h);
}

void PrintHexWordSpace(...) {
    PrintHexByte(a = *hl);
    hl--;
    PrintHexByte(a = *hl);
    PrintSpace();
}

void PrintSpace(...) {
    PrintCharA(a = ' ');
}

void Loop(...) {
    push_pop(de) {
        hl = param1;
        swap(hl, de);
        hl = param2;
        CompareHlDe(hl, de);
    }
    if (flag_z)
        return PopWordReturn();
    IncWord(hl = &param1);
}

void IncWord(...) {
    (*hl)++;
    if (flag_nz)
        return;
    hl++;
    (*hl)++;
}

void CompareHlDe(...) {
    if ((a = h) != d)
        return;
    compare(a = l, e);
}

// Команда X
// Изменение содержимого внутреннего регистра микропроцессора

void CmdX() {
    hl = &cmdBuffer1;
    a = *hl;
    if (a == 0x0D)
        return PrintRegs();
    if (a == 'S')
        return CmdXS();
    FindRegister(de = &regList);
    hl = &regs;
    de++;
    l = a = *de;
    push_pop(hl) {
        PrintSpace();
        PrintHexByte(a = *hl);
        Input();
        if (flag_nc)
            return Monitor();
        ParseWord();
        a = l;
    }
    *hl = a;
}

void CmdXS() {
    PrintSpace();
    PrintHexWordSpace(hl = &regSPH);
    Input();
    if (flag_nc)
        return Monitor();
    ParseWord();
    regSP = hl;
}

void FindRegister(...) {
    for (;;) {
        a = *de;
        if (flag_z(a &= a))
            return MonitorError();
        if (a == *hl)
            return;
        de++;
        de++;
    }
}

void PrintRegs(...) {
    de = &regList;
    b = 8;
    PrintLf();
    do {
        c = a = *de;
        de++;
        push_pop(bc) {
            PrintRegMinus(c);
            a = *de;
            hl = &regs;
            l = a;
            PrintHexByte(a = *hl);
        }
        de++;
    } while (flag_nz(b--));

    c = a = *de;
    PrintRegMinus();
    param1 = hl = regs;
    PrintParam1Space();
    PrintRegMinus(c = 'O');
    PrintHexWordSpace(hl = &lastBreakAddressHigh);
    PrintLf();
}

void PrintRegMinus(...) {
    PrintSpace();
    PrintCharA(a = c);
    PrintCharA(a = '-');
}

uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC,
                     'D', (uint8_t)(uintptr_t)&regD, 'E', (uint8_t)(uintptr_t)&regE, 'F', (uint8_t)(uintptr_t)&regF,
                     'H', (uint8_t)(uintptr_t)&regH, 'L', (uint8_t)(uintptr_t)&regL, 'S', (uint8_t)(uintptr_t)&regSP,
                     0};

uint8_t aStart[] = "\x0ASTART-";
uint8_t aDir_[] = "\x0ADIR. -";

// Команда B
// Задание адреса останова при отладке

void CmdB() {
    ParseParams();
    InitRst38();
    hl = param1;
    a = *hl;
    *hl = OPCODE_RST_38;
    breakAddress = hl;
    breakPrevByte = a;
}

void InitRst38() {
    rst38Opcode = a = OPCODE_JMP;
    rst38Address = hl = &BreakPoint;
}

void BreakPoint(...) {
    regHL = hl;
    push(a);
    hl = 4;
    hl += sp;
    regs = hl;
    pop(a);
    swap(*sp, hl);
    hl--;
    swap(*sp, hl);
    sp = &regHL;
    push(de, bc, a);
    sp = STACK_TOP;

    hl = regSP;
    hl--;
    d = *hl;
    hl--;
    e = *hl;
    l = e;
    h = d;
    lastBreakAddress = hl;

    hl = breakAddress;
    CompareHlDe();
    if (flag_nz) {
        hl = breakAddress2;
        CompareHlDe(hl, de);
        if (flag_z)
            return BreakPointAt2();

        hl = breakAddress3;
        CompareHlDe(hl, de);
        if (flag_z)
            return BreakpointAt3();

        return MonitorError();
    }
    *hl = a = breakPrevByte;
    breakAddress = hl = 0xFFFF;
    return Monitor();
}

// Команда G<адрес>
// Запуск программы в отладочном режиме

void CmdG() {
    ParseParams();
    if ((a = cmdBuffer1) == 0x0D)
        param1 = hl = lastBreakAddress;
    Run();
}

void Run() {
    jumpOpcode = a = OPCODE_JMP;
    sp = &regs;
    pop(de, bc, a, hl);
    sp = hl;
    hl = regHL;
    jumpParam1();
}

void CmdP(...) {
    ParseParams();
    InitRst38();

    breakAddress2 = hl = param1;
    a = *hl;
    *hl = OPCODE_RST_38;
    breakPrevByte2 = a;

    breakAddress3 = hl = param2;
    a = *hl;
    *hl = OPCODE_RST_38;
    breakPrevByte3 = a;

    breakCounter = a = param3;

    PrintString(hl = &aStart);

    hl = &cmdBuffer1;
    ReadStringLoop();
    ParseParams();
    PrintString(hl = &aDir_);
    ReadString();
    Run();
}

void BreakPointAt2(...) {
    *hl = a = breakPrevByte2;

    hl = breakAddress3;
    a = OPCODE_RST_38;
    if (a != *hl) {
        b = *hl;
        *hl = a;
        breakPrevByte3 = a = b;
    }
    ContinueBreakpoint();
}

void ContinueBreakpoint(...) {
    PrintRegs();
    MonitorExecute();
    param1 = hl = lastBreakAddress;
    Run();
}

void BreakpointAt3(...) {
    *hl = a = breakPrevByte3;

    hl = breakAddress2;
    a = OPCODE_RST_38;
    if (a == *hl)
        return ContinueBreakpoint();
    b = *hl;
    *hl = a;
    breakPrevByte2 = a = b;

    hl = &breakCounter;
    (*hl)--;
    if (flag_nz)
        return ContinueBreakpoint();

    a = breakPrevByte2;
    hl = breakAddress2;
    *hl = a;
    Monitor();
}

// Команда D<адрес>,<адрес>
// Просмотр содержимого области памяти в шестнадцатеричном виде

void CmdD() {
    ParseParams();
    PrintLf();
CmdDLine:
    PrintLfParam1();
    for (;;) {
        PrintSpace();
        PrintByteFromParam1();
        Loop();
        a = param1;
        a &= 0x0F;
        if (flag_z)
            goto CmdDLine;
    }
}

// Команда C<адрес от>,<адрес до>,<адрес от 2>
// Сравнение содержимого двух областей памяти

void CmdC() {
    ParseParams();
    hl = param3;
    swap(hl, de);
    for (;;) {
        hl = param1;
        a = *de;
        if (a != *hl) {
            PrintLfParam1();
            PrintSpace();
            PrintByteFromParam1();
            PrintSpace();
            a = *de;
            PrintHexByte();
        }
        de++;
        Loop();
    }
}

// Команда F<адрес>,<адрес>,<байт>
// Запись байта во все ячейки области памяти

void CmdF() {
    ParseParams();
    b = a = param3;
    for (;;) {
        hl = param1;
        *hl = b;
        Loop();
    }
}

// Команда S<адрес>,<адрес>,<байт>
// Поиск байта в области памяти

void CmdS() {
    ParseParams();
    c = l;
    for (;;) {
        hl = param1;
        a = c;
        if (a == *hl)
            PrintLfParam1();
        Loop();
    }
}

// Команда T<начало>,<конец>,<куда>
// Пересылка содержимого одной области в другую

void CmdT() {
    ParseParams();
    hl = param3;
    swap(hl, de);
    for (;;) {
        hl = param1;
        *de = a = *hl;
        de++;
        Loop();
    }
}

// Команда M<адрес>
// Просмотр или изменение содержимого ячейки (ячеек) памяти

void CmdM() {
    ParseParams();
    for (;;) {
        PrintSpace();
        PrintByteFromParam1();
        Input();
        if (flag_c) {
            ParseWord();
            a = l;
            hl = param1;
            *hl = a;
        }
        hl = &param1;
        IncWord();
        PrintLfParam1();
    }
}

// Команда J<адрес>
// Запуск программы с указанного адреса

void CmdJ() {
    ParseParams();
    hl = param1;
    return hl();
}

// Команда А<символ>
// Вывод кода символа на экран

void CmdA() {
    PrintLf();
    PrintHexByte(a = cmdBuffer1);
    PrintLf();
}

// Команда K
// Вывод символа с клавиатуры на экран

void CmdK() {
    for (;;) {
        ReadKey();
        if (a == 1)  // УС + А
            return Monitor();
        PrintCharA(a);
    }
}

// Команда Q<начало>,<конец>
// Тестирование области памяти

void CmdQ() {
    ParseParams();
    for (;;) {
        hl = param1;
        c = *hl;

        a = 0x55;
        *hl = a;
        if (a != *hl)
            CmdQResult();

        a = 0xAA;
        *hl = a;
        if (a != *hl)
            CmdQResult();

        *hl = c;
        Loop();
    }
}

void CmdQResult(...) {
    push_pop(a) {
        PrintLfParam1();
        PrintSpace();
        PrintByteFromParam1();
        PrintSpace();
    }
    PrintHexByte(a);
    return;
}

// Команда L<начало>,<конец>
// Посмотр области памяти в символьном виде

void CmdL() {
    ParseParams();
    PrintLf();

CmdLLine:
    PrintLfParam1();

    for (;;) {
        PrintSpace();
        hl = param1;
        a = *hl;
        if (a >= 0x20) {
            if (a < 0x80) {
                goto CmdLShow;
            }
        }
        a = '.';
    CmdLShow:
        PrintCharA();
        Loop();
        if (flag_z((a = param1) &= 0x0F))
            goto CmdLLine;
    }
}

// Команда H<число 1>,<число 2>
// Сложение и вычитание чисел

void CmdH(...) {
    hl = &param1;
    b = 6;
    a ^= a;
    do {
        *hl = a;
    } while (flag_nz(b--));

    de = &cmdBuffer1;

    ParseWord();
    param1 = hl;

    ParseWord();
    param2 = hl;

    PrintLf();
    param3 = hl = param1;
    swap(hl, de);
    hl = param2;
    hl += de;
    param1 = hl;
    PrintParam1Space();

    hl = param2;
    swap(hl, de);
    hl = param3;
    a = e;
    invert(a);
    e = a;
    a = d;
    invert(a);
    d = a;
    de++;
    hl += de;
    param1 = hl;
    PrintParam1Space();
    PrintLf();
}

// Команда I
// Ввод информации с магнитной ленты

void CmdI() {
    ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
    param1h = a;
    tapeStartH = a;

    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param1 = a;
    tapeStartL = a;

    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param2h = a;
    tapeStopH = a;

    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param2 = a;
    tapeStopL = a;

    a = READ_TAPE_NEXT_BYTE;
    hl = &CmdIEnd;
    push(hl);

    for (;;) {
        hl = param1;
        ReadTapeByte(a);
        *hl = a;
        Loop();
        a = READ_TAPE_NEXT_BYTE;
    }
}

void CmdIEnd(...) {
    PrintHexWordSpace(hl = &tapeStartH);
    PrintHexWordSpace(hl = &tapeStopH);
    PrintLf();
}

// Команда O<начало>,<конец>
// Вывод содержимого области памяти на магнитную ленту

void CmdO() {
    ParseParams();
    a ^= a;
    b = 0;
    do {
        WriteTapeByte(a);
    } while (flag_nz(b--));
    WriteTapeByte(a = TAPE_START);
    WriteTapeByte(a = param1h);
    WriteTapeByte(a = param1);
    WriteTapeByte(a = param2h);
    WriteTapeByte(a = param2);
    for (;;) {
        hl = param1;
        a = *hl;
        WriteTapeByte(a);
        Loop();
    }
}

// Команда V
// Сравнение информации на магнитной ленте с содержимым области памяти

void CmdV() {
    ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
    param1h = a;
    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param1 = a;
    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param2h = a;
    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
    param2 = a;
    for (;;) {
        ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
        hl = param1;
        if (a != *hl) {
            push_pop(a) {
                PrintLfParam1();
                PrintSpace();
                PrintByteFromParam1();
                PrintSpace();
            }
            PrintHexByte();
        }
        Loop();
    }
}

void ReadTapeByte(...) {
    push(bc, de);
    c = 0;
    d = a;
    e = a = in(PORT_TAPE);
    do {
    loc_FD9D:
        a = c;
        a &= 0x7F;
        cyclic_rotate_left(a, 1);
        c = a;

        do {
            a = in(PORT_TAPE);
        } while (a == e);
        a &= 1;
        a |= c;
        c = a;
        ReadTapeDelay();
        e = a = in(PORT_TAPE);
        if (flag_m((a = d) |= a)) {
            if ((a = c) == TAPE_START) {
                tapePolarity = (a ^= a);
            } else {
                if (a != (0xFF ^ TAPE_START))
                    goto loc_FD9D;
                tapePolarity = a = 0xFF;
            }
            d = 8 + 1;
        }
    } while (flag_nz(d--));
    a = tapePolarity;
    a ^= c;
    pop(bc, de);
}

void ReadTapeDelay(...) {
    push(a);
    TapeDelay(a = readDelay);
}

void TapeDelay(...) {
    b = a;
    pop(a);
    do {
    } while (flag_nz(b--));
}

void WriteTapeByte(...) {
    push_pop(bc, de, a) {
        d = a;
        c = 8;
        do {
            a = d;
            cyclic_rotate_left(a, 1);
            d = a;

            out(PORT_TAPE, (a = 1) ^= d);
            WriteTapeDelay();

            out(PORT_TAPE, (a = 0) ^= d);
            WriteTapeDelay();
        } while (flag_nz(c--));
    }
}

void WriteTapeDelay(...) {
    push(a);
    TapeDelay(a = writeDelay);
}

uint8_t monitorCommands = 'M';
uint16_t monitorCommandsMa = (uintptr_t)&CmdM;
uint8_t monitorCommandsC = 'C';
uint16_t monitorCommandsCa = (uintptr_t)&CmdC;
uint8_t monitorCommandsD = 'D';
uint16_t monitorCommandsDa = (uintptr_t)&CmdD;
uint8_t monitorCommandsB = 'B';
uint16_t monitorCommandsBa = (uintptr_t)&CmdB;
uint8_t monitorCommandsG = 'G';
uint16_t monitorCommandsGa = (uintptr_t)&CmdG;
uint8_t monitorCommandsP = 'P';
uint16_t monitorCommandsPa = (uintptr_t)&CmdP;
uint8_t monitorCommandsX = 'X';
uint16_t monitorCommandsXa = (uintptr_t)&CmdX;
uint8_t monitorCommandsF = 'F';
uint16_t monitorCommandsFa = (uintptr_t)&CmdF;
uint8_t monitorCommandsS = 'S';
uint16_t monitorCommandsSa = (uintptr_t)&CmdS;
uint8_t monitorCommandsT = 'T';
uint16_t monitorCommandsTa = (uintptr_t)&CmdT;
uint8_t monitorCommandsI = 'I';
uint16_t monitorCommandsIa = (uintptr_t)&CmdI;
uint8_t monitorCommandsO = 'O';
uint16_t monitorCommandsOa = (uintptr_t)&CmdO;
uint8_t monitorCommandsV = 'V';
uint16_t monitorCommandsVa = (uintptr_t)&CmdV;
uint8_t monitorCommandsJ = 'J';
uint16_t monitorCommandsJa = (uintptr_t)&CmdJ;
uint8_t monitorCommandsA = 'A';
uint16_t monitorCommandsAa = (uintptr_t)&CmdA;
uint8_t monitorCommandsK = 'K';
uint16_t monitorCommandsKa = (uintptr_t)&CmdK;
uint8_t monitorCommandsQ = 'Q';
uint16_t monitorCommandsQa = (uintptr_t)&CmdQ;
uint8_t monitorCommandsL = 'L';
uint16_t monitorCommandsLa = (uintptr_t)&CmdL;
uint8_t monitorCommandsH = 'H';
uint16_t monitorCommandsHa = (uintptr_t)&CmdH;
uint8_t monitorCommandsEnd = 0;

uint8_t aPrompt[] = "\x0A*MikrO/80* MONITOR\x0A>";
uint8_t aLf[] = "\x0A";

void PrintCharA(...) {
    push(hl, bc, de, a);
    PrintCharInt(c = a);
}

void PrintChar(...) {
    push(hl, bc, de, a);
    return PrintCharInt(c);
}

void PrintCharInt(...) {
    hl = cursor;
    de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
    hl += de;
    *hl = SCREEN_ATTRIB_DEFAULT;

    hl = cursor;
    a = c;
    if (a == 0x1F)
        return ClearScreen();
    if (a == 0x08)
        return MoveCursorLeft(hl);
    if (a == 0x18)
        return MoveCursorRight(hl);
    if (a == 0x19)
        return MoveCursorUp(hl);
    if (a == 0x1A)
        return MoveCursorDown(hl);
    if (a == 0x0A)
        return MoveCursorNextLine(hl);
    if (a == 0x0C)
        return MoveCursorHome();

    if ((a = h) == SCREEN_END >> 8) {
        IsAnyKeyPressed();
        if (a != 0) {
            ReadKey();
        }
        ClearScreenInt();
        hl = SCREEN_BEGIN;
    }
    *hl = c;
    hl++;
    return MoveCursor();
}

void MoveCursor(...) {
    cursor = hl;
    de = -(SCREEN_WIDTH * SCREEN_HEIGHT) + 1;
    hl += de;
    *hl = SCREEN_ATTRIB_DEFAULT | SCREEN_ATTRIB_UNDERLINE;
    pop(hl, bc, de, a);
}

void ClearScreen() {
    ClearScreenInt();
    MoveCursorHome();
}

void MoveCursorHome() {
    MoveCursor(hl = SCREEN_BEGIN);
}

void ClearScreenInt() {
    hl = SCREEN_BEGIN;
    de = SCREEN_ATTRIB_BEGIN;
    for (;;) {
        *hl = ' ';
        hl++;
        a = 0;
        *de = a;
        de++;
        a = h;
        if (a == SCREEN_END >> 8)
            return;
    }
}

void MoveCursorRight(...) {
    hl++;
    if ((a = h) != SCREEN_END >> 8)
        return MoveCursor(hl);
    if (flag_z)  // Лишнее
        return MoveCursorHome();
    MoveCursorLeft(hl);  // Лишнее
}

void MoveCursorLeft(...) {
    hl--;
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    MoveCursor(hl = SCREEN_END - 1);
}

void MoveCursorDown(...) {
    hl += (de = SCREEN_WIDTH);
    if ((a = h) != SCREEN_END >> 8)
        return MoveCursor(hl);
    h = SCREEN_BEGIN >> 8;
    MoveCursor(hl);
}

void MoveCursorUp(...) {
    hl += (de = -SCREEN_WIDTH);
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
    MoveCursor(hl);
}

void MoveCursorNextLine(...) {
    for (;;) {
        hl++;
        a = l;
        if (a == SCREEN_WIDTH * 0)
            return MoveCursorNextLine1(hl);
        if (a == SCREEN_WIDTH * 1)
            return MoveCursorNextLine1(hl);
        if (a == SCREEN_WIDTH * 2)
            return MoveCursorNextLine1(hl);
        if (a == SCREEN_WIDTH * 3)
            return MoveCursorNextLine1(hl);
    }
}

void MoveCursorNextLine1(...) {
    if ((a = h) != SCREEN_END >> 8)
        return MoveCursor(hl);

    IsAnyKeyPressed();
    if (a == 0)
        return ClearScreen();
    ReadKey();
    ClearScreen();
}

void ReadKey() {
    push(bc, de, hl);

    for (;;) {
        b = 0;
        c = 1 ^ 0xFF;
        d = KEYBOARD_COLUMN_COUNT;
        do {
            out(PORT_KEYBOARD_COLUMN, a = c);
            cyclic_rotate_left(a, 1);
            c = a;
            a = in(PORT_KEYBOARD_ROW);
            a &= KEYBOARD_ROW_MASK;
            if (a != KEYBOARD_ROW_MASK)
                return ReadKey1(a, b);
            b = ((a = b) += KEYBOARD_ROW_COUNT);
        } while (flag_nz(d--));
    }
}

void ReadKey1(...) {
    keyLast = a;

    for (;;) {
        carry_rotate_right(a, 1);
        if (flag_nc)
            break;
        b++;
    }

    // b - key number

    //  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
    //  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
    // 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
    // 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
    // 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
    // 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
    // 48   Space Right Left  Up    Down  Vk    Str   Home

    a = b;
    if (a < 48) {
        a += '0';
        if (a >= 0x3C)
            if (a < 0x40)
                a &= 0x2F;  // <=>? to .-./
        c = a;
    } else {
        hl = &keyTable;
        a -= 48;
        c = a;
        b = 0;
        hl += bc;
        a = *hl;
        return ReadKey2(a);
    }

    a = in(PORT_KEYBOARD_MODS);
    a &= KEYBOARD_MODS_MASK;
    if (a == KEYBOARD_MODS_MASK)
        goto ReadKeyNoMods;
    carry_rotate_right(a, 2);
    if (flag_nc)
        goto ReadKeyControl;
    carry_rotate_right(a, 1);
    if (flag_nc)
        goto ReadKeyShift;

    // RUS key pressed
    a = c;
    a |= 0x20;
    return ReadKey2(a);

    // US (Control) key pressed
ReadKeyControl:
    a = c;
    a &= 0x1F;
    return ReadKey2(a);

    // SS (Shift) key pressed
ReadKeyShift:
    a = c;
    if (a >= 0x40)  // @ A-Z [ \ ] ^ _
        return ReadKey2(a);
    if (a < 0x30) {  // .-./ to <=>?
        a |= 0x10;
        return ReadKey2(a);
    }
    a &= 0x2F;  // 0123456789:; to !@#$%&'()*+
    return ReadKey2(a);

ReadKeyNoMods:
    ReadKey2(a = c);
}

void ReadKey2(...) {
    c = a;

    ReadKeyDelay();

    hl = &keyLast;
    do {
        a = in(PORT_KEYBOARD_ROW);
    } while (a == *hl);

    ReadKeyDelay();

    a = c;
    pop(bc, de, hl);
}

void ReadKeyDelay() {
    de = 0x1000;
    for (;;) {
        de--;
        if (flag_z((a = d) |= e))
            return;
    }
}

uint8_t keyTable[] = {
    0x20,  // Space
    0x18,  // Right
    0x08,  // Left
    0x19,  // Up
    0x1A,  // Down
    0x0D,  // Enter
    0x1F,  // Clear
    0x0C,  // Home
};

void IsAnyKeyPressed() {
    out(PORT_KEYBOARD_COLUMN, a = 0);
    a = in(PORT_KEYBOARD_ROW);
    a &= KEYBOARD_ROW_MASK;
    if (a == KEYBOARD_ROW_MASK) {
        a ^= a;  // Returns 0 if no key is pressed
        return;
    }
    a = 0xFF;  // Returns 0xFF if there are any keys pressed
}

asm(" savebin \"micro80.bin\", 0xF800, 0x10000");
