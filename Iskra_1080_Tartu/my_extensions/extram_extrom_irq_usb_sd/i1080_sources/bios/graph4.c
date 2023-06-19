#include "graph.h"
#include "opcodes.h"
#include "macro.h"

/* Полиморфизм */
extern uint8_t DrawChar4a;
extern uint8_t DrawChar4b;
extern uint8_t DrawChar4a_And1;
extern uint8_t DrawChar4b_And1;
extern uint8_t DrawChar4a_And2;
extern uint8_t DrawChar4b_And2;
extern uint8_t DrawChar4a_Xor1;
extern uint8_t DrawChar4b_Xor1;
extern uint8_t DrawChar4a_Xor2;
extern uint8_t DrawChar4b_Xor2;

/* Прототипы */
void DrawChar6();
void DrawChar60();
void DrawChar66();
void DrawChar64();
void DrawChar62();
void DrawChar4();
void DrawChar44();
void DrawChar40();

/* Шрифт */
asm("font4: incbin \"font4.tmp\"");
extern uint8_t font4[256 * 10];

void DrawChar4(...) {
    b = a;

    a = l;
    a += a += a;
    a += l;
    a += a;
    invert(a);
    e = a;

    a = h;
    c = a;
    a |= a;
    CarryRotateRight(a);
    invert(a);
    d = a;

    /* Calc chargen address */
    a = b;
    SET_HL_A_PLUS_CONST(&font4);

    /* Select function */
    if (flag_nz((a = c) &= 1))
         return DrawChar40();
    return DrawChar44();
}

/* Draw char XXXX....
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar44() {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        a &= 0xF0;
        b = a;
        a = *de;
DrawChar4a_And1:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
DrawChar4a_Xor1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar4a:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        a &= 0xF0;
        b = a;
        a = *de;
DrawChar4a_And2:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
DrawChar4a_Xor2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while(flag_nz(c--));
}

/* Draw char ....XXXX
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar40() {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        a &= 0x0F;
        b = a;
        a = *de;
DrawChar4b_And1:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
DrawChar4b_Xor1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar4b:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        a &= 0x0F;
        b = a;
        a = *de;
DrawChar4b_And2:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
DrawChar4b_Xor2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while(flag_nz(c--));
}

void SetColor4(...) {
    /* TODO: Заменить на ^= 0x10, ^= 0xFF, ^= 0xA8 */
    c = a;
    if (flag_z(a &= 4)) {
        hl = OPCODE_AND_CONST | (0x0F << 8);
        DrawChar4a_And1 = hl;
        h = 0xF0;
        DrawChar4b_And1 = hl;
    } else {
        hl = OPCODE_OR_CONST | (0xF0 << 8);
        DrawChar4a_And1 = hl;
        h = 0x0F;
        DrawChar4b_And1 = hl;
    }
    b = a;
    a = c;
    a += a += a;
    a &= 4;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    DrawChar4a_Xor1 = a;
    DrawChar4b_Xor1 = a;

    a = c;
    if (flag_z(a &= 8)) {
        hl = OPCODE_AND_CONST | (0x0F << 8);
        DrawChar4a_And2 = hl;
        h = 0xF0;
        DrawChar4b_And2 = hl;
    } else {
        hl = OPCODE_OR_CONST | (0xF0 << 8);
        DrawChar4a_And2 = hl;
        h = 0x0F;
        DrawChar4b_And2 = hl;
    }
    b = a;
    a = c;
    a += a += a;
    a &= 8;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    DrawChar4a_Xor2 = a;
    DrawChar4b_Xor2 = a;
}

void DrawCursor4() {
    /* Координаты в адрес */
    a = h;
    a |= a;
    CarryRotateRight(a);
    Invert(a);
    d = a;
    a = l;
    a += a += a;
    a += l;
    a += a;
    Invert(a);
    e = a;

    /* Маска курсора */
    a = h;
    a &= 1;
    b = 0x0F;
    if (flag_z)
        b = 0xF0;

    /* Рисуем курсор */
    c = FONT_HEIGHT;
    do {
        *de = ((a = *de) ^= b);
        e--;
    } while(flag_nz(c--));
}

void SetScreenBw4() {
    text_screen_width = a = 96;
    SetColorAddress = hl = &SetColor4;
    DrawCharAddress = hl = &DrawChar4;
    DrawCursorAddress = hl = &DrawCursor4;
    DrawChar4a = a = OPCODE_RET;
    DrawChar4b = a;
    return SetScreenBw();
}

void SetScreenColor4() {
    text_screen_width = a = 96;
    SetColorAddress = hl = &SetColor4;
    DrawCharAddress = hl = &DrawChar4;
    DrawCursorAddress = hl = &DrawCursor4;
    DrawChar4a = a = OPCODE_LD_A_D;
    DrawChar4b = a;
    return SetScreenColor();
}
