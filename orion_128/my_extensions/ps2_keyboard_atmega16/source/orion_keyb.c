// Контроллер PS/2 клавиатуры для компьютеров с клавиатурой Радио-86РК. 
// (c) 1-04-2012 vinxru (aleksey.f.morozov@gmail.com)
// Версия 2 от 1-04-2012

// Прошивка будет поддерживать микроконтроллеры ATMega16, ATMega8, ATMega48 и т.д.
// Но пока работает только ATMega16. 

// Джойстик отключен! Надо раскоментировать строки ниже #define JOY_

// При первом запуске контроллера, необходимо инициализировать EEPROM
// 1) Нажимаете F2, нажимаете PAUSE, отпускаете F2, отпускаете BREAK
// 2) Светодиоды должны последовательно мигнуть  
// 3) Наберите 65534. Нажмите ENTER.
// 4) Через 2 секунды светодиоды должны последовательно мигнуть. Готово!  

// Почему то Scroll Lock нажимается самопроизвольно при запуске. Надо починить.

// Хотелось бы нормализовать длительность нажатия клавиш. Что бы в Бейсике 
// всегда выводился только один символ!

// В программы все переменные глобальные. Это сделано для того, что бы освободить
// регистровую пару R28:R29, которая используется в быстром прерываниии. Надо не 
// забыть в свойствах программы Data stack size установить в 160 байт. Это установит 
// адрес первой переменной data в 100h, а так же R29=1

#include <delay.h>
#define ATMEGA8

//---------------------------------------------------------------------------

#ifdef ATMEGA16
#include <mega16.h>

// Настройка отдельных кнопок
#define OUT_PORT    PORTD  // Порт к которому подключены входы светодиодов 
#define OUT_DDR     DDRD 
#define OUT_RESET   0      // Вывод порта для кнопки сброса
#define OUT_US      4      // Вывод порта для кнопки УС
#define OUT_SS      5      // Вывод порта для кнопки СС
#define OUT_RUSLAT  6      // Вывод порта для кнопки РУС/ЛАТ

// Настройка светодиодов
#define LED_PIN     PIND   // Порт к которому подключены входы светодиодов 
#define LED_RUSLAT  1      // Вывод порта для вход индикатора РУС/ЛАТ
#define LED_TAPE    3      // Вывод порта для входа индикатора МАГНИТОФОН

// Настройка подключения клавиатуры 
#define PS2_PORT    PORTB    // Порт к которому подключена клавиатура
#define PS2_PIN     PINB
#define PS2_DDR     DDRB
#define PS2_CLOCK   3        // Вывод порта для линии данных
#define PS2_DATA    4        // Вывод порта для тектового входа

// Настройка джойстика 
//#define JOY_PIN     PINB     // Порт к которому подключен джойстик
//#define JOY_UP      0        // Вывод порта для кнопки вверх
//#define JOY_DOWN    1        // Вывод порта для кнопки вниз
//#define JOY_LEFT    5        // Вывод порта для кнопки влево
//#define JOY_RIGHT   6        // Вывод порта для кнопки вправо
//#define JOY_FIRE    7        // Вывод порта для кнопки выстрел

// Подключение матрицы
#define DECODE_DDR  DDRC
#define DECODE      PORTC = data[(unsigned char)PINA];

// Прерывание от компьютера.
interrupt [EXT_INT0] void ext_int0() {
#asm
	IN   R28,0x19
	LD   R28,Y
	OUT  0x15,R28
#endasm
}
#endif

//---------------------------------------------------------------------------

#ifdef ATMEGA8
#include <mega8.h>
// Биты порта D
#define OUT_PORT    PORTC  // Порт к которому подключены перечисленные ниже кнопки 
#define OUT_DDR     DDRC 
#define OUT_US      3      // Вывод порта для кнопки УС
#define OUT_SS      4      // Вывод порта для кнопки СС
#define OUT_RUSLAT  5      // Вывод порта для кнопки РУС/ЛАТ

