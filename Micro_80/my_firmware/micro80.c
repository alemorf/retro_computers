/* Прошивка компьютера Микро 80 из журнала Радио за 1983 год
 * Реверc-инженеринг 5-06-2024 Алексей Морозов aleksey.f.morozov@gmail.com
 * Доработка 12-04-2025 Алексей Морозов aleksey.f.morozov@gmail.com
 * + Ни одна функция и возможность оригинального монитора не потеряна
 * + Поддержка цвета
 * + Поддержка знакогенератора 256 символов. Поддержка строчных букв.
 * + Команды и 16-ричные цифры можно вводить строчными буквами.
 * + Прокрутка экрана
 * + Уменьшение размера экрана до 25 линий
 * + Программная фиксация клавиш Рус и Заг
 * + Отображение Рус/Лат и Заг/Стр на экране
 * + Клавиатура реагирует при нажатии клавиши, а не при отпускании
 * + Автоповтор нажатой клавиши
 * + Название компьютера выводится только при старте
 * + Отключение прерываний
 * + Установка скорости чтения/записи с магнитофона при старте
 * +  Если IsKeyPressed вернул нажатую клавишу, то последующий вызов ReadKey не зависает
 * + Контроль переполнения при парсинге чисел
 */

#include "cmm.h"
#include "micro80.h"

void Reboot();
void Monitor();
void MonitorExecute();
void ReadString();
void PrintString(...);
void MonitorError();
void ParseDword(...);
void PopReturnCf(...);
void PopReturn();
void PrintHexByte(...);
void PrintHex(...);
void PrintParam1Space();
void PrintHexWordSpace(...);
void PrintSpace(...);
void CmpHlDe(...);
void PrintRegs(...);
void PrintRegMinus(...);
void InitRst38();
void BreakPoint(...);
void Run();
void BreakPointAt2(...);
void ContinueBreakpoint(...);
void BreakpointAt3(...);
void CmdQResult(...);
void CmdIEnd(...);
void ReadTapeByteNext(...);
void ReadTapeByte(...);
void ReadTapeDelay(...);
void TapeDelay(...);
void WriteTapeByte(...);
void WriteTapeDelay(...);
void PrintLf(...);
void PrintCharA(...);
void PrintChar(...);
void PrintCharInt(...);
void MoveCursor(...);
void ClearScreen();
void MoveCursorHome();
void MoveCursorRight(...);
void MoveCursorLeft(...);
void MoveCursorDown(...);
void MoveCursorUp(...);
void MoveCursorNextLine(...);
void ReadKey();
void ScanKey();
void ScanKey0();
void PrintKeyStatus();
void PrintKeyStatus1();
void ScanKey1(...);
void ScanKey2(...);
void ScanKeyExit(...);
void IsKeyPressed();

extern uint8_t aHello[20];
extern uint8_t aPrompt[3];
extern uint8_t monitorCommands;
extern uint8_t regList[19];
extern uint8_t keyTable[8];

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
    disable_interrupts();
    readDelay = hl = 0x324B;
    keybMode = (a ^= a);
    a--;
    keySaved = a; /* = 0xFF */
    color = a = SCREEN_ATTRIB_DEFAULT;
    regSP = hl = USER_STACK_TOP;
    sp = STACK_TOP;
    PrintString(hl = &aHello);
    Monitor();
}

void Monitor() {
    out(PORT_KEYBOARD_MODE, a = 0x8B);
    sp = STACK_TOP;
    color = a = SCREEN_ATTRIB_INPUT;
    PrintString(hl = &aPrompt);
    ReadString();
    color = a = SCREEN_ATTRIB_DEFAULT;
    push(hl = &Monitor);
    MonitorExecute();
}

void MonitorExecute() {
    a = cmdBuffer;
    a &= 0x7F; /* Lowercase support */
    hl = &monitorCommands;
    do {
        b = *hl;
        b--;
        b++;
        if (flag_z)
            return MonitorError();
        hl++;
        e = *hl;
        hl++;
        d = *hl;
        hl++;
    } while (a != b);
    swap(hl, de);
    return hl();
}

