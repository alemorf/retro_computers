#include "bios.h"
#include "graph.h"
#include "graph4.h"
#include "console.h"
#include "storage.h"
#include "keyboard.h"

const int cpm_load_address = 0xE500;
void CpmEntryPoint() __address(0xFB33);

extern uint16_t cpm_start;
extern uint16_t cpm_stop;

void menu() {
    ClearScreen();
    DrawText(c = 0, de = 0, hl = "Выберите разрешение экрана");
    SetColor(a = 1);
    DrawText(c = 0, de = 0x2, hl = "1. 64x25 2 цвета");
    DrawText(c = 0, de = 0x3, hl = "2. 64x25 4 цвета");
    DrawText(c = 0, de = 0x4, hl = "3. 96x25 2 цвета");
    DrawText(c = 0, de = 0x5, hl = "4. 96x25 4 цвета");

    for(;;) {
        do {
            ReadKeyboard();
        } while(flag_z);
        if (a == '1')
            return SetScreenBw6();
        if (a == '2')
            return SetScreenColor6();
        if (a == '3')
            return SetScreenBw4();
        if (a == '4')
            return SetScreenColor4();
    }

}

void main() {
    /* Настройка адресного пространства */
    out(PORT_WINDOW(0), a = PAGE_RAM(0));
    out(PORT_WINDOW(1), a = PAGE_RAM(1));
    out(PORT_WINDOW(2), a = PAGE_STD);
    out(PORT_WINDOW(3), a = PAGE_STD);

    /* Настройка стека */
    sp = &stack;

    /* Очистка экрана и запуск прерываний */
    SetScreenColor6();
    SetColor(a = 3);
    ConReset();

    /* Настройка палитры */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a = PALETTE_YELLOW);
    out(PORT_PALETTE(2), a = PALETTE_WHITE);
    out(PORT_PALETTE(3), a = PALETTE_CYAN);

    menu();

    SetColor(a = 3);
    ClearScreen();
    DrawText(c = 0, de = 0, hl = "Искра 1080М");
    SetColor(a = 1);
    cursor_visible = a = 1;
    return CpmWBoot();
}

void CpmWBoot() {
    /* Копирование CP/M */
    out(PORT_WINDOW(3), a = PAGE_RAM(7));
    de = cpm_load_address;
    hl = &cpm_start;
    do {
        *de = a = *hl;
        hl++;
        de++;
    } while (flag_nz((a = d) |= a));

    /* Запуск CP/M */
    c = a = drive_number;
    return CpmEntryPoint();
}

asm("cpm_start: incbin \"cpm22/cpm22.bin\"");
asm("cpm_stop: db 0");