// Настройка подключения клавиатуры 
#define PS2_PORT    PORTC  // Порт к которому подключена клавиатура
#define PS2_PIN     PINC
#define PS2_DDR     DDRC
#define PS2_CLOCK   1      // Вывод порта для линии данных
#define PS2_DATA    2      // Вывод порта для тектового входа

// Подключение матрицы.
#define DECODE_DDR  DDRB
#define DECODE      PORTB = data[(unsigned char)((PIND & ~4) | (PINC.0 ? 4 : 0))]; 

// Прерывание от компьютера.
interrupt [EXT_INT0] void ext_int0() {
#asm
	IN   R28, 0x3F   // SREG
    STS  0x99, R28
     
	IN   R28, 0x10  // R28 = PIND
    CBR  R28, 0x04
    SBIC 0x13, 0    // if(PINC.0)
    SBR  R28, 0x04        
	LD   R28, Y     // R28 = (R29:R28)
	OUT  0x18, R28  // PORTB = R28
                  
    LDS  R28, 0x99
	OUT  0x3F, R28   // SREG
#endasm
}
#endif

//---------------------------------------------------------------------------

#ifdef ATMEGA48
#include <mega48.h>

// Биты порта D
#define OUT_PORT    PORTC  // Порт к которому подключены перечисленные ниже кнопки 
#define OUT_DDR     DDRC 
#define OUT_US      0      // Вывод порта для кнопки УС
#define OUT_SS      1      // Вывод порта для кнопки СС
#define OUT_RESET   2      // Выход сброса       
#define OUT_RUSLAT  3      // Вывод порта для кнопки РУС/ЛАТ
                                        
// Настройка подключения клавиатуры 
#define PS2_PORT    PORTC  // Порт к которому подключена клавиатура
#define PS2_PIN     PINC
#define PS2_DDR     DDRС
#define PS2_CLOCK   4      // Вывод порта для линии данных
#define PS2_DATA    5      // Вывод порта для тектового входа

// Подключение матрицы
#define DECODE_DDR  DDRB
#define DECODE      PORTB = data[(unsigned char)PIND]; 
#endif

//---------------------------------------------------------------------------
// Английская раскладка

const int decodeSize = 109;

const flash unsigned short decodeE_std[decodeSize] = {
  80,88,96,104,112,120,83,68,119,0,0,0,2048,
  0,4096,0,99,74,82,90,98,106,114,122,67,75,
  66,107,91,89,73,64,342,0,123,595,107,65,78,
  126,108,86,102,79,110,77,125,70,95,111,81,0,
  72,348,122,67,75,603,1024,76,94,100,116,124,69,
  85,93,101,83,594,103,98,106,114,512,87,71,92,
  118,84,117,109,99,115,123,512,105,74,82,90,81,
  256,0,0,127,0,0,0,256,97,121,113,66,115,
  0,0,0,0,0
};

//---------------------------------------------------------------------------
// Русская раскладка

const flash unsigned short decodeR_std[decodeSize] = {
  80,88,96,104,112,120,83,580,631,0,0,0,2048,
  0,4096,0,99,74,82,90,98,106,114,122,67,75,
  66,107,91,89,73,64,342,0,123,595,107,65,85,
  92,110,93,108,117,124,95,111,87,69,71,81,0,
  72,348,122,67,75,603,1024,116,79,126,76,70,86,
  125,101,100,118,103,615,98,106,114,512,78,119,94,
  109,77,102,71,84,68,115,512,105,74,82,90,81,
  256,0,0,127,0,0,0,256,97,121,113,66,115,
  0,0,0,0,0
};

//===========================================================================

// Константы 
enum { K_SS=0x0100, K_US=0x0200, K_RUSLAT=0x0400, K_RESET=0x0800, K_MODE=0x1000 }; 
const unsigned char pressedMax = 16; // Максимальное кол-во одновременно нажатых клавиш                                                                        

#ifdef LED_RUSLAT  
const int modesCnt = 3;
#else
const int modesCnt = 2;
#endif

