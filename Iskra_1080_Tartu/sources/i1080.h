// Реверс-инженеринг ПЗУ компьютера Искра 1080 Тарту
// В процессе
// (c) 24-09-2020 Aleksey Morozov

#include "cmm.h"

// Порты ввода вывода
const int PORT_UART_DATA = 0x80;
const int PORT_UART_CONFIG = 0x81;
const int PORT_UART_STATE = 0x81;
const int PORT_EXT_DATA_OUT = 0x88;
const int PORT_PALETTE_3 = 0x90;
const int PORT_PALETTE_2 = 0x91;
const int PORT_PALETTE_1 = 0x92;
const int PORT_PALETTE_0 = 0x93;
const int PORT_EXT_IN_DATA = 0x89;
const int PORT_A0 = 0xA0;
const int PORT_ROM_0000 = 0xA8;
const int PORT_ROM_0000__ROM = 0;
const int PORT_ROM_0000__RAM = 0x80;
const int PORT_VIDEO_MODE_1_HIGH = 0xF9;
const int PORT_VIDEO_MODE_0_LOW = 0xB8;
const int PORT_UART_SPEED_0 = 0xBB;
const int PORT_KEYBOARD = 0xC0;
const int PORT_UART_SPEED_1 = 0xFB;
const int PORT_CODE_ROM = 0xBA;
const int PORT_CHARGEN_ROM = 0xFA;
const int PORT_TAPE_AND_IDX2 = 0x99;
const int PORT_TAPE_AND_IDX2_ID1_2 = 2;
const int PORT_TAPE_AND_IDX2_ID2_2 = 4;
const int PORT_TAPE_AND_IDX2_ID3_2 = 8;
const int PORT_TAPE_AND_IDX2_ID6_2 = 0x40;
const int PORT_TAPE_AND_IDX2_ID7_2 = 0x80;
const int PORT_RESET_CU1 = 0xBC;
const int PORT_RESET_CU2 = 0xBD;
const int PORT_RESET_CU3 = 0xBE;
const int PORT_RESET_CU4 = 0xBF;
const int PORT_SET_CU1 = 0xFC;
const int PORT_SET_CU2 = 0xFD;
const int PORT_SET_CU3 = 0xFE;
const int PORT_SET_CU4 = 0xFF;
const int PORT_TAPE_OUT = 0xB0;

// Режим КР580ВВ51
// Может быть установлено только после аппаратного или программного сброса.
const int VV51_MODE__ASYNC_1 = 1;     // Не используется в параметре UartSetMode
const int VV51_MODE__ASYNC_16 = 2;    // -//-
const int VV51_MODE__ASYNC_64 = 3;    // -//-
const int VV51_MODE__ASYNC_MASK = 3;  // -//-
const int VV51_MODE__DATA_5 = 0 << 2;
const int VV51_MODE__DATA_6 = 1 << 2;
const int VV51_MODE__DATA_7 = 2 << 2;
const int VV51_MODE__DATA_8 = 3 << 2;
const int VV51_MODE__ODD = 1 << 4;
const int VV51_MODE__CHECK = 1 << 5;
const int VV51_MODE__STOP_1 = 1 << 6;
const int VV51_MODE__STOP_15 = 2 << 6;
const int VV51_MODE__STOP_2 = 3 << 6;

// Комада КР580ВВ51
const int VV51_COMMAND__TX_ENABLE = 1 << 0;
const int VV51_COMMAND__DTR = 1 << 1;
const int VV51_COMMAND__RX_ENABLE = 1 << 2;
const int VV51_COMMAND__SEND_BREAK = 1 << 3;
const int VV51_COMMAND__ERROR_RESET = 1 << 4;
const int VV51_COMMAND__RTS = 1 << 5;
const int VV51_COMMAND__INTERNAL_RESET = 1 << 6;  // Следующим обращением к КР580ВВ51 необходимо установить режим
const int VV51_COMMAND__ENTER_HUNT_MODE = 1 << 7;  // Только для синхронного режима. В Искре 1080 не используется.

// Состояние КР580ВВ51
const int VV51_STATE__TX_READY = 1 << 0;  // Data buffer empty
const int VV51_STATE__RX_READY = 1 << 1;
const int VV51_STATE__TX_EMPTY = 1 << 2;
const int VV51_STATE__PARITY_ERROR = 1 << 3;
const int VV51_STATE__OVERRUN_ERROR = 1 << 4;
const int VV51_STATE__FRAMING_ERROR = 1 << 5;  // Не обнаружен стартовый бит
const int VV51_STATE__SYNDET = 1 << 6;         // Вид синхронизации
const int VV51_STATE__DSR = 1 << 7;

