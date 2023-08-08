#include "graph.h"
#include "macro.h"
#include "opcodes.h"

extern uint8_t font[256 * 10];

uint8_t text_screen_width = 96;

/* Прототипы */
void DrawChar6();
void DrawChar60();
void DrawChar66();
void DrawChar64();
void DrawChar62();
void ScrollUpSubBw();
void ScrollUpSubColor();
void SetColor6();
void DrawCursor6();

/* Полиморфизм */
extern uint8_t DrawChar_1;
extern uint8_t DrawChar_2;
extern uint8_t DrawChar_3;
extern uint8_t DrawChar_4;
extern uint8_t ClearScreen_1;
extern uint16_t ClearScreen_2 __address(ClearScreen_1 + 1);
extern uint16_t ClearScreen_3 __address(ClearScreen_1 + 2);
extern uint8_t ClearScreen_4 __address(ClearScreenPoly3 + 1);
extern uint16_t ClearScreenSetSp;
extern uint16_t ClearScreenSp __address(ClearScreenSetSp + 1);
extern uint16_t DrawChar_And1;
extern uint16_t DrawChar_And2;
extern uint16_t DrawChar_And3;
extern uint16_t DrawChar_And4;
extern uint16_t DrawChar_And5;
extern uint16_t DrawChar_And6;
extern uint16_t DrawChar_And7;
extern uint16_t DrawChar_And8;
extern uint16_t DrawChar_And9;
extern uint16_t DrawChar_And10;
extern uint16_t DrawChar_And11;
extern uint16_t DrawChar_And12;
extern uint16_t DrawChar_Xor1;
extern uint16_t DrawChar_Xor2;
extern uint16_t DrawChar_Xor3;
extern uint16_t DrawChar_Xor4;
extern uint16_t DrawChar_Xor5;
extern uint16_t DrawChar_Xor6;
extern uint16_t DrawChar_Xor7;
extern uint16_t DrawChar_Xor8;
extern uint16_t DrawChar_Xor9;
extern uint16_t DrawChar_Xor10;
extern uint16_t DrawChar_Xor11;
extern uint16_t DrawChar_Xor12;
extern uint16_t ScrollUpAddr __address(ScrollUp + 1);
extern uint16_t ScrollUpSp __address(ScrollUpSpInstr + 1);
extern uint16_t ScrollUpSp2 __address(ScrollUpSpInstr2 + 1);
extern uint16_t ScrollUpBwSp __address(ScrollUpBwSpInstr + 1);
extern uint16_t ScrollUp_1 __address(ScrollUpSub + 1);
extern uint8_t ScrollUp_2 __address(ScrollUp_2);
extern uint8_t ScrollUp_3 __address(ScrollUp_2 + 1);
extern uint8_t ScrollUpSpInstr2 __address(ScrollUpSpInstr2);

void DrawChar(...) {
    return DrawChar6();
}

void SetColor(...) {
    return SetColor6();
}

void DrawCursor(...) {
    return DrawCursor6();
}

void SetColorSave(...) {
    push_pop(bc, de, hl)
        SetColor(a);
}

void ClearScreen() {
    ClearScreenSp = ((hl = 0) += sp);
    de = 0; // TODO: Залить текущим цветом фона
    c = 48;
    hl = 0;
    do {
        b = 16;
        DisableInterrupts();
        sp = hl;
        do {
            push(de, de, de, de, de, de, de, de);
        } while(flag_nz(b--));
        a = h;
ClearScreen_1:
        a -= 0x40; /* Заменяется: goto ClearScreenSetSp; */
        h = a;
        b = 16;
        sp = hl;
        do {
            push(de, de, de, de, de, de, de, de);
        } while(flag_nz(b--));
ClearScreenSetSp:
        sp = 0;
        EnableInterrupts();
ClearScreenPoly3:
        a += 0x3F; /* Заменяется: a += 0xFF; */
        h = a;
    } while(flag_nz(c--));
}

const int SCROLL_COLUMN_UP = 0x100;
const int BITPLANE_OFFSET = 0x4000;
const int SCREEN_SIZE = 0x3000;

void ScrollUpSubBw() {
    /* Копирование одной строки символов */
    do {
        /* Копирование одного знакоместа */
        sp = hl;
        hl += de;
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl;      push(bc);
        hl = FONT_HEIGHT + 0x100;
        hl += sp;
    } while (flag_nz(a--));
    goto ScrollUpSpInstr;
}

