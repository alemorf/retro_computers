/* Прошивка компьютера Микро 80 из журнала Радио за 1983 год
 * Реверc-инженеринг 5-06-2024 Алексей Морозов aleksey.f.morozov@gmail.com
 * Доработано
 */

#include "cmm.h"
#include "micro80.h"

const int PORT_TAPE = 1;
const int PORT_KEYBOARD_MODE = 4;
const int PORT_KEYBOARD_COLUMN = 7;
const int PORT_KEYBOARD_ROW = 6;
const int PORT_KEYBOARD_MODS = 5;

const int KEYBOARD_ROW_MASK = 0x7F;
const int KEYBOARD_MODS_MASK = 0x07;
const int KEYBOARD_RUS_MOD = 1 << 0;
const int KEYBOARD_COLUMN_COUNT = 8;
const int KEYBOARD_ROW_COUNT = 7;

const int STACK_TOP = 0xF7FF;
const int USER_STACK_TOP = 0xF7C0;

const int OPCODE_RST_38 = 0xFF;
const int OPCODE_JMP = 0xC3;

const int READ_TAPE_FIRST_BYTE = 0xFF;
const int READ_TAPE_NEXT_BYTE = 8;
const int TAPE_START = 0xE6;

void Reboot();
void ReadKey();
void ReadKey0();
void ReadKey1(...);
void ReadKey2(...);
void ReadKeyDelay();
void ReadTapeByte(...);
void ReadTapeByteNext();
void PrintChar(...);
void WriteTapeByte(...);
void PrintChar(...);
void IsKeyPressed();
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
void ParseDword(...);
void CmpHlDe(...);
void ReturnCf(...);
void ParseDword1(...);
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
void ClearScreenHome();
void MoveCursorLeft(...);
void MoveCursorRight(...);
void MoveCursorUp(...);
void MoveCursorDown(...);
void MoveCursorNextLine(...);
void MoveCursorHome();
void ClearScreen();
void MoveCursor(...);
void MoveCursorNextLine1(...);
void ReadStringBs(...);
void ReadStringCr(...);

extern uint8_t textScreen __address(0xE800);    // TODO
extern uint8_t attribScreen __address(0xE000);  // TODO

extern uint8_t aHello[];
extern uint8_t aPrompt[];
extern uint8_t monitorCommands[];
extern uint8_t regList[];
extern uint8_t aLf[];
extern uint8_t keyTable[];

asm(" org 0F800h");

void EntryReboot() {
    Reboot();
}

void EntryReadChar(...) {
    ReadKey();
}

void EntryReadTapeByte(...) {
    ReadTapeByte();
}

void EntryPrintChar(...) {
    PrintChar();
}

void EntryWriteTapeByte(...) {
    WriteTapeByte();
}

void EntryPrintChar2(...) {
    PrintChar();
}

void EntryIsKeyPressed() {
    IsKeyPressed();
}

void EntryPrintHexByte(...) {
    PrintHexByte();
}

void EntryPrintString(...) {
    PrintString();
}

void Reboot() {
    DisableInterrupts();
    mode = (a ^= a);
    color = a = SCREEN_ATTRIB_DEFAULT;
    regSP = hl = USER_STACK_TOP;
    sp = STACK_TOP;
    PrintString(hl = &aHello);
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
        hl++;
        if (flag_z(a &= a))
            return MonitorError();
        if (a == b)
            break;
        hl++;
        hl++;
    }

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
        *hl = a;
        if (a == 0x0D)
            return ReadStringCr(hl);
        PrintCharA(a);
        a = &cmdBufferEnd;
        Compare(a, l);
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
        *hl = a;
        if (a == ' ')
            return PopWordReturn();
        if (a == 0x0D)
            return InputEndSpace();
        PrintCharA();
        b = 0xFF;
        if ((a = &cmdBufferEnd) == l)
            return MonitorError();
        hl++;
    }
}

void InputEndSpace(...) {
    a = b;
    CarryRotateLeft(a, 1);
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
    ParseDword();
    param1 = hl;
    param2 = hl;
    if (flag_c)
        return;
    ParseDword();
    param2 = hl;
    push_pop(a, de) {
        swap(hl, de);
        hl = param1;
        swap(hl, de);
        CmpHlDe();
        if (flag_c)
            return MonitorError();
    }
    if (flag_c)
        return;
    ParseDword();
    param3 = hl;
    if (flag_c)
        return;
    MonitorError();
}

