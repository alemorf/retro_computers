#include "cmm.h"

/* Screen */
const int SCREEN_ATTRIB_BEGIN = 0xE000;
const int SCREEN_SIZE = 0x800;
const int SCREEN_BEGIN = 0xE800;
const int SCREEN_END = 0xF000;
const int SCREEN_WIDTH = 64;
const int SCREEN_HEIGHT = 25;
const int SCREEN_ATTRIB_DEFAULT = 0x27;
const int SCREEN_ATTRIB_BLANK = 0x07;
const int SCREEN_ATTRIB_INPUT = 0x23;
const int SCREEN_ATTRIB_UNDERLINE = 1 << 7;

/* Bits of keybMode */
const int KEYB_MODE_CAP = 1 << 0;
const int KEYB_MODE_RUS = 1 << 1;

/* IO ports */
const int PORT_TAPE = 1;
const int PORT_KEYBOARD_MODE = 4;
const int PORT_KEYBOARD_COLUMN = 7;
const int PORT_KEYBOARD_ROW = 6;
const int PORT_KEYBOARD_MODS = 5;

/* Keyboard */
const int KEYBOARD_ROW_MASK = 0x7F;
const int KEYBOARD_MODS_MASK = 0x07;
const int KEYBOARD_RUS_MOD = 1 << 0;
const int KEYBOARD_COLUMN_COUNT = 8;
const int KEYBOARD_ROW_COUNT = 7;

/* Tape */
const int READ_TAPE_FIRST_BYTE = 0xFF;
const int READ_TAPE_NEXT_BYTE = 8;
const int TAPE_START = 0xE6;

/* i8080 opcodes */
const int OPCODE_RST_38 = 0xFF;
const int OPCODE_JMP = 0xC3;

/* Interrupt vector */
extern uint8_t rst38Opcode __address(0x38);
extern uint16_t rst38Address __address(0x39);

/* BIOS variables */
void jumpParam1(void) __address(0xF750);
extern uint8_t jumpOpcode __address(0xF750);
extern uint16_t param1 __address(0xF751);
extern uint8_t param1h __address(0xF752);
extern uint16_t param2 __address(0xF753);
extern uint8_t param2h __address(0xF754);
extern uint16_t param3 __address(0xF755);
extern uint8_t param3h __address(0xF756);
extern uint8_t tapePolarity __address(0xF757);
extern uint8_t keybMode __address(0xF758);
extern uint8_t color __address(0xF759);
extern uint16_t cursor __address(0xF75A);
extern uint8_t readDelay __address(0xF75C);
extern uint8_t writeDelay __address(0xF75D);
extern uint8_t tapeStartL __address(0xF75E);
extern uint8_t tapeStartH __address(0xF75F);
extern uint8_t tapeStopL __address(0xF760);
extern uint8_t tapeStopH __address(0xF761);
extern uint8_t keyDelay __address(0xF762);
extern uint8_t keyLast __address(0xF763);
extern uint8_t keySaved __address(0xF764);
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
