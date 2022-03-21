#include MAX_MUOUSE_MULTIPLIER 3

//Либза для работы с мышой PS/2
//На основе документа AVR313: Interfacing the PC AT Keyboard  
//и информации из http://www.computer-engineering.org

#include <mega8.h>
#include <delay.h>

//Длина асинхронного буфера ввода-вывода для PS/2
#define BUFF_SIZE 16

//Дефайны для мыша. Ноги PS/2
#define P_CLK  PORTD.2
#define P_DATA PORTD.4
#define P_CLK_DIR  DDRD.2
#define P_DATA_DIR DDRD.4
#define CLK_READ PIND.2
#define DATA_READ PIND.4

//возможные состояния порта
#define PS2error 0
#define PS2read  1
#define PS2write 2

unsigned char ps2state; //состояние порта (читаю/пишу/облом)
unsigned char edge; //выбор полярности перепада для обработчика прерывания (фронт/срез)
unsigned char bitcount; //счётчик битов обработчика
static unsigned char data;//буфер на байт
unsigned char ms_buffer[BUFF_SIZE];
unsigned char *ms_input, *ms_output; //указатели для буфера
unsigned char buffcnt; //счётчик буфера данных

//запихнуть байт в буфер мыши
void PS2put(unsigned char c)
{
    if (buffcnt >= BUFF_SIZE) return;
    buffcnt++;
    *ms_input++ = c; // Запихнём в него байт
    if(ms_input == ms_buffer + BUFF_SIZE) ms_input = ms_buffer;
}

// вытянуть байт из буфера мыши
unsigned char PS2get(void)
{
    unsigned char byte;
    if(buffcnt == 0) return 0;
    buffcnt--;
    byte = *ms_output++;
    if (ms_output >= ms_buffer + BUFF_SIZE)
        ms_output = ms_buffer;
    return byte;
}

//проверка, буфер мыши пустой?
unsigned char PS2ready(void)
{
    return buffcnt;
}

//вычисляет бит чётности
unsigned char Parity(unsigned char p)
{
    p = p ^ (p >> 4 | p << 4);
    p = p ^ (p >> 2);
    p = p ^ (p >> 1);
    return (p ^ 1) & 1;
}

//Вставить это в обработчик прерывания CLK PS/2
void ProcessPS2(void)
{
    //при записи временно хранит бит чётности
    static unsigned char par;

    if (ps2state == PS2read) //обработчик чтения
    {

        if (!edge) //обработка по срезу импульса CLK
        {

            if (bitcount == 11) //проверяем старт-бит
            {
                if (DATA_READ) ps2state = PS2error; //нет старт-бита? Значит что-то пошло не так 
            }

            if((bitcount < 11) & (bitcount > 2))//Перекидываем значащие биты в буфер
            {
                data = (data >> 1);
                if (DATA_READ) data = data | 0x80;
            }

            if (bitcount == 2) //проверяем бит чётности
            {
                if (Parity(data) != DATA_READ)
                ps2state = PS2error; //чётность не совпадает? Значит что-то пошло не так 
            }

            if (bitcount == 1) //проверяем стоп-бит
            {
                if (DATA_READ == 0) ps2state = PS2error; //нет стоп-бита? Значит что-то пошло не так 
            }

            MCUCR = (MCUCR & 0xFC) | 3;//Переводим внешнее прерывание в режим по фронту
            edge = 1;//А также меняем и контекст, выполняемый обработчиком
        } else { // обработка по фронту импульса CLK
            MCUCR = (MCUCR & 0xFC) | 2;//Переводим внешнее прерывание в режим по срезу
            edge = 0;//А также меняем и контекст, выполняемый обработчиком
            if(--bitcount == 0)//Все биты поыслки приняты?
            {
                PS2put(data);
                bitcount = 11; //взводим счётчик битов заново
            }
        }
    }
    if (ps2state == PS2write) //обработчик записи
    {
        if (!edge) //обработка по срезу импульса CLK
        {
            if (bitcount == 11) //в самом начале сразу посчитаем бит чётности на будущее
                par = Parity(data);
            if((bitcount <= 11) & (bitcount > 3))//Перекидываем значащие биты в ногу DATA
            {
                P_DATA_DIR = (data & 1)^1;
                data = (data >> 1);
            }
            if (bitcount == 3) //Перекидываем бит чётности
                P_DATA_DIR = par ^ 1;
            if (bitcount == 2) //Формируем стоп-бит
                P_DATA_DIR = 0;
            if (bitcount == 1) //Напоследок проверим приход ACK
                if (DATA_READ) ps2state = PS2error; //нет ACK? Значит что-то пошло не так 

            MCUCR = (MCUCR & 0xFC) | 3;//Переводим внешнее прерывание в режим по фронту
            edge = 1;//А также меняем и контекст, выполняемый обработчиком
        } else {
            MCUCR = (MCUCR & 0xFC) | 2;//Переводим внешнее прерывание в режим по срезу
            edge = 0;//А также меняем и контекст, выполняемый обработчиком

            if(--bitcount == 0)//Все биты поыслки переданы?
            {
                ps2state = PS2read; //переходим в режим чтения
                bitcount = 11; //и взводим счётчик битов заново
            }
        }
    }
}