// Спецаиальные переменные
volatile unsigned char data[256];           // Рассчитанный заранее ответ на все 256 комбинаций входного регистра. Должен быть по аресу 100h и первой переменной в ОЗУ
unsigned short decodeE[decodeSize];
unsigned short decodeR[decodeSize];
register unsigned char leds;                // Светодиоды клавиатуры 
register unsigned char mode;                // Выбранная раскладка
register unsigned char pressedCnt;          // Кол-во нажатых клавиш клавиатуры
register unsigned short* v_decode;          // Выбранная раскладка
unsigned char pressed[pressedMax];          // Нажатые клавиши клавиатуры и джойстика

// Общие переменные
register unsigned short v_u;             
register unsigned char v_a, v_i, v_j;
unsigned char v_ext; // Не влезает в регистры
unsigned char v_row[8];

#ifdef JOY_PIN
unsigned char joystic;             // Состояние джойстика
#endif 

//---------------------------------------------------------------------------
// Таблица сжатия 512 сканкодов в 109 сканкодов. Часть 0x000 - 0x083

const flash unsigned char compact_l[] = {
  0xFF,        // 0x00
  9,           // 0x01 F9
  0xFF,        // 0x02 
  5,           // 0x03 F5 
  3,           // 0x04 F3
  1,           // 0x05 F1
  2,           // 0x06 F2
  12,          // 0x07 F12
  0xFF,        // 0x08
  10  ,        // 0x09 F10
  8,           // 0x0A F8
  6,           // 0x0B F6
  4,           // 0x0C F4
  37,          // 0x0D TAB
  16,          // 0x0E ~
  0xFF,        // 0x0F Keypad = 
  0xFF,        // 0x10 
  93,          // 0x11 LAlt
  74,          // 0x12 LShift
  0xFF,        // 0x13 
  91,          // 0x14 LCtrl
  38,          // 0x15 Q
  17,          // 0x16 1
  0xFF,        // 0x17
  0xFF,        // 0x18
  0xFF,        // 0x19
  75,          // 0x1A Z
  60,          // 0x1B S
  59,          // 0x1C A
  39,          // 0x1D W
  18,          // 0x1E 2
  0xFF,        // 0x1F
  0xFF,        // 0x20
  77,          // 0x21 C
  76,          // 0x22 X
  61,          // 0x23 D
  40,          // 0x24 E
  20,          // 0x25 4
  19,          // 0x26 3
  0xFF,        // 0x27
  0xFF,        // 0x28
  94,          // 0x29 SPACE  
  78,          // 0x2A V
  62,          // 0x2B F
  42,          // 0x2C T
  41,          // 0x2D R
  21,          // 0x2E 5
  0xFF,        // 0x2F
  0xFF,        // 0x30
  80,          // 0x31 N
  79,          // 0x32 B
  64,          // 0x33 H
  63,          // 0x34 G   
  43,          // 0x35 Y
  22,          // 0x36 6
  0xFF,        // 0x37          
  0xFF,        // 0x38
  0xFF,        // 0x39
  81,          // 0x3A M
  65,          // 0x3B J
  44,          // 0x3C U
  23,          // 0x3D 7
  24,          // 0x3E 8
  0xFF,        // 0x3F
  0xFF,        // 0x40
  82,          // 0x41 , Запяточие
  66,          // 0x42 6 K
  45,          // 0x43 7 I
  46,          // 0x44 O
  26,          // 0x45 0
  25,          // 0x46 9
  0xFF,        // 0x47
  0xFF,        // 0x48
  83,          // 0x49 .
  84,          // 0x4A /
  67,          // 0x4B L
  68,          // 0x4C ;
  47,          // 0x4D P
  27,          // 0x4E -
  0xFF,        // 0x4F
  0xFF,        // 0x50
  0xFF,        // 0x51
  69,          // 0x52 "
  0xFF,        // 0x53
  48,          // 0x54 [
  28,          // 0x55 +
  0xFF,        // 0x56
  0xFF,        // 0x57
  58,          // 0x58 CAPS
  85,          // 0x59 RShift
  50,          // 0x5A          
  49,          // 0x5B ]
  0xFF,        // 0x5C
  70,          // 0x5D \
  0xFF,        // 0x5E
  0xFF,        // 0x5F
  0xFF,        // 0x60
  0xFF,        // 0x61
  0xFF,        // 0x62
  0xFF,        // 0x63
  0xFF,        // 0x64
  0xFF,        // 0x65
  29,          // 0x66 Backspace
  0xFF,        // 0x67
  0xFF,        // 0x68
  87,          // 0x69 Keypad 1 End 
  0xFF,        // 0x6A
  71,          // 0x6B Keypad 4 Left
  54,          // 0x6C Keypad 7 Home    
  0xFF,        // 0x6D
  0xFF,        // 0x6E
  0xFF,        // 0x6F
  102,         // 0x70 Keypad 0 Ins 
  103,         // 0x71 Keypad . Del  
  88,          // 0x72 Keypad 2 Down
  72,          // 0x73 Keypad 5 
  73,          // 0x74 Keypad 6 Right
  55,          // 0x75 Keypad 8 Up     
  0,           // 0x76 ESC  
  33,          // 0x77 Num 
  11,          // 0x78 F11
  57,          // 0x79 Keypad + 
  89,          // 0x7A Keypad 3 PgDn 
  36,          // 0x7B Keypad - 
  35,          // 0x7C Keypad *
  56,          // 0x7D Keypad 9 PgUp
  14,          // 0x7E Scroll Lock
  0xFF,        // 0x7F
  0xFF, 	   // 0x80
  0xFF, 	   // 0x81
  0xFF, 	   // 0x82
  7, 	       // 0x83 F7          
};