void ScrollUpSubColor() {
    /* Копирование одной строки символов */
    do {
        /* Копирование одного знакоместа в первой плоскости */
        sp = hl;
        hl += de;
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl;      push(bc);
        hl = FONT_HEIGHT - BITPLANE_OFFSET;
        hl += sp;

        /* Копирование одного знакоместа во второй плоскости */
        sp = hl;
        hl += de;
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl; l--; push(bc);
        b = *hl; l--; c = *hl;      push(bc);
        hl = FONT_HEIGHT + BITPLANE_OFFSET + 0x100;
        hl += sp;
    } while (flag_nz(a--));
    goto ScrollUpSpInstr;
}

void ScrollUp() {
    /* Сохранение SP */
    (hl = 0) += sp;
    ScrollUpSp = hl;
    ScrollUpSp2 = hl;

    /* Оптимизация */
    de = -FONT_HEIGHT - 1;

    /* Вертикаль */
    hl = 0xD100; /* Первая запись будет в 0xD0FF */
    do {
        /* Копирование одной строки символов */
        DisableInterrupts();
        a = 0x30;
ScrollUpSub:
        return ScrollUpSubBw();
        /* Включение прерываний */
ScrollUpSpInstr:
        sp = 0;
        EnableInterrupts();

        /* Следующая строка */
        a = l;
        a -= FONT_HEIGHT;
        l = a;
        h = 0xD0;
    } while (a >= FONT_HEIGHT + 7);

    /* Очистка нижней строки */
    a = 48;
    de = 0; // TODO: Background
    DisableInterrupts();
    sp = (SCREEN_0_ADDRESS + SCREEN_SIZE) - ((TEXT_SCREEN_HEIGHT - 1) * FONT_HEIGHT);
    do {
        push(de, de, de, de, de);
        hl = -SCROLL_COLUMN_UP + FONT_HEIGHT;
        hl += sp;
        sp = hl;
    } while (flag_nz(a--));

    // Вторая плоскость
ScrollUp_2: /* Заменяется: jp ScrollUpSpInstr2 */
    a = 48;
    de = 0; // TODO: Background
    sp = (SCREEN_1_ADDRESS + SCREEN_SIZE) - ((TEXT_SCREEN_HEIGHT - 1) * FONT_HEIGHT);
    do {
        push(de, de, de, de, de);
        hl = -SCROLL_COLUMN_UP + FONT_HEIGHT;
        hl += sp;
        sp = hl;
    } while (flag_nz(a--));

    /* Включение прерываний */
ScrollUpSpInstr2:
    sp = 0;
    EnableInterrupts();
}

/* Draw text
 * Input:
 *   C  - Shift 0..3
 *   HL - Text address
 *   DE - Video address 0xD000..0xFFFF
 * Output:
 *   C  - Next shift 0..3
 *   DE - Next video address 0xD000..0xFFFF
 *   HL - End of text address
 */

void DrawText(...) {
    for (;;) {
        a = *hl;
        hl++;
        if (flag_z(a |= a))
            return;
        push_pop(hl, de) {
            swap(hl, de);
            DrawChar();
        }
        d++;
    }
}

/* Draw char
 * Input:
 *   A  - Char
 *   DE - Coodrs
 */

void DrawChar6(...) {
    b = a;

    a = l;
    a *= 4;
    a += l;
    a += a;
    invert(a);
    e = a;

    a = h;
    a += a;
    a += h;
    c = a;
    CarryRotateRight(a);
    CarryRotateRight(a);
    a &= 0x3F;
    invert(a);
    d = a;

    /* Calc chargen address */
    a = b;
    SET_HL_A_PLUS_CONST(&font);

    /* Select function */
    a = c;
    a &= 3;
    if (flag_z)
        return DrawChar60();
    a--;
    if (flag_z)
        return DrawChar62();
    a--;
    if (flag_z)
        return DrawChar64();
    return DrawChar66();
}

/* Draw char ......XX XXXX....
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar66() {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        CyclicRotateRight(a, 4);
        push_pop(a) {
            a &= 0x03;
            b = a;
            a = *de;
DrawChar_And3:
            a &= 0xFC; /* Замена: a |= 0xFF ^ 0xFC; */
DrawChar_Xor3:
            a ^= b; /* Замена: nop(); */
            *de = a;
        }
        d--;
        a &= 0xF0;
        b = a;
        a = *de;