// Инициализация PS/2
void InitPS2(void)
{
    // делаем ноги PS/2 входами. При включениии вначале только слушаем.
    P_CLK_DIR = 0;
    P_DATA_DIR = 0;

    ms_input = ms_buffer; // Устанавливаем указатели на буфер
    ms_output = ms_buffer;
    buffcnt = 0;

    GIFR = 0x40;
    GICR |= 0x40;
    MCUCR = (MCUCR & 0xFC) | 2;//Устанавливаем внешнее прерывание в режим по срезу

    ps2state = PS2read; //Устанавливаем задачу - чтение
    edge = 0; //устанавлваем контекст, выполняемый обработчиком (работа по срезу CLK)
    bitcount = 11; //взводим счётчик битов
}

//Запись байта в PS/2
void WritePS2(unsigned char a)
{
    //временно вырубаем прерывания от CLK
    GIFR = 0x40;
    GICR &= 0xBF;

    //тянем CLK на землю
    P_CLK = 0;
    P_CLK_DIR = 1;

    //чистим буфер мыши
    while (PS2ready())
    PS2get();

    //будем писать этот байт
    data = a;

    //ждём в течение 100 мкс
    delay_us(100);

    //тянем DATA на землю
    P_DATA = 0;
    P_DATA_DIR = 1;

    //отпускаем CLK
    P_CLK_DIR = 0;

    GIFR = 0x40;
    GICR |= 0x40;
    MCUCR = (MCUCR & 0xFC) | 2;//Устанавливаем внешнее прерывание в режим по срезу

    ps2state = PS2write; //Устанавливаем задачу - чтение
    edge = 0; //устанавлваем контекст, выполняемый обработчиком (работа по срезу CLK)
    bitcount = 11; //взводим счётчик битов
}

//типовая процедура пропуска подтверждения операции записи в мыша
//(простейшее ожидание и проверка ответа "0xFA")
void FAskip(void)
{
    while (PS2ready() < 1) ; //ждём ответ
    if (PS2get() != 0xFA) ps2state = PS2error; //проверяем ответ
}

unsigned char ps2_recv()
{
    while (PS2ready() < 1) ; //ждём ответ
    return PS2get();
}

void ps2_send(unsigned char x)
{
    WritePS2(x);
    FAskip();
}

// Инициализация мыши. Возвращает 0/1, если мышь возващает 3/4 байта.

unsigned char mouse_init()
{
    unsigned char sample_rate; //сохраняет значение скорости выдачи данных
    unsigned char has_wheel; 

    InitPS2(); // вначале инициализация интерфейса

    // Сброс мышки
    ps2_send(0xFF);
    if(ps2_recv() != 0xAA) ps2state = PS2error;
    if(ps2_recv() != 0x00) ps2state = PS2error;

    // Запомним скорость выдачи информации
    ps2_send(0xFF);
    ps2_recv(); //статус кнопок не интересует
    ps2_recv(); //разрешение не интересует
    sample_rate = ps2_recv(); //запоминаем значение скорости выдачи данных 

    // Включаем расширенный режим мыши, в котором работает колесо
    ps2_send(0xF3);
    ps2_send(0xC8);
    ps2_send(0xF3);
    ps2_send(0x64);
    ps2_send(0xF3);
    ps2_send(0x50);

    // Включился ли расширенный режим?
    ps2_send(0xF2);
    has_wheel = ps2_recv() ? 1 : 0;

    // Установим скорость выдачи данных
    ps2_send(0xF3); 
    ps2_send(sample_rate);
    
    // Устанавливаем самое высокое разрешение 8 значений на 1 мм 
    ps2_send(0xE8);
    ps2_send(0x03); 
              
    // Включаем потоковый режим передачи
    ps2_send(0xF4);
              
    return has_wheel;
}