//---------------------------------------------------------------------------
// Таблица сжатия 512 сканкодов в 109 сканкодов. Часть 0x111 - 0x17E

const flash unsigned char compact_h[] = {
  95,       // 0x11 Right Alt
  0xFF,0xFF, // 12,13
  98,       // 0x14 Right Ctrl
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 15,16,17,18,19,1A,1B,1C,1D,1E
  92,       // 0x1F Left Win
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 20,21,22,23,24,25,26
  96,       // 0x27 Right Win                                               
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 28,29,2A,2B,2C,2D,2E
  97,       // 0x2F Menu
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 30-3F
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 40-49  
  34,       // 0x4A /
  0xFF,0xFF,0xFF,0xFF,0xFF, // 4B,4C,4D,4E,4F
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 50-59
  90,       // 0x5A Enter
  0xFF,0xFF,0xFF,0xFF,0xFF, // 5B,5C,5D,5E,5F
  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, // 60-68
  52,       // 0x69 End
  0xFF,     // 0x6A
  99,       // 0x6B Left 
  31,       // 0x6C Home
  0xFF,0xFF,0xFF, // 6D,6E,6F
  30,       // 0x70 Insert
  51,       // 0x71 Delete 
  100,      // 0x72 Down
  0xFF,     // 0x73  
  101,      // 0x74 Right
  86,       // 0x75 Up
  0xFF,0xFF,0xFF,0xFF, // 76,77,78,79
  53,       // 0x7A Page Down  
  0xFF,     // 0x7B
  13,       // 0x7C Keyrus *
  32,       // 0x7D Page UP
  15,       // 0x7E Ctrl+Pause
};

//---------------------------------------------------------------------------
// Функция сжатия 512 сканкодов в 109 сканкодов
//   Вход:  v_ext + v_a - сканкод от 0 до 511
//   Выход: v_a - сканкод от 0 до 108

void compact() {
  if(v_ext) {
    v_a -= 0x11;       
    if(v_a < sizeof(compact_h)) {
      v_a = compact_h[v_a];
      return;
    } 
  } else {
    if(v_a < sizeof(compact_l)) { 
      v_a = compact_l[v_a];
      return;
    }
  }
  v_a = 0xFF;
};

//---------------------------------------------------------------------------

void delay_msX() { while(v_i--) delay_us(10000); }
void delay_ms300() { v_i=30; delay_msX(); }
void delay_ms800() { v_i=80; delay_msX(); }
void delay_ms150() { v_i=15; delay_msX(); }