void ParseDword(...) {
    hl = 0;
    ParseDword1();
}

void ParseDword1(...) {
    for (;;) {
        a = *de;
        de++;
        if (a == 0x0D)
            return ReturnCf();
        if (a == ',')
            return;
        if (a == ' ')
            continue;
        a -= '0';
        if (flag_m)
            return MonitorError();
        if (flag_p(Compare(a, 10))) {
            if (flag_m(Compare(a, 0x11)))
                return MonitorError();
            if (flag_p(Compare(a, 0x17)))
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

void ReturnCf(...) {
    SetFlagC();
}

void PrintByteFromParam1(...) {
    hl = param1;
    PrintHexByte(a = *hl);
}

void PrintHexByte(...) {
    b = a;
    a = b;
    CyclicRotateRight(a, 4);
    PrintHex(a);
    PrintHex(a = b);
}

void PrintHex(...) {
    a &= 0x0F;
    if (flag_p(Compare(a, 10)))
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
        CmpHlDe(hl, de);
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

void CmpHlDe(...) {
    if ((a = h) != d)
        return;
    Compare(a = l, e);
}

/* X - Изменение содержимого внутреннего регистра микропроцессора */

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
        PrintLf();
        PrintHexByte(a = *hl);
        Input();
        if (flag_nc)
            return Monitor();
        ParseDword();
        a = l;
    }
    *hl = a;
}

void CmdXS() {
    PrintLf();
    PrintHexWordSpace(hl = &regSPH);
    Input();
    if (flag_nc)
        return Monitor();
    ParseDword();
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
}

void PrintRegMinus(...) {
    PrintSpace();
    PrintCharA(a = c);
    PrintCharA(a = '-');
}

uint8_t regList[] = {'A', &regA, 'B', &regB, 'C', &regC, 'D', &regD,  'E', &regE,
                     'F', &regF, 'H', &regH, 'L', &regL, 'S', &regSP, 0};

uint8_t aStart[] = "\x0ASTART-";
uint8_t aDir_[] = "\x0ADIR. -";

/* B - Задание адреса останова при отладке */

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
    sp = &cmdBuffer + 0x84;

    hl = regSP;
    hl--;
    d = *hl;
    hl--;
    e = *hl;
    l = e;
    h = d;
    lastBreakAddress = hl;

    hl = breakAddress;
    CmpHlDe();
    if (flag_nz) {
        hl = breakAddress2;
        CmpHlDe(hl, de);
        if (flag_z)
            return BreakPointAt2();

        hl = breakAddress3;
        CmpHlDe(hl, de);
        if (flag_z)
            return BreakpointAt3();

        return MonitorError();
    }
    *hl = a = breakPrevByte;
    breakAddress = hl = 0xFFFF;
    return Monitor();
}

/* G<адрес> - Запуск программы в отладочном режиме */

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
    jumpOpcode();
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

/* D<адрес>,<адрес> - Просмотр содержимого области памяти в шестнадцатеричном виде */

void CmdD() {
    ParseParams();
CmdDLine:
    PrintLfParam1();
    for (;;) {
        PrintByteFromParam1();
        PrintSpace();
        Loop();
        a = param1;
        a &= 0x0F;
        if (flag_z)
            goto CmdDLine;
    }
}

/* C<адрес от>,<адрес до>,<адрес от 2> - Сравнение содержимого двух областей памяти */

void CmdC() {
    ParseParams();
    hl = param3;
    swap(hl, de);
    for (;;) {
        hl = param1;
        a = *de;
        if (a != *hl) {
            PrintLfParam1();
            PrintByteFromParam1();
            PrintSpace();
            a = *de;
            PrintHexByte();
        }
        de++;
        Loop();
    }
}

/* F<адрес>,<адрес>,<байт> - Запись байта во все ячейки области памяти */

void CmdF() {
    ParseParams();
    b = a = param3;
    for (;;) {
        hl = param1;
        *hl = b;
        Loop();
    }
}

/* S<адрес>,<адрес>,<байт> - Поиск байта в области памяти */

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

/* T<начало>,<конец>,<куда> - Пересылка содержимого одной области в другую */

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

/* M<адрес> - Просмотр или изменение содержимого ячейки (ячеек) памяти */

void CmdM() {
    ParseParams();
    for (;;) {
        PrintLfParam1();
        PrintByteFromParam1();
        Input();
        if (flag_c) {
            ParseDword();
            a = l;
            hl = param1;
            *hl = a;
        }
        hl = &param1;
        IncWord();
    }
}

/* J<адрес> - Запуск программы с указанного адреса */

void CmdJ() {
    ParseParams();
    hl = param1;
    return hl();
}

/* А<символ> - Вывод кода символа на экран */

void CmdA() {
    PrintLf();
    PrintHexByte(a = cmdBuffer1);
}

/* K - Вывод символа с клавиатуры на экран */

void CmdK() {
    PrintLf();
    for (;;) {
        ReadKey();
        if (a == 1) /* УС + А */
            return PrintLf();
        PrintCharA(a);
    }
}

/* Q<начало>,<конец> - Тестирование области памяти */

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
        PrintByteFromParam1();
        PrintSpace();
    }
    PrintHexByte(a);
}

