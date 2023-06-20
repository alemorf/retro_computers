/*
 * SD card SPI driver
 * Copyright (c) 2023 Aleksey Morozov
 * aleksey.f.morozov@gmail.com
 * aleksey.f.morozov@yandex.ru
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "main.h"
#include "../../FatFs/src/diskio.h"
#include "stm32f4xx_hal.h"
#include "sdcard.h"
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include "my.h"

/* Config */
static GPIO_TypeDef* const SDCARD_CS_PORT = GPIOB;
static const uint32_t SDCARD_CS_PIN = GPIO_PIN_13;
static SPI_TypeDef* const SDCARD_SPI = SPI2;

/* Consts */
static const uint16_t SDCARD_SECTOR_SIZE = 512u;
static const uint32_t SPI_BAUDRATEPRESCALER_MASK = SPI_BAUDRATEPRESCALER_256;
static const uint16_t SDCARD_INIT_TIMEOUT = 200u;
static const uint8_t SDCARD_INIT_TRY_COUNT = 10u;
static const uint16_t SDCARD_READ_BLOCK_TIMEOUT = 2000u;
static const uint8_t SDCARD_READ_BLOCK_RESULT_WAIT = 0xFFu;
static const uint8_t SDCARD_READ_BLOCK_RESULT_DONE = 0xFEu;
static const uint16_t SDCARD_WRITE_BLOCK_TIMEOUT = 65535u;
static const uint8_t SDCARD_WRITE_BLOCK_RESULT_DONE = 0xFFu;
static const uint8_t SDCARD_WRITE_BLOCK_MARKER = 0xFEu;
static const uint8_t SDCARD_WRITE_MULTIPLE_BLOCK_MARKER = 0xFCu;
static const uint8_t SDCARD_WRITE_MULTIPLE_BLOCK_END = 0xFDu;

/* Commands */
static const uint8_t SDCARD_CMD0_GO_IDLE_STATE = 0x40u | 0u;
static const uint8_t SDCARD_CMD8_SEND_IF_COND = 0x40u | 8u;
static const uint8_t SDCARD_CMD9_GET_CSD = 0x40u | 9u;
static const uint8_t SDCARD_CMD9_GET_CSD_LENGTH = 16u;
static const uint8_t SDCARD_CMD10_GET_CID = 0x40u | 10u;
static const uint8_t SDCARD_CMD10_GET_CID_LENGTH = 16u;
static const uint8_t SDCARD_CMD12_STOP_TRANSMISSION = 0x40u | 12u;
static const uint8_t SDCARD_CMD17_READ_SINGLE_BLOCK = 0x40u | 17u;
static const uint8_t SDCARD_CMD18_READ_MULTIPLE_BLOCK = 0x40u | 18u;
static const uint8_t SDCARD_CMD24_WRITE_BLOCK = 0x40u | 24u;
static const uint8_t SDCARD_CMD25_WRITE_MULTIPLE_BLOCK = 0x40u | 25u;
static const uint8_t SDCARD_CMD55_APP_CMD = 0x40u | 55u;
static const uint8_t SDCARD_CMD58_READ_OCR = 0x40u | 58u;
static const uint8_t SDCARD_CMD58_READ_OCR_LENGTH = 4u;
static const uint8_t SDCARD_ACMD23_SET_WR_BLK_ERASE_COUNT = 0x40u | 23u;
static const uint8_t SDCARD_ACMD41_SEND_OP_COND = 0x40u | 41u;

/* For sdcard_state */
static const uint8_t SDCARD_STATE_INITED = 1u << 0u;
static const uint8_t SDCARD_STATE_SDHC = 1u << 1u;

/* State */
static uint8_t sdcard_state = 0u;

/* Code */

static void SdcardSetCsLow(void) {
    SDCARD_CS_PORT->BSRR = (uint32_t)SDCARD_CS_PIN << 16u;
}

static void SdcardSetCsHigh(void) {
    SDCARD_CS_PORT->BSRR = SDCARD_CS_PIN;
}

static inline uint8_t SdcardRxTx(uint8_t byte) {
    SDCARD_SPI->DR = byte;
    while ((SDCARD_SPI->SR & SPI_FLAG_RXNE) == 0u) {
    }
    return SDCARD_SPI->DR;
}

static inline uint8_t SdcardRx(void) {
    return SdcardRxTx(0xFFu);
}

static inline void SdcardTx(uint8_t byte) {
    (void)SdcardRxTx(byte);
}

static inline void SdcardSetSpiLowSpeed(void) {
    SDCARD_SPI->CR1 &= ~SPI_CR1_SPE;
    SDCARD_SPI->CR1 = SPI_BAUDRATEPRESCALER_256 | (SDCARD_SPI->CR1 & ~SPI_BAUDRATEPRESCALER_MASK);
    SDCARD_SPI->CR1 |= SPI_CR1_SPE;
}