void ReadString() {
    hl = &cmdBuffer;
    d = h;
    e = l;
    for (;;) {
        ReadKey();
        if (a == 8) {
            if ((a = e) == l)
                continue;
            PrintChar(c = 8);
            hl--;
            continue;
        }
        *hl = a;
        if (a == 0x0D)
            return;
        if (a < 32)
            a = '.';
        PrintCharA(a);
        hl++;
        if ((a = l) == (uintptr_t)&cmdBufferEnd)
            return MonitorError();
    }
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

void MonitorError() {
    PrintChar(c = '?');
    return Monitor();
}

void ParseDword(...) {
    push(hl = &MonitorError);
    hl = 0;
    for (;;) {
        a = *de;
        if (a == 0x0D)
            return PopReturnCf();
        de++;
        if (a == ',')
            return PopReturn();
        if (a == ' ')
            continue;
        a &= 0x7F; /* Lowercase support */
        a -= '0';
        if (flag_m)
            return;
        if (flag_p(compare(a, 10))) {
            if (flag_m(compare(a, 0x11)))
                return;
            if (flag_p(compare(a, 0x17)))
                return;
            a -= 7;
        }
        b = 0;
        c = a;
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
        hl += bc;
    }
}

void PopReturnCf() {
    set_flag_c();
    PopReturn();
}

void PopReturn() {
    pop(bc);
}

void PrintByteFromParam1(...) {
    hl = param1;
    PrintHexByte(a = *hl);
}

void PrintHexByte(...) {
    b = a;
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

void PrintLfParam1Space(...) {
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
    PrintChar(c = ' ');
}

void Loop() {
    push_pop(de) {
        hl = param2;
        swap(hl, de);
        hl = param1;
        CmpHlDe(hl, de);
        hl++;
        param1 = hl;
    }
    if (flag_nz)
        return;
    pop(hl);
}

void CmpHlDe(...) {
    if ((a = h) != d)
        return;
    compare(a = l, e);
}

/* X - Изменение содержимого внутреннего регистра микропроцессора */

void CmdX() {
    de = &cmdBuffer1;
    a = *de;
    if (a == 0x0D)
        return PrintRegs();
    de++;
    push_pop(a) {
        ParseDword();
    }
    if (a == 'S') {
        regSP = hl;
        return;
    }
    c = l;
    b = a;
    hl = regList - 1;
    do {
        hl++;
        a = *hl;
        if (a == 0)
            return MonitorError();
        hl++;
    } while (a != b);
    l = *hl;
    h = (uintptr_t)&regs >> 8;
    *hl = c;
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
            PrintSpace();
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
    PrintChar(c);
    PrintChar(c = '-');
}

uint8_t regList[] = {'A', (uint8_t)(uintptr_t)&regA, 'B', (uint8_t)(uintptr_t)&regB, 'C', (uint8_t)(uintptr_t)&regC,
                     'D', (uint8_t)(uintptr_t)&regD, 'E', (uint8_t)(uintptr_t)&regE, 'F', (uint8_t)(uintptr_t)&regF,
                     'H', (uint8_t)(uintptr_t)&regH, 'L', (uint8_t)(uintptr_t)&regL, 'S', (uint8_t)(uintptr_t)&regSP,
                     0};

uint8_t aStart[] = "\x0ASTART-";
uint8_t aDir_[] = "\x0ADIR  -";

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
    param1 = hl = lastBreakAddress;
    if ((a = cmdBuffer1) != 0x0D)
        ParseParams();
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
    ReadString();
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
    PrintLfParam1Space();
    for (;;) {
        PrintByteFromParam1();
        PrintSpace();
        Loop();
        a = param1;
        a &= 0x0F;
        if (flag_z)
            PrintLfParam1Space();
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
            PrintLfParam1Space();
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
            PrintLfParam1Space();
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
        PrintLfParam1Space();
        PrintByteFromParam1();
        PrintSpace();
        ReadString();
        hl = param1;
        a = *de;
        if (a != 0x0D) {
            push_pop(hl) {
                ParseDword();
                a = l;
            }
            *hl = a;
        }
        hl++;
        param1 = hl;
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
        if (a == 0) /* УС + @ */
            return;
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
        PrintLfParam1Space();
        PrintByteFromParam1();
        PrintSpace();
    }
    PrintHexByte(a);
}

/* L<начало>,<конец> - Посмотр области памяти в символьном виде */

void CmdL() {
    ParseParams();
    PrintLfParam1Space();
    for (;;) {
        hl = param1;
        a = *hl;
        if (a < 0x20)
            a = '.';
        PrintCharA();
        Loop();
        PrintSpace();
        if (flag_z((a = param1) &= 0x0F))
            PrintLfParam1Space();
    }
}

/* H<число 1>,<число 2> - Сложение и вычитание чисел */

void CmdH(...) {
    de = &cmdBuffer1;
    ParseDword();
    param1 = hl;
    ParseDword();
    param2 = hl;

    /* param1 + param2 */
    swap(hl, de);
    hl = param1;
    push(hl);
    hl += de;
    param1 = hl;
    PrintLfParam1Space();

    /* param1 - param2 */
    pop(hl);
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
                PrintLfParam1Space();
                PrintByteFromParam1();
                PrintSpace();
            }
            PrintHexByte();
        }
        Loop();
    }
}

