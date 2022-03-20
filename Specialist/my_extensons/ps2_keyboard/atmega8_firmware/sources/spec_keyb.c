// Контроллер PS/2 клавиатуры для компьютера Специалист. 
// (c) 24-03-2013 vinxru (aleksey.f.morozov@gmail.com)

// Контроллер поддерживает перепрограммирование соответствия клавиш во время работы
// Нажмите клавишу, которую хотите перепрограммировать. Затем нажмите Break.
// Отпустите все клавиши. Светодиоды должны мигнуть.
// Затем наберите цифрами (на основной клавиатуре) код клавиши Специалиста и нажмите
// Enter.

// Что бы запистать изменения в энергонезависимую память, нажмите любую 
// кнопку, а потом Break. А потом отпустите все клавиши. На основной клавиатуре
// наберите 65535 и нажмите Enter.

// Что бы установить все соотвествия по умолчанию, введите код 65534.

// В программы все переменные глобальные. Это сделано для того, что бы освободить
// регистровую пару R28:R29, которая используется в быстром прерываниии. Надо не 
// забыть в свойствах программы Data stack size установить в 160 байт. Это установит 
// адрес первой переменной data в 100h.

#include <delay.h>
#include <mega8.h>

//---------------------------------------------------------------------------
// Привязка

// 2       - прерывание от компьютера
// 0,1,4,5 - данные от компьютера. 

#define KEY_HP      7      // Вывод порта D для кнопки HP
#define PS2_CLOCK   3      // Вывод порта D для тактового входа PS/2
#define PS2_DATA    6      // Вывод порта D для линии данных PS/2

//---------------------------------------------------------------------------
// Английская раскладка

const int decodeSize = 109;

const flash unsigned short decodeE_std[decodeSize] = {
  134,221,220,217,216,215,214,213,212,211,210,209,208,
  8192,4096,0,145,204,201,200,199,198,197,196,195,194,
  193,192,205,144,0,0,0,0,145,432,192,135,157,
  169,183,166,150,172,185,151,165,167,180,179,128,512,
  0,0,196,195,194,461,141,168,153,163,173,181,177,
  189,184,164,176,147,161,199,198,197,256,178,149,188,
  162,148,182,152,146,160,156,256,137,204,201,200,128,
  131,140,129,133,129,140,0,131,132,136,130,193,160
};

//---------------------------------------------------------------------------
// Раскладка QWERT

const flash unsigned short decodeR_std[decodeSize] = {
  134,221,220,217,216,215,214,213,212,211,210,209,208,
  8192,4096,0,145,204,201,200,199,198,197,196,195,194,
  193,192,205,144,0,0,0,0,145,432,192,135,189,
  188,185,184,183,182,181,180,179,178,177,176,128,512,
  0,0,196,195,194,461,141,173,172,169,168,167,166,
  165,164,163,162,161,146,199,198,197,256,157,156,153,
  152,151,150,149,148,147,160,256,137,204,201,200,128,
  131,140,129,133,129,140,0,131,132,136,130,193,160
};


//---------------------------------------------------------------------------
// Константы 

enum { K_HP=0x0100, K_RESET=0x0200, K_MODE=0x1000, K_MXMODE=0x2000 }; 
enum { M_QWERT=1, M_MX=2 };
const unsigned char pressedMax = 16; // Максимальное кол-во одновременно нажатых клавиш                                                                        

//---------------------------------------------------------------------------
// Переменные в регистрах.
// Переменные должны идти именно в таком порядке, что бы
// под reservedForInterrupt были забиты регистры R8,R9

register unsigned char  v_a;                   // (Временная переменная)
register unsigned char  v_i;                   // (Временная переменная)
register unsigned char  v_j;                   // (Временная переменная)
register unsigned short reservedForInterrupt;  // Регистры R8,R9 забиты под прерывание.
register unsigned char  prepared_ddrd;         // Тут всегда должно находится значение DDR&0xCC. Используется в прерывании.
register unsigned short v_u;                   // (Временная переменная)
register unsigned char  scanMode;              // Используемый компьютером способ сканирования (0=верт->гор, 1=гор->верт)
register unsigned char  intTrigger;            // Устаналивается в 1, если было прерывание. Позволяет снизить вероятность случаных нажатий (баг) из за одновременого выполнения прерывания и updatePorts.