// Используется в параметре UartSetMode.
// Может быть установлено только после аппаратного или программного сброса.
const int UART_MODE__SPEED_0 = 0;
const int UART_MODE__SPEED_1 = 1;
const int UART_MODE__SPEED_2 = 2;
const int UART_MODE__SPEED_3 = 3;
const int UART_MODE__DATA_5 = VV51_MODE__DATA_5;
const int UART_MODE__DATA_6 = VV51_MODE__DATA_6;
const int UART_MODE__DATA_7 = VV51_MODE__DATA_7;
const int UART_MODE__DATA_8 = VV51_MODE__DATA_8;
const int UART_MODE__ODD = VV51_MODE__ODD;
const int UART_MODE__CHECK = VV51_MODE__CHECK;
const int UART_MODE__STOP_1 = VV51_MODE__STOP_1;
const int UART_MODE__STOP_15 = VV51_MODE__STOP_15;
const int UART_MODE__STOP_2 = VV51_MODE__STOP_2;

// Коды клавиш
const int KEY_LEFT_DOWN = 0x81;
const int KEY_DOWN = 0x82;
const int KEY_RIGHT_DOWN = 0x83;
const int KEY_LEFT = 0x84;
const int KEY_RIGHT = 0x86;
const int KEY_LEFT_UP = 0x87;
const int KEY_UP = 0x88;
const int KEY_RIGHT_UP = 0x89;
const int KEY_EXT_0 = 0x80;
const int KEY_EXT_1 = 0x81;
const int KEY_EXT_2 = 0x82;
const int KEY_EXT_3 = 0x83;
const int KEY_EXT_4 = 0x84;
const int KEY_EXT_5 = 0x85;
const int KEY_EXT_6 = 0x86;
const int KEY_EXT_7 = 0x87;
const int KEY_EXT_8 = 0x88;
const int KEY_EXT_9 = 0x89;
const int KEY_EXT_POINT = 0x8A;
const int KEY_COP = 0x8B;
const int KEY_RUS = 0x8D;
const int KEY_LAT = 0x8C;
const int KEY_CAPS_LOCK = 0x8E;
const int KEY_NUM_LOCK = 0x8F;
const int KEY_F1 = 0x90;
const int KEY_F2 = 0x91;
const int KEY_F3 = 0x92;
const int KEY_SHIFT_F1 = 0x93;
const int KEY_SHIFT_F2 = 0x94;
const int KEY_SHIFT_F3 = 0x95;

// Светодиоды. Биты порта PORT_KEYBOARD на запись.
const int LED_CAPS_LOCK = 0x10;
const int LED_NUM_LOCK = 0x20;

// Точки входа CP/M BIOS
void vBiosEntrySetTrk(...) __address(0xB21E);
void vBiosEntrySetSec(...) __address(0xB221);
void vBiosEntrySetDma(...) __address(0xB224);
void vBiosEntryRead(...) __address(0xB227);
void vBiosEntryWrite(...) __address(0xB22A);
void vBiosEntryListSt(...) __address(0xB22D);
void vBiosEntrySecTran(...) __address(0xB230);
extern uint8_t vBiosEntryDisks __address(0xB233);

// Пакет CP/M BIOS
extern uint8_t vPacketSize __address(0xB353);
extern uint8_t vPacketDirection __address(0xB354);
extern uint8_t vPacketAddress __address(0xB355);
extern uint8_t vPacketCommandResult __address(0xB356);

// Переменные CP/M BIOS
extern uint8_t vBiosDisk __address(0xB357);
extern uint8_t vBiosTrackLow __address(0xB358);
extern uint8_t vBiosTrackHigh __address(0xB359);
extern uint8_t vBiosSector __address(0xB35A);
extern uint8_t vBiosDma __address(0xB35B);
extern uint8_t vDisk __address(0xB35F);
extern uint8_t vDiskTries __address(0xB360);
extern uint8_t vDiskResult __address(0xB363);