static inline void SdcardSetSpiHighSpeed(void) {
    SDCARD_SPI->CR1 &= ~SPI_CR1_SPE;
    SDCARD_SPI->CR1 = SPI_BAUDRATEPRESCALER_4 | (SDCARD_SPI->CR1 & ~SPI_BAUDRATEPRESCALER_MASK);
    SDCARD_SPI->CR1 |= SPI_CR1_SPE;
}

static void SdcardRxBytes(uint8_t buffer[], size_t buffer_size) {
    assert(buffer != NULL);
    size_t i = 0u;
    for (i = 0u; i < buffer_size; i++) {
        buffer[i] = SdcardRx();
    }
}

static uint8_t SdcardSendCommandInternal(uint8_t command, uint32_t argument, uint8_t response_buffer[],
                                         size_t response_buffer_size) {
    SdcardSetCsLow();

    SdcardTx(command);
    SdcardTx((uint8_t)(argument >> 24u));
    SdcardTx((uint8_t)(argument >> 16u));
    SdcardTx((uint8_t)(argument >> 8u));
    SdcardTx((uint8_t)argument);
    SdcardTx((command == SDCARD_CMD8_SEND_IF_COND) ? 0x87u : 0x95u);

    if (command == SDCARD_CMD12_STOP_TRANSMISSION) {
        (void)SdcardRx();
    }

    uint8_t response = 0xFFu;
    uint8_t i = 0u;
    for (i = 10u; i != 0u; i--) {  // TODO: Check count
        response = SdcardRx();
        if (response != 0xFFu) {  // TODO: Check & 0x80
            break;
        }
    }

    if (response_buffer_size != 0u) {
        SdcardRxBytes(response_buffer, response_buffer_size);
    }

    return response;
}

static void SdcardTxBytes(const uint8_t buffer[], size_t buffer_size) {
    assert(buffer != NULL);
    size_t i = 0u;
    for (i = 0u; i < buffer_size; i++) {
        SdcardTx(buffer[i]);
    }
}

static uint8_t SdcardSendCommand(uint8_t command, uint32_t argument, uint8_t response_buffer[],
                                 size_t response_buffer_size) {
    const uint8_t result = SdcardSendCommandInternal(command, argument, response_buffer, response_buffer_size);
    SdcardSetCsHigh();
    (void)SdcardRx();
    return result;
}

static inline uint8_t SdcardSendCommandSector(uint8_t command, uint32_t sector) {
    uint32_t argument = sector;
    if ((sdcard_state & SDCARD_STATE_SDHC) == 0u) {
        // TODO: Check overflow
        argument *= SDCARD_SECTOR_SIZE;
    }
    return SdcardSendCommandInternal(command, argument, NULL, 0u);
}

