// (с) 30-08-2015 Morozov Aleksey
// aleksey.f.morozov@gmail.com
// AS IS

#include <mega8.h>
#include <delay.h>
#include <stdint.h>
#include <string.h>

#define JOY_SELECT_PORT PORTD.4

//===========================================================================
// PS/2 порт компьютеры
//===========================================================================

volatile uint8_t ps2k_rx_buf[16]; // Приемный буфер PS/2 порта
volatile uint8_t ps2k_rx_buf_w;
volatile uint8_t ps2k_rx_buf_r;
volatile uint8_t ps2k_rx_buf_count;

volatile uint8_t ps2k_tx_buf[16]; // Приемный буфер PS/2 порта
volatile uint8_t ps2k_tx_buf_w;
volatile uint8_t ps2k_tx_buf_r;
volatile uint8_t ps2k_tx_buf_count;

void ps2k_rx_push(uint8_t c) {
    // Если буфер переполнен и потерян байт, то программа не сможет правильно 
    // расшифровать все дальнейшие пакеты, поэтому перезагружаем контроллер.
    if(ps2k_rx_buf_count >= sizeof(ps2k_rx_buf)) return;
    // Сохрраняем в буфер
    ps2k_rx_buf[ps2k_rx_buf_w] = c;
    ps2k_rx_buf_count++;
    ps2k_rx_buf_w = (ps2k_rx_buf_w + 1) % sizeof(ps2k_rx_buf);
}

uint8_t ps2k_ready(void) {
    return ps2k_rx_buf_count;
}

uint8_t ps2k_aread(void) {
    uint8_t d = 0;
    // Выключаем прерывания, так как обработчик прерывания 
    // то же модифицирует эти переменные.
    #asm("cli")
    // Если буфер пуст, возвращаем ноль
    if(ps2k_rx_buf_count != 0) {
        // Читаем байт из буфера
        d = ps2k_rx_buf[ps2k_rx_buf_r];
        ps2k_rx_buf_count--;
        if(++ps2k_rx_buf_r == sizeof(ps2k_rx_buf)) ps2k_rx_buf_r = 0;
    }
    // Включаем прерывания
    #asm("sei")
    return d;
}

void ps2k_write(uint8_t c) {    
    #asm("cli")
    // Если буфер переполнен и потерян байт, то программа не сможет правильно 
    // расшифровать все дальнейшие пакеты, поэтому перезагружаем контроллер.
    if(ps2k_tx_buf_count <= sizeof(ps2k_tx_buf)) {
        // Сохрраняем в буфер
        ps2k_tx_buf[ps2k_tx_buf_w] = c;
        ps2k_tx_buf_count++;
        ps2k_tx_buf_w = (ps2k_tx_buf_w + 1) % sizeof(ps2k_tx_buf);
    }
    #asm("sei")    
}

#define CYCLES_PER_US 8
#define COUNT_UP    (256 - ((33 * CYCLES_PER_US)/8))

#define KEYB_CLOCK_DDR  DDRD.3
#define KEYB_CLOCK_PORT PORTD.3
#define KEYB_DATA_DDR   DDRD.1
#define KEYB_DATA_PORT  PORTD.1

#define clockHigh()    { KEYB_CLOCK_DDR = 0; }
#define clockLow(void) { KEYB_CLOCK_DDR = 1; }
#define dataHigh(void) { KEYB_DATA_DDR = 0; }
#define dataLow(void)  { KEYB_DATA_DDR = 1; }
#define readClockPin() PIND.3
#define readDataPin()  PIND.1

volatile unsigned char    kbd_flags;

enum enum_state { IDLE_START = 0, IDLE_WAIT_REL, 
    IDLE_OK_TO_TX, IDLE_END,

    RX_START = IDLE_END+10, RX_RELCLK, RX_DATA0,
    RX_DATA1, RX_DATA2, RX_DATA3, RX_DATA4,
    RX_DATA5, RX_DATA6, RX_DATA7,
    RX_PARITY, RX_STOP, RX_SENT_ACK, RX_END,