//---------------------------------------------------------------------------
// Функция перезагрузки
             
inline void reboot() {
#asm
  rjmp 0
#endasm  
}

//---------------------------------------------------------------------------
// Низкоуровневые функции протокола PS/2

#define PORT(X) PORT##X

#define ps2_setClock0()  { PS2_PORT.PS2_CLOCK = 0; PS2_DDR.PS2_CLOCK = 1; }
#define ps2_setClock1()  { PS2_PORT.PS2_CLOCK = 1; PS2_DDR.PS2_CLOCK = 0; } 
#define ps2_setDataOut() { PS2_DDR.PS2_DATA = 1; }
#define ps2_setDataIn()  { PS2_DDR.PS2_DATA = 0; } 
#define ps2_setData0()   { PS2_PORT.PS2_DATA = 0; }
#define ps2_setData1()   { PS2_PORT.PS2_DATA = 1; } 
#define ps2_waitClock0() { while(PS2_PIN.PS2_CLOCK); }
#define ps2_waitClock1() { while(!PS2_PIN.PS2_CLOCK); }
#define ps2_waitClock()  { ps2_waitClock1(); ps2_waitClock0(); }
#define ps2_data()       PS2_PIN.PS2_DATA
#define ps2_wait()       (PS2_PIN & ((1<<PS2_DATA) | (1<<PS2_CLOCK)))
 
//---------------------------------------------------------------------------
// Включить режим передачи или ожидаения.

void ps2_transmitMode() {
  delay_us(100); // Без этого залипает чаще
  ps2_setClock0();
  delay_us(100);   
}

//---------------------------------------------------------------------------
// Включить режим приема. В этом режиме клаиватура может начать передачу, 
// поэтому необходимо постоянно проверять ps2_wait()

void ps2_receiveMode() {
  ps2_setClock1();
  //delay_us(10);   
}

//---------------------------------------------------------------------------
// Отправить байт клавиатуре
//   Вход:  v_a - байт

void ps2_send() {
  ps2_setDataOut();
  ps2_setData0();
  delay_us(20);
  ps2_setClock1();                                 
  delay_us(10);
  v_j=0;
  ps2_waitClock0();    
  for(v_i=0; v_i<8; v_i++) {
    if(v_a&1) { ps2_setData1(); v_j++; } else ps2_setData0();
    v_a >>= 1;
    ps2_waitClock();    
  }
  // Бит четности
  if(v_j&1) ps2_setData0(); else ps2_setData1();
  ps2_waitClock();    
  // Стоповый бит
  ps2_setData1();
  ps2_waitClock();    
  // Пропуск ACK
  ps2_setDataIn();
  ps2_waitClock1();
  if(ps2_data()) reboot(); // Ошибка клавиатуры. Перезагружаем её. 
  ps2_transmitMode();    
}
  
//---------------------------------------------------------------------------
// Принять байт от клавиатуры. Эта функция вызывается уже после того, как 
// клавиатура начала отправку
//   Выход:  v_a - байт

void ps2_recv_int() {
  v_a = 0; v_j = 0;
  for(v_i=0; v_i<8; v_i++) {
    ps2_waitClock();
    v_a >>= 1; 
    if(PS2_PIN.PS2_DATA) { v_a |= 0x80; v_j++; }
  }
  // parity bit
  ps2_waitClock();
  if(PS2_PIN.PS2_DATA) v_j++; 
  // stop bit
  ps2_waitClock();  
  if((v_j&1)==0) reboot();
  if(PS2_PIN.PS2_DATA==0) reboot();
  // end 
  ps2_waitClock1();
  ps2_transmitMode();    
}

//---------------------------------------------------------------------------
// Принять байт от клавиатуры. Функция включает режим приема, ждет байт, а 
// потом выключает режим приема.
//   Выход:  v_a - байт
 
void ps2_recv() {
  ps2_receiveMode();
  while(ps2_wait());
  ps2_recv_int();
}