static bool SdcardInitInternal(void) {
    sdcard_state = 0u;

    SdcardSetCsHigh();

    /* Start send 74 clocks at least */
    uint16_t i = 0u;
    for (i = 10u; i != 0u; i--) {
        (void)SdcardRx();
    }

    /* The SD Card is powered up in the SD mode. It will enter SPI mode if the CS signal is asserted (negative)
     * during the reception of the reset command (CMD0). If the card recognizes that the SD mode is required
     * it will not respond to the command and remain in the SD mode. If SPI mode is required, the card will
     * switch to SPI and respond with the SPI mode R1 response
     * Argument: [31:0] stuff bits = 0s
     * Return code: NOT DETERMINED
     */
    (void)SdcardSendCommand(SDCARD_CMD0_GO_IDLE_STATE, 0u, NULL, 0u);

    /* It is mandatory for the host compliant to "Physical Spec Version 2.00" to send CMD8.
     * Argument: [7:0] check pattern 0xAA, [11:8] supply voltage(VHS) = 2.7-3.6V = 1, [31:12] Reserved bits = 0
     * Answer: [7:0] check pattern 0xAA, [11:8] voltage accepted, [27:12] Reserved bits, [31:28] Command version
     * Return code: R1 (0 = Ok, 1u = The card is in idle state and running the initializing process)
     * In the response, the card echoes back both the voltage range and check pattern set in the argument.
     * If the card does not support the host supply voltage, it shall not return response and stays in Idle state.
     */
    uint8_t answer[4u] = {0u};
    const bool sdcard_version_2 = (SdcardSendCommand(SDCARD_CMD8_SEND_IF_COND, 0x1AAu, answer, sizeof(answer)) == 1u);

    bool result = true;
    if (sdcard_version_2) {
        result = ((answer[3u] == 0xAAu) && ((answer[2u] & 0x0Fu) == 0x01u));
    }

    /* SDCARD_CMD55_APP_CMD
     * Indicates to the card that the next command is an application specific command rather than a standard command
     * Argument: [15:0] stuff bits, [31:16] RCA
     * Return code: R1 (0 = Ok, 1u = The card is in idle state and running the initializing process)
     *
     * SDCARD_ACMD41_SEND_OP_COND
     * Sends host capacity support information and activates the card's initialization process.
     * Argument: [29:0] Reserved bits = 0, [30] = HCS, [31] Reserved bits = 0
     * Return code: R1 (0 = Ok, 1u = The card is in idle state and running the initializing process)
     * The HCS (Host Capacity Support) bit set to 1 indicates that the host supports SDHC or SDXC Card.
     * Setting "IN_IDLE_STATE" bit to "1" indicates that the card is still initializing.
     * Setting this bit to "0" indicates completion of initialization.
     * The host repeatedly issues ACMD41 until this bit is set to "0".
     */

    if (result) {
        for (i = SDCARD_INIT_TIMEOUT; i != 0u; i--) {
            if ((SdcardSendCommand(SDCARD_CMD55_APP_CMD, 0u, NULL, 0u) <= 1u) &&
                (SdcardSendCommand(SDCARD_ACMD41_SEND_OP_COND, 0x40000000u, NULL, 0u) == 0u)) {
                break;
            }
        }
        result = i != 0u;
    }

    /* SDCARD_CMD58_READ_OCR
     * Reads the OCR register of a card. CCS bit is assigned to OCR[30].
     * Answer: [31:0] OCR
     * Return code: R1 (0 = Ok)
     */
    if (sdcard_version_2) {
        uint8_t ocr[4u] = {0u};
        if (result) {
            result = SdcardSendCommand(SDCARD_CMD58_READ_OCR, 0u, ocr, sizeof(ocr)) == 0u;
        }
        if (result) {
            if ((ocr[0u] & 0x40u) != 0u) {
                sdcard_state |= SDCARD_STATE_SDHC;
            }
        }
    }

    /* Done */
    if (result) {
        sdcard_state |= SDCARD_STATE_INITED;
    }

    return result;
}

DSTATUS SdcardGetStatus(void) {
    return ((sdcard_state & SDCARD_STATE_INITED) != 0u) ? RES_OK : RES_NOTRDY;
}

DSTATUS SdcardInit(void) {
    SdcardSetSpiLowSpeed();

    uint8_t tries = 0u;
    for (tries = SDCARD_INIT_TRY_COUNT; tries != 0u; tries--) {
        if (SdcardInitInternal()) {
            break;
        }
    }

    if (tries != 0u) {
        SdcardSetSpiHighSpeed();
    }

    return (tries != 0u) ? RES_OK : RES_NOTRDY;
}

static bool SdcardReadBlock(uint8_t buffer[]) {
    assert(buffer != NULL);

    bool result = false;
    uint16_t i = 0u;
    for (i = SDCARD_READ_BLOCK_TIMEOUT; i != 0u; i--) {
        const uint8_t byte = SdcardRx();
        if (byte != SDCARD_READ_BLOCK_RESULT_WAIT) {
            result = byte == SDCARD_READ_BLOCK_RESULT_DONE;
            break;
        }
    }

    if (result) {
        SdcardRxBytes(buffer, SDCARD_SECTOR_SIZE);
        (void)SdcardRx(); /* Ignore CRC */
        (void)SdcardRx(); /* Ignore CRC */
    }

    return result;
}

DRESULT SdcardRead(uint8_t buffer[], uint32_t sector_number, uint32_t sector_count) {
    DRESULT result = RES_ERROR;
    if ((buffer == NULL) || (sector_count == 0u)) {
        result = RES_PARERR;
    } else if ((sdcard_state & SDCARD_STATE_INITED) == 0u) {
        result = RES_NOTRDY;
    } else if (sector_count == 1u) {
        if (SdcardSendCommandSector(SDCARD_CMD17_READ_SINGLE_BLOCK, sector_number) == 0u) {
            if (SdcardReadBlock(buffer)) {
                result = RES_OK;
            }
        }
        SdcardSetCsHigh();
        (void)SdcardRx();
    } else {
        if (SdcardSendCommandSector(SDCARD_CMD18_READ_MULTIPLE_BLOCK, sector_number) == 0u) {
            result = RES_OK;
            uint32_t i = 0u;
            for (i = 0u; i < sector_count; i++) {
                if (!SdcardReadBlock(&buffer[(size_t)i * SDCARD_SECTOR_SIZE])) {
                    result = RES_ERROR;
                    break;
                }
            }
        }
        if (SdcardSendCommand(SDCARD_CMD12_STOP_TRANSMISSION, 0u, NULL, 0u) != 0u) {
            result = RES_ERROR;
        }
    }
    if (result != RES_OK) {
        DebugOutput("Failed to read sdcard, sector %u, count %u\r\n", (unsigned)sector_number, (unsigned)sector_count);
    }
    return result;
}

