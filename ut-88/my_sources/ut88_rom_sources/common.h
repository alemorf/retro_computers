// Порты ввода вывода

const int ioSysConfig       = 0x04; // КР580ВВ55А. Системный порт и порт клавиатуры.
const int ioSysC            = 0x05;
const int ioSysB            = 0x06;
const int ioSysA            = 0x07;
const int ioUserA           = 0xF8; // КР580ВВ55А. Пользовательский порт. Сюда подключается внешее ПЗУ.
const int ioUserB           = 0xF9;
const int ioUserC           = 0xFA;
const int ioUserConfig      = 0xFB;
const int ioUserConfigValue = 0x82;

// Настройка cистемного порта и порта клавиатуры, микросхема КР580ВВ55А
// 1 - бит 0 - PC0..3 вход - вход клавиатуры и накопителя на магнитной ленте
// 1 - бит 1 - PB0..7 вход - вход клавиатуры
// 0 - бит 2 - режим, равно 0
// 0 - бит 3 - PC4..7 вход - выход управления картой адресного пространства и магнитофона
// 0 - бит 4 - PA0..7 вход - выход клавиатуры
// 0 - бит 5 - режим, равно 0
// 0 - бит 6 - режим, равно 0
// 1 - бит 7 - команда установки, равено 1

const int ioSysConfigValue = 0x83;

// Команды системного порта

const int ioSysConfigTape0       = (4 << 1) | 0;
const int ioSysConfigTape1       = (4 << 1) | 1;
const int ioSysConfigExt0        = (5 << 1) | 0;
const int ioSysConfigExt1        = (5 << 1) | 1;
const int ioSysConfigEnableRom   = (6 << 1) | 1;
const int ioSysConfigDisableRom  = (6 << 1) | 0;
const int ioSysConfigEnableRam   = (7 << 1) | 1;
const int ioSysConfigDisableRam  = (7 << 1) | 0;

// Адреса в ПЗУ

const  int     romMonitorStart = 0x0006;
const  int     romMonitorSize  = 0x10000 - 0xF600;
const  int     romFiles        = romMonitorStart + romMonitorSize;
extern uint8_t romTestF        = 0xFE00;
extern uint8_t romTestFDone    = 0xFE03;
extern uint8_t romTestFError   = 0xFE06;

// Адреса в ОЗУ

extern uint8_t ramTest0                     = 0x0000;
extern uint8_t ramTest0Start                = 0x0000;
extern uint8_t ramTest0Stack                = 0x0010;
extern uint8_t ramTest0JmpMonitor           = 0x0000;
extern uint8_t ramTest0HighRamTest          = 0x0007;
extern uint8_t ramVideo                     = 0xE800;
extern uint8_t ramVideoEnd                  = 0xF000;
extern uint8_t ramMonitorStart              = 0xF600;
extern uint8_t ramMonitorEntry              = 0xF800;
extern uint8_t romMenuRamAddr               = 0x100;