    TX_START = RX_END+10, 
    TX_DATA1, TX_DATA2, TX_DATA3, TX_DATA4,
    TX_DATA5, TX_DATA6, TX_DATA7,
    TX_PARITY, TX_STOP, TX_AFTER_STOP, TX_END } ;

volatile unsigned char kbd_state;

static volatile unsigned char    rx_byte;
//static volatile unsigned char    tx_byte;
static volatile unsigned char    tx_shift;
static volatile unsigned char    ps2k_parity;
//static volatile unsigned char    ps2k_tx_resend;

#define FLA_CLOCK_HIGH	1
#define FLA_RX_BAD	2
//#define FLA_RX_BYTE	4
//#define FLA_TX_BYTE	8
//#define FLA_TX_OK	0x10

#define FLA_TX_ERR	0x20

void kbd_init(void)
{
    kbd_state = IDLE_START;
    kbd_flags = FLA_CLOCK_HIGH;// | FLA_TX_OK;

    ps2k_rx_buf_w = 0;
    ps2k_rx_buf_r = 0;
    ps2k_rx_buf_count = 0;
    ps2k_tx_buf_w = 0;
    ps2k_tx_buf_r = 0;
    ps2k_tx_buf_count = 0;
//    ps2k_tx_last = 0;                                  
//    ps2k_tx_resend = 0;

    KEYB_CLOCK_PORT = 0;
    KEYB_DATA_PORT = 0;
    clockHigh();
    dataHigh();

    TCCR0 = 2; // Включить таймер 0, делитель 8
    TCNT0 = COUNT_UP;
    TIMSK |= 1; // Разрешаем прерывания
//    timer2Init();
//    timer2SetPrescaler(TIMER_CLK_DIV8);
//    timerAttach(TIMER2OVERFLOW_INT, timerAction);
//    outp(COUNT_UP, TCNT2);    /* value counts up from this to zero */
}