//---------------------------------------------------------------------------
// Послать байт клавиатуре и получить от неё подтвержение приёма.

void ps2_sendAndCheck() {
  ps2_send();
  ps2_recv();
  if(v_a!=0xFA) reboot();
}

//---------------------------------------------------------------------------
// Сброс клавиатуры

void ps2_reset() {
  // Аппаратный сброс.
  ps2_setClock1();
  ps2_setDataOut();
  ps2_setData0();
  delay_ms300();
  ps2_setData1();      
  ps2_setDataIn();    
  ps2_setClock0();
  delay_ms800();
         
  // Клавиатура исправна
  ps2_recv();
  if(v_a!=0xAA) reboot();
}

//---------------------------------------------------------------------------

void ps2_setLeds() {      
  v_a = 0xED; ps2_sendAndCheck();
  v_a = leds; ps2_sendAndCheck();
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// Обработка светодиодов и джойстика. Вызывается из функции ожидаение приема 
// команд от клавиатуры.

void pressRelease(); // forward 
void calc(); // forward

void recvIdle() {      
  // Если включить эту строку, то символы дублируется. Хотя никакого эффекта от этой
  // строки быть не должно.
  // DECODE
                     
  v_i=0;
//  if(mode!=modesCnt-1) v_i += 1; // scroll lock
v_i = pressedCnt;
#ifdef LED_TAPE
  if(LED_PIN.LED_TAPE==0) v_i += 2; // num lock
#endif
#ifdef LED_RUSLAT  
  if(LED_PIN.LED_RUSLAT==0) v_i += 4; // caps lock
#endif

#ifdef JOY_PIN
  v_j = JOY_PIN & ((1<<JOY_UP)|(1<<JOY_DOWN)|(1<<JOY_LEFT)|(1<<JOY_RIGHT)|(1<<JOY_FIRE));
#endif
  
  if(v_i == leds 
#ifdef JOY_PIN
    && v_j == joystic
#endif
  ) return;
    
  // Отключаем прием
  ps2_transmitMode();
     
  // Обновляем светодиоды
  if(v_i != leds) {      
    leds = v_i;
    ps2_setLeds();
  }
#ifdef JOY_PIN
  // Эмулируем нажатия кнопок джойстика
  if(v_j != joystic) {
    joystic = v_j;
    v_j = (joystic & (1<<JOY_UP   ))==0; v_a = 104; pressRelease(); 
    v_j = (joystic & (1<<JOY_DOWN ))==0; v_a = 105; pressRelease(); 
    v_j = (joystic & (1<<JOY_LEFT ))==0; v_a = 106; pressRelease(); 
    v_j = (joystic & (1<<JOY_RIGHT))==0; v_a = 107; pressRelease(); 
    v_j = (joystic & (1<<JOY_FIRE ))==0; v_a = 108; pressRelease();
    calc(); 
  }
#endif

  // Вкплючаем прием    
  ps2_receiveMode();      
}

//---------------------------------------------------------------------------
// Ожидаение приема команд от клавиатуры и обработка светодиодов и джойстика

void ps2_recvAndIdle() {
  ps2_receiveMode();
  while(ps2_wait()) {
    recvIdle();  
  } 
  ps2_recv_int();
}

//---------------------------------------------------------------------------
// Преобразование клавиш РК86 в матрицу нажатых клавиш клаиватуры РК86

void calc() {          
  // Выбираем таблицу
  switch(mode) {
    case 0: v_decode = decodeE; break; 
    case 1: v_decode = decodeR; break; 
#ifdef LED_RUSLAT
    case 2: v_decode = (LED_PIN&(1<<LED_RUSLAT))==0 ? decodeR : decodeE; break;
#endif
  }                
  
  // Очищаем матрица 8x8
  for(v_i=0; v_i<8; v_i++) 
    v_row[v_i] = 0xFF;
                           
  // Преобразовываем нажатые клавиши в матрицу 8x8 и рассчитываем шифты
  v_j = 0xFF;    
  for(v_i=0; v_i<pressedCnt; v_i++) {
    v_u = v_decode[pressed[v_i]];                    
    if(v_u & 0x40) v_row[v_u&7] &= ~(1<<((v_u>>3)&7));    
    if(v_u & K_RUSLAT) v_j &= ~(1<<OUT_RUSLAT);
    if(v_u & K_SS    ) v_j &= ~(1<<OUT_SS);
    if(v_u & K_US    ) v_j &= ~(1<<OUT_US);
#ifdef OUT_RESET
    if(v_u & K_RESET ) v_j &= ~(1<<OUT_RESET);
#endif    
  }
                     
  // Записываем шифты
  v_i = OUT_PORT;
  OUT_PORT = v_j;

  // Если шифты изменились, то делаем паузу в 20 мс перед загрузкой кнопок.
  if(v_i != v_j) delay_us(20000);
    
  // Преобразовываем матрицу 8x8 в 256x8
  v_i = 0;
  do {
    v_j = 0xFF;
    if(0==(v_i&0x01)) v_j &= v_row[0];
    if(0==(v_i&0x02)) v_j &= v_row[1];
    if(0==(v_i&0x04)) v_j &= v_row[2];
    if(0==(v_i&0x08)) v_j &= v_row[3];
    if(0==(v_i&0x10)) v_j &= v_row[4];
    if(0==(v_i&0x20)) v_j &= v_row[5];
    if(0==(v_i&0x40)) v_j &= v_row[6];
    if(0==(v_i&0x80)) v_j &= v_row[7];
    data[v_i] = v_j;                    
    v_i++;
  } while(v_i!=0);
            
  // Обновляем данные на выходе МК
  DECODE                   
}

//---------------------------------------------------------------------------
// Нажата кнопка переключения раскладок

void pressModeKey() {
  mode++;
  if(mode>=modesCnt) mode=0;
}

//---------------------------------------------------------------------------
// Нажатие или отпускание кнопки
// Использует v_i, v_j

void pressRelease() {
  if(v_j) {
    // Нажатие
    if(pressedCnt == pressedMax) return;
    for(v_i=0; v_i<pressedCnt; v_i++)
      if(pressed[v_i]==v_a) 
        return;    
    pressed[pressedCnt++] = v_a; 
    if(v_decode[v_a] & K_MODE) pressModeKey();
  } else {
    // Отпускание
    for(v_i=0; v_i<pressedCnt; v_i++)
      if(pressed[v_i]==v_a) {
        pressedCnt--;
        for(;v_i<pressedCnt; v_i++)
          pressed[v_i] = pressed[v_i+1];  
        return;
      }
  }  
}

//---------------------------------------------------------------------------

void readEEPROM () {
  while (EECR.1 != 0);
  EEAR = v_u; v_u++;       
  EECR.0 = 1;
  EECR.0 = 0;
}

//---------------------------------------------------------------------------

void writeEEPROM() {
  while(EECR.1 != 0);
  EEDR = v_a;
  EEAR = v_u; v_u++;       
  EECR.2 = 1;
  EECR.1 = 1;
}

//---------------------------------------------------------------------------

void loadDecode() {
  v_u = 0;   
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    readEEPROM();
    ((unsigned char*)decodeE)[v_i] = EEDR;
  } 
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    readEEPROM();
    ((unsigned char*)decodeR)[v_i] = EEDR;
  } 
  readEEPROM();
  mode = EEDR;
  if(mode >= modesCnt) mode = 0; 
}