/* L<начало>,<конец> - Посмотр области памяти в символьном виде */

void CmdL() {
    ParseParams();

CmdLLine:
    PrintLfParam1();

    for (;;) {
        hl = param1;
        a = *hl;
        if (a < 0x20)
            a = '.';
        PrintCharA();
        Loop();
        if (flag_z((a = param1) &= 0x0F))
            goto CmdLLine;
        PrintSpace();
    }
}

// TODO:

void CmdH(...) {
    hl = &param1;
    b = 6;
    a ^= a;
    do {
        *hl = a;
    } while (flag_nz(b--));

    de = &cmdBuffer1;

    ParseDword();
    param1 = hl;

    ParseDword();
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
    Invert(a);
    e = a;
    a = d;
    Invert(a);
    d = a;
    de++;
    hl += de;
    param1 = hl;
    PrintParam1Space();
}

/* I - Ввод информации с магнитной ленты */

void CmdI() {
    ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
    param1h = a;
    tapeStartH = a;

    ReadTapeByteNext();
    param1 = a;
    tapeStartL = a;

    ReadTapeByteNext();
    param2h = a;
    tapeStopH = a;

    ReadTapeByteNext();
    param2 = a;
    tapeStopL = a;

    hl = &CmdIEnd;
    push(hl);

    for (;;) {
        hl = param1;
        ReadTapeByteNext(a);
        *hl = a;
        Loop();
    }
}

void CmdIEnd(...) {
    PrintLf();
    PrintHexWordSpace(hl = &tapeStartH);
    PrintHexWordSpace(hl = &tapeStopH);
}

/* O<начало>,<конец> - Вывод содержимого области памяти на магнитную ленту */