//---------------------------------------------------------------------------
// Переменные в памяти

volatile unsigned char b2c[256];    // Рассчитанный заранее ответ для прерывания.
volatile unsigned char c2b[64];     // Эти переменные должы идти первыми в программе,
volatile unsigned char c2d[128];    // что бы занимать адреса 100h, 200h, 240h, 2C0h
volatile unsigned char d2c[64];     
unsigned short decode[decodeSize];  // Выбранная таблица перекодировки (копируется из EEPROM)
unsigned char  pressed[pressedMax]; // Коды нажатых клавиш клавиатуры
unsigned char  v_leds;              // Светодиоды клавиатуры 
unsigned char  mode1;               // Выбранная раскладка
unsigned char  pressedCnt;          // Кол-во нажатых клавиш клавиатуры
unsigned char  v_row[16];           // (Временная переменная)
unsigned char  v_row1[8];           // (Временная переменная)
unsigned char  v_row2[8];           // (Временная переменная)
unsigned char  v_ext;               // (Временная переменная)
                                                                                                                                          
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
  0xFF,        // 0x80
  0xFF,        // 0x81
  0xFF,        // 0x82
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
// forward

void loadDecode();
void resetDecode();
void pressRelease();
void updatePorts();
void calc(); 

//---------------------------------------------------------------------------
// Сторожевой таймер

const int WDCE  = 4;
const int WDE   = 3;
const int WDP2  = 2;
const int WDP1  = 1;
const int WDP0  = 0;

#define WDT_ON()  { WDTCR = (1<<WDCE) | (1<<WDE); WDTCR = (1<<WDE) | (1<<WDP2) | (1<<WDP1) | (1<<WDP0); }
#define WDT_OFF() { WDTCR = (1<<WDCE) | (1<<WDE);  WDTCR = 0; }
            
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
// Функции задержки. Стандартные использовать нельзя, так как они требут стек.

void delay_msX() { 
  while(v_i--) { 
#asm
  WDR
#endasm
    delay_us(10000);
  } 
}

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

#define ps2_setClock0()  { PORTD.PS2_CLOCK = 0; prepared_ddrd |=  (1 << PS2_CLOCK); DDRD.PS2_CLOCK = 1; }
#define ps2_setClock1()  { PORTD.PS2_CLOCK = 1; prepared_ddrd &= ~(1 << PS2_CLOCK); DDRD.PS2_CLOCK = 0; } 
#define ps2_setDataOut() { prepared_ddrd |=  (1 << PS2_DATA); DDRD.PS2_DATA = 1; }
#define ps2_setDataIn()  { prepared_ddrd &= ~(1 << PS2_DATA); DDRD.PS2_DATA = 0; } 
#define ps2_setData0()   { PORTD.PS2_DATA = 0; }
#define ps2_setData1()   { PORTD.PS2_DATA = 1; } 
#define ps2_waitClock0() { while(PIND.PS2_CLOCK); }
#define ps2_waitClock1() { while(PIND.PS2_CLOCK==0); }
#define ps2_waitClock()  { ps2_waitClock1(); ps2_waitClock0(); }
#define ps2_data()       PIND.PS2_DATA
#define ps2_wait()       (PIND.PS2_DATA || PIND.PS2_CLOCK)
 
//---------------------------------------------------------------------------
// Включить режим передачи или ожидаения.

void ps2_transmitMode() {
  ps2_setClock0();
  delay_us(100);   
}

//---------------------------------------------------------------------------
// Включить режим приема. В этом режиме клаиватура может начать передачу, 
// поэтому необходимо постоянно проверять ps2_wait()

void ps2_receiveMode() {
  ps2_setClock1();
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
  if(v_j&1) { ps2_setData0(); } else { ps2_setData1(); }
  ps2_waitClock();    
  // Стоповый бит
  ps2_setData1();
  ps2_waitClock();    
  // Пропуск ACK
  ps2_setDataIn();
  ps2_waitClock();
  if(ps2_data()) reboot(); // Ошибка клавиатуры. Перезагружаем её. 
  ps2_waitClock1();
  ps2_transmitMode();    
#asm
  WDR
#endasm
}
  
//---------------------------------------------------------------------------
// Принять байт от клавиатуры. Эта функция вызывается уже после того, как 
// клавиатура начала отправку
//   Выход:  v_a - байт

