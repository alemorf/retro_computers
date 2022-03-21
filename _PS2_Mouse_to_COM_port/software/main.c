// (с) 30-08-2015 Morozov Aleksey
// aleksey.f.morozov@gmail.com
// AS IS

#include <mega8.h>
#include <delay.h>
#include <stdint.h>

//===========================================================================
// PS/2 порт
//===========================================================================

#define PS2_BUF_SIZE 16  // Размер приёмного буфера PS/2 порта

#define PS2_CLK_PORT  PORTD.2 // Ножка к которой подлючен тактовый сиг. PS/2
#define PS2_CLK_DDR   DDRD.2
#define PS2_CLK_PIN   PIND.2
#define PS2_DATA_PORT PORTD.4 // Ножка к которой подлючен сигнал данных PS/2 
#define PS2_DATA_DDR  DDRD.4
#define PS2_DATA_PIN  PIND.4

enum ps_state_t { ps2_state_error, ps2_state_read, ps2_state_write };

uint8_t ps2_state;                // состояние порта (ps_state_t)
uint8_t ps2_bitcount;             // счётчик битов обработчика
uint8_t ps2_data;                 // буфер на байт
uint8_t ps2_parity;
uint8_t ps2_rx_buf[PS2_BUF_SIZE]; // Приемный буфер PS/2 порта
uint8_t ps2_rx_buf_w;
uint8_t ps2_rx_buf_r;
uint8_t ps2_rx_buf_count;

//---------------------------------------------------------------------------
// Сохранить принятый байт в буфер приёма PS/2 порта. Вызывается только из
// обработчика прерывания.

void ps2_rx_push(uint8_t c) {
    // Если буфер переполнен и потерян байт, то программа не сможет правильно 
    // расшифровать все дальнейшие пакеты, поэтому перезагружаем контроллер.
    if(ps2_rx_buf_count >= sizeof(ps2_rx_buf)) {
	    ps2_state = ps2_state_error;
	    return;
    }
    // Сохрраняем в буфер
    ps2_rx_buf[ps2_rx_buf_w] = c;
    ps2_rx_buf_count++;
    if(++ps2_rx_buf_w == sizeof(ps2_rx_buf)) ps2_rx_buf_w = 0;
}

//---------------------------------------------------------------------------
// Получить байт из приёмного буфера PS/2 порта

uint8_t ps2_aread(void) {
    uint8_t d;
    // Выключаем прерывания, так как обработчик прерывания 
    // то же модифицирует эти переменные.
    #asm("cli")
    // Если буфер пуст, возвращаем ноль
    if(ps2_rx_buf_count == 0) {
        d = 0;
    } else {
        // Читаем байт из буфера
        d = ps2_rx_buf[ps2_rx_buf_r];
        ps2_rx_buf_count--;
        if(++ps2_rx_buf_r == sizeof(ps2_rx_buf)) ps2_rx_buf_r = 0;
    }
    // Включаем прерывания
    #asm("sei")
    return d;
}

//---------------------------------------------------------------------------
//проверка, буфер мыши пустой?

uint8_t ps2_ready(void) {
    return ps2_rx_buf_count;
}

//---------------------------------------------------------------------------
// Вычисление бита чернсоти

uint8_t parity(uint8_t p) {
    p = p ^ (p >> 4 | p << 4);
    p = p ^ (p >> 2);
    p = p ^ (p >> 1);
    return (p ^ 1) & 1;
}

//---------------------------------------------------------------------------
// Изменение тактового сигнала PS/2