void CmdO() {
    ParseParams();
    a ^= a;
    b = a;
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

/* V - Сравнение информации на магнитной ленте с содержимым области памяти */

void CmdV() {
    ReadTapeByte(a = READ_TAPE_FIRST_BYTE);
    param1h = a;
    ReadTapeByteNext();
    param1 = a;
    ReadTapeByteNext();
    param2h = a;
    ReadTapeByteNext();
    param2 = a;
    for (;;) {
        ReadTapeByteNext();
        hl = param1;
        if (a != *hl) {
            push_pop(a) {
                PrintLfParam1();
                PrintByteFromParam1();
                PrintSpace();
            }
            PrintHexByte();
        }
        Loop();
    }
}

void ReadTapeByteNext() {
    ReadTapeByte(a = READ_TAPE_NEXT_BYTE);
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
        CyclicRotateLeft(a, 1);
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
                if (a != 0xFF ^ TAPE_START)
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
            CyclicRotateLeft(a, 1);
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
uint16_t monitorCommandsMa = &CmdM;
uint8_t monitorCommandsC = 'C';
uint16_t monitorCommandsCa = &CmdC;
uint8_t monitorCommandsD = 'D';
uint16_t monitorCommandsDa = &CmdD;
uint8_t monitorCommandsB = 'B';
uint16_t monitorCommandsBa = &CmdB;
uint8_t monitorCommandsG = 'G';
uint16_t monitorCommandsGa = &CmdG;
uint8_t monitorCommandsP = 'P';
uint16_t monitorCommandsPa = &CmdP;
uint8_t monitorCommandsX = 'X';
uint16_t monitorCommandsXa = &CmdX;
uint8_t monitorCommandsF = 'F';
uint16_t monitorCommandsFa = &CmdF;
uint8_t monitorCommandsS = 'S';
uint16_t monitorCommandsSa = &CmdS;
uint8_t monitorCommandsT = 'T';
uint16_t monitorCommandsTa = &CmdT;
uint8_t monitorCommandsI = 'I';
uint16_t monitorCommandsIa = &CmdI;
uint8_t monitorCommandsO = 'O';
uint16_t monitorCommandsOa = &CmdO;
uint8_t monitorCommandsV = 'V';
uint16_t monitorCommandsVa = &CmdV;
uint8_t monitorCommandsJ = 'J';
uint16_t monitorCommandsJa = &CmdJ;
uint8_t monitorCommandsA = 'A';
uint16_t monitorCommandsAa = &CmdA;
uint8_t monitorCommandsK = 'K';
uint16_t monitorCommandsKa = &CmdK;
uint8_t monitorCommandsQ = 'Q';
uint16_t monitorCommandsQa = &CmdQ;
uint8_t monitorCommandsL = 'L';
uint16_t monitorCommandsLa = &CmdL;
uint8_t monitorCommandsH = 'H';
uint16_t monitorCommandsHa = &CmdH;
uint8_t monitorCommandsEnd = 0;

uint8_t aHello[] = "\x1F*MikrO/80* MONITOR";
uint8_t aPrompt[] = "\x0A>";
uint8_t aLf[] = "\x0A";

void PrintCharA(...) {
    push(bc);
    PrintCharInt(c = a);
}

void PrintChar(...) {
    push(bc);
    PrintCharInt(c);
}

void PrintCharInt(...) {
    push(hl, de, a);

    hl = cursor;
    de = -(SCREEN_WIDTH * SCREEN_HEIGHT);
    push_pop(hl) {
        hl += de;
        a = *hl;
        a &= 0xFF ^ SCREEN_ATTRIB_UNDERLINE;
        *hl = a;
    }

    a = c;
    a -= 0x08;
    if (flag_z)
        return MoveCursorLeft(hl);
    a -= 0x0A - 0x08;
    if (flag_z)
        return MoveCursorNextLine(hl);
    a -= 0x0C - 0x0A;
    if (flag_z)
        return MoveCursorHome();
    a -= 0x18 - 0x0C;
    if (flag_z)
        return MoveCursorRight(hl);
    a--; // 0x19
    if (flag_z)
        return MoveCursorUp(hl);
    a--; // 0x1A
    if (flag_z)
        return MoveCursorDown(hl);
    a -= 0x1F - 0x1A;
    if (flag_z)
        return ClearScreenHome();

    *hl = c;
    push_pop(hl) {
        hl += de;
        *hl = a = color;
    }
    hl++;
    return MoveCursor();
}

void MoveCursor(...) {
    swap(hl, de);
    hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_LINES);
    hl += de;
    swap(hl, de);

    if (flag_c) {
        push_pop(hl) {
            hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_LINES - 1;
            c = SCREEN_WIDTH;
            do {
                push_pop(hl) {
                    de = 0x800 - SCREEN_WIDTH;
                    b = 0;
                    c = a = color;
                    do {
                        a = b;
                        b = *hl;
                        *hl = a;
                        h = ((a = h) -= 8);
                        a = c;
                        c = *hl;
                        *hl = a;
                        hl += de;
                    } while((a = h) != 0xE7);
                }
                l--;
            } while((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_LINES - 1 - SCREEN_WIDTH);
        }
        hl += (de = -SCREEN_WIDTH);
    }

    cursor = hl;
    de = -(SCREEN_WIDTH * SCREEN_HEIGHT);
    hl += de;
    a = *hl;
    a |= SCREEN_ATTRIB_UNDERLINE;
    *hl = a;
    pop(bc, hl, de, a);
}

void ClearScreenHome() {
    ClearScreen();
    MoveCursorHome();
}

void MoveCursorHome() {
    MoveCursor(hl = &textScreen);
}

void ClearScreen() {
    hl = &textScreen;
    de = &attribScreen;
    for (;;) {
        *hl = ' ';
        hl++;
        a = color;
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
    if (flag_z) /* Not needed */
        return MoveCursorHome();
    MoveCursorLeft(hl); /* Not needed */
}

void MoveCursorLeft(...) {
    hl--;
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    MoveCursor(hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_LINES - 1);
}

void MoveCursorDown(...) {
    hl += (de = SCREEN_WIDTH);
    MoveCursor(hl);
}

void MoveCursorUp(...) {
    hl += (de = -SCREEN_WIDTH);
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    hl += (de = SCREEN_WIDTH * SCREEN_LINES);
    MoveCursor(hl);
}

void MoveCursorNextLine(...) {
    a = l;
    a &= 0xFF ^ (SCREEN_WIDTH - 1);
    l = a;
    MoveCursorDown();
}

void ReadKey() {
    push(bc, de, hl);
    ReadKey0();
}

void ReadKey0() {
    for (;;) {
        b = -1;
        c = 1 ^ 0xFF;
        d = KEYBOARD_COLUMN_COUNT;
        do {
            out(PORT_KEYBOARD_COLUMN, a = c);
            CyclicRotateLeft(a, 1);
            c = a;
            a = in(PORT_KEYBOARD_ROW);
            a &= KEYBOARD_ROW_MASK;
            if (a != KEYBOARD_ROW_MASK)
                return ReadKey1(a, b);
            b = ((a = b) += KEYBOARD_ROW_COUNT);
        } while (flag_nz(d--));

        a = in(PORT_KEYBOARD_MODS);
        if (flag_z(a &= KEYBOARD_RUS_MOD))
            return ReadKey1(a, b);

        keyLast = a = 0xFF;
        keyDelay = a;
    }
}

void ReadKey1(...) {
    do {
        b++;
        CyclicRotateRight(a);
    } while(flag_c);

    /* b - key number */

    /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
     *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
     * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
     * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
     * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
     * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
     * 48   Space Right Left  Up    Down  Vk    Str   Home */

    a = keyLast;
    if (a == b) {
        ReadKeyDelay();
        hl = &keyDelay;
        (*hl)--;
        if (flag_nz)
            return ReadKey0();
        a = 0x40; // Repeat delay
    } else {
        a = 0xFF; // First repeat delay
    }
    keyDelay = a;
    keyLast = a = b;

    if (a == 56) { // RUS/LAT
        hl = mode;
        a = *hl;
        a ^= 1;
        *hl = a;
        return ReadKey0();
    }

    if (a >= 48) {
        hl = &keyTable;
        a -= 48;
        c = a;
        b = 0;
        hl += bc;
        a = *hl;
        return ReadKey2(a);
    }

    a += '0';
    if (a >= 0x3C)
        if (a < 0x40)
            a &= 0x2F; /* <=>? to .-./ */
    c = a;

    a = mode;
    CyclicRotateRight(a, 1); /* MODE_RUS */
    if (flag_c) {
        a = c;
        a |= 0x20;
        c = a;
    }

    a = in(PORT_KEYBOARD_MODS);
    CarryRotateRight(a, 2); /* Ctrl */
    if (flag_nc) {
        a = c;
        a &= 0x1F;
        return ReadKey2(a);
    }

    CarryRotateRight(a, 1); /* Shift */
    if (flag_nc) {
        a = c;
        if (a >= 'A') {
           a |= 0x80;
           return ReadKey2(a);
        }
        if (a >= 0x40) /* @ A-Z [ \ ] ^ _ */
            return ReadKey2(a);
        if (a < 0x30) { /* .-./ to <=>? */
            a |= 0x10;
            return ReadKey2(a);
        }
        a &= 0x2F; /* 0123456789:; to !@#$%&'()*+ */
        return ReadKey2(a);
    }

    ReadKey2(a = c);
}

void ReadKey2(...) {
    c = a;

    ReadKeyDelay();

    a = c;
    pop(bc, de, hl);
}

void ReadKeyDelay() {
    de = 0x80;
    for (;;) {
        de--;
        if (flag_z((a = d) |= e))
            return;
    }
}

uint8_t keyTable[] = {
    0x20, /* Space */
    0x18, /* Right */
    0x08, /* Left */
    0x19, /* Up */
    0x1A, /* Down */
    0x0D, /* Enter */
    0x1F, /* Clear */
    0x0C, /* Home */
};

void IsKeyPressed() {
    out(PORT_KEYBOARD_COLUMN, a ^= a);
    a = in(PORT_KEYBOARD_ROW);
    Invert(a);
    a += a;
    if (flag_z)
        return; /* Returns 0 if no key is pressed */
    a = 0xFF; /* Returns 0xFF if there are any keys pressed */
}