/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : PS/2 to COM converter
Version : 2.2
Date    : 01.03.2015
Author  : E.J.SanYo
Company : 
Comments: 
История изменений

29.04.2015 2.2.1:
           Маленький багфикс. Иногда раньше переходник мог пропустить
           клик мыши - исправлено.

01.03.2015 2.2:
           Сделан "более умный" алгоритм пропуска пакетов PS/2, 
           гарантирующий, что пакеты с нажатиями или с колесом
           пропущены не будут. Благодаря этому стало возможным пустить
           частоту выборок PS/2 с "родной" для этого интерфейса скоростью.
           (убирает проблемы с буферизацией пакетов в некоторых мышах).
           При этом из-за снижения относительной чувствительности 
           добавлена функция "умного масштабирования" перемещения.

27.02.2015 2.1:
           Скорректированы значения частоты посылок PS/2 для разных
           режимов работы. Добавлена регулировка чувствительности с
           кнопок программным методом (деление перемещения на коэффициент).
           Добавлена простая защита от переполнения буфера COM порта.
           Вновь добавлен watchdog для сброса при зависании обмена по PS/2. 

26.02.2015 2.1 alpha:
           Полностью переработан алгоритм работы с PS/2. Перевод 
           его на работу по прерываниям, практически асинхронно 
           от основгого цикла программы. Реализован нормальный 
           потоковый режим работы мыши. Временно убрана регулировка
           чувствительности. Остальной функционал сохранён.

22.02.2015 2.00 beta:
           Добавлен экспериментальный режим эмуляции чипа EM84520
           (мышь со скроллером). Активируется замкнутым джампером
           при включении питания

20.02.2015 2.00 alpha2:
           Добавлено подмигивание светодиодом при приёме данных по PS/2.

19.02.2015 2.00 alpha:
           Порт предыдущей версии прошивки под новую схемотехнику.

24.11.2014 1.00:
           Добавлен опрос кнопок с "антидребезговым алгоритмом" 
           и подстройка чувствительности мыши ими (4 стандартных значения PS/2.
           Данная настройка может сохраняться в EEPROM контроллера.
           SB1 - увеличить чувствительность, SB2 - уменьшить, SB3 - сохранить

22.11.2014 0.91 alpha 2:
           Коррекция в схемотехнике под "особенности" работы Windows 3.1
           Добавлена поддержка средней кнопки мыши

20.11.2014 0.9 alpha:
           Добавлена буферизация и работа с прерываниями UART по рецепту от CodeVision ;)
           Немного изменены функции работы с PS/2
           Добавлен watchdog на случай, если обмен PS/2 наглухо зависнет 



Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 14,745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

flash char EM84520_ID[61] = {
    0x4D, 0x5A, 0x40, 0x00, 0x00, 0x00,
    0x08, 0x01, 0x24, 0x25, 0x2D, 0x23,
    0x10, 0x10, 0x10, 0x11, 0x3C, 0x3C,
    0x2D, 0x2F, 0x35, 0x33, 0x25, 0x3C,
    0x30, 0x2E, 0x30, 0x10, 0x26, 0x10,
    0x21, 0x3C, 0x25, 0x2D, 0x23, 0x00,
    0x33, 0x23, 0x32, 0x2F, 0x2C, 0x2C,
    0x29, 0x2E, 0x27, 0x00, 0x33, 0x25,
    0x32, 0x29, 0x21, 0x2C, 0x00, 0x2D,
    0x2F, 0x35, 0x33, 0x25, 0x21, 0x15,
    0x09
};

//долговременно хранит значение предделителя для скорости мыша
eeprom unsigned char mouse_multiplier_eeprom;

//тот же делитель, только в ОЗУ для текущих операций
unsigned char ps2_divider_current;

