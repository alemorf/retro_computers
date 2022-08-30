// Реверс-инженеринг ПЗУ компьютера Искра 1080 Тарту
// В процессе
// (c) 24-09-2020 Aleksey Morozov

// Типы блоков на магнитной ленте
const int TAPE_BINARY = 0xD0;
const int TAPE_BASIC = 0xD3;
const int TAPE_ASCII = 0xEA;

// Используемые опкоды КР580ВМ80
const int OPCODE_RET = 0xC9;
const int OPCODE_CALL = 0xC3;
const int OPCODE_IN = 0xDB;
const int OPCODE_OUT = 0xD3;
const int OPCODE_HALT = 0x76;

// Конец строки
const int EOL = 0x0D;

// Бит в байте
const int BIT_PER_BYTE = 8;

// Функнции CP/M BIOS в ПЗУ2
extern uint8_t BiosBoot2 = 0xC8A1;
extern uint8_t BiosInit2 = 0xC8B2;
extern uint8_t BiosLoadDph2 = 0xC8E4;
extern uint8_t BiosLoadCpm2 = 0xC905;
extern uint8_t BiosList2 = 0xC96A;
extern uint8_t BiosRead2 = 0xC984;
extern uint8_t BiosWrite2 = 0xC998;

// Данные в ПЗУ2
extern uint8_t bKeybaordEnglishLayout = 0xC000;
extern uint8_t bKeybaordRussianLayout = 0xC140;
extern uint8_t bDisassemlerOpcodes1 = 0xC280;
extern uint8_t bDisassemlerOpcodes2 = 0xC2A1;
extern uint8_t bDisassemlerUnknown = 0xC2CF;
extern uint8_t bDisassemlerMov = 0xC2D3;
extern uint8_t bDisassemlerNames1 = 0xC2D7;
extern uint8_t bDisassemlerNames2 = 0xC35C;
extern uint8_t bDisassemlerArguments = 0xC3B9;
extern uint8_t bPressPlayOnTape = 0xC401;      // 'Press PLAY on tape$'
extern uint8_t bAndAnyKeyOnKeyboard = 0xC414;  // ' & any key on keyboard$'
extern uint8_t bSearching = 0xC42B;            // 'Searching\r$'
extern uint8_t bFound = 0xC436;                // 'Found $'
extern uint8_t bReading = 0xC43D;              // 'Reading\r$'
extern uint8_t bLoadError = 0xC446;            // 'Load error\r$'
extern uint8_t bVerifyError = 0xC452;          // 'Verify error\r$'
extern uint8_t bDone = 0xC460;                 // 'Done\r$'
extern uint8_t bPressRecord = 0xC466;          // 'Press RECORD &'
extern uint8_t bPlayOnTapeSaving = 0xC474;     // ' PLAY on tape$'
extern uint8_t bSaving = 0xC482;               // 'Saving\r$'
extern uint8_t bFileTooLong = 0xC48A;          // 'File too long\r$'
extern uint8_t bBasic = 0xC499;                // '(BASIC)   $'
extern uint8_t bAscii = 0xC4A4;                // '(ASCII)   $'
extern uint8_t bBinary = 0xC4AF;               // '(BINARY)  $'
extern uint8_t bUnknown = 0xC4BA;              // '(UNKNOWN) $'
extern uint8_t bNextWithoutFor = 0xC4C5;       // 'NEXT without FOR',0
extern uint8_t bSyntaxError = 0xC4D6;          // 'Syntax error',0
extern uint8_t bReturnWithoutGosub = 0xC4E3;   // 'RETURN without GOSUB',0
extern uint8_t bOutOfData = 0xC4F8;            // 'Out of DATA',0
extern uint8_t bIllegalValue = 0xC504;         // 'Illegal value',0
extern uint8_t bOverflow = 0xC512;             // 'Overflow',0
extern uint8_t bOutOfMemory = 0xC51B;          // 'Out of memory',0
extern uint8_t bUnndefinedStatement = 0xC529;  // 'Undefined statement',0
extern uint8_t bBadSubscript = 0xC53D;         // 'Bad subscript',0
extern uint8_t bRedimDArray = 0xC54B;          // 'ReDIM\'d array',0
extern uint8_t bDivisionByZero = 0xC559;       // 'Division by zero',0
extern uint8_t bIllegalDirect = 0xC56A;        // 'Illegal direct',0
extern uint8_t bTypeMismatch = 0xC579;         // 'Type mismatch',0
extern uint8_t bOutOfStringSpace = 0xC587;     // 'Out of string space',0
extern uint8_t bStringTooLong = 0xC59B;        // 'String too long',0
extern uint8_t bFormulaTooComplex = 0xC5AB;    // 'Formula too complex',0
extern uint8_t bCanTContinue = 0xC5BF;         // 'Can\'t CONTinue',0
extern uint8_t bUndefinedFunction = 0xC5CE;    // 'Undefined function',0
// Далее имена команд и функций Бейска
// C719 - CFFF заполнено нулями
