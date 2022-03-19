// Коды клавиш

#define KEY_F1    0
#define KEY_F2    1
#define KEY_F3    2
#define KEY_F4    3
#define KEY_F5    4
#define KEY_LEFT  0x08
#define KEY_TAB   0x09
#define KEY_RIGHT 0x18
#define KEY_UP    0x19
#define KEY_DOWN  0x1A
#define KEY_SPACE 0x20
#define KEY_ENTER 0x0D
#define KEY_BKSPC 0x7F

// BIOS компьютера РК86

char reboot()                                  @ 0xF800;                          // F800 Перезагрузка
char getch()                                   @ 0xF803;                          // F803 Ввод символа с клавиатуры с ожиданием
char getTape(char syncFlag)                    @ 0xF806;                          // F806 Чтение байта с магнитофона (FF - с поиском синхробайта, 08 - без поиска синхробайта)
void putch(char c)                             @ "orion/putch.c";                 // F809 Вывод символа на экран
void putTape(char c)                           @ "orion/puttape.c";               // F80C Запись байта на магнитофон
char kbhit()                                   @ "orion/kbhit.c";                 // F812 Опрос состояния клавиатуры (FF - ни одна клавиша не нажата)
void puthex(char)                              @ 0xF815;                          // F815 Вывод на экран 16-ричного числа
void puts(const char*)                         @ 0xF818;                          // F818 Вывод на экран текстовой строки
char bioskey()                                 @ 0xF81B;                          // F81B Опрос состояния клавиатуры 2 (FF - ни одна клавиша не нажата, FE - нажата клавиша РУС/ЛАТ, иначе A - код клавиши)
int  wherexy()                                 @ 0xF81E;                          // F81E Запрос положения курсора(Н - номер строк, L - номер позиции)
// F821 не реализовано
void loadTape(void* start)                     @ "orion/loadtape.c";              // F824 Чтение блока с магнитофона (НЕ ВСЕ АРГУМЕНТЫ ВОЗВРАЩАЮТСЯ)
void saveTape(void* start, void* end, int crc) @ "orion/savetape.c";              // F827 Вывод блока на магнитофон
int  crcTape(void* start, void* end)           @ "orion/crctape.c";               // F82A Подсчет контрольной суммы блока
void initVideo()                               @ "orion/initvideo.c";             // F82D Инициализация знакогенератора
int  getMemTop()                               @ 0xF830;                          // F830 Запрос верхней границы доступной памяти
void setMemTop(int)                            @ 0xF833;                          // F833 Установка верхней границы доступной памяти

char getExtMem(int, char)                      @ "orion/getextmem.c";             // F836 Чтение байта из расширенной памяти
void setExtMem(int, char, char)                @ "orion/setextmem.c";             // F839 Запись байта в расширенную память
void gotoxy(char, char)                        @ "orion/gotoxy.c";                // F83C Устанлвка положения курсора

// Эмуляция стандартной библиотеки Си

char wherex()                                  @ "orion/wherex.c";             // F81E Положение курсора по оси X @ (char)wherexy()
char wherey()                                  @ "orion/wherey.c";             // F81E Положение курсора по оси Y @ (char)(wherexy()>>8)
void clrscr()                                  @ "orion/clrscr.c";             // F809 Очистить экран = putch(0x1F)

// Порты

#define SCREEN_MODE (*(char*)0xF800)