DrawChar_And5:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
DrawChar_Xor4:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
        h++;
        e--;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar_2:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        e++;
        h--;
        a = *hl;
        CyclicRotateRight(a, 4);
        push_pop(a) {
            a &= 0x03;
            b = a;
            a = *de;
DrawChar_And4:
            a &= 0xFC; /* Замена: a |= 0xFF ^ 0xFC; */
DrawChar_Xor5:
            a ^= b; /* Замена: nop(); */
            *de = a;
        }
        d--;
        a &= 0xF0;
        b = a;
        a = *de;
DrawChar_And6:
        a &= 0x0F; /* Замена: a |= 0xFF ^ 0x0F; */
DrawChar_Xor6:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
    } while(flag_nz(c--));
}

/* Draw char XXXXXX.. ........
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar60() {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        b = (a += a += a);
        a = *de;
DrawChar_And1:
        a &= 0x03; /* Замена: a |= 0xFF ^ 0x03; */
DrawChar_Xor1:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar_1:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        b = (a += a += a);
        a = *de;
DrawChar_And2:
        a &= 0x03; /* Замена: a |= 0xFF ^ 0x03; */
DrawChar_Xor2:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while(flag_nz(c--));
}

/* Draw char ..XXXXXX
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar62() {
    c = FONT_HEIGHT;
    do {
        b = *hl;
        a = *de;
DrawChar_And11:
        a &= 0xC0; /* Замена: a |= 0xFF ^ 0xC0; */
DrawChar_Xor11:
        a ^= b; /* Замена: nop(); */
        *de = a;
        e--;
        h++;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar_3:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    /* Bit plane 1 */
    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        b = *hl;
        a = *de;
DrawChar_And12:
        a &= 0xC0; /* Замена: a |= 0xFF ^ 0xC0; */
DrawChar_Xor12:
        a ^= b; /* Замена: nop(); */
        *de = a;
    } while(flag_nz(c--));
}

/* Draw char ....XXXX XX......
 * Input:
 *   HL - Chargen address
 *   DE - Video address 0x9000..0xBFFF
 */

void DrawChar64() {
    c = FONT_HEIGHT;
    do {
        a = *hl;
        CyclicRotateRight(a, 2);
        a &= 0x0F;
        b = a;
        a = *de;
DrawChar_And7:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
DrawChar_Xor7:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d--;
        a = *hl;
        CyclicRotateRight(a, 2);
        a &= 0xC0;
        b = a;
        a = *de;
DrawChar_And9:
        a &= 0x3F; /* Замена: a |= 0xFF ^ 0x3F; */
DrawChar_Xor8:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
        e--;
        h++;
    } while(flag_nz(c--));

    /* Следующая плоскость */
DrawChar_4:
    a = d; /* Замена: return */
    a -= 0x40;
    d = a;

    c = FONT_HEIGHT;
    do {
        h--;
        e++;
        a = *hl;
        CyclicRotateRight(a, 2);
        a &= 0x0F;
        b = a;
        a = *de;
DrawChar_And8:
        a &= 0xF0; /* Замена: a |= 0xFF ^ 0xF0; */
DrawChar_Xor9:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d--;
        a = *hl;
        CyclicRotateRight(a, 2);
        a &= 0xC0;
        b = a;
        a = *de;
DrawChar_And10:
        a &= 0x3F; /* Замена: a |= 0xFF ^ 0x3F; */
DrawChar_Xor10:
        a ^= b; /* Замена: nop(); */
        *de = a;
        d++;
    } while(flag_nz(c--));
}