static bool SdcardWriteBlock(const uint8_t buffer[], uint8_t command) {
    SdcardTx(command);
    bool result = true;
    if (buffer != NULL) {
        SdcardTxBytes(buffer, SDCARD_SECTOR_SIZE);
        SdcardTx(0xFFu); /* No CRC */
        SdcardTx(0xFFu); /* No CRC */
        result = (SdcardRx() & 0x1Fu) == 0x05u;
    }
    if (result) {
        uint16_t i = 0u;
        for (i = SDCARD_WRITE_BLOCK_TIMEOUT; i != 0u; i--) {
            if (SdcardRx() == SDCARD_WRITE_BLOCK_RESULT_DONE) {
                break;
            }
        }
        result = i != 0u;
    }
    return result;
}

DRESULT SdcardWrite(const uint8_t buffer[], uint32_t sector_number, size_t sector_count) {
    DRESULT result = RES_ERROR;
    if ((buffer == NULL) || (sector_count == 0u)) {
        result = RES_PARERR;
    } else if ((sdcard_state & SDCARD_STATE_INITED) == 0u) {
        result = RES_NOTRDY;
    } else if (sector_count == 1u) {
        if (SdcardSendCommandSector(SDCARD_CMD24_WRITE_BLOCK, sector_number) == 0u) {
            if (SdcardWriteBlock(buffer, SDCARD_WRITE_BLOCK_MARKER)) {
                result = RES_OK;
            }
        }
        SdcardSetCsHigh();
        (void)SdcardRx();
    } else {
        if (SdcardSendCommand(SDCARD_CMD55_APP_CMD, 0u, NULL, 0u) == 0u) {
            if (SdcardSendCommand(SDCARD_ACMD23_SET_WR_BLK_ERASE_COUNT, sector_count, NULL, 0u) == 0u) {
                result = RES_OK;
                if (SdcardSendCommandSector(SDCARD_CMD25_WRITE_MULTIPLE_BLOCK, sector_number) != 0u) {
                    result = RES_ERROR;
                }
                if (result == RES_OK) {
                    size_t i = 0u;
                    for (i = 0u; i < sector_count; i++) {
                        if (!SdcardWriteBlock(&buffer[i * SDCARD_SECTOR_SIZE], SDCARD_WRITE_MULTIPLE_BLOCK_MARKER)) {
                            result = RES_ERROR;
                            break;
                        }
                    }
                }
                if (!SdcardWriteBlock(NULL, SDCARD_WRITE_MULTIPLE_BLOCK_END)) {
                    result = RES_ERROR;
                }
                SdcardSetCsHigh();
                (void)SdcardRx();
            }
        }
    }
    if (result != RES_OK) {
        DebugOutput("Failed to write sdcard, sector %u, count %u\r\n", (unsigned)sector_number, (unsigned)sector_count);
    }
    return result;
}

DRESULT SdcardIoctl(uint8_t id, void* buffer) {
    DRESULT result = RES_ERROR;
    if ((sdcard_state & SDCARD_STATE_INITED) == 0u) {
        result = RES_NOTRDY;
    } else {
        switch (id) {
            case CTRL_SYNC:
                result = RES_OK;
                break;
            case GET_SECTOR_SIZE: {
                assert(buffer != NULL);
                const uint16_t data = SDCARD_SECTOR_SIZE;
                (void)memcpy(buffer, &data, sizeof(data));
                result = RES_OK;
                break;
            }
            case MMC_GET_CSD:
                assert(buffer != NULL);
                if (0u == SdcardSendCommand(SDCARD_CMD9_GET_CSD, 0u, buffer, SDCARD_CMD9_GET_CSD_LENGTH)) {
                    result = RES_OK;
                }
                break;
            case MMC_GET_CID:
                assert(buffer != NULL);
                if (0u == SdcardSendCommand(SDCARD_CMD10_GET_CID, 0u, buffer, SDCARD_CMD10_GET_CID_LENGTH)) {
                    result = RES_OK;
                }
                break;
            case MMC_GET_OCR:
                assert(buffer != NULL);
                if (0u == SdcardSendCommand(SDCARD_CMD58_READ_OCR, 0u, buffer, SDCARD_CMD58_READ_OCR_LENGTH)) {
                    result = RES_OK;
                }
                break;
            default:
                result = RES_PARERR;
                break;
        }
    }
    return result;
}
