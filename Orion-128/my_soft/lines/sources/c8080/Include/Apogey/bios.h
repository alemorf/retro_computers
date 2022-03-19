// Коды клавиш

#define KEY_LEFT  8
#define KEY_TAB   9
#define KEY_RIGHT 0x18
#define KEY_UP    0x19
#define KEY_DOWN  0x1A
#define KEY_SPACE 0x20

// BIOS компьютера РК86

char reboot()                                  @ 0xF800;                           // F800 Перезагрузка
char getch()                                   @ 0xF803;                           // F803 Ввод символа с клавиатуры с ожиданием
char getTape(char syncFlag)                    @ 0xF806;                           // F806 Чтение байта с магнитофона (FF - с поиском синхробайта, 08 - без поиска синхробайта)
void putch(char c)                             @ "apogey/putch.c";                 // F809 Вывод символа на экран
void putTape(char c)                           @ "apogey/puttape.c";               // F80C Запись байта на магнитофон
char kbhit()                                   @ "apogey/kbhit.c";                 // F812 Опрос состояния клавиатуры (FF - ни одна клавиша не нажата)
void puthex(char)                              @ 0xF815;                           // F815 Вывод на экран 16-ричного числа
void puts(const char*)                         @ 0xF818;                           // F818 Вывод на экран текстовой строки
char bioskey()                                 @ 0xF81B;                           // F81B Опрос состояния клавиатуры 2 (FF - ни одна клавиша не нажата, FE - нажата клавиша РУС/ЛАТ, иначе A - код клавиши)
int  wherexy()                                 @ 0xF81E;                           // F81E Запрос положения курсора(Н - номер строк, L - номер позиции)
char getCharFromCursor()                       @ "apogey/getcharfromcursor.c";     // F821 Запрос символа под курсором
void loadTape(void* start)                     @ "apogey/loadtape.c";              // F824 Чтение блока с магнитофона (НЕ ВСЕ АРГУМЕНТЫ ВОЗВРАЩАЮТСЯ)
void saveTape(void* start, void* end, int crc) @ "apogey/savetape.c";              // F827 Вывод блока на магнитофон
int  crcTape(void* start, void* end)           @ "apogey/crctape.c";               // F82A Подсчет контрольной суммы блока
void initVideo()                               @ "apogey/initvideo.c";             // F82D Инициализация видеоконтроллера
int  getMemTop()                               @ 0xF830;                           // F830 Запрос верхней границы доступной памяти
void setMemTop(int)                            @ 0xF833;                           // F833 Установка верхней границы доступной памяти

// Расширение BIOS компьютера Апогей БК01

void putTapeMSX(char c)                        @ "apogey/puttapemsx.c";            // F003 Запись байта в формате MSX на магнитофон
int  getTapeMSX()                              @ "apogey/gettapemsx.c";            // F006 Чтение байта в формате MSX с магнитофона (если была ошибка, то H@1)
void saveTapeMSX(void* start, void* end)       @ "apogey/savetapemsx.c";           // F009 Запись блока в формате MSX на магнитофон
char loadTapeMSX(void* start, void* end)       @ "apogey/loadtapemsx.c";           // F00С Чтение блока в формате MSX с магнитофона (если была ошибока, то результат не ноль)
void putTapeLongMarkerMSX()                    @ "apogey/puttapelongmarkermsx.c";  // F00F Запись длинного маркера MSX
void putTapeShortMarkerMSX()                   @ "apogey/puttapeshortmarkermsx.c"; // F012 Запись коротного маркера MSX
void getTapeLongMarkerMSX()                    @ "apogey/gettapelongmarkermsx.c";  // F015 Чтение длинного маркера MSX

// Эмуляция стандартной библиотеки Си

char wherex()                                  @ "apogey/wherex.c";             // F81E Положение курсора по оси X @ (char)wherexy()
char wherey()                                  @ "apogey/wherey.c";             // F81E Положение курсора по оси Y @ (char)(wherexy()>>8)
void gotoxy(char,char)                         @ "apogey/gotoxy.c";             // F809 Переместить курсор в коодринаты @ putch(0x1B, 'Y', y+0x20, x+0x20)
void clrscr()                                  @ "apogey/clrscr.c";             // F809 Очистить экран = putch(0x1F)