//---------------------------------------------------------------------------

void saveDecode() {
  v_u = 0;
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    v_a = ((unsigned char*)decodeE)[v_i];
    writeEEPROM();                 
  } 
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    v_a = ((unsigned char*)decodeR)[v_i];
    writeEEPROM();
  }
  v_a = mode;
  writeEEPROM();
}

//---------------------------------------------------------------------------

void resetData() {
  v_i=0;
  for(;;) {
    data[v_i] = 255;
    v_i++;
    if(v_i==0) break;
  }  
}

//---------------------------------------------------------------------------
        
void resetDecode() {
  for(v_i=0; v_i<decodeSize; v_i++) {
    decodeR[v_i] = decodeR_std[v_i];  
    decodeE[v_i] = decodeE_std[v_i];  
  }
}

//---------------------------------------------------------------------------

void demo() {
  leds=1; ps2_setLeds(); delay_ms150();
  leds=4; ps2_setLeds(); delay_ms150();
  leds=2; ps2_setLeds(); delay_ms150();
}

//---------------------------------------------------------------------------

void programmMode() {      
  if(pressedCnt!=1) return;
  
  resetData();
                         
  demo();
  leds=7; ps2_setLeds();
            
  v_u = 0; 
  for(;;) {
    ps2_recv(); 
    if(v_a==0xE0) ps2_recv();
    if(v_a==0xF0) {
      ps2_recv();
      continue;
    }
    switch(v_a) {
      case 0x45: v_a=0; break;
      case 0x16: v_a=1; break;
      case 0x1E: v_a=2; break;
      case 0x26: v_a=3; break;
      case 0x25: v_a=4; break;
      case 0x2E: v_a=5; break;
      case 0x36: v_a=6; break;
      case 0x3D: v_a=7; break;
      case 0x3E: v_a=8; break;
      case 0x46: v_a=9; break;
      case 0x5A: goto ok;      
      default: goto exit;
    }  
    v_u *= 10;
    v_u += v_a;
  }
ok:      
  switch(v_u) {
    case 65534: resetDecode();
    case 65535: saveDecode(); break;
    default: v_decode[pressed[0]] = v_u; break; 
  }
  
exit:                
  demo();
  
  pressedCnt=0;
}