void ps2_intRecv() {
  // Биты данных
  v_a = 0; v_j = 0;
  for(v_i=0; v_i<8; v_i++) {
    ps2_waitClock();
    v_a >>= 1; 
    if(PIND.PS2_DATA) { v_a |= 0x80; v_j++; }
  }
  // Бит четнсоти
  ps2_waitClock();
  if(PIND.PS2_DATA) v_j++; 
  if((v_j&1)==0) reboot();
  // Стоповй бит
  ps2_waitClock();  
  if(PIND.PS2_DATA==0) reboot();
  // Конец 
  ps2_waitClock1();
  // Сбрасываем сторожевой таймер, если клавиатура жива
#asm
  WDR
#endasm
}

//---------------------------------------------------------------------------
// Принять байт от клавиатуры. Функция включает режим приема, ждет байт, а 
// потом выключает режим приема.
//   Выход:  v_a - байт
 
void ps2_continueRecv() {
  // Сбрасываем WDT
#asm 
    WDR
#endasm       
  // Ждем, пока клавиатура рещит принять данные
  while(ps2_wait());    
  // Принимаем
  ps2_intRecv();        // Там произвойдет сброс WDT
}

//---------------------------------------------------------------------------
// Ожидаение приема команд от клавиатуры и обработка светодиодов и джойстика

void ps2_firstRecv() {
  // Сбрасываем WDT
#asm 
    WDR
#endasm       
  // Ждем, пока клавиатура рещит принять данные
  ps2_receiveMode();
  v_u = 0;
  while(ps2_wait()) {
    v_u++;              
    // Периодически посылаем пинг, что бы убедится в нормально работе клавиатуры.
    if(v_u==0) {
      ps2_transmitMode();
      v_a = 0xEE; ps2_send(); // Там произвойдет сброс WDT
      ps2_receiveMode();
      ps2_continueRecv();     // Там произвойдет сброс WDT
      if(v_a!=0xEE) reboot();
      v_u = 0;
    }
  } 
  // Продолжить прием
  ps2_intRecv();
}

//---------------------------------------------------------------------------
// Послать байт клавиатуре и получить от неё подтвержение приёма.

void ps2_sendAndCheck() {
  // Посылаем команду
  ps2_send();
  // Принимаем от клавиатуры FA
  ps2_receiveMode();
  ps2_continueRecv();  
  ps2_transmitMode();    
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
         
  // Если клавиатура исправна, она первым байтом пошлет 0xAA
  ps2_receiveMode();
  ps2_continueRecv();
  if(v_a!=0xAA) reboot();    

  // Запрещаем передачу данных
  ps2_transmitMode();
}

//---------------------------------------------------------------------------
// Устаналиваем светодиоды клавиатуры