#ifndef NO_INT
interrupt [EXT_INT0]
#endif
void ext_int0_isr(void) {
    if(ps2_state == ps2_state_error) return;

    if(ps2_state == ps2_state_write) {
        switch(ps2_bitcount) {
            default: // Данные
                PS2_DATA_DDR = (ps2_data & 1) ^ 1;
                ps2_data >>= 1;
                break;
            case 3: // Бит четности
                PS2_DATA_DDR = ps2_parity ^ 1;
                break;
            case 2: // Стоп бит
                PS2_DATA_DDR = 0;
                break;
            case 1: // Подтверждение приёма
                if(PS2_DATA_PIN) ps2_state = ps2_state_error;
                            else ps2_state = ps2_state_read; 
                ps2_bitcount = 12;
        } 
    } else {
        switch(ps2_bitcount) {
            case 11: // Старт бит
                if(PS2_DATA_PIN) ps2_state = ps2_state_error;
                break;
            default: // Данные
                ps2_data >>= 1;
                if(PS2_DATA_PIN) ps2_data |= 0x80;
                break;
            case 2: // Бит четности 
                if(parity(ps2_data) != PS2_DATA_PIN) ps2_state = ps2_state_error;
                break;
            case 1: // Стоп бит 
                if(PS2_DATA_PIN) ps2_rx_push(ps2_data);
                            else ps2_state = ps2_state_error;  
                ps2_bitcount = 12;
        }
    }
    ps2_bitcount--;
}

//---------------------------------------------------------------------------
// Инициализация PS/2

void ps2_init(void) {
    // Переключаем PS/2 порт на приём
    PS2_CLK_DDR = 0;
    PS2_DATA_DDR = 0;
    
    // Очищаем приёмный буфер
    ps2_rx_buf_w = 0;
    ps2_rx_buf_r = 0;
    ps2_rx_buf_count = 0;
    
    // Устаналиваем переменные обработчика прерывания
    ps2_state = ps2_state_read;
    ps2_bitcount = 11;

    // Прерывание по срезу тактового сигнала
    GIFR = 0x40;
    GICR |= 0x40;
    MCUCR = (MCUCR & 0xFC) | 2;
}

//---------------------------------------------------------------------------
// Отправка байта в PS/2 порт без подтверждения

void ps2_write(uint8_t a) {
    // Отключаем прерывание по изменению тактового сигнала PS/2
    GIFR = 0x40;
    GICR &= 0xBF;

    // Замыкаем тактовый сигнал PS/2 на землю
    PS2_CLK_PORT = 0;
    PS2_CLK_DDR = 1;

    // ждём в течение 100 мкс
    delay_us(100);

    // Замыкаем линию данных PS/2 на землю
    PS2_DATA_PORT = 0;
    PS2_DATA_DDR = 1;

    // Освобождаем тактовый сигнал
    PS2_CLK_DDR = 0;

    // Очищаем приёмный буфер
    ps2_rx_buf_count = 0;
    ps2_rx_buf_w = 0;
    ps2_rx_buf_r = 0;

    // Настраиваем переменные обработчика прерывания
    ps2_state = ps2_state_write;
    ps2_bitcount = 11;
    ps2_data = a;             
    ps2_parity = parity(a);

    // Включаем прерывание по срезу тактового сигнала PS/2
    GIFR = 0x40;
    GICR |= 0x40;
    MCUCR = (MCUCR & 0xFC) | 2;    
}

//---------------------------------------------------------------------------
// Получение байта из PS/2 порта с ожиданием

uint8_t ps2_recv(void)
{
    while(ps2_rx_buf_count == 0);
    return ps2_aread();
}

//---------------------------------------------------------------------------
// Отправка байта в PS/2 порт с подтверждением

void ps2_send(uint8_t c) {
    ps2_write(c);
    if(ps2_recv() != 0xFA) ps2_state = ps2_state_error;
}

//===========================================================================
// RS232 порт
//===========================================================================

#define RS232_TX_BUFFER_SIZE 16

uint8_t rs232_tx_buf[RS232_TX_BUFFER_SIZE];
uint8_t rs232_tx_buf_w;
uint8_t rs232_tx_buf_r;
uint8_t rs232_tx_buf_count;
uint8_t rs232_reset;
uint8_t rs232_enabled;