//---------------------------------------------------------------------------
            
void main(void) {     
#ifdef ATMEGA16        
  PORTA = 0xFF;
#endif  
  PORTB = 0xFF;
  PORTC = 0xFF;
  PORTD = 0xFF;

  // Настройка портов   
#ifdef OUT_RESET
  OUT_DDR  |= (1<<OUT_RESET);
#endif
  OUT_DDR  |= (1<<OUT_RUSLAT)|(1<<OUT_SS)|(1<<OUT_US);
  DECODE_DDR = 0xFF;

  // Сброс переменных
  leds       = 0;
  mode       = modesCnt-1;
  pressedCnt = 0;
  v_decode   = decodeE;

  resetData();
  loadDecode();   

  // Сброс клавиатуры
  ps2_reset();

  // Вкдючаем внешнее прерывание
#ifdef ATMEGA48
  ??? // Включить прерывание
#else
  #define ISC00 0
  #define ISC01 1
  #define INT0  6                 
  MCUCR |= (1<<ISC01)|(0<<ISC00); // falling  
  GICR |= (1<<INT0);
#endif

  #asm("sei")

  // Основной цикл  
  for(;;) {
    ps2_recvAndIdle();
            
    // Обработка кнопки Pause               
    if(v_a==0xE1) {
      // Вот такой скан код у этой кнопки
      ps2_recvAndIdle(); if(v_a!=0x14) reboot();
      ps2_recvAndIdle(); if(v_a!=0x77) reboot();
      ps2_recvAndIdle(); if(v_a!=0xE1) reboot();
      ps2_recvAndIdle(); if(v_a!=0xF0) reboot();     
      ps2_recvAndIdle(); if(v_a!=0x14) reboot();     
      ps2_recvAndIdle(); if(v_a!=0xF0) reboot();     
      ps2_recvAndIdle(); if(v_a!=0x77) reboot();
        
      programmMode();
      continue;    
    }
                            
    v_ext = 0;
    if(v_a==0xE0) { v_ext=1; ps2_recvAndIdle(); }
    
    if(v_a==0xF0) {
      ps2_recvAndIdle(); // Эта функция портит все переменные кроме v_ext 
      v_j = 0;
    } else {
      v_j = 1;
    }  
    compact();
    if(v_a!=0xFF) {
      pressRelease();
      calc();
    }                        
  }
}  

/*interrupt [EXT_INT0] void ext_int0() {
  DECODE
} */