void ps2_setLeds() {      
  v_a = 0xED;   ps2_sendAndCheck();
  v_a = v_leds; ps2_sendAndCheck();
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// Обработка светодиодов.

void updateLeds() {      
  v_leds = 0;
  if(mode1 & M_QWERT) v_leds += 1; // scroll lock
  if(mode1 & M_MX   ) v_leds += 4; // caps lock
  ps2_setLeds();
}

//---------------------------------------------------------------------------
// Преобразование кодов клавиш Специалиста в матрицу нажатых клавиш клаиватуры.
// Портит все регистры

unsigned char v_reset;

void calc() {          
  // Очищаем матрицу 12x6(8)
  for(v_i=0; v_i<16; v_i++) 
    v_row[v_i] = 0;

  // Очищаем матрицу 6x12(16)
  for(v_i=0; v_i<8; v_i++) { 
    v_row1[v_i] = 0;
    v_row2[v_i] = 0;     
  }
                           
  // Преобразовываем нажатые клавиши в матрицу 12x6 и 6x12 рассчитываем шифты
  v_j = 0xFF;                    
  v_reset = 1;
  for(v_i=0; v_i<pressedCnt; v_i++) {
    v_u = decode[pressed[v_i]];
    if(v_u & K_HP) v_j &= ~(1<<KEY_HP);    
    if(v_u & K_RESET) v_reset = 0;
    if(v_u & 0x80) {
      if(mode1 & M_MX) {
        v_u &= 0x7F;
        if(v_u==0x6) v_u = 0x5D; else // ESC => F1
        if(v_u==0x7) v_u = 0x3; else // TAB
        if(v_u==0x5D) v_u=0x5C; else // F1 => F2
        if(v_u==0x5C) v_u=0x59; else // F2 => F3
        if(v_u>=0x51 && v_u<=0x59) v_u--; // F3..F11 => F4..F12
      }
      v_row[v_u&15] |= (1<<((v_u>>4)&7));
      if(v_u&8) v_row2[(v_u>>4)&7] |= (1<<(v_u&7));           
           else v_row1[(v_u>>4)&7] |= (1<<(v_u&7));
    }    
  }
                     
  // Старое состояние шифтов
  //v_i = PORTD | ~(1<<KEY_HP);
  //if(!v_reset) v_j &= ~(1<<KEY_HP);    

  // Записываем шифты    
  PORTD = (PORTD | (1<<KEY_HP)) & v_j;
  PORTC.6 = v_reset; 
    
  // Если шифты изменились, то делаем паузу в 20 мс перед загрузкой кнопок.
  // if(v_j != v_i) delay_us(20000);
    
  // Преобразовываем матрицу 12x6 (низ) в 256x6
  v_i = 0;
  do {
    v_j = 0b01000000; // RESET
    if(0==(v_i&0x01)) v_j |= v_row[0];
    if(0==(v_i&0x02)) v_j |= v_row[1];
    if(0==(v_i&0x04)) v_j |= v_row[2];
    if(0==(v_i&0x08)) v_j |= v_row[3];
    if(0==(v_i&0x10)) v_j |= v_row[4];
    if(0==(v_i&0x20)) v_j |= v_row[5];
    if(0==(v_i&0x40)) v_j |= v_row[6];
    if(0==(v_i&0x80)) v_j |= v_row[7];
    b2c[v_i] = v_j; // длиная вертикаль в горизонталь                    
    v_i++;
  } while(v_i!=0);

  // Преобразовываем матрицу 12x6 (верх) в 64x6
  v_i = 0;
  do {
    v_j = 0b01000000; // RESET
    if(0==(v_i&0x01)) v_j |= v_row[8];
    if(0==(v_i&0x02)) v_j |= v_row[9];
    if(0==(v_i&0x10)) v_j |= v_row[12];
    if(0==(v_i&0x20)) v_j |= v_row[13];
    d2c[v_i] = v_j; // короткая вертикаль в горизонталь.                    
    v_i++;
  } while(v_i!=64);
            
  // Преобразовываем матрицу 6x8 в 64x8
  v_i = 0;
  do {
    v_j = 0;
    if(0==(v_i&0x01)) v_j |= v_row1[0];
    if(0==(v_i&0x02)) v_j |= v_row1[1];
    if(0==(v_i&0x04)) v_j |= v_row1[2];
    if(0==(v_i&0x08)) v_j |= v_row1[3];
    if(0==(v_i&0x10)) v_j |= v_row1[4];
    if(0==(v_i&0x20)) v_j |= v_row1[5];
    c2b[v_i] = v_j; // горизонталь в длиную вертикаль                    
    v_i++;
  } while(v_i!=64);

  // Преобразовываем матрицу 6x4 в 64x4
  v_i = 0;
  do {
    v_j = 0;
    if(0==(v_i&0x01)) v_j |= v_row2[0];
    if(0==(v_i&0x02)) v_j |= v_row2[1];
    if(0==(v_i&0x04)) v_j |= v_row2[2];
    if(0==(v_i&0x08)) v_j |= v_row2[3];
    if(0==(v_i&0x10)) v_j |= v_row2[4];
    if(0==(v_i&0x20)) v_j |= v_row2[5];
    c2d[v_i] = v_j & 0x33; // горизонталь в короткую вертикаль                    
    v_i++;
  } while(v_i!=64);
}

//---------------------------------------------------------------------------
// Нажатие или отпускание кнопки
// Использует v_i, v_a, c_u

void pressRelease() {
  if(v_j) {
    // Нажатие

    // Если максимум клавин нажат, выходим
    if(pressedCnt == pressedMax) return;

    // Если клавиша уже нажата, выходим
    for(v_i=0; v_i<pressedCnt; v_i++)
      if(pressed[v_i]==v_a) {
        v_i=1; 
        return;              
      }

    // Сохраняем клавишу в массив
    pressed[pressedCnt++] = v_a; 

    // Нажата кнопка переключения раскладок
    if(decode[v_a] & K_MODE) mode1 ^= M_QWERT;

    // Нажата кнопка переключения раскладок
    if(decode[v_a] & K_MXMODE) mode1 ^= M_MX;

    // Загружаем привязки из EEPORV
    if(decode[v_a] & (K_MODE | K_MXMODE)) {
      updateLeds();
      loadDecode(); // Портит: v_i, v_a, v_u;
    }
    
    v_i=0;
  } else {
    // Отпускание
    for(v_i=0; v_i<pressedCnt; v_i++)
      if(pressed[v_i]==v_a) {
        pressedCnt--;
        for(;v_i<pressedCnt; v_i++)
          pressed[v_i] = pressed[v_i+1];  
        v_i=0; 
        return;
      }       
    v_i=1;
  }  
}

//---------------------------------------------------------------------------
// Обновляем данные на выходах МК. 
// Портит: v_i, v_j

void updatePorts() {
  intTrigger = 1;
  if(scanMode) {  
    v_i = PINC & 0x3F;
    DDRB = c2b[v_i], DDRD = c2d[v_i] | prepared_ddrd;
  } else {
    DDRC = b2c[(unsigned char)PINB] | d2c[PIND & 0x33];
  }
  intTrigger = 0;
}

//---------------------------------------------------------------------------
// Прерывание от компьютера.
// НАДО ПЕРЕМЕНСТИ РУЧКАМИ В ТАБЛИЦУ ПРЕРЫВАНИЙ! Это даст ускорение в 4 такта

interrupt [EXT_INT0] void ext_int0() {
#asm
.EQU PIND  = $10
.EQU DDRD  = $11
.EQU PORTD = $12
.EQU PINC  = $13
.EQU DDRC  = $14
.EQU PORTC = $15
.EQU PINB  = $16
.EQU DDRB  = $17
.EQU PORTB = $18
        ; На входе R9  = 0
        ; На входе R29 = 2              
        ; Можно использовать регистры R8, R9, R28, R29
        
        ; Переводим PORTC в режим ввода
        OUT  DDRC, R9             ; 1 1
        
        ; Сохраняем флаги попозже, что бы увеличить дистанцию до команды чтения
        IN   R8, SREG             ; 1 2
           
        ; Не хваатет времени, из за большой ймкости монтажа
        NOP

        ; DDRB = c2b[PINC]; 
        IN   R28, PINC            ; 1 3
        ANDI R28, 0x3F            ; +1   Нужна только при включенном RESET и то не факт. 
        CPI  R28, 0x3F            ; 1 4
        BRNE  _v2                 ; 1 5  Если был переход, то 2 такта

        OUT  DDRD, _prepared_ddrd ; 1 6  Сначала записываем DDRD, что бы увеличить дистанцию до команды чтения
        OUT  DDRB, R9             ; 1 7  R9 равен 0         
        ; DDRC = d2c[PIND & 0x33] | b2c[PINB]
    	IN   R28, PIND            ; 1 8  Глюка нет, если заменить на PINB       
    	ORI  R28, $CC             ; 1 9  Инфа передается по линиям 00110011, поэтому маскируем остальные
        LD   R9, Y                ; 2 11 Адрес 0x200+R28+192        
        IN   R28, PINB            ; 1 12
    	LDI  R29, 1               ; 1 13
    	LD   R28, Y               ; 2 15 Адрес 0x100+R28
    	OR   R28, R9              ; 1 16
    	OUT  DDRC, R28            ; 1 17

        ; Режим сканирования и подготовка регистров
        LDI  R29, 2
        CLR  R9
        MOV  _scanMode, R9
        
        ; Если выполняется updatePorts, прерываем её
        OR _intTrigger, _intTrigger
        BRNE  _v3
        
        ; Выход
        OUT  SREG, R8
        RETI
        
_v2:    ; DDRB = c2b[PINC]; 
        LD   R9, Y                ; 2 8 Адрес 0x200+R28
        OUT  DDRB, R9             ; 1 9 

        ; DDRD = (DDRD & 0xCC) | c2d[PINC]; 
        SUBI R28, -64             ; 1 10 
        LD   R28, Y               ; 2 12 Адрес 0x200+R28+64
        OR   R28, _prepared_ddrd  ; 1 13
        OUT  DDRD, R28            ; 1 14 

        ; Режим сканирования и подготовка регистров
        CLR  R9
        MOV  _scanMode, R29
        
        ; Возвращаем ножку сброса
    	LDI  R28, 0x40
    	OUT  DDRC, R28
        
        ; Если выполняется updatePorts, прерываем её
        OR _intTrigger, _intTrigger
        BRNE  _v3
                 
        ; Выход
        OUT  SREG, R8
        RETI
        
_v3:    POP R28        
        POP R28
        MOV _intTrigger, R9 ; =0         
        OUT  SREG, R8
#endasm
}

//---------------------------------------------------------------------------
// Чтение байта из EEPORM

void readEEPROM () {
  while (EECR.1 != 0);
  EEAR = v_u; v_u++;       
  EECR.0 = 1;
  EECR.0 = 0;
}

//---------------------------------------------------------------------------
// Запись байта в EEPORM

void writeEEPROM() {
  while(EECR.1 != 0);
  EEDR = v_a;
  EEAR = v_u; v_u++;       
  EECR.2 = 1;
  EECR.1 = 1;
}

//---------------------------------------------------------------------------
// Чтение раскладки из EEPORT
// Портит: v_i, v_a, v_u;

void loadDecode() {
  v_u = (mode1&M_QWERT)==0 ? 2 : (2+decodeSize*2);
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    readEEPROM();
    ((unsigned char*)decode)[v_i] = EEDR;
  } 
}                       

