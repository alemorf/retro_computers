#pragma once

#include <stdint.h>

/* Коды ошибок */

enum {
    IS_ERROR_DONE = 0,
    IS_ERROR_BUSY = 0xFF,
    IS_ERROR_UNSUPPORTED = 0xFE,
    IS_ERROR_SIZE = 0xFD,
    IS_ERROR_RX = 0xFC,
};

/* Коды команд */

enum {
    IS_COMMAND_TEST = 0,
    IS_COMMAND_READ = 1,
    IS_COMMAND_WRITE = 2,
};

/* Команда чтения */

struct __attribute__ ((__packed__)) IsCommandTest {
    uint8_t  command;
    uint16_t value;
};

struct __attribute__ ((__packed__)) IsCommandTestAnswer {
    uint16_t  value;
};

#define IS_SECTOR_SIZE 128

struct __attribute__ ((__packed__)) IsCommandRead {
    uint8_t  command;
    uint8_t  device;
    uint32_t offset;
};

struct __attribute__ ((__packed__)) IsCommandReadAnswer {
    uint8_t  data[IS_SECTOR_SIZE];
};

/* Команда записи */

struct __attribute__ ((__packed__)) IsCommandWrite {
    uint8_t  command;
    uint8_t  device;
    uint32_t offset;
    uint8_t  data[IS_SECTOR_SIZE];
};

/* Приёмный буфер для любой команды */

union  __attribute__ ((__packed__)) IsRx {
    uint8_t bytes[1];
    union {
        uint8_t command;
        struct IsCommandTest test;
        struct IsCommandRead read;
        struct IsCommandWrite write;
    };
};

/* Передающий буфер для любой команды */

union  __attribute__ ((__packed__)) IsTx {
    uint8_t bytes[1];
    struct IsCommandTestAnswer test;
    struct IsCommandReadAnswer read;
};
