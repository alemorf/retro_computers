    ; 2 // (c) Морозов Алексей
    ; 3 // Главное меню.
    ; 5 const KEY_UP   = 1;
    ; 6 const KEY_DOWN = 2;
    ; 7 const KEY_FIRE = 4;
    ; 9 const menuItemH      = 10;
    ; 10 const menuItemsY     = 100;
    ; 11 const menuItemsX     = 60;
    ; 12 const menuItemsSX    = 50;
    ; 13 const menuItemsCount = 4;
    ; 14 const menuItemsM     = menuItemsCount * menuItemH;
    ; 16 uint8_t menuX = 0;
menuX db 0
    ; 17 uint8_t menuX1 = 0;
menuX1 db 0
    ; 19 uint16_t test;
test dw 0
    ; 21 void menuLoad()
menuLoad:
    ; 22 {
    ; 23 tickHandler = hl = &menuTick;
    ld   hl, menuTick
    ld   (tickHandler), hl
    ; 24 redrawHandler = hl = 0;
    ld   hl, 0
    ld   (redrawHandler), hl
    ; 26 screenClear(a = 0x45);
    ld   a, 69
    call screenClear
    ; 28 // canvas2d.drawImage(logoImage,0,0,logoImage.width,logoImage.height, 8,16,logoImage.width,logoImage.height);
    ; 29 // drawText(menuItemsZ, menuItemsX + menuItemH * 0, 0x78, "Начать новую игру");
    ; 30 // drawText(menuItemsZ, menuItemsX + menuItemH * 1, 0x78, "Настроить управление");
    ; 31 // drawText(menuItemsZ, menuItemsX + menuItemH * 2, 0x78, "Ввести пароль");
    ; 33 drawText(hl = 0, de = "Игра | 2019 Алексей {Alemorf} Морозов");
    ld   hl, 0
    ld   de, s0
    call drawText
    ; 34 drawText(hl = 0, de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    ld   hl, 0
    ld   de, s1
    call drawText
    ; 35 drawText(hl = 0, de = "Елена {Мириам} Ханпира");
    ld   hl, 0
    ld   de, s2
    call drawText
    ; 37 menuX = a ^= a;
    xor  a
    ld   (menuX), a
    ; 38 menuX1 = (++a);
    inc  a
    ld   (menuX1), a
    ; 39 return;
    ret
    ; 40 }
    ; 42 void menuTick()
menuTick:
    ; 43 {
    ; 44 // Получить нажатую клавишу
    ; 45 hl = &keyTrigger;
    ld   hl, keyTrigger
    ; 46 b = *hl;
    ld   b, (hl)
    ; 47 *hl = 0;
    ld   (hl), 0
    ; 49 // Нажат выстрел
    ; 50 a = menuX;
    ld   a, (menuX)
    ; 51 if (b & KEY_FIRE)
    bit  2, b
    ; 52 {
    jp   nz, l0
    ; 53 if (a == [0 * menuItemH]) return newGame();
    cmp  0
    jp   z, newGame
    ; 54 if (a == [1 * menuItemH]) return setupControls();
    cmp  10
    jp   z, setupControls
    ; 55 if (a == [2 * menuItemH]) return loadGame();
    cmp  20
    jp   z, loadGame
    ; 56 return saveGame();
    jp   saveGame
    ; 57 }
    ; 59 // Перемещение курсора
    ; 60 if (b & KEY_UP)
l0:
    bit  0, b
    ; 61 {
    jp   nz, l1
    ; 62 a -= menuItemH;
    sub  10
    ; 63 if (flag_c) return;
    ret  c
    ; 64 }
    ; 65 else if (b & KEY_DOWN)
    jp   l2
l1:
    bit  1, b
    ; 66 {
    jp   nz, l3
    ; 67 a += menuItemH;
    add  10
    ; 68 if (a >= menuItemsM) return;
    cmp  40
    ret  nc
    ; 69 }
    ; 70 menuX = a;
l3:
l2:
    ld   (menuX), a
    ; 72 // Плавное перемещение курсора
    ; 73 hl = &menuX1;
    ld   hl, menuX1
    ; 74 b = *hl;
    ld   b, (hl)
    ; 75 if (a != b) // Оставит флаг CF при выполнении menuX1 - menuX
    cmp  b
    ; 76 {
    jp   z, l4
    ; 77 b++; // Не изменяет CF
    inc  b
    ; 78 if (flag_c) ----b;
    jp   nc, l5
    dec  b
    dec  b
    ; 79 *hl = b;
l5:
    ld   (hl), b
    ; 80 drawText(h = ((a = b) += menuItemsY), l = menuItemsSX, de = "@");
    ld   a, b
    add  100
    ld   h, a
    ld   l, 50
    ld   de, s3
    call drawText
    ; 81 }
    ; 82 }
l5:
    ; strings
s"@" db  3
s"Елена {Мириам} Ханпира" db  2
s"Игра | 2019 Алексей {Alemorf} Морозов" db  0
s"Мюзикл | 1998 Антон {Саруман} Круглов," db  1
