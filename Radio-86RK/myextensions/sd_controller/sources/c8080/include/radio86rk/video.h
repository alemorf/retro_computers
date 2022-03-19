// Адрес левого-верхнего видимого символа. Расчитывается функцией radio86rkInitVideo 

extern uchar* radio86rkVideoMem @ "radio86rk/radio8screenvars.c";

// Количество байт в строке. По умолчанию 78. Это значение может быть от 2 до 94. 

// Строка изображения всегда состоит из 78 символов. Из них только 64 видимы.
// 8 первых и 6 последний байт находится за краем экрана. 

// Вместо 6 последних нулей можно указать одно значнеие EOL (0xF1), которое 
// понимается видеоконтроллером как конец строки. Его использование позволяет
// сократить длину строки на 7 байт.

// Скрытые аттрибуты (байты определяющие цвет и мерцание) не выводятся на экран и
// увеличивают длину строки в байтах. Что бы длина строки была постоянна, 
// удобно использовать EOL. Но при длине строки 78 байт получается всего 
// 6 цветов на линию.

// Или размещать в строке постоянное кол-во атрибутов. Для 16 атрибутов длина строки
// будет 94 байта. Причем, 16 аттрибутов (включая EOL) на строку это максимум 
// контроллера.

// Если мы используем EOL, то остается всего 15 цветов. Но длина строки 
// получается 8+64+15 = 87 байт

extern uchar radio86rkVideoBpl @ "radio86rk/radio8screenvars.c";

// Установка видеорежима

void radio86rkScreen0 () @ "radio86rk/radio8screen0.c";  // 64x25, атрибут это пробел,  BPL@78, без EOL, с межстрочным отступом, без экономии, совместим с монитором
void radio86rkScreen0b() @ "radio86rk/radio8screen0b.c"; // 64x25, 0-5 скрытых атрибут, BPL@78, EOL, с межстрочным отступом, без экономии, совместим с монитором	
void radio86rkScreen1 () @ "radio86rk/radio8screen1.c";  // 64x25, атрибут это пробел,  BPL@78, без EOL, совместим с монитором, без экономии
void radio86rkScreen1b() @ "radio86rk/radio8screen1b.c"; // 64x25, 0-5 скрытых атрибут, BPL@78, EOL, совместим с монитором, без экономии
void radio86rkScreen2a() @ "radio86rk/radio8screen2a.c"; // 64x30, атрибут это пробел,  BPL@75, EOL
void radio86rkScreen2b() @ "radio86rk/radio8screen2b.c"; // 64x30, 0-5 скрытых атрибут, BPL@78, EOL, использует основное ОЗУ
void radio86rkScreen2c() @ "radio86rk/radio8screen2c.c"; // 64x30, 16  скрытых атрибут, BPL@94, без EOL, использует основное ОЗУ

// функции вывода текста на экран

void print(uchar x, uchar y, char* text)              @ "radio86rk/print.c";
void print2(uchar* a, char* text)                     @ "radio86rk/print2.c";
void printn(uchar x, uchar y, uchar len, char* text)  @ "radio86rk/printn.c";
void print2n(uchar* a, uchar len, char* text)         @ "radio86rk/print2n.c";
void printm(uchar x, uchar y, uchar len, char* text)  @ "radio86rk/printm.c";
void print2m(uchar* a, uchar len, char* text)         @ "radio86rk/print2m.c";
void printcn(uchar x, uchar y, uchar len, char c)     @ "radio86rk/printcn.c";
void print2cn(uchar* a, uchar len, char c)            @ "radio86rk/print2cn.c";
uchar* charAddr(uchar x, uchar y)                     @ "radio86rk/charAddr.c";
void directCursor(uchar x, uchar y)                   @ "radio86rk/directCursor.c";

// Ожидание КСИ

void waitHorzSync()                                  @ "radio86rk/waithorzsync.c";