void SetColor6(...) {
    /* TODO: Заменить на ^= 0x10, ^= 0xFF, ^= 0xA8 */
    c = a;
    if (flag_z(a &= 8)) {
        hl = OPCODE_AND_CONST | (0x03 << 8);
        DrawChar_And1 = hl;
        DrawChar_And2 = hl;
        h = 0xFC;
        DrawChar_And3 = hl;
        h = 0x0F;
        DrawChar_And5 = hl;
        h = 0xF0;
        DrawChar_And7 = hl;
        h = 0x3F;
        DrawChar_And9 = hl;
        h = 0xC0;
        DrawChar_And11 = hl;
    } else {
        hl = OPCODE_OR_CONST | ((0xFF ^ 0x03) << 8);
        DrawChar_And1 = hl;
        DrawChar_And2 = hl;
        h = 0xFF ^ 0xFC;
        DrawChar_And3 = hl;
        h = 0xFF ^ 0x0F;
        DrawChar_And5 = hl;
        h = 0xFF ^ 0xF0;
        DrawChar_And7 = hl;
        h = 0xFF ^ 0x3F;
        DrawChar_And9 = hl;
        h = 0xFF ^ 0xC0;
        DrawChar_And11 = hl;
    }
    b = a;
    a = c;
    a *= 4;
    a &= 8;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    DrawChar_Xor1 = a;
    DrawChar_Xor3 = a;
    DrawChar_Xor4 = a;
    DrawChar_Xor7 = a;
    DrawChar_Xor8 = a;
    DrawChar_Xor11 = a;

    a = c;
    if (flag_z(a &= 4)) {
        hl = OPCODE_AND_CONST | (0x03 << 8);
        DrawChar_And2 = hl;
        h = 0xFC;
        DrawChar_And4 = hl;
        h = 0x0F;
        DrawChar_And6 = hl;
        h = 0xF0;
        DrawChar_And8 = hl;
        h = 0x3F;
        DrawChar_And10 = hl;
        h = 0xC0;
        DrawChar_And12 = hl;
    } else {
        hl = OPCODE_OR_CONST | ((0xFF ^ 3) << 8);
        DrawChar_And2 = hl;
        h = 0xFF ^ 0xFC;
        DrawChar_And4 = hl;
        h = 0xFF ^ 0x0F;
        DrawChar_And6 = hl;
        h = 0xFF ^ 0xF0;
        DrawChar_And8 = hl;
        h = 0xFF ^ 0x3F;
        DrawChar_And10 = hl;
        h = 0xFF ^ 0xC0;
        DrawChar_And12 = hl;
    }
    b = a;
    a = c;
    a *= 4;
    a &= 4;
    a ^= b;
    a = OPCODE_XOR_B;
    if (flag_z)
        a = OPCODE_NOP;
    DrawChar_Xor2 = a;
    DrawChar_Xor5 = a;
    DrawChar_Xor6 = a;
    DrawChar_Xor9 = a;
    DrawChar_Xor10 = a;
    DrawChar_Xor12 = a;
}

void DrawCursor6() {
    /* Маска */
    a = h;
    a &= 3;
    if (flag_z)
        de = 0x00FC;
    else if (flag_z(a--))
        de = 0xF003;
    else if (flag_z(a--))
        de = 0xC00F;
    else
        de = 0x003F;

    /* Координаты в адрес */
    a = l;
    a *= 4;
    a += l;
    a *= 2;
    Invert(a);
    l = a;
    a = h;
    a += a;
    a += h;
    CyclicRotateRight(a, 2);
    a &= 0x3F;
    Invert(a);
    h = a;

    /* Рисуем */
    c = FONT_HEIGHT;
    do {
        *hl = ((a = *hl) ^= e);
        h--;
        *hl = ((a = *hl) ^= d);
        h++;
        l--;
    } while(flag_nz(c--));
}

void SetScreenBw6() {
    text_screen_width = a = 64;
    DrawCharAddress = hl = &DrawChar6;
    SetColorAddress = hl = &SetColor6;
    DrawChar_1 = a = OPCODE_RET;
    DrawChar_2 = a;
    DrawChar_3 = a;
    DrawChar_4 = a;
    return SetScreenBw();
}

void SetScreenBw() {
    out(PORT_VIDEO_MODE_0_LOW, a);
    out(PORT_VIDEO_MODE_1_HIGH, a);

    ClearScreen_1 = a = OPCODE_JP;
    ClearScreen_2 = hl = &ClearScreenSetSp;
    ClearScreen_4 = a = 0xFF;
    ScrollUp_1 = hl = &ScrollUpSubBw;
    ScrollUp_2 = a = OPCODE_JP;
    ScrollUp_3 = hl = &ScrollUpSpInstr2;
}

void SetScreenColor6() {
    text_screen_width = a = 64;
    DrawCharAddress = hl = &DrawChar6;
    SetColorAddress = hl = &SetColor6;
    DrawChar_1 = a = OPCODE_LD_A_D;
    DrawChar_2 = a;
    DrawChar_3 = a;
    DrawChar_4 = a;
    return SetScreenColor();
}

void SetScreenColor() {
    out(PORT_VIDEO_MODE_0_HIGH, a);
    out(PORT_VIDEO_MODE_1_LOW, a);

    ClearScreen_1 = hl = OPCODE_SUB_CONST | (0x40 << 8);
    ClearScreen_3 = a = OPCODE_LD_H_A;
    ClearScreen_4 = a = 0x3F;
    ScrollUp_1 = hl = &ScrollUpSubColor;
    ScrollUp_2 = a = OPCODE_LD_A_CONST;
    ScrollUp_3 = hl = 0x30 | (OPCODE_LD_DE_CONST << 8);
}

asm("font: incbin \"font.bin\"");