#pragma used+
void rs232_send(uint8_t c) {
    // Ожиданиие, если буфер переполнен
    while(rs232_tx_buf_count == sizeof(rs232_tx_buf));

    // Выключаем прерывания, так как обработчик прерывания 
    // то же модифицирует эти переменные.
    #ifndef NO_INT
    #asm("cli")
    #endif

    // Если передача уже идет или в буфере передачи что то есть,
    // то сохраняем в буфер значение
    if (rs232_tx_buf_count || ((UCSRA & (1 << UDRE)) == 0)) {
        rs232_tx_buf[rs232_tx_buf_w] = c;
        if(++rs232_tx_buf_w == sizeof(rs232_tx_buf)) rs232_tx_buf_w = 0;
        rs232_tx_buf_count++;
    } else {
        // Иначе выводим значение в порт
        UDR = c;
    }

    // Включаем прерывания
    #ifndef NO_INT
    #asm("sei")
    #endif
}
#pragma used-

//---------------------------------------------------------------------------
// COM-порт отправил байт

#ifndef NO_INT
interrupt [USART_TXC] 
#endif
void rs232_interrupt(void) {
    // Если буфер пуст, то ничего не делаем
    if(!rs232_tx_buf_count) return;

    // Иначе отправляем байт из буфера
    --rs232_tx_buf_count;
    UDR = rs232_tx_buf[rs232_tx_buf_r];
    if(++rs232_tx_buf_r == sizeof(rs232_tx_buf)) rs232_tx_buf_r = 0;
}

//---------------------------------------------------------------------------
// Измененилось состояние линий DTR или RTS

#ifndef NO_INT
interrupt [EXT_INT1] 
#endif
void ext_int1_isr(void) {
    // Сохраняем состояние в переменную
    rs232_enabled = (PIND & 8) ? 0 : 1;
    // Сохраняем признак сброса
    rs232_reset = 1;          
}

//===========================================================================
// Наплатный светодиод
//===========================================================================

#ifndef NO_INT
#define PORT_LED PORTB.3
#endif

// Включить светодиод
void flash_led(void) {
    PORT_LED = 0;
    TCNT2 = 0x00;
    TCCR2 = 0x37;
}

//---------------------------------------------------------------------------
// Выключение светодиода через некоторое время

#ifndef NO_INT
interrupt [TIM2_OVF]
#endif
void timer2_ovf_isr(void) {
    TCCR2 = 0;
    PORT_LED = 1;
}

//===========================================================================
// Инициализация PS/2 мыши
//===========================================================================

uint8_t  ps2m_protocol;   // Используемый протокол: 0=без колеса, 1=с колесом
uint8_t  ps2m_multiplier; // Масштабирование координат
uint8_t  ps2m_b;          // Нажатые кнопки
int16_t  ps2m_x, ps2m_y, ps2m_z; // Координаты

//---------------------------------------------------------------------------
// Инициализация PS/2 мыши

void ps2m_init() {
    // Посылаем команду "Сброс".
    ps2_send(0xFF);
    if(ps2_recv() != 0xAA) { ps2_state = ps2_state_error; return; }
    if(ps2_recv() != 0x00) { ps2_state = ps2_state_error; return; }

    // Включаем колесо и побочно устаналвиаем 80 пакетов в секунду.    
    ps2_send(0xF3);
    ps2_send(0xC8);
    ps2_send(0xF3);
    ps2_send(0x64);
    ps2_send(0xF3);
    ps2_send(0x50);

    // Узнаем, получилось ли включить колесо
    ps2_send(0xF2);
    ps2m_protocol = ps2_recv() ? 1 : 0;

    // Разрешение 8 точек на мм
    ps2_send(0xE8);
    ps2_send(0x03);

    // 20 значений в сек (мышь игнорирует эту команду)
    ps2_send(0xF3);
    ps2_send(20);
               
    // Включаем потоковый режим.
    ps2_send(0xF4);
}

//---------------------------------------------------------------------------
// Обработка поступивших с PS/2 порта данных