//переменная для выбора протокола
//сейчас 1 - это EM84520, 0 - это logitech
char output_protocol;

//переменная хранит прошлое состояние средней кнопки мыхи
//при использовании M$ Mouse протокола.
char msmb_old = 0;

//бит для разрешения передачи данных от PS/2 в COM
bit rs232_enabled = 1;

//Счётчик для "антидребезга" кнопок
char butt_counter = 0;

//Значение нажатой кнопки
//1 - SB1, 2 - SB2, 3 - SB3, 0 - кнопка не нажата
char butt_value = 0;

void putchar(char c);


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
//выполняем обработку очередного импульса CLK
ProcessPS2();

}

//-------------------------------------------------------------------------------------
// External Interrupt 1 service routine

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    char i;             
    rs232_enabled = !PIND.3; 
    if(rs232_enabled)
    {
        delay_ms(14);
        if(output_protocol)
        {
            // Отправляем приветствие протокола EM84520
            for (i=0; i<sizeof(EM84520_ID); i++)
                putchar(EM84520_ID[i]);
        } else {
            // Отправляем приветствие протокола MS Mouse
            putchar('M');
            delay_ms(63);
            putchar('3');
        }
    }
}

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Transmitter buffer
#define TX_BUFFER_SIZE 16
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
    if (tx_counter)
    {
        --tx_counter;
        UDR = tx_buffer[tx_rd_index];
        if(++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
    };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

//-------------------------------------------------------------------------------------
// Timer 0 overflow interrupt service routine

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    if(button_disabled == 0) return;
    if((PINB & 7) != 7) button_disabled = BUTTON_DISABLED;
    button_disabled--;
}

//-------------------------------------------------------------------------------------
// Timer1 output compare A interrupt service routine

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
}

//-------------------------------------------------------------------------------------
// Таймер гашения светодиода

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    TCCR2 = 0;     // Остановка таймера    
    PORTB.3 = 1;   // Гашение светодиода
}

//-------------------------------------------------------------------------------------
// Отправка пакета по протоколу MS Mouse + Logitech

void SendCoordMS(signed char x, signed char y, char LB, char RB, char MB)
{
    //Стандартная часть протокола 
    putchar((1 << 6) | (LB << 5) | (RB << 4) | ((y & 0xC0) >> 4) | ((x & 0xC0) >> 6));
    putchar(x & 0x3F);
    putchar(y & 0x3F);
    
    // Расширение для 3-й кнопки, известное как Logitech, или Microsoft Plus
    // 3 кнопка нажата или только что отпущена? 
    if (MB || msmb_old)
    {
        putchar(MB << 5);
        msmb_old = MB;
    } 
}

//-------------------------------------------------------------------------------------

//Функция выдаёт инф. пакет по протоколу чипа EM84520
void SendCoordEM84520(signed char x, signed char y, signed char z, char LB, char RB, char MB)
{
    // Стандартная часть протокола, как у M$ mouse 
    putchar((1 << 6) | (LB << 5) | (RB << 4) | ((y & 0xC0) >> 4) | ((x & 0xC0) >> 6));
    putchar(x & 0x3F);
    putchar(y & 0x3F);

    // Расширение чипа EM84520
    putchar((MB << 4) | (z & 0x0F)); 
}

//-------------------------------------------------------------------------------------
//зажигает светик и он светит до тех пор, пока не прервётся таймером

void SetLED(void)
{
    PORTB.3 = 0;
    TCNT2 = 0x00;
    TCCR2 = 0x37;
}

//-------------------------------------------------------------------------------------
// Получить номер нажатой наплатной кнопки

unsigned char get_onboard_button()
{
    unsigned char n;      
    // Устраняем дребезг контактов
    if(button_disabled) return 0;
    // Номер нажатой кнопки
    if(!PINB.0) n=1; else 
    if(!PINB.1) n=2; else
    if(!PINB.2) n=3; else return 0;
    // Если была нажата кнопка, мигнем светодиодом
    SetLED();
    // И некоторое время не реагируем на нажатия
    button_disabled = BUTTON_DISABLED;
    return n;
}

//-------------------------------------------------------------------------------------

