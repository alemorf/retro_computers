// BIOS компьютера РК86

char reboot()                                  @ 0xC000;                           // C000 Перезагрузка
char getch()                                   @ 0xC803;                           // C003 Ввод символа с клавиатуры с ожиданием
char getTape(char syncFlag)                    @ 0xC806;                           // C806 Чтение байта с магнитофона (FF - с поиском синхробайта, 08 - без поиска синхробайта)
void putch(char c)                             @ "spec/putch.c";                   // C809 Вывод символа на экран
void putTape(char c)                           @ "spec/puttape.c";                 // C80C Запись байта на магнитофон
// C80F ввод строки символов с клавиатуры
char kbhit()                                   @ 0xC812;                           // C812 Опрос состояния клавиатуры (FF - ни одна клавиша не нажата)
void puthex(char)                              @ 0xC815;                           // C815 Вывод на экран 16-ричного числа
void puts(const char*)                         @ 0xC818;                           // C818 Вывод на экран текстовой строки
int  wherexy()                                 @ 0xC81E;                           // C81E Запрос положения курсора(Н - номер строк, L - номер позиции)

void loadTape(void* start)                     @ "spec/loadtape.c";                // C824 Чтение блока с магнитофона (НЕ ВСЕ АРГУМЕНТЫ ВОЗВРАЩАЮТСЯ)
void saveTape(void* start, void* end, int crc) @ "spec/savetape.c";                // C827 Вывод блока на магнитофон
int  crcTape(void* start, void* end)           @ "spec/crctape.c";                 // C82A Подсчет контрольной суммы блока
int  getMemTop()                               @ 0xC830;                           // F830 Запрос верхней границы доступной памяти
void setMemTop(int)                            @ 0xC833;                           // F833 Установка верхней границы доступной памяти

// Эмуляция стандартной библиотеки Си

char wherex()                                  @ "spec/wherex.c";                  // C81E Положение курсора по оси X @ (char)wherexy()
char wherey()                                  @ "spec/wherey.c";                  // C81E Положение курсора по оси Y @ (char)(wherexy()>>8)
void gotoxy(char,char)                         @ "spec/gotoxy.c";                  // C809 Переместить курсор в коодринаты @ putch(0x1B, 'Y', y+0x20, x+0x20)
void clrscr()                                  @ "spec/clrscr.c";                  // C809 Очистить экран = putch(0x1F)