void ps2m_process() {
    while(ps2_ready() >= (3 + ps2m_protocol)) {
        ps2m_b = ps2_aread() & 7; //! Тут старшие биты!!!
        ps2m_x += (int8_t)ps2_aread();
        ps2m_y -= (int8_t)ps2_aread();
        if(ps2m_protocol) ps2m_z += (int8_t)ps2_aread();
    }
}          

//===========================================================================
// Наплатные кнопки
//===========================================================================

#define BUTTONS_TIMEOUT 50

uint8_t buttons_disabled = 0;    // Таймаут для предотвращения дребезга
uint8_t pressed_button   = 0xFF; // Последняя нажатая кнопка

// Периодический опрос наплатных кнопок
#ifndef NO_INT
interrupt [TIM0_OVF] 
#endif
void timer0_ovf_isr(void) {
    uint8_t b = (PINB & 7) ^ 7;
    if(!buttons_disabled) {
        if(b & 1) pressed_button = 0; else
        if(b & 2) pressed_button = 1; else
        if(b & 4) pressed_button = 2; else return;
    }
    if(b) buttons_disabled = BUTTONS_TIMEOUT;
    buttons_disabled--;
}

//===========================================================================
// Интерфейс с компьютером
//===========================================================================

uint8_t rs232m_protocol; // Используемый протокол: 0=MSMouse, 1=EM84520

const uint8_t EM84520_ID[61] = {
    0x4D, 0x5A, 0x40, 0x00, 0x00, 0x00, 0x08, 0x01, 0x24, 0x25, 0x2D, 0x23,
    0x10, 0x10, 0x10, 0x11, 0x3C, 0x3C, 0x2D, 0x2F, 0x35, 0x33, 0x25, 0x3C,
    0x30, 0x2E, 0x30, 0x10, 0x26, 0x10, 0x21, 0x3C, 0x25, 0x2D, 0x23, 0x00,
    0x33, 0x23, 0x32, 0x2F, 0x2C, 0x2C, 0x29, 0x2E, 0x27, 0x00, 0x33, 0x25,
    0x32, 0x29, 0x21, 0x2C, 0x00, 0x2D, 0x2F, 0x35, 0x33, 0x25, 0x21, 0x15,
    0x09
};

//---------------------------------------------------------------------------

void rs232m_init() {
    // Протокол определяется перемычкой на плате
    rs232m_protocol = (PIND & 0x80) ? 0 : 1;

    // Настройка RS232: 1200 бод, 1/2 стоп бита, 7 бит, нет четсноти
    UCSRA = 0;
    UCSRB = 0x48;
    UCSRC = rs232m_protocol ? 0x8C : 0x84; 
    UBRRH = 0x02;
    UBRRL = 0xFF;
    
    // По умолчанию включен
    rs232_enabled = 1;

    // Вывести приветствие
    rs232_reset = 1;    
}

//---------------------------------------------------------------------------

void rs232m_send(int8_t x, int8_t y, int8_t z, uint8_t b) {
    uint8_t i, lb, rb, mb;
    static uint8_t mb1;
    
    // Обработка сброса      
    if(rs232_reset) {
        rs232_reset = 0; 
        delay_ms(14);
        if (rs232m_protocol) {
            // Приветствие EM84520
            for(i=0; i<sizeof(EM84520_ID); i++)
                rs232_send(EM84520_ID[i]);
        } else {
            // Приветствие Logitech/Microsoft Plus
            rs232_send(0x4D);
            delay_ms(63);
            rs232_send(0x33);
        }
    }
    
    // Клавиши мыши
    lb = b & 1;
    rb = (b >> 1) & 1;
    mb = (b >> 2) & 1;

    // Стандартная часть протокола 
    rs232_send((1 << 6) | (lb << 5) | (rb << 4) | ((y & 0xC0) >> 4) | ((x & 0xC0) >> 6));
    rs232_send(x & 0x3F);
    rs232_send(y & 0x3F);
    
    if(rs232m_protocol) {
        // Расширение EM84520
        rs232_send((mb << 4) | (z & 0x0F));
    } else { 
        // Расширение Logitech/Microsoft Plus
        if(mb || mb1) {
            rs232_send(mb << 5);
            mb1 = mb;
        }
    }                    
}

