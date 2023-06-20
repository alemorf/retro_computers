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

// Используется функциями из ПЗУ2
void BiosBoot(...);
void BiosWarmBoot(...);
void BiosConst(...);
void BiosWaitKey(...);
void BiosPutch(...);
void BiosList(...);
void BiosAuxOut(...);
void BiosAuxIn(...);
void BiosHome(...);
void BiosSetDsk(...);
void BiosSetTrk(...);
void BiosSetSec(...);
void BiosSectTran(...);
void BiosSetDma(...);
void BiosRead(...);
void BiosWrite(...);
void BiosListSt(...);
void RealInput(...);
void VideoPrint(...);

// Функнции CP/M BIOS в ПЗУ2
void BiosBoot2(...) __address(0xC8A1);
void BiosInit2(...) __address(0xC8B2);
void BiosLoadDph2(...) __address(0xC8E4);
void BiosLoadCpm2(...) __address(0xC905);
void BiosList2(...);// __address(0xC96A);
void BiosRead2(...) __address(0xC984);
void BiosWrite2(...) __address(0xC998);

// Данные в ПЗУ2
extern uint8_t bKeybaordEnglishLayout __address(0xC000);
extern uint8_t bKeybaordRussianLayout __address(0xC140);
extern uint8_t bDisassemlerOpcodes1 __address(0xC280);
extern uint8_t bDisassemlerOpcodes2 __address(0xC2A1);
extern uint8_t bDisassemlerUnknown __address(0xC2CF);
extern uint8_t bDisassemlerMov __address(0xC2D3);
extern uint8_t bDisassemlerNames1 __address(0xC2D7);
extern uint8_t bDisassemlerNames2 __address(0xC35C);
extern uint8_t bDisassemlerArguments __address(0xC3B9);
extern uint8_t bPressPlayOnTape __address(0xC401);      // 'Press PLAY on tape$'
extern uint8_t bAndAnyKeyOnKeyboard __address(0xC414);  // ' & any key on keyboard$'
extern uint8_t bSearching __address(0xC42B);            // 'Searching\r$'
extern uint8_t bFound __address(0xC436);                // 'Found $'
extern uint8_t bReading __address(0xC43D);              // 'Reading\r$'
extern uint8_t bLoadError __address(0xC446);            // 'Load error\r$'
extern uint8_t bVerifyError __address(0xC452);          // 'Verify error\r$'
extern uint8_t bDone __address(0xC460);                 // 'Done\r$'
extern uint8_t bPressRecord __address(0xC466);          // 'Press RECORD &'
extern uint8_t bPlayOnTapeSaving __address(0xC474);     // ' PLAY on tape$'
extern uint8_t bSaving __address(0xC482);               // 'Saving\r$'
extern uint8_t bFileTooLong __address(0xC48A);          // 'File too long\r$'
extern uint8_t bBasic __address(0xC499);                // '(BASIC)   $'
extern uint8_t bAscii __address(0xC4A4);                // '(ASCII)   $'
extern uint8_t bBinary __address(0xC4AF);               // '(BINARY)  $'
extern uint8_t bUnknown __address(0xC4BA);              // '(UNKNOWN) $'
extern uint8_t bNextWithoutFor __address(0xC4C5);       // 'NEXT without FOR',0
extern uint8_t bSyntaxError __address(0xC4D6);          // 'Syntax error',0
extern uint8_t bReturnWithoutGosub __address(0xC4E3);   // 'RETURN without GOSUB',0
extern uint8_t bOutOfData __address(0xC4F8);            // 'Out of DATA',0
extern uint8_t bIllegalValue __address(0xC504);         // 'Illegal value',0
extern uint8_t bOverflow __address(0xC512);             // 'Overflow',0
extern uint8_t bOutOfMemory __address(0xC51B);          // 'Out of memory',0
extern uint8_t bUnndefinedStatement __address(0xC529);  // 'Undefined statement',0
extern uint8_t bBadSubscript __address(0xC53D);         // 'Bad subscript',0
extern uint8_t bRedimDArray __address(0xC54B);          // 'ReDIM\'d array',0
extern uint8_t bDivisionByZero __address(0xC559);       // 'Division by zero',0
extern uint8_t bIllegalDirect __address(0xC56A);        // 'Illegal direct',0
extern uint8_t bTypeMismatch __address(0xC579);         // 'Type mismatch',0
extern uint8_t bOutOfStringSpace __address(0xC587);     // 'Out of string space',0
extern uint8_t bStringTooLong __address(0xC59B);        // 'String too long',0
extern uint8_t bFormulaTooComplex __address(0xC5AB);    // 'Formula too complex',0
extern uint8_t bCanTContinue __address(0xC5BF);         // 'Can\'t CONTinue',0
extern uint8_t bUndefinedFunction __address(0xC5CE);    // 'Undefined function',0

// Далее имена команд и функций Бейска
// C719 - CFFF заполнено нулями