//---------------------------------------------------------------------------
// Загрузка настроек из EEPORM при включении

void loadSelectedTable() {
  // Читаем нулевой байт
  v_u = 0;
  readEEPROM();

  if(EEDR!=0xEA) {
    // нулевой байт некорректен, это первый запуск контроллера.
    // Записываем в EEPORM значения по умолчанию
    resetDecode();  
    return;
  }
  
  // Читаем номер выбранной раскладки
  v_u = 1;
  readEEPROM();
  mode1 = EEDR;

  // Читаем раскладку из EEPORM в ОЗУ
  loadDecode();
}

//---------------------------------------------------------------------------
// Сохранить привязку в EEPROM
// Портит: v_a, v_i, v_u

void saveDecode() {
  v_u = (mode1&M_QWERT)==0 ? 2 : (2+decodeSize*2);
  for(v_i=0; v_i<decodeSize*2; v_i++) {
    v_a = ((unsigned char*)decode)[v_i];
    writeEEPROM();                 
  } 

  // Сохраняем выбранную раскладку
  v_u = 1;
  v_a = mode1;
  writeEEPROM();
}

//---------------------------------------------------------------------------
// Отпускаем все клавиши эмулируемой клавиатуры
//   Портит: v_i, v_j

void releasePorts() {
  // Сбрасываем матрицы, которые использует прерывание

  v_i=0;
  for(;;) {
    b2c[v_i] = 0;
    v_i++;
    if(v_i==0) break;
  }             

  v_i=0;
  for(;;) {
    d2c[v_i] = 0;
    c2b[v_i] = 0;
    c2d[v_i] = 0;
    v_i++;
    if(v_i==64) break;
  }      
       
  // Сбрасываем порты

  updatePorts(); // Портит: v_i, v_j
}