interrupt [TIM0_OVF] void timerAction(void)
{
    /* restart timer */
    TCNT0 = COUNT_UP;    /* value counts up from this to zero */

    if (kbd_state < IDLE_END) { // start, wait_rel or ready to tx
        dataHigh();
        if (!(kbd_flags & FLA_CLOCK_HIGH)) {
            kbd_flags |= FLA_CLOCK_HIGH;
            clockHigh();
            return;
        }
        /* if clock held low, then we must prepare to start rxing */
        if (!readClockPin()) {
            kbd_state = IDLE_WAIT_REL;
            return;
        }
        switch(kbd_state) {
            case IDLE_START:
                kbd_state = IDLE_OK_TO_TX;
                return;
            case IDLE_WAIT_REL:
                if (!readDataPin()) {
                    /* PC wants to transmit */
                    kbd_state = RX_START;
                    return;
                }
                /* just an ack or something */
                kbd_state = IDLE_OK_TO_TX;
                return;
            case IDLE_OK_TO_TX:
                if (ps2k_tx_buf_count /*|| ps2k_tx_resend*/) {
                    dataLow();
                    kbd_state = TX_START;
                }
                return;
        }
        return;
    } else // end < IDLE_END
        if (kbd_state < RX_END) {
            if (!(kbd_flags & FLA_CLOCK_HIGH)) {
                kbd_flags |= FLA_CLOCK_HIGH;
                clockHigh();
                return;
            }
            /* at this point clock is high in preparation to going low */
            if (!readClockPin()) {
                /* PC is still holding clock down */
                dataHigh();
                kbd_state = IDLE_WAIT_REL;
                return;
            }
            switch(kbd_state) {
                case RX_START:
                    /* PC has released clock line */
                    /* we keep it high for a good half cycle */
                    kbd_flags &= ~FLA_RX_BAD;
                    kbd_state++;
                    return;
                case RX_RELCLK:
                    /* now PC has seen clock high, show it some low */
                    break;
                case RX_DATA0:
                    //kbd_flags &= ~FLA_RX_BYTE;
                    if (readDataPin()) {
                        rx_byte = 0x80;
                        ps2k_parity = 1;
                    } else {
                        ps2k_parity = 0;
                        rx_byte = 0;
                    }
                    break; /* end clk hi 1 */
                case RX_DATA1: 
                case RX_DATA2: 
                case RX_DATA3: 
                case RX_DATA4: 
                case RX_DATA5: 
                case RX_DATA6: 
                case RX_DATA7: 
                    rx_byte >>= 1;
                    if (readDataPin()) {
                        rx_byte |= 0x80;
                        ps2k_parity++;
                    }
                    break; /* end clk hi 2 to 8 */
                case RX_PARITY: 
                    if (readDataPin()) {
                        ps2k_parity++;
                    }
                    if (!(ps2k_parity & 1)) {
                        /* faulty, not odd parity */
                        kbd_flags |= FLA_RX_BAD;
                    }
                    break; /* end clk hi 9 */
                case RX_STOP: 
                    if (!readDataPin()) {
                        /* if stop bit not seen */
                        //kbd_flags |= FLA_RX_BAD;
                    }
                    if (!(kbd_flags & FLA_RX_BAD)) {
                        dataLow();
                        //kbd_flags |= FLA_RX_BYTE;
                        //if(rx_byte == 0xFE) { ps2k_tx_resend = 1; PORTB.6 = !PORTB.6; } else 
                        ps2k_rx_push(rx_byte);
                    }
                    break; /* end clk hi 10 */
                case RX_SENT_ACK: 
                    dataHigh();
                    kbd_state = IDLE_START;
                    /* remains in clk hi 11 */
                    return;
            }
            clockLow();
            kbd_flags &= ~(FLA_CLOCK_HIGH);
            kbd_state++;
            return;
        } else // end < RX_END
            if (kbd_state < TX_END) {
                if (kbd_flags & FLA_CLOCK_HIGH) {
                    if (!readClockPin()) {
                        /* PC is still holding clock down */
                        dataHigh();
                        kbd_state = IDLE_WAIT_REL;
                        return;
                    }
                    kbd_flags &= ~FLA_CLOCK_HIGH;
                    clockLow();
                    return;
                }

                /* at this point clock is low in preparation to going high */
                kbd_flags |= FLA_CLOCK_HIGH;
                clockHigh();
                switch(kbd_state) {
                    case TX_START:
                        //if(!ps2k_tx_resend) ps2k_tx_last = ps2k_tx_buf[ps2k_tx_buf_r];
                        //               else ps2k_tx_resend = 0; // RESEND не повторяем попытку сам                        
                        tx_shift = ps2k_tx_buf[ps2k_tx_buf_r];
                        ps2k_parity = 0;
                    case TX_DATA1: 
                    case TX_DATA2: 
                    case TX_DATA3: 
                    case TX_DATA4:
                    case TX_DATA5: 
                    case TX_DATA6: 
                    case TX_DATA7:
                        if (tx_shift & 1) {
                            dataHigh();
                            ps2k_parity++;
                        } else {
                            dataLow();
                        }
                        tx_shift >>= 1;
                        break; /* clock hi 1 to 8 */

                    case TX_PARITY: 
                        if (ps2k_parity & 1) {
                            dataLow();
                        } else {
                            dataHigh();
                        }          
                        ps2k_tx_buf_count--;
                        ps2k_tx_buf_r = (ps2k_tx_buf_r + 1) % sizeof(ps2k_tx_buf); 
                        // kbd_flags &= ~FLA_TX_BYTE;
                        // kbd_flags |= FLA_TX_OK;
                        break; /* clock hi 9 */
                    case TX_STOP: 
                        dataHigh();
                        break; /* clock hi 10 */
                    case TX_AFTER_STOP:
                        kbd_state = IDLE_START;
						/* remains in clk hi 11 */
						return;
				}
				kbd_state++;

			} //else

}

//===========================================================================
// PS/2 порт
//===========================================================================

#define PS2_BUF_SIZE 16  // Размер приёмного буфера PS/2 порта

