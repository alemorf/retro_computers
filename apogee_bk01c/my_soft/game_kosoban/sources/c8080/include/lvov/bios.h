// BIOS компьютера Львов ПК01

char getch()                                                   @ 0xF803;                // F803 Ввод символа с клавиатуры с отработкой специальных функций
char getch2()                                                  @ 0xF806;                // F806 Ввод символа без отработки специальных функций
char kbhit()                                                   @ 0xF812;                // F812 Статус клавиатуры (FF=нажата, 0=не нажата)
void putch(char c)                                             @ "lvov/putch.c";        // F809 Вывод символа на экран
void putchPrinter(char c)                                      @ "lvov/putchprinter.c"; // F80C Вывод символа на принтер
void putchAll(char c)                                          @ "lvov/putchall.c";     // F80F Вывод символа на экран и/или принтер
void puts(const char*)                                         @ 0xE4A4;                // E4A4 Вывод на экран текстового сообщения
void putHexByte(uchar)                                         @ 0xFFD6;                // FFD6 Вывод на экран содержимого регистра A в шестнадцатеричном виде
void putHexWord(uint)                                          @ 0xFFD1;                // FFD1 Вывод на экран содержимого регистровой пары HL в шестнадцатеричном виде
void putCrc(void* start, void* end)                            @ "lvov/putcrc.c";       // F815 Вывод на экран контрольной суммы блока
void locate(uchar x, uchar y, uchar cursor)                    @ "lvov/locate.c";       // F82D Позиционирование курсора (cursor=0 показать курсор, cursor=FF скрыть курсор)
void clrscr()                                                  @ 0xF836;                // F836 Очистка экрана
void pset(uchar x, uchar y, uchar c)                           @ "lvov/pset.c";         // F821 Вывод на экран точки
void preset(uchar x, uchar y)                                  @ "lvov/preset.c";       // F020 Стирание точки
void line(uchar x0, uchar y0, uchar x1, uchar y1, uchar c)     @ "lvov/line.c";         // F824 Вывод на экран линии
void rect(uchar x0, uchar y0, uchar x1, uchar y1, uchar c)     @ "lvov/rect.c";         // F827 Вывод на экран прямоугольника
void fillRect(uchar x0, uchar y0, uchar x1, uchar y1, uchar c) @ "lvov/fillrect.c";     // F82A Вывод закрашенного прямоугольника
void paint(uchar x, uchar y, uchar c, uchar borderColor)       @ "lvov/paint.c";        // F830 Закраска замкнутой фигуры
void color(uchar palette, uchar bgcolor)                       @ "lvov/color.c";        // F833 Установка цветовой палитры (palette=0-6, bgcolor=0-7)
void copy()                                                    @ 0xE627;                // E627 Копирование экрана на принтере
void beep()                                                    @ 0xF81B;                // F81B Короткий звуковой сигнал ( BEEP ).
void sound(uchar note, uchar delay)                            @ "lvov/sound.c";        // F81E Управляемый звуковой сигнал ( SOUND ).
uint vaddr(uchar x, uchar y)                                   @ "lvov/vaddr.c";        // F818 Вычисление экранного адреса по координатам ( VADDR ).

// Функции записи и чтения с магнитофона не описаны

// E2BE Передача бита "0"
// E2C5 Передача бита "1"
// E2D5 Передача периода меандра.
// E42B WR_PILOT Передача пилот-сигнала
// E437 WR_BYTE Передача байта
// DD86 WR_WORD Передача слова
// E3E4 WR_HEAD Передача заголовка файла
// DD31 BSAVE Передача кодового файла
// E4D0 Прием пилот-сигнала ( RD_PILOT )
// E4BE Прием байта ( RD_BYTE ).
// DDCA Прием слова ( RD_WORD ).
// E443 Прием заголовка файла ( RD_HEAD ).
// DDBC Прием блока ( RD_BLOCK ).
// DD94 Прием кодового файла ( BLOAD ).

// Переменные

#define KEYB_CODE     (*(uchar*)0xBE10) // код нажатой клавиши 
#define KEYB_STAT     (*(uchar*)0xBE14) // состояние клавиатуры
#define KEYB_MODE     (*(uchar*)0xBE1D) // режим клавиатуры
#define KEYB_BEEP     (*(uchar*)0xBE1E) // звук клавиатуры

#define TEXT_ADDR     (*(uchar*)0xBE30) // адрес вывода символа (только чтение)
#define TEXT_COL      (*(uchar*)0xBE32) // X позиция вывода текста (только чтение)
#define TEXT_ROW      (*(uchar*)0xBE33) // Y позиция вывода текста (только чтение)
#define TEXT_COLOR    (*(uchar*)0xBE36) // Цвет текста
#define BORDER_COLOR  (*(uchar*)0xBE38) // Байт заполнения рамки
#define SCROLL_LOCK   (*(uchar*)0xBE39) // Cкроллинг авт./ожид.
#define CURSOR_HIDDEN (*(uchar*)0xBE3C) // Курсор скрыт (только чтение)
#define PALETTE       (*(uchar*)0xBEC0) // Выбранная палитра (только чтение)
#define GROUND_COLOR  (*(uchar*)0xBEC1) // Цвет фона (только чтение)

#define PRN_SHIFT     (*(uchar*)0xBE40) // Принтер. Смещение букв кириллицы.
#define PRN_XOR       (*(uchar*)0xBE41) // Принтер. Инверсный вывод.
#define DISP_OUT      (*(uchar*)0xBE1B) // 0 если putchAll должна выводить на экран, иначе FFh
#define PRN_OUT       (*(uchar*)0xBEF3) // 80h если putchAll должна выводить на принтер, иначе 0

// Переменные  записи и чтения с магнитофона не описаны

// BE80/BE81 WR0PERIOD длит.периода сигн."0"  
// BE82/BE83 WR1PERIOD длит.периода сигн."1"  
// BE84      PILOT_DUR длительность пилота    
// BE85                - параметры чтения МЛ  
// BE86                L (опред. автоматич.)  
// BE87      FILE_TYPE идентификат.типа файла 
// BE88/BE89 BASFL_ORG начало BASIC-файла     
// BE8A/BE8B BASFL_END конец BASIC-файла      
// BE8C-BE91 SAVE_NAME имя файла запись/эталон
// BE92-BE97 LOAD_NAME считанное имя файла    
// BEA3      AUTOSTART признак автостарта     
// BEA4/BEA5 CODFL_ORG начало CODE-файла      
// BEA6/BEA7 CODFL_END конец CODE-файла       
// BEA9/BEAA CODFL_RUN старт CODE-файла       
// BEAB/BEAC OFFSET    смещение CODE-файла    
// BEF1/BEF2 LOAD_ERR  адр.перех. по ОШИБ.В/В