//---------------------------------------------------------------------------
// Загружаем в EEPORM привязки клавиш по умолчанию
        
void resetDecode() {  
  mode1 = M_QWERT;
  for(v_i=0; v_i<decodeSize; v_i++)
    decode[v_i] = decodeR_std[v_i];  
  saveDecode();

  mode1 = 0;
  for(v_i=0; v_i<decodeSize; v_i++)
    decode[v_i] = decodeE_std[v_i];  
  saveDecode();

  v_u = 0;
  v_a = 0xEA;
  writeEEPROM();
}

//---------------------------------------------------------------------------
// Мигаем светодиодами

void demo() {
  v_leds=1; ps2_setLeds(); delay_ms150();
  v_leds=4; ps2_setLeds(); delay_ms150();
  v_leds=2; ps2_setLeds(); delay_ms150();
}

//---------------------------------------------------------------------------
// Режим настройки привязки клавиш

void programmMode() {      
  // Должна быть нажата одна клавиша
  if(pressedCnt != 1) return;
  
  // Отпускаем все клавиши эмулируемой клавиатуры
  releasePorts();
                         
  // Мигаем светодиодами
  demo();
  v_leds=7; ps2_setLeds();
            
  // Получаем от пользователя код
  v_leds = 0; 
  for(;;) {
    ps2_firstRecv(); 
    if(v_a==0xE0) ps2_continueRecv();
    if(v_a==0xF0) {
      ps2_continueRecv();
      continue;
    }
    ps2_transmitMode();
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
      case 0x5A: goto break2;      
      default: goto exit;
    }  
    v_leds *= 10;
    v_leds += v_a;
  }