#define PS2_CLK_PORT  PORTD.2 // Ножка к которой подлючен тактовый сиг. PS/2
#define PS2_CLK_DDR   DDRD.2
#define PS2_CLK_PIN   PIND.2
#define PS2_DATA_PORT PORTD.0 // Ножка к которой подлючен сигнал данных PS/2 
#define PS2_DATA_DDR  DDRD.0
#define PS2_DATA_PIN  PIND.0

enum ps_state_t { ps2_state_error, ps2_state_read, ps2_state_write };

volatile uint8_t ps2_state;                // состояние порта (ps_state_t)
volatile uint8_t ps2_bitcount;             // счётчик битов обработчика
volatile uint8_t ps2_data;                 // буфер на байт
volatile uint8_t ps2_parity;
volatile uint8_t ps2_rx_buf[PS2_BUF_SIZE]; // Приемный буфер PS/2 порта
volatile uint8_t ps2_rx_buf_w;
volatile uint8_t ps2_rx_buf_r;
volatile uint8_t ps2_rx_buf_count;

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
    uint8_t d = 0;
    // Выключаем прерывания, так как обработчик прерывания 
    // то же модифицирует эти переменные.
    #asm("cli")
    // Если буфер пуст, возвращаем ноль
    if(ps2_rx_buf_count) {
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
                //!if(PS2_DATA_PIN) ps2_state = ps2_state_error;
                //!            else ps2_state = ps2_state_read; 
                ps2_state = ps2_state_read;
                ps2_bitcount = 12;
        } 
    } else {
        switch(ps2_bitcount) {
            case 11: // Старт бит
                //! if(PS2_DATA_PIN) ps2_state = ps2_state_error;
                break;
            default: // Данные
                ps2_data >>= 1;
                if(PS2_DATA_PIN) ps2_data |= 0x80;
                break;
            case 2: // Бит четности 
                //! if(parity(ps2_data) != PS2_DATA_PIN) ps2_state = ps2_state_error;
                break;
            case 1: // Стоп бит 
                if(PS2_DATA_PIN) ps2_rx_push(ps2_data);
                            else ps2_state = ps2_state_error;
                ps2_state = ps2_state_read; //!  
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
    PS2_CLK_PORT = 0;
    PS2_DATA_PORT = 0;
    
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

/*uint8_t ps2_recv(void)
{
    while(ps2_rx_buf_count == 0);
    return ps2_aread();
}*/

//---------------------------------------------------------------------------
// Отправка байта в PS/2 порт с подтверждением

/*void ps2_send(uint8_t c) {
    ps2_write(c);
    if(ps2_recv() != 0xFA) ps2_state = ps2_state_error;
}*/

//===========================================================================
// Джойстик
//===========================================================================

flash const uint16_t joy_scans_default[] = {
    0x175,
    0x172,
    0x16B,
    0x174,
    0x12, // B    SHIFT
    0x14, // C     CTRL

    0x11, // Z     ALT
    0x1E, // Y     2 
    0x16, // X     1
    0x26, // MODE  3  
    0x29, // A     SPACE
    0x5A, // START ENTER
    
    0x1D, // W
    0x1B, // S
    0x1C, // A
    0x23, // D
    0x15, // Q
    0x24, // E
    
    0x1A, // Z
    0x22, // X
    0x21, // C
    0x4D, // R
    0x2B, // F
    0x2A, // V
};

uint8_t  joyselect;
uint8_t  joy0a0; // 0, A, START
uint8_t  joy0a1; // 0, A, START
uint8_t  joy0b0; // UP, DOWN, LEFT
uint8_t  joy0b1; // RIGHT, B, C
uint8_t  joy0c0; // Z, Y, X
uint8_t  joy0c1; // MODE, 0, 0
uint8_t  joy1a;  // 0, 0, 0, 0, A, START
uint8_t  joy1b;  // UP, DOWN, LEFT, RIGHT, B, C
uint8_t  joy1c;  // Z, Y, X, MODE, 0, 0
uint16_t joy_scans[24];
uint8_t  joy_n;
uint8_t  joy_prog;
uint16_t joy_prog_scan;


#define JOY_0A_PIN  PINB
#define JOY_0B_PIN  PIND
#define JOY_1_PIN   PINC
#define JOY_0A_PORT PORTB
#define JOY_0B_PORT PORTD
#define JOY_1_PORT  PORTC

    // PINB.0  PINC.0  - Up
    // PINB.1  PINC.1  - Down
    // PINB.2  PINC.2  - Left
    // PIND.5  PINC.3  - Right
    // PIND.6  PINC.4  - B
    // PIND.7  PINC.5  - C

//---------------------------------------------------------------------------
// Таймер джойстиков

interrupt [TIM1_OVF] void timer_1_overflow() {
    switch(--joyselect)
    {
        case 7:
            TCNT1 = 65536 - 20;
            JOY_SELECT_PORT = 0;            
            return;
        case 6:
            TCNT1 = 65536 - 20;
            joy0b0 = JOY_0A_PIN;
            joy0b1 = JOY_0B_PIN;
            joy1b = JOY_1_PIN;            
            JOY_SELECT_PORT = 1;
            return;            
        case 5:
            TCNT1 = 65536 - 20;
            joy0a0 = JOY_0A_PIN;
            joy0a1 = JOY_0B_PIN;
            joy1a = JOY_1_PIN;            
            JOY_SELECT_PORT = 0;            
            return;
        case 4:
            TCNT1 = 65536 - 20;
            JOY_SELECT_PORT = 1;
            return;            
        case 3:
            TCNT1 = 65536 - 20;
            JOY_SELECT_PORT = 0;            
            return;
        case 2:
            TCNT1 = 65536 - 20;
            JOY_SELECT_PORT = 1;
            return;            
        case 1:
            TCNT1 = 65536 - 20;
            joy0c0 = JOY_0A_PIN;
            joy0c1 = JOY_0B_PIN;
            joy1c  = JOY_1_PIN;
            JOY_SELECT_PORT = 0;            
            return;
        default:
            TCNT1 = 65536 - 16000;
            joyselect = 8;
            JOY_SELECT_PORT = 1;
    }
}

void joy_init() {
    memcpyf(joy_scans, joy_scans_default, sizeof(joy_scans_default));         
    joy_prog = 0;

    // Подтягивающие резисторы
    JOY_0A_PORT |= 1+2+4;
    JOY_0B_PORT |= 0x20+0x40+0x80;
    JOY_1_PORT  |= 1+2+4+8+0x10+0x20;

    DDRD.4 = 1; // JOY_SELECT_DDR

    joyselect = 0;    
    TCCR1A = 0;
    TCCR1B = (0<<CS12)|(1<<CS11)|(0<<CS10);
    TIMSK |= (1<<TOIE1);
    TCNT1 = 0;            
    #asm 
    sei
    #endasm
}

void process_joy(uint8_t s, uint8_t o) {
    uint8_t b;                        
    for(b=1; b!=0x40; b<<=1, joy_n++) {
        if((s & b) != (o & b)) {
            if(joy_prog == 2 && (s & b) == 0) { 
                joy_scans[joy_n] = joy_prog_scan;
                joy_prog = 0;
                continue;
            }
            if(joy_scans[joy_n] & 0x100) ps2k_write(0xE0);
            if(s & b) ps2k_write(0xF0);
            ps2k_write(joy_scans[joy_n]);
            PORTB.7 = !PORTB.7;
        }
    }
}

void main(void)
{
    uint8_t d, ext, rel;
    uint8_t old_joy0a0 = 0, old_joy0c0 = 0;
    uint8_t old_joy1a = 0, old_joy1c = 0;                
    uint8_t wait_for_pc_answer, wait_for_pc_arg;                
    
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

    // Светодиоды
    DDRB |= 0xC0;    
    
    // PINB.0  PINC.0  - Up
    // PINB.1  PINC.1  - Down
    // PINB.2  PINC.2  - Left
    // PIND.5  PINC.3  - Right
    // PIND.6  PINC.4  - B
    // PIND.7  PINC.5  - C
               
    for(d=0; d<4; d++)
    {    
        PORTB.6 = d & 1;
        PORTB.7 = (d & 1) ^ 1;
        delay_ms(250);
    }
    PORTB.6 = 0;
    PORTB.7 = 0;
                      
    // Раскладка по умолчанию

    joy_init();                        
    ps2_init();
    kbd_init();       

    // Обнуление переменных
        
    ext=0; rel=0; 
    wait_for_pc_answer = 0;
    wait_for_pc_arg = 0;
    
    // Основной цикл программы 
    while (1) {
        if(ps2_ready()) { 
            d = ps2_aread();
            if(wait_for_pc_answer) {
                wait_for_pc_answer = 0;
                ps2k_write(d);
            } else {
                if(d==0xE0) { ext = 1; continue; }
                if(d==0xF0) { rel = 1; continue; }
                if(!rel && !ext && d==0x07) joy_prog = 1; else
                if(!rel && joy_prog==1) { 
                    joy_prog = 2;
                    joy_prog_scan = d;
                    if(ext) joy_prog_scan |= 0x100, ext=0;
                    continue;
                }
                if(ext) { ps2k_write(0xE0); ext=0; }
                if(rel) { ps2k_write(0xF0); rel=0; }
                ps2k_write(d);
            }
            //PORTB.6 = !PORTB.6;
        }                
        
        // Получена команда от компьютера
        if(ps2_state != ps2_state_write && ps2k_ready()) {
            //PORTB.7 = !PORTB.7;
            d = ps2k_aread();
            
            // Некоторые команды от PC
            // 0xED D - Установить светодиоды
            // 0xEE   - Эхо. Клавиатура отвечает 0xEE
            // 0xF0 D - Установить кодовую страницу
            // 0xF2   - Пустая команда
            // 0xF3 D - Скорость клавиатуры
            // 0xF4   - Включает клавиатуру (после 0xF5)
            // 0xF5   - Выключить клавиатуру и набор скан-кодов 2
            // 0xF6   - Временные задержки по-умолчанию и набор скан-кодов 2            
            // 0xF8   - Только информацию о нажатии и отпускании клавиши.
            // 0xFB ? - Set specific key to typematic/autorepeat only (scancode set 3 only) 
            // 0xFC ? - Set specific key to make/release (scancode set 3 only) 
            // 0xFD ? - Set specific key to make only (scancode set 3 only)
            // 0xFF   - Сброс            

            // Тут наверное не совсем правильно. Может быть при получении FF всегда надо сбрасываться.
            if(wait_for_pc_arg) {
                wait_for_pc_arg--;
            } else
            if(d == 0xED || d == 0xF0 || d == 0xF3) {
                wait_for_pc_arg = 1;
            }
            
            ps2_write(d);
            
            // До ответа клавиатуры джоайстики не должны передавать
            wait_for_pc_answer = 1;
        }

        // Если мы ждем от компьютера еще один байт, либо компьютер ждет 
        // от клавиатуры ответ, то не посылаем кнопки джойстика
        
        if(wait_for_pc_answer == 0 && wait_for_pc_arg == 0) {
            joy_n = 0;
            // up,down,left,right,b,c                   
            d = (joy0a0 & (1+2+4)) | ((joy0a1 >> 2) & (8+16+32));
            process_joy(d, old_joy0a0);
            old_joy0a0 = d; 
            // z,y,x,mode,a,start
            d = (joy0c0 & (1+2+4)) | ((joy0c1 >> 2) & 8) | ((joy0b1 >> 2) & (16+32));
            process_joy(d, old_joy0c0);
            old_joy0c0 = d; 
            // up,down,left,right,b,c                   
            d = joy1a;
            process_joy(d, old_joy1a);
            old_joy1a = d; 
            // z,y,x,mode,a,start
            d = (joy1c & (1+2+4+8)) | (joy1b & (16+32));
            process_joy(d, old_joy1c);            
            old_joy1c = d; 
        }
    }
}