void ReadTapeByteNext(...) {
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

uint8_t aHello[] = "\x1F*MikrO/80* MONITOR";
uint8_t aPrompt[] = "\x0A>";

void PrintLf(...) {
    PrintCharA(a = 0x0A);
}

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

    /* Hide cursor */
    hl = cursor;
    de = -SCREEN_SIZE;
    push_pop(hl) {
        hl += de;
        a = *hl;
        a &= 0xFF ^ SCREEN_ATTRIB_UNDERLINE;
        *hl = a;
    }

    a = c;
    if (a < 32) {
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
        a--; /* 0x19 */
        if (flag_z)
            return MoveCursorUp(hl);
        a--; /* 0x1A */
        if (flag_z)
            return MoveCursorDown(hl);
        a -= 0x1F - 0x1A;
        if (flag_z)
            return ClearScreen();
    }

    *hl = c;
    push_pop(hl) {
        hl += de;
        *hl = a = color;
    }
    return MoveCursorRight();
}

void MoveCursorRight(...) {
    hl++;
    return MoveCursor(hl);
}

void MoveCursor(...) {
    swap(hl, de);
    hl = -(SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT);
    hl += de;
    swap(hl, de);
    if (flag_c) {
        push_pop(hl) {
            /* Scroll up */
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
                        h = ((a = h) -= 8);
                        a = c;
                        c = *hl;
                        *hl = a;
                        hl += de;
                    } while ((a = h) != 0xE7);
                }
                l--;
            } while ((a = l) != SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1 - SCREEN_WIDTH);
        }
        hl += (de = -SCREEN_WIDTH);
    }

    cursor = hl;

    /* Show cursor */
    hl += (de = -SCREEN_SIZE);
    a = *hl;
    a |= SCREEN_ATTRIB_UNDERLINE;
    *hl = a;

    pop(bc, hl, de, a);
}

void ClearScreenInt() {
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
    bc = 0x740; /* 25 rows */
    a = color;
    ClearScreenInt();
    a = SCREEN_ATTRIB_BLANK;
    bc = 0x2C0; /* 7 rows */
    ClearScreenInt();
    PrintKeyStatus();
    MoveCursorHome();
}

void MoveCursorHome() {
    MoveCursor(hl = SCREEN_BEGIN);
}

void MoveCursorLeft(...) {
    hl--;
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    MoveCursor(hl = SCREEN_BEGIN + SCREEN_WIDTH * SCREEN_HEIGHT - 1);
}

void MoveCursorNextLine(...) {
    a = l;
    a &= 0xFF ^ (SCREEN_WIDTH - 1);
    l = a;
    MoveCursorDown();
}

void MoveCursorDown(...) {
    hl += (de = SCREEN_WIDTH);
    MoveCursor(hl);
}

void MoveCursorUp(...) {
    hl += (de = -SCREEN_WIDTH);
    if ((a = h) != (SCREEN_BEGIN >> 8) - 1)
        return MoveCursor(hl);
    hl += (de = SCREEN_WIDTH * SCREEN_HEIGHT);
    MoveCursor(hl);
}

void ReadKey() {
    do {
        ScanKey();
    } while (flag_z);
    a--;

    push_pop(a) {
        keySaved = a = 0xFF;
    }
}

uint8_t aZag[] = {'z', 'a' | 0x80, 'g' | 0x80, 's', 't' | 0x80, 'r' | 0x80};
uint8_t aLat[] = {'l', 'a' | 0x80, 't' | 0x80, 'r', 'u' | 0x80, 's' | 0x80};

void PrintKeyStatus() {
    bc = 0xEFF9;
    a = keybMode;
    hl = &aZag;
    PrintKeyStatus1();
    bc++;
    hl = &aLat;
    PrintKeyStatus1();
}

