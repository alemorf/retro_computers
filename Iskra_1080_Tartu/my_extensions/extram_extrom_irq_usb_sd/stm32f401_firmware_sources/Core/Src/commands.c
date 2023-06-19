#include "commands.h"
#include "main.h"
#include "is_protocol.h"
#include "fatfs.h"
#include <errno.h>
#include <stdbool.h>

static const uint8_t FD_NUMBER_NOT_OPENED = UINT8_MAX;

static uint8_t file_number = FD_NUMBER_NOT_OPENED;
static FIL file;

void CommandsInit() {
}

static int SelectDevice(uint8_t number, uint32_t offset) {
    if (file_number != number) {
        if (number > 1 + 'z' - 'a') {
            DebugOutput("Incorrect device %u\r\n", number);
            return ENOENT;
        }

        if (file_number != FD_NUMBER_NOT_OPENED) {
            FRESULT result = f_close(&file);
            if (result != 0) {
                DebugOutput("Can't close file, error %i\r\n", result);
                return result;
            }
            file_number = FD_NUMBER_NOT_OPENED;
        }

        char *file_name = asnprintf(NULL, NULL, number == 0 ? "%s/boot.cpm" : "%s/%c.cpm", USBHPath, number - 1 + 'a');
        if (file_name == NULL) {
            DebugOutput("Out of memory\r\n");
            return ENOMEM;
        }

        FRESULT result = f_open(&file, file_name, FA_OPEN_EXISTING | FA_READ | FA_WRITE);
        if (result != FR_OK) {
            DebugOutput("Can't open file '%s', error %u\r\n", file_name, result);
            free(file_name);
            return EIO;
        }
        file_number = number;
        free(file_name);
    }

    const uint64_t byte_offset = (uint64_t)offset * IS_SECTOR_SIZE;

    if (byte_offset + IS_SECTOR_SIZE > f_size(&file)) {
        DebugOutput("Incorrect offset %u\r\n", offset);
        return EINVAL;
    }

    FRESULT result = f_lseek(&file, byte_offset);
    if (result != FR_OK) {
        DebugOutput("Can't seek file, error %i, position %u\r\n", result, (unsigned)byte_offset);
        return EIO;
    }

    return 0;
}

uint8_t IsProcessRead(uint8_t device, uint32_t offset, uint8_t data[]) {
    DebugOutput("Read %u %u\r\n", device, offset);

    int result = SelectDevice(device, offset);
    if (result != 0)
        return result;

    UINT result_bytes = 0;
    FRESULT fresult = f_read(&file, data, IS_SECTOR_SIZE, &result_bytes);
    if (fresult != FR_OK || result_bytes != IS_SECTOR_SIZE) {
        DebugOutput("Can't read file, error %u, byte_result %u\r\n", fresult, result_bytes);
        return EIO;
    }

    return 0;
}

uint8_t IsProcessWrite(uint8_t device, uint32_t offset, const uint8_t data[]) {
    DebugOutput("Write %u %u\r\n", device, offset);

    int result = SelectDevice(device, offset);
    if (result != 0)
        return result;

    UINT result_bytes = 0;
    FRESULT fresult = f_write(&file, data, IS_SECTOR_SIZE, &result_bytes);
    if (fresult != FR_OK || result_bytes != IS_SECTOR_SIZE) {
        DebugOutput("Can't read file, error %u, byte_result %u\r\n", fresult, result_bytes);
        return EIO;
    }

    return 0;
}