void main(void)
{
    char x, y, z, mouse_b;
    short mouse_x, mouse_y, mouse_z;
    char mouse_b_out;
              
    // Инициализация портов
    DDRB = 0x08; PORTB = 0x38;
    DDRC = 0x00; PORTC = 0x7F;
    DDRD = 0x02; PORTD = 0x62;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 57,600 kHz
    TCCR0 = 0x04;
    TCNT0 = 0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 14,400 kHz
    // Mode: CTC top=OCR1A
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: On
    // Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x0D;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x02;
    OCR1AL=0xD0;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 14,400 kHz
    // Mode: Normal top=FFh
    // OC2 output: Disconnected
    ASSR=0x00;
    TCCR2=0x07;
    TCNT2=0x00;
    OCR2=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: On
    // INT1 Mode: Any change
    GICR|=0x80;
    MCUCR=0x04;
    GIFR=0x80;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x51;

    //на этом этапе выбираем протокол эмулируемого COM-овского мыша
    output_protocol = PIND.7 ^ 1;

    // Настройка COM-порта на 1200, 7 Data, No Parity
    UCSRA=0x00;
    UCSRB=0x48;
    UCSRC=output_protocol ? 0x8C : 0x84; // 2 Stop / 1 Stop 
    UBRRH=0x02;
    UBRRL=0xFF;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;

    // Watchdog Timer initialization
    // Watchdog Timer Prescaler: OSC/1024k
    #pragma optsize-
    WDTCR=0x1E;
    WDTCR=0x0E;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Прочитаем значение делителя из EEPROM
    mouse_mul = ps2_divider;
    
    // Скорректируем его значение, если требуется
    if(mouse_mul > 2) mouse_mul = 1; 

    // Global enable interrupts
    #asm("sei")

    //выполняем настройку мыша PS/2
    input_protocol = mouse_init();

    //подмигнём после инициализации
    SetLED();
    
    // Сброс положения мыши
    mouse_x = 0, mouse_y = 0, mouse_z = 0;

    for(;;)
    {
        // Обработка поступающих от PS/2 данных
        if(PS2ready() > (2 + input_protocol))
        {
            mouse_b = PS2get();
            mouse_x += PS2get() * mouse_mul;
            mouse_y -= PS2get() * mouse_mul;
            if(input_protocol) mouse_z += PS2get();

            // подмигнём светиком
            SetLED();
        }
    
        // Отправляем пакет компьютеру
        // - Если буфер отправки пуст (cкорость PS/2 мыши больше, чем COM)
        // - Если компьютер разрешил передачу
        // - Если положение мыши изменилось
        // - Если состояние кнопок изменилось
        if(tx_counter == 0 && rs232_enabled && ((mouse_b != mouse_b_old) || (mouse_x != 0) || (mouse_y != 0) || (mouse_z != 0)))
        {
            // Предотвращаем переполнение и потерю координат
            x = mouse_x<-128 ? -128 : (mouse_x>127 ? 127 : mouse_x); mouse_x -= x;
            y = mouse_y<-128 ? -128 : (mouse_y>127 ? 127 : mouse_y); mouse_y -= y;
            z = mouse_z<-8 ? -8 : (mouse_z>7 ? 7 : mouse_z); mouse_z -= z;
            mouse_b_old = mouse_b;

            // Отправка в COM-порт
            if (output_protocol)
                SendCoordEM84520(x, y, z, mouse_b & 1, (mouse_b >> 1) & 1, (mouse_b >> 2) & 1);
            else
                SendCoordMS(x, y, mouse_b & 1, (mouse_b >> 1) & 1, (mouse_b >> 2) & 1);                
        }
              
        // Обработка клавиш на плате
        switch(get_onboard_button())
        {
            // Нажата кнопка SB1 - Уменьшаем чувствительность мыши
            case 1:
                if(mouse_mul > 0) mouse_mul--;
                break;
            // Нажата кнопка SB2 - Увеличиваем чувствительность мыши
            case 2: 
                if(mouse_mul < MAX_MUOUSE_MULTIPLIER-1) mouse_mul++;
                break;
            // Нажата кнопка SB3 - Сохраняем чувствительность в EEPROM
            case 4:
                mouse_multiplier_eeprom = mouse_mul;
                break;
        }
         
        // Перезагружаемся, если завис PS/2     
        if(ps2state)
        {
            #asm("wdr");
        }
    };
}