void PrintKeyStatus1() {
    de = 3; /* String size */
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

void ScanKey() {
    push(bc, de, hl);
    ScanKey0();
}

void ScanKey0() {
    b = -1;
    c = 1 ^ 0xFF;
    d = KEYBOARD_COLUMN_COUNT;
    do {
        out(PORT_KEYBOARD_COLUMN, a = c);
        cyclic_rotate_left(a, 1);
        c = a;
        a = in(PORT_KEYBOARD_ROW);
        a &= KEYBOARD_ROW_MASK;
        if (a != KEYBOARD_ROW_MASK)
            return ScanKey1(a, b);
        b = ((a = b) += KEYBOARD_ROW_COUNT);
    } while (flag_nz(d--));

    a = in(PORT_KEYBOARD_MODS);
    if (flag_z(a &= KEYBOARD_RUS_MOD))
        return ScanKey1(a, b);

    keyLast = a = 0xFF;

    return ScanKeyExit();
}

void ScanKey1(...) {
    do {
        b++;
        cyclic_rotate_right(a, 1);
    } while (flag_c);

    /* Delay */
    a ^= a;
    do {
        a--;
    } while (flag_nz);

    /* b - key number */

    /*  0    0    1 !   2 "   3 #   4 $   5 %   6 &   7 ,
     *  8   8 (   9 )   : *   ; +   , <   - =   . >   / ?
     * 16   @ Ю   A А   B Б   C Ц   D Д   E Е   F Ф   G Г
     * 24   H Х   I И   J Й   K К   L Л   M М   N Н   O О
     * 32   P П   Q Я   R Р   S С   T Т   U У   V Ж   W В
     * 40   X Ь   Y Ы   Z З   [ Ш   \ Э   ] Щ   ^ Ч    _
     * 48   Space Right Left  Up    Down  Vk    Str   Home */
    hl = &keyLast;
    a = *hl;
    hl--; /* keyDelay */
    if (a == b) {
        (*hl)--;
        if (flag_nz)
            return ScanKey0();
        *hl = 0x30; /* Next repeat delay */
    } else {
        *hl = 0xFF; /* First repeat delay */
    }
    hl++;
    *hl = b; /* Key last */

    a = b;
    if (a >= 48) {
        if (a == 56) { /* RUS/LAT */
            a = in(PORT_KEYBOARD_MODS);
            carry_rotate_right(a, 3); /* Shift */
            a = KEYB_MODE_CAP;
            carry_add(a, 0); /* KEYB_MODE_CAP -> KEYB_MODE_RUS */
            hl = &keybMode;
            a ^= *hl;
            *hl = a;

            PrintKeyStatus();
            return ScanKey0();
        }
        a += ((uintptr_t)keyTable - 48);
        l = a;
        h = ((uintptr_t)keyTable - 48) >> 8;
        a = *hl;
        return ScanKey2(a);
    }

    a += '0';
    if (a >= 0x3C)
        if (a < 0x40)
            a &= 0x2F; /* <=>? to .-./ */
    c = a;

    a = keybMode;
    cyclic_rotate_right(a, 2); /* KEYB_MODE_RUS */
    if (flag_c) {
        a = c;
        a |= 0x20;
        c = a;
    }

    a = in(PORT_KEYBOARD_MODS);
    cyclic_rotate_right(a, 2); /* Ctrl */
    if (flag_nc) {
        a = c;
        a &= 0x1F;
        return ScanKey2(a);
    }

    carry_rotate_right(a, 1); /* Shift */
    a = c;
    if (flag_nc) {
        if (a >= 0x40) {
            a |= 0x80;
            return ScanKey2(a);
        }
        a ^= 0x10;
    }

    ScanKey2(a);
}

void ScanKey2(...) {
    keySaved = a;
    c = a;

    a = keybMode;
    cyclic_rotate_right(a, 1); /* KEYB_MODE_CAP */
    if (flag_nc)
        return ScanKeyExit();

    a = c;
    a &= 0x7F;
    if (a < 0x60) { /* Cyr chars */
        if (a < 'A')
            return ScanKeyExit();
        if (a >= 'Z' + 1)
            return ScanKeyExit();
    }
    a = c;
    a ^= 0x80;
    keySaved = a;
    ScanKeyExit();
}

void ScanKeyExit(...) {
    pop(bc, de, hl);
    a = keySaved;
    a++; /* Returns ZF and A = 0 if no key is pressed */
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
    ScanKey();
    if (flag_z)
        return; /* Returns 0 if no key is pressed */
    a = 0xFF;   /* Returns 0xFF if there are any keys pressed */
}