// Переменные BIOS и Монитор
void vReset(...) __address(0x0000);
extern uint8_t vResetOpcode __address(0x0000);
extern uint16_t vResetAddress __address(0x0001);
extern uint16_t vCpmDisk __address(0x0004);
extern uint8_t vRst38 __address(0x0038);
extern uint8_t vTempVideoInverse __address(0x004C);
extern uint8_t vTempVideoCursorX __address(0x004D);
extern uint8_t vTempVideoFontHeight10 __address(0x004E);
extern uint8_t vTempVideoRom __address(0x004F);
void vMonitorQuit(...) __address(0xC7ED);
extern uint8_t vMonitorQuitOpcode __address(0xC7ED);
extern uint8_t vMonitorQuitAddress __address(0xC7EE);
void vPrint(...) __address(0xC7F0);
extern uint8_t vPrintOpcode __address(0xC7F0);
extern uint16_t vPrintAddress __address(0xC7F1);
void vInput(...) __address(0xC7F3);
extern uint8_t vInputOpcode __address(0xC7F3);
extern uint16_t vInputAddress __address(0xC7F4);
void vTempMonitorProgramm(...) __address(0xC7F6);
extern uint8_t vTempMonitorProgramm0 __address(0xC7F6);
extern uint8_t vTempMonitorProgramm1 __address(0xC7F7);
extern uint8_t vTempMonitorProgramm2 __address(0xC7F8);
void vBiosReadWrite(...) __address(0xC7FF);
extern uint8_t vBiosReadWriteOpcode __address(0xC7FF);
extern uint16_t vKeyboardLayout __address(0xC800);
extern uint8_t vVideoTextWidth __address(0xC802);
extern uint8_t vVideoFontHeight10 __address(0xC803);
extern uint8_t vTempCall0000 __address(0xC804);
extern uint8_t vTempInputPrint __address(0xC806);
extern uint8_t vVideoCursorX __address(0xC807);
extern uint8_t vVideoCursorY __address(0xC808);
extern uint8_t vVideoInverse __address(0xC809);
extern uint8_t vVideoCursorAddress __address(0xC80A);
extern uint8_t vUnused __address(0xC80C);
extern uint8_t vMonitorPrompt __address(0xC80D);
extern uint8_t vTempMonitorArgument1 __address(0xC80E);
extern uint16_t vTempMonitorArgument2 __address(0xC810);
extern uint8_t vMonitorArgument1 __address(0xC812);
extern uint16_t vTempMonitorParse __address(0xC814);
extern uint8_t vKeyboardLast __address(0xC816);
extern uint16_t vKeyboardDelay __address(0xC817);
extern uint16_t vVideoFont __address(0xC819);
extern uint8_t vTempMonitorAble1 __address(0xC81B);
extern uint8_t vMonitorDirectiveIPort __address(0xC81C);
extern uint8_t vMonitorDirectiveOPort __address(0xC81D);
extern uint16_t vTempSP __address(0xC81E);
extern uint8_t vVideoEscState __address(0xC820);
extern uint8_t vVideoEscCursorState __address(0xC821);
extern uint8_t vKeyboardCapsLock __address(0xC822);
extern uint8_t vKeyboardNumLock __address(0xC823);
extern uint8_t vKeyboardLeds __address(0xC824);
extern uint8_t vInited12 __address(0xC825);
extern uint8_t vInited34 __address(0xC826);
extern uint8_t vTempRst38 __address(0xC827);
extern uint8_t vTempDisassemblerSize __address(0xC828);
extern uint8_t vTempTapeName __address(0xC829);  // 6 символов
extern uint8_t vTempTapeRequiredName __address(0xC82F);
extern uint8_t vTempTapeRequiredType __address(0xC831);
extern uint8_t vTempTapeFoundType __address(0xC832);
extern uint8_t vTempTape1 __address(0xC833);
extern uint8_t vTempTapeAsciiRead __address(0xC835);
extern uint8_t vTempTapeBegin __address(0xC837);
extern uint8_t vTempTapeEnd __address(0xC839);
extern uint8_t vTempTape2 __address(0xC83B);
extern uint8_t vTempTapeAscii __address(0xC83D);
extern uint8_t vTempTapeFunction __address(0xC83F);
extern uint8_t vTempTapeCounter __address(0xC841);
extern uint8_t vTempTape3 __address(0xC842);
extern uint8_t vTempTape4 __address(0xC843);
extern uint8_t vKeyboardF1 __address(0xC844);
extern uint8_t vKeyboardF2 __address(0xC845);
extern uint8_t vKeyboardF3 __address(0xC846);
extern uint8_t vKeyboardShiftF1 __address(0xC847);
extern uint8_t vKeyboardShiftF2 __address(0xC848);
extern uint8_t vKeyboardShiftF3 __address(0xC849);
extern uint8_t vUartMode __address(0xC84A);
extern uint8_t vMonitorStringLength __address(0xC900);
extern uint8_t vMonitorString __address(0xC901);

// Адреса в ОЗУ
const int CPM_STACK_ADDRESS = 0x0080;
const int TAPE_ASCII_BUFFER = 0x7F00;
const int SCREEN_1_ADDRESS = 0x9000;
const int STACK_ADDRESS = 0xC900;
const int TEXT_SCREEN_ADDRESS = 0xC9C0;
const int TEXT_SCREEN_WIDTH = 64;
const int TEXT_SCREEN_HEIGHT = 25;
const int SCREEN_0_ADDRESS = 0xD000;
const int SCREEN_WIDTH = 384;
const int SCREEN_HEIGHT = 256;
const int SCREEN_SIZE = 0x3000;

// Адреса в ПЗУ2
const int FONT_ADDRESS = 0xC100;

// Цвета палитры
const int PALETTE_WHITE = 0;
const int PALETTE_CYAN = 1;
const int PALETTE_MAGENTA = 2;
const int PALETTE_BLUE = 3;
const int PALETTE_YELLOW = 4;
const int PALETTE_GREEN = 5;
const int PALETTE_RED = 6;
const int PALETTE_XXX = 7;
const int PALETTE_DARK_GRAY = 8;
const int PALETTE_DARK_CYAN = 9;
const int PALETTE_DARK_MAGENTA = 10;
const int PALETTE_DARK_BLUE = 11;
const int PALETTE_DARK_YELLOW = 12;
const int PALETTE_DARK_GREEN = 13;
const int PALETTE_DARK_RED = 14;
const int PALETTE_BLACK = 15;