break2:      

  WDT_OFF()
  
  // Обабатываем код
  switch(v_leds) {
    case 65534: resetDecode();
    case 65535: saveDecode(); break;
    default: decode[pressed[0]] = v_leds; break; 
  }
  
exit:                
  // Мигаем светодиодами
  demo();
  updateLeds();
  
  pressedCnt=0;

#asm
  WDR
#endasm
  WDT_ON()
}

//---------------------------------------------------------------------------

const int ISC00 = 0;
const int ISC01 = 1;
const int INT0  = 6;

void main(void) {
  WDT_OFF();

  // Настраиваем порты ввода-вывода    

  DDRB  = 0;
  DDRC  = 0b01000000; // RESET
  DDRD  = 0;
  PORTB = 0;
  PORTC = 0b00000000; // RESET
  PORTD = 0;     
  PORTD.KEY_HP = 1;
  DDRD.KEY_HP = 1;
#ifdef KEY_RESET
  PORTD.KEY_RESET = 1;
  DDRD.KEY_RESET = 1;
#endif

  // Сброс переменных

  mode1      = 0;
  pressedCnt = 0;  

  // Загрузка настроек из EEPROM

  loadSelectedTable();  

  // Сброс клавиатуры

#asm
  WDR
#endasm
  WDT_ON();
  
  ps2_reset();
  updateLeds();

  // Настройка прерывания

  MCUCR |= (1<<ISC01)|(0<<ISC00); // Прерывание по спаду
  GICR  |= (1<<INT0);

  // Задаем значения переменных для прерывания и включаем прерывание
   
  prepared_ddrd = DDRD & 0xCC;
  intTrigger = 0;
  releasePorts();
  #asm
    LDI  R29, 2
    CLR  R9
    SEI
  #endasm

  // Сброс компьютера (завершение)

  delay_ms300();
  PORTC = 0b01000000; // RESET

  // Основной цикл  

  for(;;) {          
    // Прием байта

    ps2_firstRecv();
            
    // Обработка кнопки Break

    if(v_a==0xE1) {
      // Вот такой скан код у этой кнопки

      ps2_continueRecv(); if(v_a!=0x14) reboot();
      ps2_continueRecv(); if(v_a!=0x77) reboot();
      ps2_continueRecv(); if(v_a!=0xE1) reboot();
      ps2_continueRecv(); if(v_a!=0xF0) reboot();     
      ps2_continueRecv(); if(v_a!=0x14) reboot();     
      ps2_continueRecv(); if(v_a!=0xF0) reboot();     
      ps2_continueRecv(); if(v_a!=0x77) reboot();
      ps2_transmitMode();

      // Переходим в режим настройки привязки клавиш
        
      programmMode();
      continue;    
    }
                            
    // Код 0xE0 предшествует расширенной кнопке

    v_ext = 0;
    if(v_a==0xE0) { v_ext=1; ps2_continueRecv(); }

    // Код 0xF0 отправляется, когда кнопка отпущена
        
    if(v_a==0xF0) {
      ps2_continueRecv(); // Эта функция портит все переменные кроме v_ext 
      v_j = 0;
    } else {
      v_j = 1;
    }           
    
    ps2_transmitMode();


    // Сжатие 512 сканкодов в 109 сканкодов

    compact();
    if(v_a == 0xFF) continue;

    // Добавляем или удаляем клавишу из массива v_pressed
    // И загружаем альтернативную таблицу переводидования из EEPROM, если
    // нажата соответствующая клавиша

    pressRelease();
    if(v_i) continue;

    // Преобразование кодов клавиш Специалиста в матрицу нажатых клавиш.

    calc();

    // Обновляем данные на выходах МК. 

    updatePorts();
  }
}  