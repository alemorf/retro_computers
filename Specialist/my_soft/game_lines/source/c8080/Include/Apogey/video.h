// Адрес левого-верхнего видимого символа. Расчитывается функцией ApogeyInitVideo 

extern uchar* apogeyVideoMem @ "apogey/apogeyscreenvars.c";

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

extern uchar apogeyVideoBpl @ "apogey/apogeyscreenvars.c";

// Установка видеорежима

void apogeyScreen0 () @ "apogey/apogeyscreen0.c";  // 64x25, атрибут это пробел,  BPL@78, без EOL, с межстрочным отступом, без экономии, совместим с монитором
void apogeyScreen0b() @ "apogey/apogeyscreen0b.c"; // 64x25, 0-5 скрытых атрибут, BPL@78, EOL, с межстрочным отступом, без экономии, совместим с монитором	
void apogeyScreen1 () @ "apogey/apogeyscreen1.c";  // 64x25, атрибут это пробел,  BPL@78, без EOL, совместим с монитором, без экономии
void apogeyScreen1b() @ "apogey/apogeyscreen1b.c"; // 64x25, 0-5 скрытых атрибут, BPL@78, EOL, совместим с монитором, без экономии
void apogeyScreen2a() @ "apogey/apogeyscreen2a.c"; // 64x30, атрибут это пробел,  BPL@75, EOL
void apogeyScreen2b() @ "apogey/apogeyscreen2b.c"; // 64x30, 0-5 скрытых атрибут, BPL@78, EOL, использует основное ОЗУ
void apogeyScreen2c() @ "apogey/apogeyscreen2c.c"; // 64x30, 16  скрытых атрибут, BPL@94, без EOL, использует основное ОЗУ
void apogeyScreen3a() @ "apogey/apogeyscreen3a.c"; // 64x51, атрибут это пробел,  BPL@75, EOL, использует основное ОЗУ
void apogeyScreen3b() @ "apogey/apogeyscreen3b.c"; // 64x51, 1-5 скрытых атрибут, BPL@78, EOL, использует основное ОЗУ
void apogeyScreen3c() @ "apogey/apogeyscreen3c.c"; // 64x51, 16  скрытых атрибут, BPL@94, без EOL, использует основное ОЗУ

// функции вывода текста на экран

void print(uchar x, uchar y, char* text)             @ "apogey/print.c";
void printn(uchar x, uchar y, char* text, uchar len) @ "apogey/printn.c";
void printcn(uchar x, uchar y, char c, uchar len)    @ "apogey/printcn.c";

// Ожидание КСИ

void waitHorzSync()                                  @ "apogey/waithorzsync.c";