//===========================================================================
// Программа
//===========================================================================

void init(void) {
    // Настройка портов ввода-вывода и подтягивающих резисторов
    DDRB = 0x08; PORTB = 0x3F;
    DDRC = 0x00; PORTC = 0x7F;
    DDRD = 0x02; PORTD = 0xE2;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 57,600 kHz
    TCCR0 = 4;
    TCNT0 = 0;

    // Таймер 2
    ASSR = 0; TCCR2 = 7; TCNT2 = 0; OCR2 = 0;

    // Включение прерывания по изменению на входе INT1
    GICR |= 0x80; MCUCR = 0x04; GIFR = 0x80;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK = 0; 
    
    // Вклчюаем прерывания от таймеров 0 и 2
    TIMSK |= 0x41;                       

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR = 0x80;
    SFIOR = 0;

    // Настройка Watchdog-таймера
    #pragma optsize-
    WDTCR = 0x1E;
    WDTCR = 0x0E;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Включение прерываний
    #ifndef NO_INT
    #asm("sei")
    #endif
}

//---------------------------------------------------------------------------

eeprom uint8_t eeprom_ps2m_multiplier;

void main(void) {
    int8_t cx, cy, cz;
    uint8_t mb1=0;
    
    // Восстанавлиаем настройки
    ps2m_multiplier = eeprom_ps2m_multiplier;
    if(ps2m_multiplier > 2) ps2m_multiplier = 1; 
    
    // Запуск
    init();
    
    // Запуск PS/2 порта
    ps2_init();
    
    // Запуск протокола PS/2 мыши
    ps2m_init();
    
    // Запуск RS232 порта и протокола COM-мыши
    rs232m_init();
    
    // подмигнём после инициализации
    flash_led();    

    for(;;) {
        // читаем данные из PS/2
        ps2m_process();
        
        // Регулирование скорости мыши прямо с мыши
        if(rs232m_protocol==0 && (ps2m_b & 3) == 3)
        {
            if(ps2m_z < 0) { if(ps2m_multiplier > 0) ps2m_multiplier--; ps2m_z=0; } else
            if(ps2m_z > 0) { if(ps2m_multiplier < 2) ps2m_multiplier++; ps2m_z=0; }
        }
        
        // Отправляем копьютеру пакет, если буфер отпрваки пуст, мышь включена, 
        // изменились нажатые кнопки или положение мыши
        if(rs232_enabled)
        if(ps2m_b != mb1 || ps2m_x != 0 || ps2m_y != 0 || ps2m_z != 0 || rs232_reset) {
            if(rs232_tx_buf_count == 0) {
                cx = ps2m_x<-128 ? -128 : (ps2m_x>127 ? 127 : ps2m_x); ps2m_x -= cx;
                cy = ps2m_y<-128 ? -128 : (ps2m_y>127 ? 127 : ps2m_y); ps2m_y -= cy;
                cz = ps2m_z<-8   ? -8   : (ps2m_z>7   ?   7 : ps2m_z); ps2m_z -= cz;
                mb1 = ps2m_b;
                rs232m_send(cx, cy, cz, ps2m_b);
            } else {
                flash_led();
            }
        }

        // Обработка наплатных кнопок
        if(pressed_button != 0xFF) {
            ps2m_multiplier = pressed_button;
            eeprom_ps2m_multiplier = ps2m_multiplier;
            flash_led();
            pressed_button = 0xFF;
        }
                   
        // В случае ошибки перезагружаемся
        if(ps2_state != ps2_state_error) {
           #ifndef NO_INT
           #asm("wdr");
           #endif
        }
    }
}
